//
//  KBAdPreviously.h
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface KBAdPreviously : NSObject
+(instancetype) shareInstance;
-(void)startAdPreviously:(NSString *)rewardId interstitialId:(NSString *)interstitialId fullScreenId:(NSString *)fullScreenId userId:(NSString *)userId;
-(WindMillRewardVideoAd *) getPrevRewardAd;
-(WindMillIntersititialAd *) getPrevInterstitialAd;
-(WindMillIntersititialAd *) getPrevFullScreenAd;
-(NSString *) getInterstitialId;
-(NSString *) getFullScreenId;
@end

NS_ASSUME_NONNULL_END
