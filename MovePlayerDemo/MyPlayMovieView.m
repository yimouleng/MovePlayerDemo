//
//  MyPlayMovieView.m
//  MovePlayerDemo
//
//  Created by 朱飞飞 on 15/9/2.
//  Copyright (c) 2015年 朱飞飞. All rights reserved.
//

#import "MyPlayMovieView.h"
@interface MyPlayMovieView ()
{
    UIButton *playOrPauseBT;
    UIButton *fullScreenBT;
    UISlider *_movieProgressSlider;
}

@property (nonatomic,strong) NSTimer *currentPlayTimer; /**< 当前播放时间 */

@end
@implementation MyPlayMovieView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
- (void)makeUI{
    
    _player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://pl.youku.com/playlist/m3u8?vid=331103278&type=flv&ts=1441095517&keyframe=0&ep=ciaQG0mEU8sB4iHbjz8bMXi2cX4NXP0J9x6FgtBlCNQlTuu5&sid=044109551724712fdd592&token=1636&ctype=12&ev=1&oip=2738221694"]];
    
    _player.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width *(9/16.0));
    _player.controlStyle = MPMovieControlStyleNone;
    _player.repeatMode = MPMovieRepeatModeNone;
    _player.scalingMode = MPMovieScalingModeAspectFit;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    [self addSubview:_player.view];
    
    playOrPauseBT = [UIButton buttonWithType:UIButtonTypeCustom];
    playOrPauseBT.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [playOrPauseBT setImage:[UIImage imageNamed:@"btn_main_play"] forState:UIControlStateNormal];
    [playOrPauseBT addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [_player.view addSubview:playOrPauseBT];
    
    
    fullScreenBT = [UIButton buttonWithType:UIButtonTypeCustom];
    fullScreenBT.frame = CGRectMake(self.frame.size.width -30, self.frame.size.height -30, 30, 30);
    [fullScreenBT setImage:[UIImage imageNamed:@"icon_fullscreen"] forState:UIControlStateNormal];
    [fullScreenBT addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    [_player.view addSubview:fullScreenBT];
    fullScreenBT.hidden = YES;
    
    _movieProgressSlider = [[UISlider alloc]initWithFrame:CGRectMake(30, self.frame.size.width -30, self.frame.size.height -60, 20)];
    //_movieProgressSlider.frame = CGRectMake(60, 15, self.frame.size.width-120, 20);
    [self.player.view addSubview:_movieProgressSlider];
    
    //滑轮图片
    [_movieProgressSlider setThumbImage:[UIImage imageNamed:@"icon_progress"] forState:UIControlStateNormal];
    //已播放进度颜色
    [_movieProgressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    //未播放进度颜色
    [_movieProgressSlider setMaximumTrackTintColor:[UIColor colorWithRed:0.49f green:0.48f blue:0.49f alpha:1.00f]];
    [_movieProgressSlider addTarget:self action:@selector(scrubbingDidBegin:) forControlEvents:UIControlEventTouchDown];
    [_movieProgressSlider addTarget:self action:@selector(scrubbingDidEnd:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel)];
    [_movieProgressSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    _movieProgressSlider.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerTime:) name:MPMovieDurationAvailableNotification object:_player];
    
}
#pragma mark - 播放视频结束的回调
-(void)myMovieFinishedCallback:(NSNotification*)notify{
    
//    //视频播放对象
//    MPMoviePlayerController* theMovie = [notify object];
//    //销毁播放通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:MPMoviePlayerPlaybackDidFinishNotification
//                                                  object:theMovie];
//    [theMovie stop];
//    [theMovie.view removeFromSuperview];
}
#pragma mark - 拖动进度条
- (void)scrubbingDidBegin:(UISlider *)sender
{
    //暂停定时器
    [self.currentPlayTimer setFireDate:[NSDate distantFuture]];
    NSLog(@"拖动进度条中=====%f",sender.value);
}

- (void)scrubbingDidEnd:(UISlider *)sender
{
    NSLog(@"拖动进度条结束=====%f",sender.value);
    _player.currentPlaybackTime = sender.value;
   // [playOrPauseBT setImage:nil forState:UIControlStateNormal];
    //开始定时器
    [self.currentPlayTimer setFireDate:[NSDate date]];
    
}

- (void)sliderChange:(UISlider *)sender
{
    //NSLog(@"拖动当前时间%d",(int)sender.value);
    //_currentTimeLabel.text = [self changeTimeToString:sender.value];
}

#pragma mark - 秒转化为分
-(NSString *)changeTimeToString:(float)time
{
    NSString* timeend;
    NSString* timestr=[NSString stringWithFormat:@"%f",time];
    int inttime=[timestr intValue];
    int minute=inttime/60;
    int second=inttime%60;
    NSString* secondstr=[NSString stringWithFormat:@"%d",second];
    if ([secondstr length]==1)
        timeend=[NSString stringWithFormat:@"%d:0%d",minute,second];
    else
        timeend=[NSString stringWithFormat:@"%d:%d",minute,second];
    return timeend;
}
#pragma mark - 更新当前播放时间
- (void)updateCurrentPlayTime
{
    
    _movieProgressSlider.value = _player.currentPlaybackTime;
    //_currentTimeLabel.text = [self changeTimeToString:_player.currentPlaybackTime];
}
#pragma mark - 获取视频总时长
- (void)mediaPlayerTime:(NSNotification *)notification{
    
    //直播屏蔽掉
    NSLog(@"视频总时长====%f",_player.duration);
   // self.totalTimeLabel.text = [self changeTimeToString:_player.duration];
    _movieProgressSlider.maximumValue = _player.duration;
    _movieProgressSlider.minimumValue = 0.0;
    //progressTimeLabel.text = [NSString stringWithFormat:@"0:00/%@",[self changeTimeToString:_player.duration]];
}
- (void)fullScreen:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    self.fullScreen (sender.selected);
}
- (void)playOrPause:(UIButton *)sender{
    
    //实时监听播放进度
    if (!_currentPlayTimer) {
        _currentPlayTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateCurrentPlayTime) userInfo:nil repeats:YES];
    }
    fullScreenBT.hidden = NO;
    sender.backgroundColor = [UIColor clearColor];
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        //开始定时器
        [self.currentPlayTimer setFireDate:[NSDate date]];
        [sender setImage:nil forState:UIControlStateNormal];
        [self.player play];
    }else{
        
        //暂停定时器
        [self.currentPlayTimer setFireDate:[NSDate distantFuture]];
        [sender setImage:[UIImage imageNamed:@"btn_main_play"] forState:UIControlStateNormal];
        [self.player pause];
    }
}

- (void)setUIFrame{
    
    self.player.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    fullScreenBT.frame = CGRectMake(self.frame.size.width -30, self.frame.size.height-30, 30, 30);
    playOrPauseBT.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _movieProgressSlider.hidden = NO;
    _movieProgressSlider.frame = CGRectMake(30, self.frame.size.height -30, self.frame.size.width -60, 20);
    CGPoint center = _movieProgressSlider.center;
    center.y = fullScreenBT.center.y;
    _movieProgressSlider.center = center;
}

- (void)setBackFrame{
    
    self.player.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width *(9/16.0));
    fullScreenBT.frame = CGRectMake(self.frame.size.width -30, self.frame.size.height-30, 30, 30);
    playOrPauseBT.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _movieProgressSlider.hidden = YES;
}
@end
