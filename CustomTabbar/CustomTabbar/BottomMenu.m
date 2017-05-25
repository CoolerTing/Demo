//
//  BottomMenu.m
//  AVPlayerDemo
//
//  Created by Rain on 17/3/17.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "BottomMenu.h"
#import <Masonry.h>
@interface BottomMenu()
@property(nonatomic,assign)BOOL IsFull;

@end

@implementation BottomMenu

-(instancetype)initWithSuperView:(UIView *)superview
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        //播放按钮
        self.PlayOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.PlayOrPauseBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
        [self.PlayOrPauseBtn addTarget:self action:@selector(PlayOrPauseClick) forControlEvents:UIControlEventTouchUpInside];
        self.PlayOrPauseBtn.frame = CGRectMake(0, 0, 20, 20);
        self.PlayOrPauseBtn.center = CGPointMake(25, 20);
        [self addSubview:self.PlayOrPauseBtn];
        //进度条
        self.progressview = [[UIProgressView alloc]initWithFrame:CGRectMake(40, 19, superview.bounds.size.width - 40 - 110, 2)];
        self.progressview.trackTintColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:self.progressview];
        [self.progressview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-120);
            make.left.mas_equalTo(40);
            make.bottom.mas_equalTo(-19);
            make.height.mas_equalTo(2);
        }];
        //时间
        self.TimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40 + self.progressview.frame.size.width + 5, 0, 100, 40)];
        self.TimeLabel.textAlignment = NSTextAlignmentCenter;
        self.TimeLabel.textColor = [UIColor whiteColor];
        self.TimeLabel.text = @"00:00/00:00";
        self.TimeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.TimeLabel];
        [self.TimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(100);
        }];
        //进度圆点
        self.ProgressCircle = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ProgressCircle setImage:[UIImage imageNamed:@"icon_progress"] forState:UIControlStateNormal];
        self.ProgressCircle.frame = CGRectMake(35, 5, 30, 30);
        self.ProgressCircle.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
        self.tranform = self.ProgressCircle.transform;
        [self addSubview:self.ProgressCircle];
        
        self.ProgressCircle.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self.ProgressCircle addGestureRecognizer:pan];
        [superview addSubview:self];
    }
    return self;
}
-(void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    self.ProgressCircle.transform = CGAffineTransformMakeTranslation(self.tranform.tx + point.x, 0);
    if (self.ProgressCircle.transform.tx <= 0) {
        self.ProgressCircle.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    if (self.ProgressCircle.transform.tx >= self.progressview.frame.size.width) {
        self.ProgressCircle.transform = CGAffineTransformMakeTranslation(self.progressview.frame.size.width, 0);
    }
    switch (pan.state) {
        case UIGestureRecognizerStateEnded:
            self.tranform = self.ProgressCircle.transform;
            self.Pan(self.ProgressCircle.transform.tx / self.progressview.frame.size.width,YES);
            break;
        case UIGestureRecognizerStateBegan:
            self.Pan(0.1,NO);
            break;
        default:
            break;
    }
}
-(void)FullBtnClick
{
    self.IsFull = !self.IsFull;
    self.Full(self.IsFull);
}
-(void)PlayOrPauseClick
{
    self.PlayOrPause();
}
@end
