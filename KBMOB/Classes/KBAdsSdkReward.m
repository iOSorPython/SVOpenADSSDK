//
//  KBAdsSdkReward.m
//  KBMOB
//
//

#import "KBAdsSdkReward.h"

#import "KBStorage.h"
#import "KBAdDto.h"
#import "KBAdPreviously.h"
#import "KBAdsSdkInterstitial.h"
#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>
#import "KBAdsRequest.h"
#import "NumberEncryptUtil.h"



@interface KBAdsSdkReward ()<WindMillRewardVideoAdDelegate>
@property (nonatomic, strong) WindMillRewardVideoAd *rewardAd;
@property (nonatomic, strong) KBAdsSdkInterstitial *hjitl;
@property (nonatomic, strong) NSString *rewardId;
@property (nonatomic, strong) UIViewController *rvController;
@end

@implementation KBAdsSdkReward

- (instancetype)initWithRequest:(KBAdsRequest *)request {
    WindMillAdRequest *req = [WindMillAdRequest request];
//    req.placementId = request.placementId;
    req.placementId =  [self decode:request.placementId];

    req.userId = request.userId;
    req.options = request.options;
//    self.rewardId = request.placementId;
    self.rewardId  =  [self decode:request.placementId];

//    KBAdPreviously* huijingAdPreviously = [KBAdPreviously shareInstance];
//    self.rewardAd = huijingAdPreviously.getPrevRewardAd;
//    if (self.rewardAd == nil || !self.rewardAd.ready) {
//        NSLog(@"---- reward  initWithChannel");
//        self.rewardAd = [[WindMillRewardVideoAd alloc] initWithRequest:req];
//    }
    
    
    KBAdPreviously* huijingAdPreviously = [KBAdPreviously shareInstance];
    WindMillRewardVideoAd *cacheAd = huijingAdPreviously.getPrevRewardAd;

    if (cacheAd &&
        cacheAd.ready &&
        [cacheAd.placementId isEqualToString:req.placementId]) {

        self.rewardAd = cacheAd;

    } else {

        self.rewardAd = [[WindMillRewardVideoAd alloc] initWithRequest:req];
    }
    
    self.rewardAd.delegate = self;
    return self;
    
    
    
}

- (BOOL)isAdReady {
    return self.rewardAd && self.rewardAd.ready;
}

- (void)loadAd {
    if (self.rewardAd) {
        if (self.rewardAd.ready) {
            self.rewardAd.delegate = self;
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(onVideoAdLoadSuccess:)]) {
                    [self.delegate onVideoAdLoadSuccess:self.rewardId];
                } else {
                    // 处理可选方法未实现的情况
                    NSLog(@"可选方法未实现 onVideoAdLoadSuccess");
                }
            }
        } else {
            [self.rewardAd loadAdData];
        }
    }
}

- (void)show:(UIViewController *)rootViewController options:(NSDictionary<NSString *,NSString *> * _Nullable)options {
    NSLog(@"---- reward  show1");
    if (self.rewardAd && self.rewardAd.ready) {
        NSLog(@"---- reward  show2");
        if (options != nil && [options count] > 0) {
            NSLog(@"---- reward resetRequestOptions");
            [self.rewardAd resetRequestOptions:options];
        }
        [self.rewardAd showAdFromRootViewController:rootViewController options:options];
        self.rvController = rootViewController;
    }
}

#pragma mark - ----- WindMillRewardVideoAdDelegate -----
- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"KBAdsSdkReward %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onVideoAdLoadSuccess:)]) {
            [self.delegate onVideoAdLoadSuccess:rewardVideoAd.placementId];
        } else {
            // 处理可选方法未实现的情况
            NSLog(@"可选方法未实现 onVideoAdLoadSuccess");
        }
    }
}

- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    NSLog(@"KBAdsSdkReward rewardVideoAdDidLoad didFailWithError %@ error: %@", NSStringFromSelector(_cmd), error);
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onVideoAdLoadError:error:)]) {
            [self.delegate onVideoAdLoadError:rewardVideoAd.placementId error: error];
        } else {
            // 处理可选方法未实现的情况
            NSLog(@"可选方法未实现 onVideoAdLoadError");
        }
    }
}

