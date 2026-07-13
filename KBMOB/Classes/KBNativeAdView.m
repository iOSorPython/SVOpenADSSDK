//
//  KBNativeAdView.m
//  KBMOB
//
//

#import "KBNativeAdView.h"

#import "KBNativeAd.h"
#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>

@interface KBNativeAdView ()<WindMillNativeAdViewDelegate>
@property (nonatomic, strong) WindMillNativeAdView *nativeAdView;
@end

@implementation KBNativeAdView
+ (instancetype) initAdView {
    KBNativeAdView *adView = [[self alloc] init];
    adView.nativeAdView = [WindMillNativeAdView new];
    return adView;
}

- (void)refreshData:(KBNativeAd *)nativeAd {
    NSLog(@"KBNativeAdView refreshData 1111111");
//    if (self.nativeAdView && nativeAd.getAd) {
//        NSLog(@"HJNativeAdView refreshData 222222");
        self.nativeAdView.frame = self.frame;
        self.nativeAdView.delegate = self;
        self.nativeAdView.viewController = self.viewController;
        [self.nativeAdView refreshData:nativeAd.getAd];
//    }
}

- (UIView *)getView {
    return self.nativeAdView;
}

#pragma mark - ----- WindMillNativeAdViewDelegate -----

- (void)nativeExpressAdViewRenderSuccess:(WindMillNativeAdView *)nativeExpressAdView {
    NSLog(@"KBNativeAdView nativeExpressAdViewRenderSuccess %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( nativeExpressAdViewRenderSuccess:)]) {
            self.frame = nativeExpressAdView.frame;
                [self.delegate nativeExpressAdViewRenderSuccess:self];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 nativeExpressAdViewRenderSuccess");
            }
    }
}

- (void)nativeExpressAdViewRenderFail:(WindMillNativeAdView *)nativeExpressAdView error:(NSError *)error {
    NSLog(@"KBNativeAdView nativeExpressAdViewRenderFail %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( nativeExpressAdViewRenderFail:)]) {
                [self.delegate nativeExpressAdViewRenderFail:error];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 nativeExpressAdViewRenderFail");
            }
    }
}

- (void)nativeAdViewWillExpose:(WindMillNativeAdView *)nativeAdView {
    NSLog(@"KBNativeAdView nativeAdViewWillExpose %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( nativeAdViewWillExpose)]) {
                [self.delegate nativeAdViewWillExpose];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 nativeAdViewWillExpose");
            }
    }
}

- (void)nativeAdViewDidClick:(WindMillNativeAdView *)nativeAdView {
    NSLog(@"KBNativeAdView nativeAdViewDidClick %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( nativeAdViewDidClick)]) {
                [self.delegate nativeAdViewDidClick];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 nativeAdViewDidClick");
            }
    }
}

- (void)nativeAdView:(WindMillNativeAdView *)nativeAdView dislikeWithReason:(NSArray<WindMillDislikeWords *> *)filterWords {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( dislikeWithReason:)]) {
            NSString *reason = @"";
                if (filterWords.count > 0) {
                    WindMillDislikeWords *word = (WindMillDislikeWords *)filterWords.firstObject;
                    reason = word.name;
                }
            [self.delegate dislikeWithReason:reason];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 dislikeWithReason");
            }
    }
}

//- (void)dealloc {
//    NSLog(@"--- dealloc -- %@", self);
//    self.nativeAdView.delegate = nil;
//    self.nativeAdView = nil;
//    self.delegate = nil;
//}
@end
