//
//  NumberEncryptUtil.m
//  KBMOB

#import "NumberEncryptUtil.h"

#import "NumberEncryptUtil.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NumberEncryptUtil

static NSString * const DEFAULT_KEY = @"32e326b5053bc97b895f2c14c228af82";

#pragma mark - Public

+ (NSString *)secureEncrypt:(NSString *)data {
    return [self secureEncrypt:data key:DEFAULT_KEY];
}

+ (NSString *)secureEncrypt:(NSString *)data key:(NSString *)key {
    NSString *paddedData = [self padDataTo16Digits:data];
    NSArray<NSNumber *> *encryptKey = [self generateEncryptionKey:key];

    NSMutableString *result = [NSMutableString stringWithCapacity:16];
    for (NSInteger i = 0; i < 16; i++) {
        NSInteger digit = [paddedData characterAtIndex:i] - '0';
        digit = (digit + encryptKey[i].integerValue) % 10;
        [result appendFormat:@"%ld", (long)digit];
    }
    return result;
}

+ (NSString *)secureDecrypt:(NSString *)encryptedData {
    return [self secureDecrypt:encryptedData key:DEFAULT_KEY];
}

+ (NSString *)secureDecrypt:(NSString *)encryptedData key:(NSString *)key {
    if (encryptedData.length != 16) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"输入必须是16位数字"
                                     userInfo:nil];
    }

    NSArray<NSNumber *> *encryptKey = [self generateEncryptionKey:key];

    NSMutableString *result = [NSMutableString stringWithCapacity:16];
    for (NSInteger i = 0; i < 16; i++) {
        NSInteger digit = [encryptedData characterAtIndex:i] - '0';
        digit = (digit - encryptKey[i].integerValue + 10) % 10;
        [result appendFormat:@"%ld", (long)digit];
    }
    return result;
}

+ (NSString *)decimalToOctal:(NSString *)decimalStr {
    if (decimalStr.length == 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"输入不能为空"
                                     userInfo:nil];
    }

    NSCharacterSet *nonDigits =
        [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([decimalStr rangeOfCharacterFromSet:nonDigits].location != NSNotFound) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"输入必须是纯数字字符串"
                                     userInfo:nil];
    }

    unsigned long long value = decimalStr.longLongValue;
    return [NSString stringWithFormat:@"%llo", value];
}

#pragma mark - Private

/// 补齐 / 截断为 16 位纯数字（与 Java 版完全一致）
+ (NSString *)padDataTo16Digits:(NSString *)data {
    if (data == nil) {
        data = @"";
    }

    NSCharacterSet *nonDigits =
        [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([data rangeOfCharacterFromSet:nonDigits].location != NSNotFound) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"输入必须是纯数字"
                                     userInfo:nil];
    }

    if (data.length >= 16) {
        return [data substringToIndex:16];
    }

    NSMutableString *padded = [data mutableCopy];
    while (padded.length < 16) {
        [padded appendString:@"0"];
    }
    return padded;
}

/// 使用 MD5 生成 16 位加密 key（完全对齐 Java 实现）
//+ (NSArray<NSNumber *> *)generateEncryptionKey:(NSString *)key {
//    NSData *data = [key dataUsingEncoding:NSUTF8StringEncoding];
//
//    unsigned char md[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(data.bytes, (CC_LONG)data.length, md);
//
//    NSMutableArray<NSNumber *> *result = [NSMutableArray arrayWithCapacity:16];
//    for (NSInteger i = 0; i < 16; i++) {
//        int value = abs((int)md[i] % 10);
//        [result addObject:@(value)];
//    }
//    return result;
//}
+ (NSArray<NSNumber *> *)generateEncryptionKey:(NSString *)key {
    NSData *data = [key dataUsingEncoding:NSUTF8StringEncoding];

    unsigned char md[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, md);

    NSMutableArray<NSNumber *> *result = [NSMutableArray arrayWithCapacity:16];

    for (NSInteger i = 0; i < 16; i++) {
        int8_t signedByte = (int8_t)md[i];   // 关键：模拟 Java byte
        int value = abs(signedByte % 10);
        [result addObject:@(value)];
    }

    return result;
}
@end
