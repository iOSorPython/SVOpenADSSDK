//
//  KBNativeAdView.h
//  KBMOB
//

//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KBNativeAdView;
@class KBNativeAd;
@protocol KBNativeAdViewDelegate <NSObject>
@optional
- (void)nativeExpressAdViewRenderSuccess:(KBNativeAdView *)nativeExpressAdView;
- (void)nativeExpressAdViewRenderFail:(NSError *)error;
- (void)nativeAdViewWillExpose;
- (void)nativeAdViewDidClick;
- (void)dislikeWithReason:(NSString *) reason;

@end
@interface KBNativeAdView : NSObject
+ (instancetype) initAdView;

@property(nonatomic) CGRect frame;
@property (nonatomic, weak) id<KBNativeAdViewDelegate> delegate;
@property (nonatomic, weak) UIViewController *viewController;
- (void)refreshData:(KBNativeAd *)nativeAd;
- (UIView *)getView;
@end
