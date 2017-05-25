//
//  VideoViewController.m
//  CustomTabbar
//
//  Created by Rain on 17/3/20.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "VideoViewController.h"
#import "BottomMenu.h"
#import "TopMenu.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
@interface VideoViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;
@property(nonatomic,strong)UIView *container;
@property(nonatomic,strong)UIButton *PlayerOrPause;
@property(nonatomic,assign)BOOL IsPlaying;
@property(nonatomic,assign)BOOL MenuIsHidden;
@property(nonatomic,strong)BottomMenu *bottom;
@property(nonatomic,strong)TopMenu *top;
@property(nonatomic,strong)UIActivityIndicatorView *Loading;
@end

@implementation VideoViewController
-(UIActivityIndicatorView *)Loading
{
    if (!_Loading) {
        _Loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _Loading.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
        [_Loading startAnimating];
    }
    return _Loading;
}
-(BottomMenu *)bottom
{
    if (!_bottom) {
        _bottom = [[BottomMenu alloc]initWithSuperView:self.container];
    }
    return _bottom;
}
-(TopMenu *)top
{
    if (!_top) {
        _top = [[TopMenu alloc]initWithSuperView:self.container];
        _top.title.text = self.Title;
    }
    return _top;
}
-(AVPlayer *)player
{
    if (!_player) {
        
        NSString *urlstring = [self.VedioURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlstring]];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        AVPlayerItem *currentItem = self.player.currentItem;
        __weak typeof(self) weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current = CMTimeGetSeconds(time);
            float total = CMTimeGetSeconds([currentItem duration]);
            if (current) {
                weakSelf.bottom.TimeLabel.text = [NSString stringWithFormat:@"%@/%@",[weakSelf SecondToTime:(int)current],[weakSelf SecondToTime:(int)total]];
                weakSelf.bottom.ProgressCircle.transform = CGAffineTransformMakeTranslation(current / total * weakSelf.bottom.progressview.frame.size.width, 0);
                weakSelf.bottom.tranform = weakSelf.bottom.ProgressCircle.transform;
            }
        }];
    }
    return _player;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self SetPlayer];
}
-(void)SetPlayer
{
    self.IsPlaying = YES;
    self.MenuIsHidden = YES;
    
    self.container = [UIView new];
    self.container.clipsToBounds = YES;
    self.container.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 2);
    self.container.layer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.container];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.container.bounds;
    [self.container.layer addSublayer:self.playerLayer];
    [self.player play];
    
    UITapGestureRecognizer *SingleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap)];
    SingleTap.numberOfTapsRequired = 1;
    SingleTap.delegate = self;
    [self.container addGestureRecognizer:SingleTap];
    
    UITapGestureRecognizer *DoubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DoubleTap)];
    DoubleTap.numberOfTapsRequired = 2;
    DoubleTap.delegate = self;
    [self.container addGestureRecognizer:DoubleTap];
    
    [SingleTap requireGestureRecognizerToFail:DoubleTap];
    
    [self.container addSubview:self.top];
    [self.container addSubview:self.bottom];
    [self.top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(-40);
    }];
    [self.bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(40);
    }];
    __weak typeof(self) weakSelf = self;
    self.bottom.PlayOrPause = ^(){
        if (weakSelf.IsPlaying) {
            [weakSelf.player pause];
            weakSelf.IsPlaying = NO;
            [weakSelf.bottom.PlayOrPauseBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
        }
        else
        {
            [weakSelf.player play];
            weakSelf.IsPlaying = YES;
            [weakSelf.bottom.PlayOrPauseBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
        }
    };
    self.bottom.Full = ^(BOOL IsFull){
        if (IsFull) {
            [weakSelf SetInvocation:UIInterfaceOrientationLandscapeRight];
            weakSelf.container.frame = [UIScreen mainScreen].bounds;
            weakSelf.playerLayer.frame = [UIScreen mainScreen].bounds;
        }
        else
        {
            [weakSelf SetInvocation:UIInterfaceOrientationPortrait];
            weakSelf.container.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 2);
            weakSelf.playerLayer.frame = weakSelf.container.bounds;
        }
        
    };
    
    [self.bottom FullBtnClick];
    [self.container addSubview:self.Loading];
    
    self.bottom.Pan = ^(CGFloat value,BOOL finish){
        if (finish) {
            AVPlayerItem *currentItem = weakSelf.player.currentItem;
            [weakSelf.player seekToTime:CMTimeMakeWithSeconds(value * CMTimeGetSeconds(currentItem.duration), NSEC_PER_SEC)];
            [weakSelf.player play];
        }
        else
        {
            [weakSelf.player pause];
        }
    };
    self.top.BackButtontap = ^(){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
-(void)SingleTap
{
    if (self.MenuIsHidden) {
        [UIView animateWithDuration:0.1 animations:^{
            self.bottom.transform = CGAffineTransformMakeTranslation(0, -40);
            self.top.transform = CGAffineTransformMakeTranslation(0, 40);
        }];
        self.MenuIsHidden = NO;
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            self.bottom.transform = CGAffineTransformIdentity;
            self.top.transform = CGAffineTransformIdentity;
        }];
        self.MenuIsHidden = YES;
    }
    
}
-(void)DoubleTap
{
    if (self.IsPlaying) {
        [self.player pause];
        self.IsPlaying = NO;
        [self.bottom.PlayOrPauseBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    }
    else
    {
        [self.player play];
        self.IsPlaying = YES;
        [self.bottom.PlayOrPauseBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"]intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"正在播放");
            [self.Loading stopAnimating];
            self.Loading = nil;
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval total = startSeconds + durationSeconds;
        [self.bottom.progressview setProgress:total animated:YES];
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.container) {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(NSString *)SecondToTime:(int)second
{
    NSString *time;
    if (second > 0 && second < 60) {
        time = [NSString stringWithFormat:@"00:%.2d",second];
    }
    else if (second >= 60 && second < 60 * 60)
    {
        time = [NSString stringWithFormat:@"%.2d:%.2d",second / 60,second % 60];
    }
    else
    {
        time = [NSString stringWithFormat:@"%d:%.2d:%.2d",second / 3600,second % 3600 / 60,second % 3600 % 60];
    }
    return time;
}
-(void)SetInvocation:(int)val
{
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self SetInvocation:UIInterfaceOrientationPortrait];
    self.container.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 2);
    self.playerLayer.frame = self.container.bounds;
    
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end