- (void)rewardVideoAdDidVisible:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"KBAdsSdkReward %@", NSStringFromSelector(_cmd));
    KBStorage *hjStorage = [KBStorage shareInstance];
    KBAdDto *hjAdDto = [hjStorage getStrategy:rewardVideoAd.placementId];
    NSLog(@"___________rewardVideoAdDidVisible______1");
    
    if (hjAdDto != nil && ![hjAdDto isKindOfClass:[NSNull class]]) {
       
        NSString *nAdId = hjAdDto.nAdId;
        NSString *nAdType = hjAdDto.nAdType;
        NSLog(@"___________rewardVideoAdDidVisible______11");
        if (nAdId != nil && ![nAdId isEqual:[NSNull null]] && ![nAdId isEqualToString:@""] &&
            hjAdDto.cpts > 0 && nAdType != nil && ![nAdType isEqual:[NSNull null]] && ![nAdType isEqualToString:@""]) {
            hjStorage.cps++;
            if (hjStorage.cps >= hjAdDto.cpts) {
                hjStorage.cps = 0;
                if ([nAdType isEqualToString:@"3"]) {
                    NSLog(@"___________rewardVideoAdDidVisible______111");
                    KBAdsRequest *request = [KBAdsRequest request];
                    request.placementId = nAdId;
                    self.hjitl = [[KBAdsSdkInterstitial alloc] initWithRequest:request];
                    [self.hjitl loadAd];
                }
            }
        }
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onVideoAdPlayStart)]) {
            [self.delegate onVideoAdPlayStart];
        } else {
            // 处理可选方法未实现的情况
            NSLog(@"可选方法未实现 onVideoAdPlayStart");
        }
    }
}

- (void)rewardVideoAdDidClick:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"KBAdsSdkReward %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onVideoAdClicked)]) {
            [self.delegate onVideoAdClicked];
        } else {
            // 处理可选方法未实现的情况
            NSLog(@"可选方法未实现 onVideoAdClicked");
        }
    }
}

- (void)rewardVideoAdDidClickSkip:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"KBAdsSdkReward %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onVideoAdSkiped)]) {
            [self.delegate onVideoAdSkiped];
        } else {
            // 处理可选方法未实现的情况
            NSLog(@"可选方法未实现 onVideoAdSkiped");
        }
    }
}

- (void)rewardVideoAdDidClose:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"KBAdsSdkReward %@", NSStringFromSelector(_cmd));
    if (self.hjitl != nil && self.hjitl.isAdReady) {
        NSLog(@"HJ-LOG rewardVideoAdDidClose__1 %@", NSStringFromSelector(_cmd));
        [self.hjitl show:self.rvController];
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onVideoAdClosed)]) {
            [self.delegate onVideoAdClosed];
        } else {
            // 处理可选方法未实现的情况
            NSLog(@"可选方法未实现 onVideoAdClosed");
        }
    }
}

- (void)rewardVideoAdDidPlayFinish:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    NSLog(@"KBAdsSdkReward %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if (error) {
            if ([self.delegate respondsToSelector:@selector(onVideoAdPlayError:error:)]) {
                [self.delegate onVideoAdPlayError: rewardVideoAd.placementId error: error];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 onVideoAdPlayError");
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(onVideoAdPlayEnd)]) {
                [self.delegate onVideoAdPlayEnd];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 onVideoAdPlayEnd");
            }
        }
    }
}

- (void)rewardVideoAd:(nonnull WindMillRewardVideoAd *)rewardVideoAd reward:(nonnull WindMillRewardInfo *)reward {
    NSLog(@"KBAdsSdkReward %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        [self.delegate onVideoRewarded:reward.transId];
    }
}

- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
    self.rewardAd.delegate = nil;
    self.rewardAd = nil;
    self.delegate = nil;
    self.rewardId = nil;
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
