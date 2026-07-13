//
//  KBNativeAdsManager.m
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import "KBNativeAdsManager.h"


#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>
#import "KBAdsRequest.h"
#import "KBNativeAd.h"
#import "NumberEncryptUtil.h"

@interface KBNativeAdsManager ()<WindMillNativeAdsManagerDelegate>
@property (nonatomic, strong) WindMillNativeAdsManager *nativeAdsManager;
@end

@implementation KBNativeAdsManager

- (instancetype)initWithRequest:(KBAdsRequest *)request {
    WindMillAdRequest *req = [WindMillAdRequest request];
//    req.placementId = request.placementId;
    req.placementId =  [self decode:request.placementId];

    req.userId = request.userId;
    req.options = request.options;
    self.nativeAdsManager = [[WindMillNativeAdsManager alloc] initWithRequest:req];
    self.nativeAdsManager.delegate = self;
    return self;
}

- (void)loadAdDataWithCount:(NSInteger)count {
    if (self.adSize.width != 0 && self.adSize.height != 0 && self.nativeAdsManager) {
        self.nativeAdsManager.adSize = CGSizeMake(self.adSize.width, self.adSize.height);
        [self.nativeAdsManager loadAdDataWithCount:count];
    }
}

- (NSArray<KBNativeAd *> * _Nullable)getAllNativeAds {
    NSArray<WindMillNativeAd *> *nativeAdList = [self.nativeAdsManager getAllNativeAds];
    if (nativeAdList.count == 0) return @[];
    NSMutableArray *array = [NSMutableArray array];
    for (id nativeAd in nativeAdList) {
        KBNativeAd *ad = [[KBNativeAd alloc] initWithAd: nativeAd];
        [array addObject:ad];
    }
    return [array copy];
}

#pragma mark - ----- WindMillNativeAdsManagerDelegate -----


- (void)nativeAdsManagerSuccessToLoad:(WindMillNativeAdsManager *)adsManager {
    NSLog(@"KBNativeAdsManager nativeAdsManagerSuccessToLoad %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( nativeAdsManagerSuccessToLoad:)]) {
                [self.delegate nativeAdsManagerSuccessToLoad:self];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 nativeAdsManagerSuccessToLoad");
            }
    }
}

- (void)nativeAdsManager:(WindMillNativeAdsManager *)adsManager didFailWithError:(NSError *)error {
    NSLog(@"KBNativeAdsManager nativeAdsManager didFailWithError %@", NSStringFromSelector(_cmd));
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector( nativeAdsManagerdidFailWithError:)]) {
                [self.delegate nativeAdsManagerdidFailWithError:error];
            } else {
                // 处理可选方法未实现的情况
                NSLog(@"可选方法未实现 nativeAdsManagerdidFailWithError");
            }
    }
}

//- (void)dealloc {
//    NSLog(@"--- dealloc -- %@", self);
//    self.nativeAdsManager.delegate = nil;
//    self.nativeAdsManager = nil;
//    self.delegate = nil;
//}

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
