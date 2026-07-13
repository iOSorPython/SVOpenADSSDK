//
//  KBAdsSdkReward.h
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KBAdsRequest;
@protocol KBRewardAdDelegate <NSObject>

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

@interface KBAdsSdkReward : NSObject
/// 广告代理对象
@property (nonatomic, weak) id<KBRewardAdDelegate> delegate;

- (instancetype)initWithRequest:(KBAdsRequest *)request;
- (BOOL)isAdReady;
- (void)loadAd;
- (void)show:(UIViewController *)rootViewController options:(NSDictionary<NSString *, NSString *> * _Nullable)options;
@end
