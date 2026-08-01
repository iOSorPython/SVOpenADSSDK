//
//  SVAdsRequest.h
//  SVOpenADSSDK
//
//  Created by 魏堰青 on 2026/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAdsRequest : NSObject

// 【可选】，媒体用户ID。
@property (nonatomic,copy) NSString *userId;

// 【比传】，广告位ID。
@property (nonatomic,copy) NSString *placementId;

// 【可选】，服务端激励回传时，透传参数。
@property (nonatomic,strong) NSDictionary<NSString *, NSString *> *options;

+ (instancetype)request;

@end

NS_ASSUME_NONNULL_END
