# Copyright (C) 2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Also get non-open-source specific aspects if available
$(call inherit-product-if-exists, vendor/lge/fx3t/fx3t-vendor.mk)


# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml


# Device overlay
DEVICE_PACKAGE_OVERLAYS += device/lge/fx3t/overlay

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

# We have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_BOOT_JARS += qcmediaplayer

# Boot animation
TARGET_SCREEN_HEIGHT := 800
TARGET_SCREEN_WIDTH := 480

# Graphics
PRODUCT_PACKAGES += \
    copybit.msm8960 \
    gralloc.msm8960 \
    hwcomposer.msm8960 \
    memtrack.msm8960 \
    power.msm8960 \
    libgenlock \
    libmemalloc \
    liboverlay \
    libqdutils

# Audio
PRODUCT_PACKAGES += \
    audio_policy.msm8960 \
    audio.primary.msm8960 \
    audio.a2dp.default \
    audio.usb.default \
    audio.r_submix.default \
    libaudio-resampler

# Media
PRODUCT_PACKAGES += \
    libdivxdrmdecrypt \
    libmm-omxcore \
    libOmxCore \
    libc2dcolorconvert \
    libOmxVdecHevc \
    libstagefrighthw \
    libOmxVdec \
    libOmxVenc \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxEvrcEnc \
    libOmxQcelp13Enc \
    libdashplayer \
    qcmediaplayer

# Camera
PRODUCT_PACKAGES += \
    camera.msm8960

# WiFi
PRODUCT_PACKAGES += \
    libQWiFiSoftApCfg \
    libqsap_sdk

# GPS
PRODUCT_PACKAGES += \
    gps.msm8960 \
    gps.conf \
    sap.conf

# FM radio
PRODUCT_PACKAGES += \
    qcom.fmradio \
    libqcomfm_jni \
    FM2 \
    FMRecord

# CRDA
PRODUCT_PACKAGES += \
    crda \
    regdbdump \
    regulatory.bin \
    linville.key.pub.pem

# Torch
PRODUCT_PACKAGES += Torch

# Lights
PRODUCT_PACKAGES += lights.msm8960

# QRNGD
PRODUCT_PACKAGES += qrngd

# Thermal profiles
PRODUCT_PACKAGES += \
    thermald-8930ab.conf \
    thermald-8930.conf

# Misc
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

# Live Wallpapers
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    VisualizationWallpapers \
    librs_jni

# Filesystem management tools
PRODUCT_PACKAGES += \
    make_ext4fs \
    e2fsck \
    setup_fs

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

# QC Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=/system/lib/libqc-opt.so

#common build.props
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    ro.ril.hsxpa=1 \
    ro.ril.gprsclass=10 \
    persist.radio.add_power_save=1 \
    persist.radio.dont_use_dsd=true \
    persist.radio.apm_sim_not_pwdn=1 \
    ro.ril.transmitpower=true \
    ro.warmboot.capability=1 \
    ro.qualcomm.cabl=0 \
    ro.opengles.version=196608 \
    af.resampler.quality=4 \
    persist.audio.fluence.mode=endfire \
    persist.audio.vr.enable=false \
    persist.audio.handset.mic=digital \
    ro.use_data_netmgrd=true \
    lpa.decode=true \
    lpa.use-stagefright=true \
    rild.libpath=/system/lib/libril-qc-qmi-1.so \
    persist.rild.nitz_plmn="" \
    persist.rild.nitz_long_ons_0="" \
    persist.rild.nitz_long_ons_1="" \
    persist.rild.nitz_long_ons_2="" \
    persist.rild.nitz_long_ons_3="" \
    persist.rild.nitz_short_ons_0="" \
    persist.rild.nitz_short_ons_1="" \
    persist.rild.nitz_short_ons_2="" \
    persist.rild.nitz_short_ons_3="" \
    ril.subscription.types=NV,RUIM \
    persist.gps.qmienabled=true \
    persist.gps.qc_nlp_in_use=0 \
    persist.fuse_sdcard=true \
    ro.vold.umsdirtyratio=50 \
    ro.cwm.enable_key_repeat=true \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0 \
    mm.enable.smoothstreaming=true \
    persist.timed.enable=true

PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.hw=1 \
    debug.egl.hw=1 \
    persist.hwc.mdpcomp.enable=true \
    debug.mdpcomp.logs=0 \
    ro.telephony.ril_class=LGEQualcommUiccRIL \
    ro.telephony.call_ring.multiple=0

# For userdebug builds
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.secure=0 \
    ro.adb.secure=0 \
    persist.service.adb.enable=1 \
    persist.service.debuggable=1


# call dalvik heap config
$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)
