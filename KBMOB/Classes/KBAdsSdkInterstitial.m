//
//  KBAdsSdkInterstitial.m
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import "KBAdsSdkInterstitial.h"

#import "KBAdPreviously.h"
#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>
#import "KBAdsRequest.h"

#import "NumberEncryptUtil.h"


@interface KBAdsSdkInterstitial ()<WindMillIntersititialAdDelegate>
@property (nonatomic, strong) WindMillIntersititialAd *interstitialAd;
@property (nonatomic, strong) NSString *interstitialId;
@end

@implementation KBAdsSdkInterstitial

- (instancetype)initWithRequest:(KBAdsRequest *)request {
    WindMillAdRequest *req = [WindMillAdRequest request];
//    req.placementId = request.placementId;
    req.placementId =  [self decode:request.placementId];

    req.userId = request.userId;
    req.options = request.options;
//    self.interstitialId = request.placementId;
    self.interstitialId =  [self decode:request.placementId];

    KBAdPreviously* huijingAdPreviously = [KBAdPreviously shareInstance];
    if (huijingAdPreviously.getInterstitialId &&![huijingAdPreviously.getInterstitialId isEqualToString:@""] &&![huijingAdPreviously.getInterstitialId isEqual:[NSNull null]]) {
//        if ([huijingAdPreviously.getInterstitialId isEqualToString:request.placementId]) {
        if ([huijingAdPreviously.getInterstitialId isEqualToString:[self decode:request.placementId]]) {

            NSLog(@"---- InterstitialAd");
            self.interstitialAd = huijingAdPreviously.getPrevInterstitialAd;
        } else {
            self.interstitialAd = huijingAdPreviously.getPrevFullScreenAd;
        }
    }
    if (self.interstitialAd == nil || !self.interstitialAd.ready) {
        NSLog(@"---- _intersititialAd  initWithChannel");
        self.interstitialAd = [[WindMillIntersititialAd alloc] initWithRequest:req];
    }
    self.interstitialAd.delegate = self;
    return self;
}

- (BOOL)isAdReady {
    return self.interstitialAd && self.interstitialAd.ready;
}

- (void)loadAd {
    if (self.interstitialAd) {
        if (self.interstitialAd.ready) {
            self.interstitialAd.delegate = self;
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector( onInterstitialAdLoadSuccess:)]) {
                    [self.delegate onInterstitialAdLoadSuccess:self.interstitialId];
                } else {
                    // 处理可选方法未实现的情况
                    NSLog(@"可选方法未实现 onInterstitialAdLoadSuccess");
                }
            }
        } else {
            [self.interstitialAd loadAdData];
        }
    }
}

- (void)show:(UIViewController *)rootViewController {
    if (self.interstitialAd && self.interstitialAd.ready) {
        [self.interstitialAd showAdFromRootViewController:rootViewController options:nil];
    }
}

#pragma mark - ----- WindMillIntersititialAdDelegate -----
- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"KBAdsSdkInterstitial %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( onInterstitialAdLoadSuccess:)]) {
            [self.delegate onInterstitialAdLoadSuccess:intersititialAd.placementId];
        } else {
            // 处理可选方法未实现的情况
            NSLog(@"可选方法未实现 onInterstitialAdLoadSuccess");
        }
    }
}

- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd
              didFailWithError:(NSError *)error {
    NSLog(@"KBAdsSdkInterstitial intersititialAdDidLoad didFailWithError %@ error: %@", NSStringFromSelector(_cmd), error);
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onInterstitialAdLoadError:error:)]) {
            [self.delegate onInterstitialAdLoadError:intersititialAd.placementId error: error];
        } else {
            // 处理可选方法未实现的情况
            NSLog(@"可选方法未实现 onInterstitialAdLoadError");
        }
    }
}

- (void)intersititialAdDidVisible:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"KBAdsSdkInterstitial %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onInterstitialAdPlayStart)]) {
            [self.delegate onInterstitialAdPlayStart];
        } else {
            // 处理可选方法未实现的情况
            NSLog(@"可选方法未实现 onInterstitialAdPlayStart");
        }
    }
}

- (void)intersititialAdDidPlayFinish:(WindMillIntersititialAd *)intersititialAd
                    didFailWithError:(NSError *)error {
    NSLog(@"KBAdsSdkInterstitial %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onInterstitialAdPlayEnd)]) {
            [self.delegate onInterstitialAdPlayEnd];
        } else {
            // 处理可选方法未实现的情况
            NSLog(@"可选方法未实现 onInterstitialAdPlayEnd");
        }
    }
}

- (void)intersititialAdDidClick:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"KBAdsSdkInterstitial %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onInterstitialAdClicked)]) {
            [self.delegate onInterstitialAdClicked];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 onInterstitialAdClicked");
            }
    }
}

- (void)intersititialAdDidClickSkip:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"KBAdsSdkInterstitial %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onInterstitialAdSkiped)]) {
            [self.delegate onInterstitialAdSkiped];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 onInterstitialAdSkiped");
            }
    }
}

- (void)intersititialAdDidClose:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"KBAdsSdkInterstitial %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onInterstitialAdClosed)]) {
            [self.delegate onInterstitialAdClosed];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 onInterstitialAdClosed");
            }
    }
}

- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
    self.interstitialAd.delegate = nil;
    self.interstitialAd = nil;
    self.delegate = nil;
    self.interstitialId = nil;
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

@end
