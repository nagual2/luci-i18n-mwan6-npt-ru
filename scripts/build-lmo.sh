#!/usr/bin/env bash
# Compile po/ru/mwan6-npt.po -> build/mwan6-npt.ru.lmo using OpenWrt SDK po2lmo.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PO_FILE="$ROOT/po/ru/mwan6-npt.po"
OUT_LMO="$ROOT/build/mwan6-npt.ru.lmo"
SDK_DIR="${SDK_DIR:-$ROOT/build/sdk}"
SDK_URL="${SDK_URL:-https://downloads.openwrt.org/releases/25.12.0/targets/x86/64/openwrt-sdk-25.12.0-x86-64_gcc-14.3.0_musl.Linux-x86_64.tar.zst}"

log() { printf '[build-lmo] %s\n' "$*"; }

# OpenWrt SDK must live on a case-sensitive filesystem (not /mnt/c on WSL).
if [[ "$ROOT" == /mnt/* ]] && [[ "${SDK_DIR}" == /mnt/* || "${SDK_DIR}" == "$ROOT/build/sdk" ]]; then
	SDK_DIR="/tmp/luci-i18n-mwan6-npt-ru-sdk"
	log "WSL: using SDK in $SDK_DIR (case-sensitive)"
fi

ensure_sdk() {
	if [ -f "$SDK_DIR/staging_dir/hostpkg/bin/po2lmo" ]; then
		return 0
	fi
	if [ ! -f "$SDK_DIR/Makefile" ]; then
		local archive
		if [[ "$ROOT" == /mnt/* ]]; then
			archive="/tmp/$(basename "$SDK_URL")"
		else
			archive="$ROOT/build/$(basename "$SDK_URL")"
		fi
		log "Downloading OpenWrt SDK..."
		mkdir -p "$(dirname "$archive")"
		[ -f "$archive" ] || wget -O "$archive" "$SDK_URL"
		rm -rf "$SDK_DIR"
		mkdir -p "$SDK_DIR"
		tar --zstd -xf "$archive" -C "$SDK_DIR" --strip-components=1
	fi
	log "Building luci-base/host (po2lmo)..."
	cd "$SDK_DIR"
	[ -f .config ] || make defconfig
	./scripts/feeds update luci
	./scripts/feeds install -p luci luci-base
	make defconfig
	make "package/luci-base/host/compile" -j"$(nproc)" V=s \
		|| make "package/luci-base/host/compile" -j1 V=s
}

ensure_sdk

PO2LMO="$SDK_DIR/staging_dir/hostpkg/bin/po2lmo"
[ -x "$PO2LMO" ] || {
	echo "po2lmo not found at $PO2LMO" >&2
	exit 1
}

[ -f "$PO_FILE" ] || {
	echo "Missing $PO_FILE" >&2
	exit 1
}

mkdir -p "$(dirname "$OUT_LMO")"
rm -f "$OUT_LMO"
"$PO2LMO" "$PO_FILE" "$OUT_LMO"
log "Built $OUT_LMO ($(wc -c <"$OUT_LMO") bytes)"
