//
//  KBNativeAd.h
//  KBMOB
//
//


#import <WindMillSDK/WindMillSDK.h>

@interface KBNativeAd : NSObject
- (instancetype)initWithAd:(WindMillNativeAd *) ad;
- (WindMillNativeAd *)getAd;
@end
