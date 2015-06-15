## Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Boot animation
TARGET_SCREEN_HEIGHT := 800
TARGET_SCREEN_WIDTH  := 480

# Release name
PRODUCT_RELEASE_NAME := f3

# NFC
$(call inherit-product, vendor/cm/config/nfc_enhanced.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/lge/fx3t/device_fx3t.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := fx3t
PRODUCT_NAME := cm_fx3t
PRODUCT_BRAND := T-Mobile
PRODUCT_MODEL := LG-P659
PRODUCT_MANUFACTURER := LGE

PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=fx3t
