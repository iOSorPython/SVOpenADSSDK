//
//  KBBannerView.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class KBAdsRequest;
@class KBBannerView;

NS_ASSUME_NONNULL_BEGIN

@protocol KBBannerViewDelegate <NSObject>

@optional

- (void)bannerAdViewDidAutoRefresh:(KBBannerView *)bannerAdView;

- (void)bannerViewFailedToAutoRefreshWithError:(NSError *)error;

- (void)bannerAdViewLoadSuccess:(KBBannerView *)bannerAdView;

- (void)bannerAdViewFailedToLoadError:(NSError *)error;

- (void)bannerAdViewWillExpose;

- (void)bannerAdViewDidClicked;

- (void)bannerAdViewWillLeaveApplication;

- (void)bannerAdViewWillOpenFullScreen;
- (void)bannerAdViewCloseFullScreen;
- (void)bannerAdViewDidRemoved;
@end

@interface KBBannerView : NSObject

@property (nonatomic, weak) id<KBBannerViewDelegate> delegate;

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic) BOOL animated;

@property (nonatomic, assign) CGSize adSize;
@property(nullable, nonatomic,copy) UIColor *backgroundColor;

- (instancetype)initWithRequest:(KBAdsRequest *)request;

- (instancetype)initWithRequest:(KBAdsRequest *)request
                     expectSize:(CGSize)expectSize;

- (void)loadAdData;
- (BOOL)isAdValid;
- (UIView *)getView;
@end
NS_ASSUME_NONNULL_END
