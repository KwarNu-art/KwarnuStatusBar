TARGET := iphone:clang:latest:14.0  
INSTALL_TARGET_PROCESSES := SpringBoard  
ARCHS := arm64 arm64e  
THEOS_PACKAGE_SCHEME := rootless  
  
include $(THEOS)/makefiles/common.mk  
  
TWEAK_NAME := KwarnuStatusBar  
  
KwarnuStatusBar_FILES := Tweak.x  
KwarnuStatusBar_CFLAGS := -fobjc-arc -Wno-unused-variable -Wno-unused-function  
KwarnuStatusBar_FRAMEWORKS := UIKit CoreGraphics QuartzCore  
  
include $(THEOS_MAKE_PATH)/tweak.mk  
