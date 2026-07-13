//
//  KBViewController.m
//  KBMOB
//
//  Created by iOSorPython on 04/23/2026.
//  Copyright (c) 2026 iOSorPython. All rights reserved.
//

#import "KBViewController.h"
#import <KBMOB/KBAdsOpen.h>

@interface KBViewController ()<KBRewardAdDelegate>

@property (nonatomic, strong) KBAdsSdkReward *rewardVideoAd;

@property (nonatomic, strong) UIImageView *splashImageView;

@end

@implementation KBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

//    
// 
 
//    KBAdsRequest *request = [KBAdsRequest request];
//    request.placementId = @"4275225422854808";
//    self.splash = [[KBAdsSdkSplash alloc] initWithRequest:request];
//    self.splash.delegate = self;
//    self.splash.rootViewController = self;


//    AppDelegate *delegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
    //由于idfa是必须在applicationDidBecomeActiveNotification这个方法中获取, 而这个方法的执行，会在闪屏页面的viewDidload之后
    //所以，如果是采取主动注入idfa到sdk内部的方式， 那么就需要在这里做一个延时操作；否则，闪屏的请求发送时， 获取不到idfa。经测试300ms就够了
//    [self.splash loadAdAndShow];
    
    

    
         KBAdsRequest *request = [KBAdsRequest request];
         request.placementId = @"4858666720758309";
         self.rewardVideoAd = [[KBAdsSdkReward alloc] initWithRequest:request];
         self.rewardVideoAd.delegate = self;
         [self.rewardVideoAd loadAd];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)onVideoRewarded:(NSString * _Nonnull)transId {
    
}

-(void) onVideoAdLoadSuccess:(NSString *) placementId{
    [self.rewardVideoAd show:self options:nil];

}


@end
