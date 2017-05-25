//
//  BottomMenu.h
//  AVPlayerDemo
//
//  Created by Rain on 17/3/17.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomMenu : UIView
-(instancetype)initWithSuperView:(UIView *)superview;
@property(nonatomic,copy)void(^PlayOrPause)();
@property(nonatomic,copy)void(^Full)(BOOL IsFull);
@property(nonatomic,copy)void(^Pan)(CGFloat value,BOOL finish);
@property(nonatomic,strong)UIButton *PlayOrPauseBtn;
@property(nonatomic,strong)UIProgressView *progressview;
@property(nonatomic,strong)UILabel *TimeLabel;
@property(nonatomic,strong)UIButton *ProgressCircle;
@property(nonatomic)CGAffineTransform tranform;
-(void)FullBtnClick;
@end
