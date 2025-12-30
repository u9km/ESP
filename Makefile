# المعمارية المستهدفة
ARCHS = arm64

# إصدار النظام المستهدف
TARGET = iphone:clang:latest:12.0

# نمط الروتلس للحقن في IPA
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

# اسم الملف الناتج (SovereignSecurity.dylib)
TWEAK_NAME = SovereignSecurity

# الملفات البرمجية الداخلة في البناء
SovereignSecurity_FILES = SovereignSecurity.m

# إعدادات المترجم
SovereignSecurity_CFLAGS = -fobjc-arc

# المكتبات الضرورية للحماية والواجهة
SovereignSecurity_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore Security AudioToolbox

# سطر منع الكراش وتأمين الذاكرة المحقونة
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000 -ldl

include $(THEOS_MAKE_PATH)/tweak.mk
