#
# Copyright (C) 2022 Team Win Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

TARGET_USES_XIAOMI_TITANIUM_COMMON_TREE := true

# Inherit AOSP product makefiles
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Crypto
ifeq ($(MITITANIUM_INCLUDE_CRYPTO_FBE),true)
MITITANIUM_INCLUDE_CRYPTO := true
PRODUCT_PACKAGES += qcom_decrypt_fbe
endif
ifeq ($(MITITANIUM_INCLUDE_CRYPTO_FDE),true)
MITITANIUM_INCLUDE_CRYPTO := true
endif
ifeq ($(MITITANIUM_INCLUDE_CRYPTO),true)
PRODUCT_PACKAGES += qcom_decrypt
ifeq ($(MITITANIUM_LEGACY_CRYPTO),true)
MITITANIUM_KEYMASTER_VERSION := 3.0
else # MITITANIUM_LEGACY_CRYPTO
MITITANIUM_KEYMASTER_VERSION ?= 4.0
endif # MITITANIUM_LEGACY_CRYPTO
endif # MITITANIUM_INCLUDE_CRYPTO

# Debug
PRODUCT_PACKAGES += \
    crash_dump \
    libprocinfo.recovery

PRODUCT_COPY_FILES += \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/system/apex/com.android.runtime/bin/crash_dump32:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/crash_dump32 \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/system/apex/com.android.runtime/bin/crash_dump64:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/crash_dump64

# Fstab
ifneq ($(MITITANIUM_USES_DEVICE_SPECIFIC_FSTAB),true)
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(LOCAL_PATH)/fstab/,$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/)
endif

# Gatekeeper
ifeq ($(MITITANIUM_LEGACY_CRYPTO),true)
ifeq ($(MITITANIUM_INCLUDE_CRYPTO_FBE),true)
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

PRODUCT_COPY_FILES += \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/vendor/bin/hw/android.hardware.gatekeeper@1.0-service:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.gatekeeper@1.0-service \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/hw/android.hardware.gatekeeper@1.0-impl.so
endif
endif

# Keymaster
ifeq ($(MITITANIUM_LEGACY_CRYPTO),true)
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

PRODUCT_COPY_FILES += \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/system/lib64/libkeymaster3device.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymaster3device.so \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/vendor/bin/hw/android.hardware.keymaster@3.0-service:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.keymaster@3.0-service \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/vendor/lib64/hw/android.hardware.keymaster@3.0-impl.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/hw/android.hardware.keymaster@3.0-impl.so
endif

# LED
PRODUCT_PACKAGES += \
    charger_led

# Proprietary - BEGIN
ifneq ($(MITITANIUM_USES_DEVICE_SPECIFIC_BLOBS),true)

# Proprietary - Gatekeeper
ifeq ($(MITITANIUM_INCLUDE_CRYPTO),true)
ifeq ($(MITITANIUM_LEGACY_CRYPTO),true)
ifeq ($(MITITANIUM_INCLUDE_CRYPTO_FBE),true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/gatekeeper/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)
endif
endif
endif

# Proprietary - Keystore
ifeq ($(MITITANIUM_INCLUDE_CRYPTO),true)
ifeq ($(MITITANIUM_LEGACY_CRYPTO),true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/keystore/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)
endif
endif

# Proprietary - QSEECOMd
ifeq ($(MITITANIUM_INCLUDE_CRYPTO),true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/qseecomd/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)
endif

# Proprietary - QTI Gatekeeper 1.0
ifeq ($(MITITANIUM_INCLUDE_CRYPTO),true)
ifneq ($(MITITANIUM_LEGACY_CRYPTO),true)
ifeq ($(MITITANIUM_INCLUDE_CRYPTO_FBE),true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/qti-gatekeeper-1-0/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)
endif
endif
endif

# Proprietary - QTI Keymaster
ifeq ($(MITITANIUM_INCLUDE_CRYPTO),true)
ifneq ($(MITITANIUM_LEGACY_CRYPTO),true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/qti-keymaster-common/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)
ifeq ($(MITITANIUM_KEYMASTER_VERSION),3.0)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/qti-keymaster-3-0/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)
else ifeq ($(MITHORIUM_KEYMASTER_VERSION),4.0)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/qti-keymaster-4-0/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)
endif
endif
endif

# Proprietary - END
endif # MITHORIUM_USES_DEVICE_SPECIFIC_BLOBS

# Vintf - Keymaster
ifeq ($(MITITANIUM_INCLUDE_CRYPTO),true)
ifeq ($(MITITANIUM_KEYMASTER_VERSION),3.0)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/vintf/keymaster-3-0.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/keymaster-3-0.xml
else ifeq ($(MITITANIUM_KEYMASTER_VERSION),4.0)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/vintf/keymaster-4-0.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/keymaster-4-0.xml
endif
endif

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit extra if exists
$(call inherit-product-if-exists, vendor/extra/product.mk)
