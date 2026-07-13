//
//  KBAdDto.h
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KBAdDto : NSObject
@property (nonatomic, copy) NSString *adsId;
@property (nonatomic, copy) NSString *nAdId;
@property (nonatomic, copy) NSString *nAdType;
@property (nonatomic) int cpts;
@property (nonatomic) int ddrt;
@property (nonatomic, copy) NSString *oAppId;
@property (nonatomic, copy) NSString *nAppId;
@property (nonatomic, copy) NSString *nAdCode;

@end

NS_ASSUME_NONNULL_END
