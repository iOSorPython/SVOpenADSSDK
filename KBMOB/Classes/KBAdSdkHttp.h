//
//  KBAdSdkHttp.h
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import <Foundation/Foundation.h>


typedef void(^NetworkManagerCompletionBlock)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface KBAdSdkHttp : NSObject

+ (void)postWithURLString:(NSString *)urlString
                  jsonData:(NSDictionary *)jsonData
                completion:(NetworkManagerCompletionBlock)completion;

+ (void)queryConfig:(NSString *) appId;

@end
