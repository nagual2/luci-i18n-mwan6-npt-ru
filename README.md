# luci-i18n-mwan6-npt-ru

Russian (`ru`) translations for [luci-app-mwan6-npt](https://github.com/nagual2/mwan6-npt-luci) — LuCI UI for [mwan6-npt](https://github.com/nagual2/mwan6-npt).

Repository: https://github.com/nagual2/luci-i18n-mwan6-npt-ru

## Package

| Field | Value |
|-------|--------|
| OpenWrt package | `luci-i18n-mwan6-npt-ru` |
| Depends on | `luci-app-mwan6-npt` |
| Installs | `/usr/lib/lua/luci/i18n/mwan6-npt.ru.lmo` |
| Source | `po/ru/mwan6-npt.po` |

## Install from release

Download `.apk` (OpenWrt 25.12+) or `.ipk` (23.x) from [GitHub Releases](https://github.com/nagual2/luci-i18n-mwan6-npt-ru/releases).

Install **after** `luci-app-mwan6-npt`:

```bash
# OpenWrt 25.12+ (apk)
apk add --allow-untrusted ./luci-i18n-mwan6-npt-ru-*.apk

# OpenWrt 23.x (opkg)
opkg install ./luci-i18n-mwan6-npt-ru_*.ipk
```

In LuCI: **System → Language** → **Русский (Russian)** → Save & Apply. Reload the admin UI.

## Build

Requirements: Linux, `wget`, `zstd`, `make`, OpenWrt SDK (downloaded automatically).

```bash
chmod +x scripts/*.sh
make -f Makefile.build ipk    # .ipk for opkg
make -f Makefile.build apk      # .apk for apk (uses po2lmo + mkpkg)
# or full SDK compile:
./scripts/build-apk-sdk.sh
```

Artifacts: `dist/`.

## OpenWrt feed / SDK

```bash
ln -sf /path/to/luci-i18n-mwan6-npt-ru $TOPDIR/package/custom/luci-i18n-mwan6-npt-ru
make menuconfig   # LuCI → luci-i18n-mwan6-npt-ru
make package/luci-i18n-mwan6-npt-ru/compile V=s
```

## Sync with luci-app

Translation strings are extracted from [mwan6-npt-luci](https://github.com/nagual2/mwan6-npt-luci) (`htdocs/` and menu JSON). When the app adds new `_('...')` strings, update `po/ru/mwan6-npt.po` and release a new tag.

## License

Apache-2.0 (LuCI i18n tooling); translation text follows the app license (GPL-2.0 for luci-app-mwan6-npt).
