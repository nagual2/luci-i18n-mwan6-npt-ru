# luci-i18n-mwan6-npt-ru

[English](README.md) | **Русский** | [Deutsch](README.de.md)

Русская (`ru`) локализация для [luci-app-mwan6-npt](https://github.com/nagual2/mwan6-npt-luci) — веб-интерфейса [mwan6-npt](https://github.com/nagual2/mwan6-npt).

Репозиторий: https://github.com/nagual2/luci-i18n-mwan6-npt-ru

## Пакет

| Поле | Значение |
|------|----------|
| Имя в OpenWrt | `luci-i18n-mwan6-npt-ru` |
| Зависимость | `luci-app-mwan6-npt` |
| Файл на роутере | `/usr/lib/lua/luci/i18n/mwan6-npt.ru.lmo` |
| Исходник перевода | `po/ru/mwan6-npt.po` |

## Установка из релиза

Скачайте `.apk` (OpenWrt 25.12+) или `.ipk` (23.x) с [GitHub Releases](https://github.com/nagual2/luci-i18n-mwan6-npt-ru/releases).

Устанавливайте **после** `luci-app-mwan6-npt`:

```bash
# OpenWrt 25.12+ (apk)
wget https://github.com/nagual2/luci-i18n-mwan6-npt-ru/releases/download/v1.0.2/luci-i18n-mwan6-npt-ru-1.0.2-r1.apk
apk add --allow-untrusted ./luci-i18n-mwan6-npt-ru-*.apk

# OpenWrt 23.x (opkg)
opkg install ./luci-i18n-mwan6-npt-ru_1.0.2-1_all.ipk
```

В LuCI: **Система → Язык** → **Русский (Russian)** → Сохранить и применить. Обновите страницу админки.

## Сборка

Нужны: Linux, `wget`, `zstd`, `make` (SDK скачивается скриптом).

```bash
chmod +x scripts/*.sh
make -f Makefile.build ipk PROJECT_VERSION=1.0.2
make -f Makefile.build apk PROJECT_VERSION=1.0.2
```

Результат: каталог `dist/`.

## Синхронизация с приложением

Строки берутся из [mwan6-npt-luci](https://github.com/nagual2/mwan6-npt-luci). При добавлении новых `_('...')` в JS обновите `po/ru/mwan6-npt.po` и выпустите новый тег.

## Документация

Триязычные README: `/usr/share/doc/luci-i18n-mwan6-npt-ru/` (`README.en.md`, `README.ru.md`, `README.de.md`).

## Лицензия

Apache-2.0 (как у [LuCI](https://github.com/openwrt/luci)). См. `LICENSE` и `NOTICE`.
