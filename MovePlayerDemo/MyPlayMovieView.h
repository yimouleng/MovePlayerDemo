//
//  MyPlayMovieView.h
//  MovePlayerDemo
//
//  Created by 朱飞飞 on 15/9/2.
//  Copyright (c) 2015年 朱飞飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface MyPlayMovieView : UIView

@property (nonatomic,strong) MPMoviePlayerController *player;
@property (nonatomic,copy) void (^fullScreen) (BOOL);
- (void)setUIFrame;
- (void)setBackFrame;
@end
