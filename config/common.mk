# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/palm/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/palm/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/palm/prebuilt/common/bin/50-base.sh:system/addon.d/50-base.sh \

# Bootanimation
PRODUCT_COPY_FILES += \
    vendor/palm/prebuilt/common/bootanimation/bootanimation.zip:system/media/bootanimation.zip

# Official Changelog
PRODUCT_COPY_FILES += \
	vendor/palm/Changelog.md:system/etc/Changelog.md

# Custom format script
PRODUCT_COPY_FILES += \
    vendor/palm/prebuilt/common/bin/format.sh:install/bin/format.sh

# eMMC trim
PRODUCT_COPY_FILES += \
    vendor/palm/prebuilt/common/bin/emmc_trim.sh:system/bin/emmc_trim.sh

# Overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/palm/overlay/common

#Substratum Verified
PRODUCT_PROPERTY_OVERRIDES := \
    ro.substratum.verified=true

# Enable Storage Manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=1

# SU
PRODUCT_PACKAGES += \
    su

# Set cache location
ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/data/cache
else
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/cache
endif
