//
//  KBBannerView.m
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import "KBBannerView.h"

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>
#import "KBAdsRequest.h"
#import "NumberEncryptUtil.h"

@interface KBBannerView ()<WindMillBannerViewDelegate>
@property (nonatomic, strong) WindMillBannerView *bannerView;
@end

@implementation KBBannerView

- (instancetype)initWithRequest:(KBAdsRequest *)request {
    WindMillAdRequest *req = [WindMillAdRequest request];
//    req.placementId = request.placementId;
    req.placementId =  [self decode:request.placementId];
    req.userId = request.userId;
    req.options = request.options;
    self.bannerView = [[WindMillBannerView alloc] initWithRequest:req];
    self.bannerView.delegate = self;
    return self;
}

- (instancetype)initWithRequest:(KBAdsRequest *)request
                     expectSize:(CGSize)expectSize {
    WindMillAdRequest *req = [WindMillAdRequest request];
//    req.placementId = request.placementId;
    req.placementId =  [self decode:request.placementId];

    req.userId = request.userId;
    req.options = request.options;
    self.bannerView = [[WindMillBannerView alloc] initWithRequest:req expectSize:expectSize];
    self.bannerView.delegate = self;
    return self;
}
- (NSString *)decode:(NSString *)cipherId {
    if (![self isPureDigit:cipherId]) {
        // 情况 1：包含非数字
        return cipherId;
    }

    if (cipherId.length == 16) {
        // 情况 2：16 位数字 → 解密
        return [NumberEncryptUtil secureDecrypt:cipherId];
    }

    // 情况 3：八进制 → 十进制
    unsigned long long value = strtoull(cipherId.UTF8String, NULL, 8);
    return [NSString stringWithFormat:@"%llu", value];
}
- (BOOL)isPureDigit:(NSString *)str {
    if (str.length == 0) return NO;
    NSCharacterSet *nonDigits =
        [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [str rangeOfCharacterFromSet:nonDigits].location == NSNotFound;
}
- (void)loadAdData{
    self.bannerView.animated = self.animated;
    self.bannerView.backgroundColor = self.backgroundColor;
    self.bannerView.viewController = self.viewController;
    [self.bannerView loadAdData];
}

- (BOOL)isAdValid {
    return self.bannerView && self.bannerView.isAdValid;
}

- (UIView *)getView {
    return self.bannerView;
}

#pragma mark - ----- WindMillBannerViewDelegate -----

- (void)bannerAdViewDidAutoRefresh:(WindMillBannerView *)bannerAdView {
    NSLog(@" bannerAdViewDidAutoRefresh %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( bannerAdViewDidAutoRefresh:)]) {
            self.adSize = bannerAdView.adSize;
                [self.delegate bannerAdViewDidAutoRefresh:self];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 bannerAdViewDidAutoRefresh");
            }
    }
}

- (void)bannerView:(WindMillBannerView *)bannerAdView failedToAutoRefreshWithError:(NSError *)error {
    NSLog(@" failedToAutoRefreshWithError %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( bannerViewFailedToAutoRefreshWithError:)]) {
                [self.delegate bannerViewFailedToAutoRefreshWithError:error];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 bannerViewFailedToAutoRefreshWithError");
            }
    }
}

- (void)bannerAdViewLoadSuccess:(WindMillBannerView *)bannerAdView {
    NSLog(@" bannerAdViewLoadSuccess %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( bannerAdViewLoadSuccess:)]) {
            self.adSize = bannerAdView.adSize;
                [self.delegate bannerAdViewLoadSuccess:self];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 bannerAdViewLoadSuccess");
            }
    }
}

- (void)bannerAdViewFailedToLoad:(WindMillBannerView *)bannerAdView
                           error:(NSError *)error {
    NSLog(@" bannerAdViewFailedToLoad error %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( bannerAdViewLoadSuccess:)]) {
                [self.delegate bannerAdViewFailedToLoadError:error];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 bannerAdViewFailedToLoadError");
            }
    }
}

- (void)bannerAdViewWillExpose:(WindMillBannerView *)bannerAdView {
    NSLog(@" bannerAdViewWillExpose %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( bannerAdViewWillExpose)]) {
                [self.delegate bannerAdViewWillExpose];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 bannerAdViewWillExpose");
            }
    }
}

- (void)bannerAdViewDidClicked:(WindMillBannerView *)bannerAdView {
    NSLog(@" bannerAdViewDidClicked %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( bannerAdViewWillExpose)]) {
                [self.delegate bannerAdViewDidClicked];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 bannerAdViewDidClicked");
            }
    }
}

- (void)bannerAdViewWillLeaveApplication:(WindMillBannerView *)bannerAdView{
    NSLog(@" bannerAdViewWillLeaveApplication %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( bannerAdViewWillLeaveApplication)]) {
                [self.delegate bannerAdViewWillLeaveApplication];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 bannerAdViewWillLeaveApplication");
            }
    }
}

- (void)bannerAdViewWillOpenFullScreen:(WindMillBannerView *)bannerAdView {
    NSLog(@" bannerAdViewWillOpenFullScreen %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( bannerAdViewWillOpenFullScreen)]) {
                [self.delegate bannerAdViewWillOpenFullScreen];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 bannerAdViewWillOpenFullScreen");
            }
    }
}

/// 将关闭全屏视图。关闭storekit或关闭应用程序中的网页时发送
/// - Parameter bannerAdView: WindMillBannerView 实例对象
- (void)bannerAdViewCloseFullScreen:(WindMillBannerView *)bannerAdView {
    NSLog(@" bannerAdViewCloseFullScreen %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( bannerAdViewCloseFullScreen)]) {
                [self.delegate bannerAdViewCloseFullScreen];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 bannerAdViewCloseFullScreen");
            }
    }
}

- (void)bannerAdViewDidRemoved:(WindMillBannerView *)bannerAdView {
    NSLog(@" bannerAdViewDidRemoved %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( bannerAdViewDidRemoved)]) {
                [self.delegate bannerAdViewDidRemoved];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 bannerAdViewDidRemoved");
            }
    }
}

- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
    self.bannerView.delegate = nil;
    self.bannerView = nil;
    self.delegate = nil;
}

@end
