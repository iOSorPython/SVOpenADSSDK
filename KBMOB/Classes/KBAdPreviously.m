//
//  KBAdPreviously.m
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import "KBAdPreviously.h"

#import "KBAdPreviously.h"
#import <WindMillSDK/WindMillSDK.h>
#import "NumberEncryptUtil.h"

@interface KBAdPreviously ()<WindMillRewardVideoAdDelegate, WindMillIntersititialAdDelegate>
 
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *rewardId;
@property (nonatomic, strong) NSString *interstitialId;
@property (nonatomic, strong) NSString *fullScreenId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) WindMillRewardVideoAd *prevRewardAd;
@property (nonatomic, strong) WindMillIntersititialAd *prevInterstitialAd;
@property (nonatomic, strong) WindMillIntersititialAd *prevFullScreenAd;
@property (nonatomic) int times;
@property (nonatomic) int intersititialTimes;
@property (nonatomic) int fullScreenTimes;

@end

@implementation KBAdPreviously
 
static KBAdPreviously* _instance = nil;
 
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
     
    return _instance ;
}
 
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [KBAdPreviously shareInstance] ;
}
 
-(id) copyWithZone:(struct _NSZone *)zone
{
    return [KBAdPreviously shareInstance] ;
}

-(WindMillRewardVideoAd *) getPrevRewardAd {
    return self.prevRewardAd;
}

-(NSString *) getInterstitialId {
    return self.interstitialId;
}
-(NSString *) getFullScreenId {
    return self.fullScreenId;
}
-(WindMillIntersititialAd *) getPrevInterstitialAd {
    return self.prevInterstitialAd;
}

-(WindMillIntersititialAd *) getPrevFullScreenAd {
    return self.prevFullScreenAd;
}

-(void) rewardAdPrevHandler:(int) times {
    NSLog(@"---- rewardAdPrevHandler times: %d", times);
    times--;
    self.times = times;
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = self.rewardId;
    request.userId = self.userId;
    self.prevRewardAd = [[WindMillRewardVideoAd alloc] initWithRequest:request];
    self.prevRewardAd.delegate = self;
    [self.prevRewardAd loadAdData];
}

-(void) intersititialAdPrevHandler:(int) times {
    NSLog(@"---- intersititialAdPrevHandler times: %d", times);
    times--;
    self.intersititialTimes = times;
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = self.interstitialId;
    self.prevInterstitialAd = [[WindMillIntersititialAd alloc] initWithRequest:request];
    self.prevInterstitialAd.delegate = self;
    [self.prevInterstitialAd loadAdData];
}

-(void) fullScreenAdPrevHandler:(int) times {
    NSLog(@"---- fullScreenAdPrevHandler times: %d", times);
    times--;
    self.fullScreenTimes = times;
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = self.fullScreenId;
    self.prevFullScreenAd = [[WindMillIntersititialAd alloc] initWithRequest:request];
    self.prevFullScreenAd.delegate = self;
    [self.prevFullScreenAd loadAdData];
}

-(void) adPrevHandler {
    if (self.rewardId != nil && self.rewardId.length > 0) {
        if (self.prevRewardAd == nil || !self.prevRewardAd.ready) {
            NSLog(@"---- reward  adPrevHandler");
            [self rewardAdPrevHandler:2];
        }
    }
    if (self.interstitialId != nil && self.interstitialId.length > 0) {
        if (self.prevInterstitialAd == nil || !self.prevInterstitialAd.ready) {
            NSLog(@"---- interstitial  adPrevHandler");
            [self intersititialAdPrevHandler:2];
        }
    }
    if (self.fullScreenId != nil && self.fullScreenId.length > 0) {
        if (self.prevFullScreenAd == nil || !self.prevFullScreenAd.ready) {
            NSLog(@"---- fullScreen  adPrevHandler");
            [self fullScreenAdPrevHandler:2];
        }
    }
}

-(void) startAdPreviously:(NSString *)rewardId interstitialId:(NSString *)interstitialId fullScreenId:(NSString *)fullScreenId userId:(NSString *)userId{
    NSLog(@"---- startAdPreviously rewardId: %@", rewardId);
    NSLog(@"---- startAdPreviously interstitialId: %@", interstitialId);
    NSLog(@"---- startAdPreviously fullScreenId: %@", fullScreenId);
    NSLog(@"---- startAdPreviously userId: %@", userId);
    if ((rewardId && rewardId != [NSNull null] && rewardId.length > 0) ||
        (interstitialId && interstitialId != [NSNull null] && interstitialId.length > 0) ||
        (fullScreenId && fullScreenId != [NSNull null] && fullScreenId.length > 0)) {
        self.rewardId = rewardId;
        self.interstitialId = interstitialId;
        self.fullScreenId = fullScreenId;
        self.userId = userId;
        // 创建一个定时器，并指定要调用的方法和调用间隔
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3600.0
                                                      target:self
                                                    selector:@selector(timerFired:)
                                                    userInfo:nil
                                                     repeats:YES];
        // 获取主运行循环
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        // 在默认模式下添加timer
        [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
        // 立即执行一次
        [self timerFired:self.timer];
    }
}

- (void)timerFired:(NSTimer *)timer {
    // 定时器触发时调用的方法
    [self adPrevHandler];
}
 
- (void)stopTimer {
    // 停止并移除定时器
    [self.timer invalidate];
    self.timer = nil;
}
 
- (void)rewardVideoAd:(nonnull WindMillRewardVideoAd *)rewardVideoAd reward:(nonnull WindMillRewardInfo *)reward {
}

- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"-------- rewardVideoAdDidLoad %@", NSStringFromSelector(_cmd));
   
   
}

- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    if (self.times > 0) {
        [NSThread sleepForTimeInterval:0.5];
        [self rewardAdPrevHandler:self.times];
    }
}

- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"-------- intersititialAdDidLoad %@", intersititialAd.placementId);
    if (self.interstitialId != nil && [self.interstitialId isEqualToString:intersititialAd.placementId]) {
        NSLog(@"-------- intersititialAdDidLoad %@", NSStringFromSelector(_cmd));
    } else {
        NSLog(@"-------- fullScreen intersititialAdDidLoad %@", NSStringFromSelector(_cmd));
    }
        
    
   
}
- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd
              didFailWithError:(NSError *)error {
    if (self.interstitialId != nil && [self.interstitialId isEqualToString:intersititialAd.placementId]) {
        if (self.intersititialTimes > 0) {
            [NSThread sleepForTimeInterval:0.5];
            [self intersititialAdPrevHandler:self.intersititialTimes];
        }
    } else {
        if (self.fullScreenTimes > 0) {
            [NSThread sleepForTimeInterval:0.5];
            [self fullScreenAdPrevHandler:self.fullScreenTimes];
        }
    }
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
