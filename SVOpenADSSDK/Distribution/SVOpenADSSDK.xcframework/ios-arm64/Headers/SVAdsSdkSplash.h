//
//  SVAdsSdkSplash.h
//  SVOpenADSSDK
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SVAdsRequest;
@protocol SVSplashAdDelegate <NSObject>
@optional
-(void) onSplashAdSuccessPresent;
-(void) onSplashAdFailToPresent:(NSString *) placementId error:(NSError *)error;
-(void) onSplashAdSuccessLoad:(NSString *) placementId;
-(void) onSplashAdFailToLoad:(NSString *) placementId error:(NSError *)error;
-(void) onSplashAdClicked;
-(void) onSplashAdClosed;
-(void) onSplashAdSkiped;

@end

@interface SVAdsSdkSplash : NSObject
/// 广告代理对象
@property (nonatomic, weak) id<SVSplashAdDelegate> delegate;
@property (nonatomic, weak) UIViewController *rootViewController;

- (instancetype)initWithRequest:(SVAdsRequest *)request
                              extra:(NSDictionary * _Nullable)extra;
- (instancetype)initWithRequest:(SVAdsRequest *)request;
- (BOOL)isAdReady;
-(void)loadAdAndShow;
- (void)loadAd;
- (void)showAdInWindow:(UIWindow *)window;
@end
