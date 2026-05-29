# luci-i18n-mwan6-npt-ru

[English](README.md) | [Русский](README.ru.md) | **Deutsch**

Russische (`ru`) Übersetzungen für [luci-app-mwan6-npt](https://github.com/nagual2/mwan6-npt-luci) — LuCI-Oberfläche für [mwan6-npt](https://github.com/nagual2/mwan6-npt).

Repository: https://github.com/nagual2/luci-i18n-mwan6-npt-ru

## Paket

| Feld | Wert |
|------|------|
| OpenWrt-Paket | `luci-i18n-mwan6-npt-ru` |
| Abhängigkeit | `luci-app-mwan6-npt` |
| Installiert | `/usr/lib/lua/luci/i18n/mwan6-npt.ru.lmo` |
| Quelle | `po/ru/mwan6-npt.po` |

## Installation aus Release

Laden Sie `.apk` (OpenWrt 25.12+) oder `.ipk` (23.x) von [GitHub Releases](https://github.com/nagual2/luci-i18n-mwan6-npt-ru/releases) herunter.

**Nach** `luci-app-mwan6-npt` installieren:

```bash
# OpenWrt 25.12+ (apk)
wget https://github.com/nagual2/luci-i18n-mwan6-npt-ru/releases/download/v1.0.2/luci-i18n-mwan6-npt-ru-1.0.2-r1.apk
apk add --allow-untrusted ./luci-i18n-mwan6-npt-ru-*.apk

# OpenWrt 23.x (opkg)
opkg install ./luci-i18n-mwan6-npt-ru_1.0.2-1_all.ipk
```

In LuCI: **System → Sprache** → **Русский (Russian)** → Speichern & Anwenden. Admin-Oberfläche neu laden.

## Build

```bash
chmod +x scripts/*.sh
make -f Makefile.build ipk PROJECT_VERSION=1.0.2
make -f Makefile.build apk PROJECT_VERSION=1.0.2
```

Artefakte: `dist/`.

## Synchronisation mit luci-app

Übersetzungsstrings stammen aus [mwan6-npt-luci](https://github.com/nagual2/mwan6-npt-luci). Bei neuen `_('...')`-Strings in JS `po/ru/mwan6-npt.po` aktualisieren und neuen Tag veröffentlichen.

## Dokumentation

Dreisprachige README unter `/usr/share/doc/luci-i18n-mwan6-npt-ru/` (`README.en.md`, `README.ru.md`, `README.de.md`).

## Lizenz

Apache-2.0 (wie [LuCI](https://github.com/openwrt/luci)). Siehe `LICENSE` und `NOTICE`.
