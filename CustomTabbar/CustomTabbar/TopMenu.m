//
//  TopMenu.m
//  AVPlayerDemo
//
//  Created by Rain on 17/3/17.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "TopMenu.h"

@implementation TopMenu
-(instancetype)initWithSuperView:(UIView *)superview;
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        //返回按钮
        self.BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.BackButton setImage:[UIImage imageNamed:@"go_back"] forState:UIControlStateNormal];
        self.BackButton.frame = CGRectMake(0, 0, 40, 40);
        self.BackButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 0);
        [self.BackButton addTarget:self action:@selector(BackButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.BackButton];
        //标题
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 200, 40)];
        self.title.font = [UIFont systemFontOfSize:14];
        self.title.textColor = [UIColor lightGrayColor];
        [self addSubview:self.title];
    }
    return self;
}
-(void)BackButtonClick
{
    self.BackButtontap();
}
@end
