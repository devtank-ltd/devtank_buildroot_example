################################################################################
#
# devtank-prod-tester
#
################################################################################

DEVTANK_PROD_TESTER_SITE = "$(TOPDIR)/../dtlib"
DEVTANK_PROD_TESTER_METHOD = local
DEVTANK_PROD_TESTER_LICENSE = Mit
DEVTANK_PROD_TESTER_DEPENDENCIES = python-gobject libgtk3 python-pycairo python-netifaces python-paramiko python-dateutil python-tz libiio libyaml

define DEVTANK_PROD_TESTER_EXTRACT_CMDS
  rsync -a "$(DEVTANK_PROD_TESTER_SITE)/" "$(@D)"/
endef

define DEVTANK_PROD_TESTER_BUILD_CMDS
  $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C "$(@D)/apps/gui"
endef

define DEVTANK_PROD_TESTER_INSTALL_TARGET_CMDS
  mkdir -p "$(TARGET_DIR)/opt/devtank/"
  cp -r "$(@D)/apps/gui"     "$(TARGET_DIR)/opt/devtank/"
  cp $(DEVTANK_PROD_TESTER_SITE)/../devtank-prod-tester/config_sqlite_data.yaml "$(TARGET_DIR)/opt/devtank/gui/"
endef

$(eval $(generic-package))
