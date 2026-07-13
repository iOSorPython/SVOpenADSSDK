//
//  KBNativeAdsManager.h
//  KBMOB
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KBAdsRequest;
@class KBNativeAd;
@class KBNativeAdsManager;

@protocol KBNativeAdsManagerDelegate <NSObject>

@optional
- (void)nativeAdsManagerSuccessToLoad:(KBNativeAdsManager *)nativeAdsManager;
- (void)nativeAdsManagerdidFailWithError:(NSError *)error;

@end


@interface KBNativeAdsManager : NSObject

@property (nonatomic, weak) id<KBNativeAdsManagerDelegate> delegate;

@property (nonatomic, assign, readwrite) CGSize adSize;

- (instancetype)initWithRequest:(KBAdsRequest *)request;

- (void)loadAdDataWithCount:(NSInteger)count;

- (NSArray<KBNativeAd *> * _Nullable)getAllNativeAds;

@end

