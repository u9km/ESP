#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#include <stdio.h>

// ================================================
// 1. محرك فك التشفير (Vault Engine)
// ================================================
static NSString *Sovereign_Decrypt(const char *cipher) {
    char key = 0x53; 
    size_t len = strlen(cipher);
    char *plain = malloc(len + 1);
    for (size_t i = 0; i < len; i++) plain[i] = cipher[i] ^ key;
    plain[len] = '\0';
    NSString *result = [NSString stringWithUTF8String:plain];
    free(plain);
    return result;
}

// ================================================
// 2. نظام القائمة والزر العائم (Menu UI)
// ================================================
@interface SovereignUI : NSObject
+ (void)initMenu;
@end

@implementation SovereignUI

static UIButton *fBtn;
static UIView *menuView;
static BOOL isShowing = NO;

+ (void)initMenu {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        if (!win) return;

        // إنشاء الزر العائم (Floating Button)
        fBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fBtn.frame = CGRectMake(10, 200, 55, 55);
        fBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        fBtn.layer.cornerRadius = 27.5;
        fBtn.layer.borderWidth = 2;
        fBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        [fBtn setTitle:@"S" forState:UIControlStateNormal];
        [fBtn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [fBtn addGestureRecognizer:pan];
        [win addSubview:fBtn];

        // المنيو الرئيسي
        menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 320)];
        menuView.center = win.center;
        menuView.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.95];
        menuView.layer.cornerRadius = 15;
        menuView.layer.borderWidth = 1;
        menuView.layer.borderColor = [UIColor orangeColor].CGColor;
        menuView.hidden = YES;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 260, 30)];
        title.text = @"SOVEREIGN ELITE V600";
        title.textColor = [UIColor orangeColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:16];
        [menuView addSubview:title];

        [win addSubview:menuView];
    });
}

+ (void)drag:(UIPanGestureRecognizer *)p {
    CGPoint t = [p translationInView:p.view.superview];
    p.view.center = CGPointMake(p.view.center.x + t.x, p.view.center.y + t.y);
    [p setTranslation:CGPointZero inView:p.view.superview];
}

+ (void)toggle {
    isShowing = !isShowing;
    menuView.hidden = !isShowing;
}
@end

// ================================================
// 3. درع الشبكة والحماية (Shield & Guard)
// ================================================
@implementation NSMutableURLRequest (SovereignShield)
+ (void)load {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        method_exchangeImplementations(
            class_getInstanceMethod(self, @selector(setURL:)),
            class_getInstanceMethod(self, @selector(sovereign_setURL:))
        );
    });
}

- (void)sovereign_setURL:(NSURL *)url {
    if (url) {
        NSString *u = url.absoluteString.lowercaseString;
        // حظر الروابط المكتشفة في Securit.m
        if ([u containsString:@"report"] || [u containsString:@"bugly"] || [u containsString:@"log"]) {
            [self sovereign_setURL:[NSURL URLWithString:@"about:blank"]];
            return;
        }
    }
    [self sovereign_setURL:url];
}
@end

// ================================================
// 4. المدخل الرئيسي المتوافق (Main Entry)
// ================================================
__attribute__((constructor))
static void SovereignMain() {
    // إسكات مخرجات النظام لمنع كشف الـ Log
    freopen("/dev/null", "w", stdout);
    freopen("/dev/null", "w", stderr);

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification 
                                                      object:nil 
                                                       queue:[NSOperationQueue mainQueue] 
                                                  usingBlock:^(NSNotification *note) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            // تشغيل الواجهة بعد استقرار اللعبة
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [SovereignUI initMenu];
            });
        });
    }];
}
