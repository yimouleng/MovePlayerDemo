//
//  ViewController.m
//  MovePlayerDemo
//
//  Created by 朱飞飞 on 15/9/2.
//  Copyright (c) 2015年 朱飞飞. All rights reserved.
//
#import "MyPlayMovieView.h"
#import "ViewController.h"

@interface ViewController ()
{
    MyPlayMovieView *play;
}
@end
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation ViewController
- (IBAction)fullScreen:(UIButton *)sender {
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
//    
//    //适配iOS8以下,iOS8以下bounds不同
//    CGFloat max = MAX(ScreenHeight, ScreenWidth);
//    CGFloat min = MIN(ScreenHeight, ScreenWidth);
    //play.frame = CGRectMake(0, 0, max, min);
    [play.player setFullscreen:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    play = [[MyPlayMovieView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width *(9/16.0)) ];
    [self.view addSubview:play];
    play.fullScreen = ^(BOOL isFull){
        
        if (isFull) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
            CGFloat max = MAX(ScreenHeight, ScreenWidth);
            CGFloat min = MIN(ScreenHeight, ScreenWidth);
            play.frame = CGRectMake(0, 0, max, min);
            [play setUIFrame];
            //[play.player setFullscreen:YES animated:YES];
            
        }else{
            
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            play.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width *(9/16.0));
            //play.player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width *(9/16.0));
            [play.player setFullscreen:NO animated:YES];
            [play setBackFrame];
           // fullScreenBT.frame = CGRectMake(0, 0, 100, 100);
        }
    };
}



//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//
//{
//    
//    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//    
//}
//
//- (BOOL)shouldAutorotate
//
//{
//    
//    return NO;
//    
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//
//{
//    
//    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
//    
//}

@end
