#!/usr/bin/env bash
# Build luci-i18n-mwan6-npt-ru via OpenWrt SDK (canonical package metadata).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SDK_URL="${SDK_URL:-https://downloads.openwrt.org/releases/25.12.0/targets/x86/64/openwrt-sdk-25.12.0-x86-64_gcc-14.3.0_musl.Linux-x86_64.tar.zst}"
SDK_DIR="${SDK_DIR:-$ROOT/build/sdk}"
if [[ "$ROOT" == /mnt/* ]] && [[ "${SDK_DIR}" == /mnt/* || "${SDK_DIR}" == "$ROOT/build/sdk" ]]; then
	SDK_DIR="/tmp/luci-i18n-mwan6-npt-ru-sdk"
fi
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT/dist}"
ARCHIVE="${ARCHIVE:-/tmp/$(basename "$SDK_URL")}"
if [[ "$ROOT" == /mnt/* ]]; then
	ARCHIVE="/tmp/$(basename "$SDK_URL")"
fi

PROJECT_VERSION="${PROJECT_VERSION:-$(git -C "$ROOT" describe --tags --match 'v*' 2>/dev/null | sed 's/^v//')}"
PROJECT_VERSION="${PROJECT_VERSION:-1.0.0}"
PKG_RELEASE="${PKG_RELEASE:-1}"

log() { printf '[build-apk-sdk] %s\n' "$*"; }

need_cmd() {
	command -v "$1" >/dev/null 2>&1 || {
		echo "Missing command: $1" >&2
		exit 1
	}
}

need_cmd wget
need_cmd tar
need_cmd make
need_cmd sed

if [ ! -f "$SDK_DIR/staging_dir/host/bin/apk" ]; then
	log "Downloading OpenWrt SDK..."
	mkdir -p "$ROOT/build"
	[ -f "$ARCHIVE" ] || wget -O "$ARCHIVE" "$SDK_URL"
	rm -rf "$SDK_DIR"
	mkdir -p "$SDK_DIR"
	tar --zstd -xf "$ARCHIVE" -C "$SDK_DIR" --strip-components=1
fi

log "Preparing package in SDK..."
rm -rf "$SDK_DIR/package/custom/luci-i18n-mwan6-npt-ru"
mkdir -p "$SDK_DIR/package/custom"
rsync -a --exclude .git --exclude build --exclude dist "$ROOT/" "$SDK_DIR/package/custom/luci-i18n-mwan6-npt-ru/"

cd "$SDK_DIR"

sed -i \
	-e 's|git\.openwrt\.org/feed|github.com/openwrt|g' \
	-e 's|git\.openwrt\.org/project|github.com/openwrt|g' \
	-e 's|git\.openwrt\.org/openwrt|github.com/openwrt|g' \
	feeds.conf.default

./scripts/feeds update luci
./scripts/feeds install -p luci luci-base

cat >>.config <<EOF
CONFIG_ALL_NONSHARED=n
CONFIG_ALL_KMODS=n
CONFIG_ALL=n
CONFIG_AUTOREMOVE=n
CONFIG_SIGNED_PACKAGES=n
CONFIG_PACKAGE_luci-base=y
CONFIG_PACKAGE_luci-i18n-mwan6-npt-ru=m
EOF

make defconfig

log "Compiling luci-i18n-mwan6-npt-ru ${PROJECT_VERSION}-r${PKG_RELEASE}..."
make "package/luci-i18n-mwan6-npt-ru/clean" V=s
make "package/luci-i18n-mwan6-npt-ru/compile" \
	"PKG_VERSION=${PROJECT_VERSION}" "PKG_RELEASE=${PKG_RELEASE}" \
	-j"$(nproc)" V=s \
	|| make "package/luci-i18n-mwan6-npt-ru/compile" \
		"PKG_VERSION=${PROJECT_VERSION}" "PKG_RELEASE=${PKG_RELEASE}" \
		-j1 V=s

mkdir -p "$OUTPUT_DIR"
find bin/packages -name 'luci-i18n-mwan6-npt-ru*.apk' -exec cp -a {} "$OUTPUT_DIR/" \;
find bin/packages -name 'luci-i18n-mwan6-npt-ru*.ipk' -exec cp -a {} "$OUTPUT_DIR/" \;

if ! ls "$OUTPUT_DIR"/luci-i18n-mwan6-npt-ru* >/dev/null 2>&1; then
	echo "SDK build failed: no output in $OUTPUT_DIR" >&2
	exit 1
fi

log "Built:"
ls -la "$OUTPUT_DIR"/luci-i18n-mwan6-npt-ru*
