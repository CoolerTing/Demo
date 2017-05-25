//
//  CustomTabbarButton.m
//  CustomTabbar
//
//  Created by Rain on 17/2/22.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "CustomTabbarButton.h"

@interface CustomTabbarButton()

@end

@implementation CustomTabbarButton

-(void)layoutSubviews
{
    //重新布局按钮
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2 / 3);
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height * 2 / 3, self.frame.size.width, self.frame.size.height / 3);
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self) {
        self = [super initWithFrame:frame];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted
{
    //重写高亮方法可取消高亮
}
@end
