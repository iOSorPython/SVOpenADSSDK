//
//  SVBannerView.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SVAdsRequest;
@class SVBannerView;

NS_ASSUME_NONNULL_BEGIN

@protocol SVBannerViewDelegate <NSObject>

@optional

- (void)bannerAdViewDidAutoRefresh:(SVBannerView *)bannerAdView;

- (void)bannerViewFailedToAutoRefreshWithError:(NSError *)error;

- (void)bannerAdViewLoadSuccess:(SVBannerView *)bannerAdView;

- (void)bannerAdViewFailedToLoadError:(NSError *)error;

- (void)bannerAdViewWillExpose;

- (void)bannerAdViewDidClicked;

- (void)bannerAdViewWillLeaveApplication;

- (void)bannerAdViewWillOpenFullScreen;
- (void)bannerAdViewCloseFullScreen;
- (void)bannerAdViewDidRemoved;
@end

@interface SVBannerView : NSObject

@property (nonatomic, weak) id<SVBannerViewDelegate> delegate;

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic) BOOL animated;

@property (nonatomic, assign) CGSize adSize;
@property(nullable, nonatomic,copy) UIColor *backgroundColor;

- (instancetype)initWithRequest:(SVAdsRequest *)request;

- (instancetype)initWithRequest:(SVAdsRequest *)request
                     expectSize:(CGSize)expectSize;

- (void)loadAdData;
- (BOOL)isAdValid;
- (UIView *)getView;
@end
NS_ASSUME_NONNULL_END
