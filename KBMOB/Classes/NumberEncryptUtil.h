//
//  NumberEncryptUtil.h
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NumberEncryptUtil : NSObject
/// 默认密钥
+ (NSString *)secureEncrypt:(NSString *)data;
+ (NSString *)secureEncrypt:(NSString *)data key:(NSString *)key;

+ (NSString *)secureDecrypt:(NSString *)encryptedData;
+ (NSString *)secureDecrypt:(NSString *)encryptedData key:(NSString *)key;

/// 10 进制字符串转 8 进制字符串
+ (NSString *)decimalToOctal:(NSString *)decimalStr;
@end

NS_ASSUME_NONNULL_END
