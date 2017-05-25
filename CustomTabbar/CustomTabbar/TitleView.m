//
//  TitleView.m
//  CustomTabbar
//
//  Created by Rain on 17/3/13.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView

-(instancetype)initWithFrame:(CGRect)frame WithBackColor:(UIColor *)color WithWhich:(NSString *)which WithWich_CN:(NSString *)which_cn WithIsWin:(NSString *)iswin WithKill:(NSString *)kill WithExp:(NSString *)exp WithGold:(NSString *)gold
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.frame = self.bounds;
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        [bezier moveToPoint:CGPointMake(0, 0)];
        [bezier addLineToPoint:CGPointMake(frame.size.width, 0)];
        [bezier addLineToPoint:CGPointMake(frame.size.width, 4 / [UIScreen mainScreen].scale)];
        [bezier addLineToPoint:CGPointMake(120, 4 / [UIScreen mainScreen].scale)];
        [bezier addLineToPoint:CGPointMake(80, 40)];
        [bezier addLineToPoint:CGPointMake(0, 40)];
        [bezier addLineToPoint:CGPointMake(0, 0)];
        [bezier closePath];
        shape.path = bezier.CGPath;
        shape.fillColor = color.CGColor;
        shape.strokeStart = 0;
        shape.strokeEnd = 1;
        [self.layer addSublayer:shape];
        
        UILabel *radiant = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, 40, 20)];
        radiant.text = which;
        radiant.font = [UIFont systemFontOfSize:9];
        radiant.textColor = [UIColor whiteColor];
        [self addSubview:radiant];
        
        UILabel *radiant_CN = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, 35, 20)];
        radiant_CN.text = which_cn;
        radiant_CN.font = [UIFont systemFontOfSize:13];
        radiant_CN.textColor = [UIColor whiteColor];
        [self addSubview:radiant_CN];
        
        UILabel *IsWin = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 40, 20)];
        IsWin.textAlignment = NSTextAlignmentRight;
        IsWin.font = [UIFont systemFontOfSize:17];
        IsWin.textColor = [UIColor whiteColor];
        IsWin.text = iswin;
        [self addSubview:IsWin];
        
        UILabel *detail = [[UILabel alloc]init];
        detail.text = [NSString stringWithFormat:@"杀敌 %@  经验 %@  金钱 %@",kill,exp,gold];
        detail.font = [UIFont systemFontOfSize:12];
        detail.textColor = [UIColor lightGrayColor];
        [detail sizeToFit];
        detail.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - detail.frame.size.width - 10, 0, 200, 40);
        detail.center = CGPointMake(detail.center.x, 20);
        [self addSubview:detail];
    }
    return self;
}
@end
