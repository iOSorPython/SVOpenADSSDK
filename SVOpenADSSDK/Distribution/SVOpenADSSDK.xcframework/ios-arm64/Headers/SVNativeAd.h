//
//  SVNativeAd.h
//  SVOpenADSSDK
//
//


#import <WindMillSDK/WindMillSDK.h>

@interface SVNativeAd : NSObject
- (instancetype)initWithAd:(WindMillNativeAd *) ad;
- (WindMillNativeAd *)getAd;
@end
