//
//  SVAdsSdkReward.h
//  SVOpenADSSDK
//
//  Created by 魏堰青 on 2026/4/24.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SVAdsRequest;
@protocol SVRewardAdDelegate <NSObject>

@required

-(void) onVideoRewarded:(NSString *_Nonnull) transId;

@optional
-(void) onVideoAdLoadSuccess:(NSString *) placementId;
-(void) onVideoAdLoadError:(NSString *) placementId error:(NSError *)error;
-(void) onVideoAdPlayStart;
-(void) onVideoAdPlayEnd;
-(void) onVideoAdClicked;
-(void) onVideoAdClosed;
-(void) onVideoAdSkiped;
-(void) onVideoAdPlayError:(NSString *) placementId error:(NSError *)error;

@end

@interface SVAdsSdkReward : NSObject
/// 广告代理对象
@property (nonatomic, weak) id<SVRewardAdDelegate> delegate;

- (instancetype)initWithRequest:(SVAdsRequest *)request;
- (BOOL)isAdReady;
- (void)loadAd;
- (void)show:(UIViewController *)rootViewController options:(NSDictionary<NSString *, NSString *> * _Nullable)options;
@end
