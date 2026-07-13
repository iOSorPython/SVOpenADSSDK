//
//  KBAdsSdkInterstitial.h
//  KBMOB
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KBAdsRequest;
@protocol KBInterstitialAdDelegate <NSObject>
@optional
-(void) onInterstitialAdLoadSuccess:(NSString *) placementId;
-(void) onInterstitialAdLoadError:(NSString *) placementId error:(NSError *)error;
-(void) onInterstitialAdPlayStart;
-(void) onInterstitialAdPlayEnd;
-(void) onInterstitialAdClicked;
-(void) onInterstitialAdClosed;
-(void) onInterstitialAdSkiped;

@end

@interface KBAdsSdkInterstitial : NSObject
/// 广告代理对象
@property (nonatomic, weak) id<KBInterstitialAdDelegate> delegate;

- (instancetype)initWithRequest:(KBAdsRequest *)request;
- (BOOL)isAdReady;
- (void)loadAd;
- (void)show:(UIViewController *)rootViewController;
@end
