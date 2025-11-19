################################################################################
#
# rkwifibt
#
################################################################################

RKWIFIBT_VERSION = 1.0.0
RKWIFIBT_SITE_METHOD = local
RKWIFIBT_SITE = $(TOPDIR)/../external/rkwifibt
RKWIFIBT_LICENSE = ROCKCHIP
RKWIFIBT_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_RKWIFIBT_STATIC),y)
RKWIFIBT_CFLAGS = $(TARGET_CFLAGS) -static
RKWIFIBT_LDFLAGS = $(TARGET_LDFLAGS) -static
endif

ifeq ($(BR2_PACKAGE_RKWIFIBT_AIC8800D80_SDIO_FIRMWARE),y)
RKWIFIBT_AIC_FIRMWARE_DIRS += firmware/aic/sdio/aic8800D80
endif

ifeq ($(BR2_PACKAGE_RKWIFIBT_AIC8800D80_USB_FIRMWARE),y)
RKWIFIBT_AIC_FIRMWARE_DIRS += firmware/aic/usb/aic8800D80
endif

ifneq ($(RKWIFIBT_AIC_FIRMWARE_DIRS),)
define AIC_FIRMWARE_INSTALL_DIRS
	$(foreach d,$(RKWIFIBT_AIC_FIRMWARE_DIRS), \
		cp -a $(@D)/$(d)/* $(TARGET_DIR)/lib/firmware/aic8800D80/$(sep))
endef
endif

define AIC_FIRMWARE_INSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/lib/firmware/aic8800D80
	mkdir -p $(TARGET_DIR)/lib/firmware/aic8800D80
	$(AIC_FIRMWARE_INSTALL_DIRS)
endef

RKWIFIBT_POST_INSTALL_TARGET_HOOKS += AIC_FIRMWARE_INSTALL_TARGET_CMDS

$(eval $(meson-package))
