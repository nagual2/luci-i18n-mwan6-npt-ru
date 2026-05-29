#!/usr/bin/env bash
# Sanity check for luci-i18n-mwan6-npt-ru layout (no router required).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

required=(
	Makefile
	Makefile.build
	LICENSE
	NOTICE
	README.md
	README.ru.md
	README.de.md
	po/ru/mwan6-npt.po
	root/etc/uci-defaults/50-luci-i18n-mwan6-npt-ru
	scripts/build-lmo.sh
	scripts/build-apk-mkpkg.sh
	scripts/stage-docs.sh
)

for path in "${required[@]}"; do
	[ -e "$ROOT/$path" ] || {
		echo "missing: $path" >&2
		exit 1
	}
done

grep -q 'msgid "NPTv6 Multi-WAN"' "$ROOT/po/ru/mwan6-npt.po" || {
	echo "po: missing NPTv6 Multi-WAN msgid" >&2
	exit 1
}

grep -q 'Language: ru' "$ROOT/po/ru/mwan6-npt.po" || {
	echo "po: Language: ru not set" >&2
	exit 1
}

echo "OK: structure check passed"
