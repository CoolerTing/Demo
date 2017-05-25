//
//  TopMenu.h
//  AVPlayerDemo
//
//  Created by Rain on 17/3/17.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopMenu : UIView
-(instancetype)initWithSuperView:(UIView *)superview;
@property(nonatomic,strong)UIButton *BackButton;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,copy)void(^BackButtontap)();
@end
