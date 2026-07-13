//
//  KBNativeAd.m
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import "KBNativeAd.h"


#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>

@interface KBNativeAd ()
@property (nonatomic, strong) WindMillNativeAd *nativeAd;
@end

@implementation KBNativeAd

- (instancetype)initWithAd:(WindMillNativeAd *) ad {
    self = [super init];
        if (self) {
            _nativeAd = ad;
        }
        return self;
}

- (WindMillNativeAd *)getAd {
    return self.nativeAd;
}

@end
