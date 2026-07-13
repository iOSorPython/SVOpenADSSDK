//
//  KBStorage.h
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import <Foundation/Foundation.h>
#import "KBAdDto.h"

NS_ASSUME_NONNULL_BEGIN

@interface KBStorage : NSObject
@property (nonatomic) int cps;
+(instancetype) shareInstance;
-(void) addStrategyDtos:(NSString *)adsId kbAdDto:(KBAdDto *) kbAdDto;
-(KBAdDto *) getStrategy: (NSString *)adsId;
@end

NS_ASSUME_NONNULL_END
