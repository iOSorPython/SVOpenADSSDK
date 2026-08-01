//
//  SVNativeAdView.h
//  SVOpenADSSDK
//

//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SVNativeAdView;
@class SVNativeAd;
@protocol SVNativeAdViewDelegate <NSObject>
@optional
- (void)nativeExpressAdViewRenderSuccess:(SVNativeAdView *)nativeExpressAdView;
- (void)nativeExpressAdViewRenderFail:(NSError *)error;
- (void)nativeAdViewWillExpose;
- (void)nativeAdViewDidClick;
- (void)dislikeWithReason:(NSString *) reason;

@end
@interface SVNativeAdView : NSObject
+ (instancetype) initAdView;

@property(nonatomic) CGRect frame;
@property (nonatomic, weak) id<SVNativeAdViewDelegate> delegate;
@property (nonatomic, weak) UIViewController *viewController;
- (void)refreshData:(SVNativeAd *)nativeAd;
- (UIView *)getView;
@end
