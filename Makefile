TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = bili-universal


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BiliBangumiPeaceReview

BiliBangumiPeaceReview_FILES = Tweak.x TweakLong.x
BiliBangumiPeaceReview_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
