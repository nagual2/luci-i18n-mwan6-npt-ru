#!/usr/bin/env bash
# Build luci-i18n-mwan6-npt-ru .apk for OpenWrt 25.12+ (standalone, no full SDK compile).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT/dist}"
SDK_DIR="${SDK_DIR:-$ROOT/build/sdk}"
if [[ "$ROOT" == /mnt/* ]] && [[ "${SDK_DIR}" == /mnt/* || "${SDK_DIR}" == "$ROOT/build/sdk" ]]; then
	SDK_DIR="/tmp/luci-i18n-mwan6-npt-ru-sdk"
fi
APK_TOOL="${APK_TOOL:-$SDK_DIR/staging_dir/host/bin/apk}"
LMO_FILE="${LMO_FILE:-$ROOT/build/mwan6-npt.ru.lmo}"

PROJECT_VERSION="${PROJECT_VERSION:-$(git -C "$ROOT" describe --tags --match 'v*' 2>/dev/null | sed 's/^v//')}"
PROJECT_VERSION="${PROJECT_VERSION:-1.0.0}"
PKG_RELEASE="${PKG_RELEASE:-1}"
PKG_VERSION="${PROJECT_VERSION}-r${PKG_RELEASE}"

log() { printf '[build-apk-mkpkg] %s\n' "$*"; }

ensure_apk_tool() {
	if [ -x "$APK_TOOL" ]; then
		return 0
	fi
	local archive url
	url="${SDK_URL:-https://downloads.openwrt.org/releases/25.12.0/targets/x86/64/openwrt-sdk-25.12.0-x86-64_gcc-14.3.0_musl.Linux-x86_64.tar.zst}"
	archive="$ROOT/build/$(basename "$url")"
	log "Extracting apk host tool from OpenWrt SDK..."
	mkdir -p "$ROOT/build"
	[ -f "$archive" ] || wget -O "$archive" "$url"
	rm -rf "$SDK_DIR"
	mkdir -p "$SDK_DIR"
	tar --zstd -xf "$archive" -C "$SDK_DIR" --strip-components=1
	APK_TOOL="$SDK_DIR/staging_dir/host/bin/apk"
	[ -x "$APK_TOOL" ] || {
		echo "apk tool not found: $APK_TOOL" >&2
		exit 1
	}
}

[ -f "$LMO_FILE" ] || {
	log "LMO missing, running build-lmo.sh..."
	"$ROOT/scripts/build-lmo.sh"
}

ensure_apk_tool

STAGE="$(mktemp -d)"
POSTINST="$(mktemp)"
trap 'rm -rf "$STAGE" "$POSTINST"' EXIT

install -d "$STAGE/usr/lib/lua/luci/i18n" "$STAGE/etc/uci-defaults"
install -m 0644 "$LMO_FILE" "$STAGE/usr/lib/lua/luci/i18n/mwan6-npt.ru.lmo"
install -m 0755 "$ROOT/root/etc/uci-defaults/50-luci-i18n-mwan6-npt-ru" "$STAGE/etc/uci-defaults/"

cat >"$POSTINST" <<'EOF'
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] && exit 0
[ -x /etc/uci-defaults/50-luci-i18n-mwan6-npt-ru ] && /etc/uci-defaults/50-luci-i18n-mwan6-npt-ru
rm -f /tmp/luci-indexcache.*
rm -rf /tmp/luci-modulecache/
exit 0
EOF
chmod 0755 "$POSTINST"

mkdir -p "$OUTPUT_DIR"
OUT_APK="$OUTPUT_DIR/luci-i18n-mwan6-npt-ru-${PKG_VERSION}.apk"

log "Creating $OUT_APK"
"$APK_TOOL" mkpkg \
	--compat 3.0.0_pre1 \
	--files "$STAGE" \
	--info "name:luci-i18n-mwan6-npt-ru" \
	--info "version:${PKG_VERSION}" \
	--info "arch:noarch" \
	--info "license:Apache-2.0" \
	--info "maintainer:OpenWrt Community" \
	--info "depends:luci-app-mwan6-npt" \
	--info "description:Russian translation for luci-app-mwan6-npt (NPTv6 Multi-WAN)" \
	--script "post-install:$POSTINST" \
	--output "$OUT_APK"

log "Built: $OUT_APK ($(wc -c <"$OUT_APK") bytes)"
