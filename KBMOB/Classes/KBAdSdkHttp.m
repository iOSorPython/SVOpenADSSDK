//
//  KBAdSdkHttp.m
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import "KBAdSdkHttp.h"

#import "KBAdDto.h"
#import "KBStorage.h"
#import <Foundation/Foundation.h>

@interface KBAdSdkHttp()


@end

@implementation KBAdSdkHttp

NSString *const URL_CONFIG=@"https://sdk.huimiaokeji.com/appApi/app/free/ads/v2/conf";

+ (void)postWithURLString:(NSString *)urlString
                  jsonData:(NSDictionary *)jsonData
                completion:(NetworkManagerCompletionBlock)completion {
      
    // 检查URLString
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        NSError *error = [NSError errorWithDomain:@"NetworkManager" code:-1000 userInfo:@{NSLocalizedDescriptionKey: @"Invalid URL string"}];
        if (completion) {
            completion(nil, nil, error);
        }
        return;
    }
      
    // 序列化JSON数据
    NSError *jsonError = nil;
    NSData *jsonDataToSend = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&jsonError];
    if (!jsonDataToSend) {
        if (completion) {
            completion(nil, nil, jsonError);
        }
        return;
    }
      
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = jsonDataToSend;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 创建配置并设置超时时间
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.timeoutIntervalForRequest = 30.0; // 设置请求超时时间
    // 发送请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completion) {
            completion(data, response, error);
        }
    }];
      
    [dataTask resume];
}

+ (void)queryConfig:(NSString *) appId  {
    NSDictionary *jsonData = @{@"appId": appId};
    [KBAdSdkHttp postWithURLString:URL_CONFIG jsonData:jsonData completion:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
                // 处理响应数据
                NSError *jsonError = nil;
                NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if (!jsonError) {
                    // 使用responseJSON
                    NSLog(@"HJ-LOG _____1");
                    NSNumber *codeNumber = responseJSON[@"code"];
                    NSDictionary *data = responseJSON[@"data"];
                    if ([codeNumber intValue] == 200 && data != nil) {
                        KBStorage *hjStorage = [KBStorage shareInstance];
                        NSArray *array = (NSArray *)data;
                        for (NSDictionary *dict in array) {
                            KBAdDto *hjAdDto = [[KBAdDto alloc] init];
                            hjAdDto.adsId = dict[@"adsId"];
                            hjAdDto.nAdId = dict[@"nextAdvertId"];
                            hjAdDto.nAdType = dict[@"nextAdvertType"];
                            NSNumber *cpts = dict[@"countPoints"];
                            if (cpts) {
                                hjAdDto.cpts = [cpts intValue];
                            }
                            NSNumber *ddrt = dict[@"downloadRate"];
                            if (ddrt) {
                                hjAdDto.ddrt = [ddrt intValue];
                            }
                            hjAdDto.oAppId = dict[@"oldAppId"];
                            hjAdDto.nAppId = dict[@"newAppId"];
                            hjAdDto.nAdCode = dict[@"newAdCode"];
                            NSLog(@"HJ-LOG _____2");
                              [hjStorage addStrategyDtos:hjAdDto.adsId kbAdDto:hjAdDto];
                        }
                    }
                } else {
                    // 处理JSON解析错误
                    NSLog(@"HJ-LOG Parsing Error: %@", jsonError);
                }
            } else {
                // 处理网络错误
                NSLog(@"HJ-LOG Network Error: %@", error);
            }
    }];
}
@end
