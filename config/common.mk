#Arise
PRODUCT_COPY_FILES += \
	vendor/jdc/prebuilt/common/arise/arise.zip:system/arise/arise.zip

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/jdc/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/jdc/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/jdc/prebuilt/common/bin/50-base.sh:system/addon.d/50-base.sh \

# Bootanimation
PRODUCT_COPY_FILES += \
    vendor/jdc/prebuilt/common/bootanimation/bootanimation.zip:system/media/bootanimation.zip

# Official Changelog
PRODUCT_COPY_FILES += \
	vendor/jdc/Changelog.md:system/etc/Changelog.md

# Custom format script
PRODUCT_COPY_FILES += \
    vendor/jdc/prebuilt/common/bin/format.sh:install/bin/format.sh


# eMMC trim
PRODUCT_COPY_FILES += \
    vendor/jdc/prebuilt/common/bin/emmc_trim:system/bin/emmc_trim

# Overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/jdc/overlay/common
    
# SuperSU
PRODUCT_COPY_FILES += \
    vendor/jdc/prebuilt/common/supersu/supersu.zip:system/supersu/supersu.zip

# Take a logcat
#PRODUCT_COPY_FILES += \
    vendor/jdc/prebuilt/common/bin/take_log:system/bin/take_log
    
#Substratum Verified
PRODUCT_PROPERTY_OVERRIDES := \
    ro.substratum.verified=true

# Enable Storage Manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=1
    
# Google Assistant
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opa.eligible_device=true

# Set cache location
ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/data/cache
else
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/cache
endif
