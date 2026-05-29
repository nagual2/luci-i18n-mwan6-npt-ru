#
# Copyright (C) 2026 OpenWrt Community
#
# Russian translation package for luci-app-mwan6-npt.
# Licensed under GPL-2.0 (same as LuCI).

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-i18n-mwan6-npt-ru
PKG_VERSION?=1.0.0
PKG_RELEASE?=1

PKG_MAINTAINER:=OpenWrt Community
PKG_LICENSE:=Apache-2.0

PKG_BUILD_DEPENDS:=luci-base/host

include $(INCLUDE_DIR)/package.mk

define Package/luci-i18n-mwan6-npt-ru
	SECTION:=luci
	CATEGORY:=LuCI
	TITLE:=luci-app-mwan6-npt - Russian translation
	HIDDEN:=1
	DEPENDS:=+luci-app-mwan6-npt
	PKGARCH:=all
endef

define Package/luci-i18n-mwan6-npt-ru/description
	Russian (ru) translations for the LuCI application luci-app-mwan6-npt
	(NPTv6 Multi-WAN). Installs mwan6-npt.ru.lmo under /usr/lib/lua/luci/i18n/.
endef

define Build/Compile
	$(STAGING_DIR_HOSTPKG)/bin/po2lmo \
		$(CURDIR)/po/ru/mwan6-npt.po \
		$(PKG_BUILD_DIR)/mwan6-npt.ru.lmo
endef

define Package/luci-i18n-mwan6-npt-ru/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/mwan6-npt.ru.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	echo "uci set luci.languages.ru='Русский (Russian)'; uci commit luci" \
		> $(1)/etc/uci-defaults/50-luci-i18n-mwan6-npt-ru
endef

define Package/luci-i18n-mwan6-npt-ru/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	rm -f /tmp/luci-indexcache.*
	rm -rf /tmp/luci-modulecache/
	exit 0
}
endef

$(eval $(call BuildPackage,luci-i18n-mwan6-npt-ru))
