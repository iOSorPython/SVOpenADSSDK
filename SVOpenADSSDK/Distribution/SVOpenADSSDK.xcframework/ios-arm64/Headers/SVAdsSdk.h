//
//  SVAdsSdk.h
//  SVOpenADSSDK
//
//  Created by 魏堰青 on 2026/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAdsSdk : NSObject
+(instancetype) sharedAds;
-(void)setupSDKWithAppId:(NSString *)appId;
-(void)setDebugEnable:(BOOL)enable;
-(void) startAdPreviously:(NSString *)rewardId interstitialId:(NSString *)interstitialId fullScreenId:(NSString *)fullScreenId userId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
