//
//  KBAdsSdkSplash.h
//  KBMOB
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KBAdsRequest;
@protocol KBSplashAdDelegate <NSObject>
@optional
-(void) onSplashAdSuccessPresent;
-(void) onSplashAdFailToPresent:(NSString *) placementId error:(NSError *)error;
-(void) onSplashAdSuccessLoad:(NSString *) placementId;
-(void) onSplashAdFailToLoad:(NSString *) placementId error:(NSError *)error;
-(void) onSplashAdClicked;
-(void) onSplashAdClosed;
-(void) onSplashAdSkiped;

@end

@interface KBAdsSdkSplash : NSObject
/// 广告代理对象
@property (nonatomic, weak) id<KBSplashAdDelegate> delegate;
@property (nonatomic, weak) UIViewController *rootViewController;

- (instancetype)initWithRequest:(KBAdsRequest *)request
                              extra:(NSDictionary * _Nullable)extra;
- (instancetype)initWithRequest:(KBAdsRequest *)request;
- (BOOL)isAdReady;
-(void)loadAdAndShow;
- (void)loadAd;
- (void)showAdInWindow:(UIWindow *)window;
@end
