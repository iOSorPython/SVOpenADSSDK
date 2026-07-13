//
//  KBStorage.m
//  KBMOB
//
//  Created by 魏堰青 on 2026/4/24.
//

#import "KBStorage.h"

#import "KBAdDto.h"

@interface KBStorage ()

@property (nonatomic, strong) NSMutableDictionary *strategyDict;
@end

@implementation KBStorage

static KBStorage* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
        _instance.strategyDict = [NSMutableDictionary dictionary];
    }) ;
     
    return _instance ;
}
 
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [KBStorage shareInstance] ;
}
 
-(id) copyWithZone:(struct _NSZone *)zone
{
    return [KBStorage shareInstance] ;
}

-(void) addStrategyDtos:(NSString *)adsId kbAdDto:(KBAdDto *) kbAdDto
{
    self.strategyDict[adsId] = kbAdDto;
}

-(KBAdDto *) getStrategy: (NSString *)adsId
{
    return self.strategyDict[adsId];
}



@end
