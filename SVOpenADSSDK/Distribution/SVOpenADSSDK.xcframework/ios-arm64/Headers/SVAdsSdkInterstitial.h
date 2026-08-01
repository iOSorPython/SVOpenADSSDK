//
//  SVAdsSdkInterstitial.h
//  SVOpenADSSDK
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SVAdsRequest;
@protocol SVInterstitialAdDelegate <NSObject>
@optional
-(void) onInterstitialAdLoadSuccess:(NSString *) placementId;
-(void) onInterstitialAdLoadError:(NSString *) placementId error:(NSError *)error;
-(void) onInterstitialAdPlayStart;
-(void) onInterstitialAdPlayEnd;
-(void) onInterstitialAdClicked;
-(void) onInterstitialAdClosed;
-(void) onInterstitialAdSkiped;

@end

@interface SVAdsSdkInterstitial : NSObject
/// 广告代理对象
@property (nonatomic, weak) id<SVInterstitialAdDelegate> delegate;

- (instancetype)initWithRequest:(SVAdsRequest *)request;
- (BOOL)isAdReady;
- (void)loadAd;
- (void)show:(UIViewController *)rootViewController;
@end
