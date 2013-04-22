PRODUCT_BRAND ?= chameleonos

# TODO: remove once all devices have been switched
ifneq ($(TARGET_BOOTANIMATION_NAME),)
TARGET_SCREEN_DIMENSIONS := $(subst -, $(space), $(subst x, $(space), $(TARGET_BOOTANIMATION_NAME)))
ifeq ($(TARGET_SCREEN_WIDTH),)
TARGET_SCREEN_WIDTH := $(word 2, $(TARGET_SCREEN_DIMENSIONS))
endif
ifeq ($(TARGET_SCREEN_HEIGHT),)
TARGET_SCREEN_HEIGHT := $(word 3, $(TARGET_SCREEN_DIMENSIONS))
endif
endif

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# clear TARGET_BOOTANIMATION_NAME
TARGET_BOOTANIMATION_NAME :=

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/cos/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_COPY_FILES += \
    vendor/cos/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif

ifdef COS_NIGHTLY
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmodnightly
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmod
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/cos/CHANGELOG.mkdn:system/etc/CHANGELOG-COS.txt

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/cos/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/cos/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/cos/prebuilt/common/bin/50-cos.sh:system/addon.d/50-cos.sh \
    vendor/cos/prebuilt/common/bin/blacklist:system/addon.d/blacklist

# init.d support
PRODUCT_COPY_FILES += \
    vendor/cos/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/cos/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/cos/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# COS-specific init file
PRODUCT_COPY_FILES += \
    vendor/cos/prebuilt/common/etc/init.local.rc:root/init.cos.rc

# Compcache/Zram support
PRODUCT_COPY_FILES += \
    vendor/cos/prebuilt/common/bin/compcache:system/bin/compcache \
    vendor/cos/prebuilt/common/bin/handle_compcache:system/bin/handle_compcache

# Nam configuration script
PRODUCT_COPY_FILES += \
    vendor/cos/prebuilt/common/bin/modelid_cfg.sh:system/bin/modelid_cfg.sh

# Default chaos theme
PRODUCT_COPY_FILES += \
    vendor/cos/prebuilt/common/media/chaos.ctz:system/media/default.ctz


# Copy JNI libarary of Term
ifeq ($(TARGET_ARCH),arm)
PRODUCT_COPY_FILES +=  \
    vendor/cos/proprietary/lib/armeabi/libjackpal-androidterm4.so:system/lib/libjackpal-androidterm4.so
endif

ifeq ($(TARGET_ARCH),mips)
PRODUCT_COPY_FILES +=  \
    vendor/cos/proprietary/lib/mips/libjackpal-androidterm4.so:system/lib/libjackpal-androidterm4.so
endif

ifeq ($(TARGET_ARCH),x86)
PRODUCT_COPY_FILES +=  \
    vendor/cos/proprietary/lib/x86/libjackpal-androidterm4.so:system/lib/libjackpal-androidterm4.so
endif

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/cos/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/cos/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# This is COS!
PRODUCT_COPY_FILES += \
    vendor/cos/config/permissions/org.chameleonos.android.xml:system/etc/permissions/org.chameleonos.android.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/cos/prebuilt/common/etc/mkshrc:system/etc/mkshrc

SUPERUSER_PACKAGE := org.chameleonos.superuser

# Required COS packages
PRODUCT_PACKAGES += \
    Camera \
    Development \
    LatinIME \
    SpareParts

# Optional COS packages
PRODUCT_PACKAGES += \
    VideoEditor \
    VoiceDialer \
    SoundRecorder \
    Basic

# Custom COS packages
PRODUCT_PACKAGES += \
    ChaOSLauncher \
    DSPManager \
    libcyanogen-dsp \
    audio_effects.conf \
    Flypaper \
    Apollo \
    CMUpdater \
    CMFileManager \
    LockClock \
    PermissionsManager \
    ThemeManager \
    Superuser \
    su

# Extra tools in COS
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    vim \
    nano \
    htop \
    powertop \
    lsof

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

PRODUCT_PACKAGES += \
    cpufreq-info \
    cpufreq-set

PRODUCT_PACKAGE_OVERLAYS += vendor/cos/overlay/dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/cos/overlay/common

PRODUCT_VERSION_MAJOR = 0
PRODUCT_VERSION_MINOR = 7
PRODUCT_VERSION_MAINTENANCE = BETA

# Set COS_BUILDTYPE
ifdef COS_NIGHTLY
    COS_BUILDTYPE := NIGHTLY
endif
ifdef COS_EXPERIMENTAL
    COS_BUILDTYPE := EXPERIMENTAL
endif
ifdef COS_RELEASE
    COS_BUILDTYPE := RELEASE
endif

ifdef COS_BUILDTYPE
    ifdef COS_EXTRAVERSION
        # Force build type to EXPERIMENTAL
        COS_BUILDTYPE := EXPERIMENTAL
        # Add leading dash to COS_EXTRAVERSION
        COS_EXTRAVERSION := -$(COS_EXTRAVERSION)
    endif
else
    # If COS_BUILDTYPE is not defined, set to UNOFFICIAL
    COS_BUILDTYPE := UNOFFICIAL
    COS_EXTRAVERSION :=
endif

ifdef COS_RELEASE
    COS_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(COS_BUILD)
else
    ifeq ($(PRODUCT_VERSION_MINOR),0)
        COS_VERSION := $(PRODUCT_VERSION_MAJOR)-$(shell date -u +%Y%m%d)-$(COS_BUILDTYPE)-$(COS_BUILD)$(COS_EXTRAVERSION)
    else
        COS_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(COS_BUILDTYPE)-$(COS_BUILD)$(COS_EXTRAVERSION)
    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.cos.version=$(COS_VERSION) \
  ro.modversion=ChameleonOS-$(COS_VERSION) \
  ro.goo.developerid=chaos \
  ro.goo.rom=ChameleonOS \
  ro.goo.version=$(shell date +%s)


-include $(WORKSPACE)/hudson/image-auto-bits.mk
