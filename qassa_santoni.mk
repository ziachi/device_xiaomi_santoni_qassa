#
# Copyright (C) 2019 The Lineage-OS Project
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
#

$(call inherit-product, device/xiaomi/santoni/full_santoni.mk)

# Inherit some common Qassa stuff.
$(call inherit-product, vendor/qassa/config/common_full_phone.mk)

PRODUCT_DEVICE := santoni
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := Redmi 4X
PRODUCT_NAME := qassa_santoni
BOARD_VENDOR := Xiaomi
PRODUCT_MANUFACTURER := Xiaomi

TARGET_FACE_UNLOCK_SUPPORTED := true
USE_PIXEL_CHARGER := true

# Boot animation
TARGET_BOOT_ANIMATION_RES := 720

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="santoni-user 7.1.2 N2G47H V9.5.10.0.NAMMIFD release-keys"

# Set BUILD_FINGERPRINT variable to be picked up by both system and vendor build.prop
BUILD_FINGERPRINT := "Xiaomi/santoni/santoni:7.1.2/N2G47H/V9.5.10.0.NAMMIFD:user/release-keys"

# ========================================
# Customizations by ziachi (Unofficial)
# ========================================

# Build type: Unofficial
QASSA_BUILD_TYPE := UNOFFICIAL

# Maintainer
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qassa.maintainer=ziachi \
    ro.qassa.maintainer.github=https://github.com/ziachi \
    ro.qassa.maintainer.telegram=https://t.me/kalomakan

# ADB enabled by default
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp,adb \
    persist.service.adb.enable=1

# Signing with releasekey
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/ziachi-keys/releasekey

# Android Override
PRODUCT_PACKAGES += OverrideSettings

# Override config
PRODUCT_COPY_FILES += \
    vendor/android-override/config/default_config.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/override/default_config.xml \
    vendor/android-override/config/props_database.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/override/props_database.xml
