# تحديد المعماريات المستهدفة
ARCHS = arm64 arm64e

# استهداف إصدار iOS متوافق
TARGET = iphone:clang:latest:12.0

# وضع الروتلس للحقن بدون جلبريك
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity

# تحديد كافة الملفات البرمجية المتوافقة
SovereignSecurity_FILES = SovereignSecurity.m

# إضافة المكتبيات اللازمة للرسم والحماية
SovereignSecurity_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore AudioToolbox

# إعدادات المترجم لمنع أخطاء الذاكرة
SovereignSecurity_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

# مواءمة القطاعات لمنع الكراش عند الحقن اليدوي
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk
