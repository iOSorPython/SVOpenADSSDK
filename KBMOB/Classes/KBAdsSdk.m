//
//  KBAdsSdk.m
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import "KBAdsSdk.h"

#import "KBAdSdkHttp.h"
#import "KBAdPreviously.h"
#import <WindMillSDK/WindMillSDK.h>
#import "NumberEncryptUtil.h"

@interface KBAdsSdk ()

@end

@implementation KBAdsSdk
static KBAdsSdk* _instance = nil;

+(instancetype) sharedAds
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
     
    return _instance ;
}
 
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [KBAdsSdk sharedAds] ;
}
 
-(id) copyWithZone:(struct _NSZone *)zone
{
    return [KBAdsSdk sharedAds] ;
}
-(void)setupSDKWithAppId:(NSString *)appId
{
//    [WindMillAds setupSDKWithAppId:appId];
//    [KBAdSdkHttp queryConfig:appId];
    NSString *myAppId  = [self decode:appId];
//    [WindMillAds setupSDKWithAppId:myAppId];
    [WindMillAds setupSDKWithAppId:myAppId completionHandler:^(BOOL, NSError * _Nullable) {
        
    }];
    
    [KBAdSdkHttp queryConfig:myAppId];
}

-(void)setDebugEnable:(BOOL)enable
{
    [WindMillAds setDebugEnable:enable];
}

-(void) startAdPreviously:(NSString *)rewardId interstitialId:(NSString *)interstitialId fullScreenId:(NSString *)fullScreenId userId:(NSString *)userId
{
    KBAdPreviously* KBAdPre = [KBAdPreviously shareInstance];
    [KBAdPre startAdPreviously:rewardId interstitialId:interstitialId fullScreenId:fullScreenId userId:userId];
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
