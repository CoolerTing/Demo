//
//  CustomTabbar.m
//  CustomTabbar
//
//  Created by Rain on 17/2/22.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "CustomTabbar.h"
#import "CustomTabbarButton.h"
@interface CustomTabbar()
//选中标题颜色
@property(nonatomic,strong)UIColor *TitleColor;
//选中的按钮
@property(nonatomic,strong)UIButton *SelectedButton;
//接收items的tabbaritem
@property(nonatomic,strong)UITabBarItem *barbutton;
@end

@implementation CustomTabbar

-(void)btnClick:(UIButton *)btn
{
    self.SelectedButton.selected = NO;
    self.SelectedButton = btn;
    btn.selected = !btn.selected;
    //tabbar按钮点击事件代理
    if ([_delegate respondsToSelector:@selector(Tabbar:didClickWithIndex:)]) {
        [_delegate Tabbar:self didClickWithIndex:btn.tag];
    }
}
-(instancetype)initWithFrame:(CGRect)frame WithTitleColor:(UIColor *)color WithBackgroundColor:(UIColor *)backgroundcolor WithImage:(UIImage *)image WithItems:(NSArray *)items WithCenterButtonTitle:(NSString *)CenterButtonTilte WithCenterButtonImage:(NSString *)CenterButtonImageName
{
    if (self) {
        self = [super initWithFrame:frame];
        if (backgroundcolor) {
            self.backgroundColor = backgroundcolor;
        }
        else
        {
            self.backgroundColor = [UIColor clearColor];
        }
        if (image) {
            UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
            imageview.frame = self.bounds;
            [self addSubview:imageview];
        }
        //创建tabbar按钮
        for (int i = 0; i < 4; i++) {
            self.TitleColor = color;
            self.barbutton = items[i];
            CustomTabbarButton *btn = [CustomTabbarButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake((i > 1 ? i + 1 : i) * self.frame.size.width / 5, 0, self.frame.size.width / 5, 40);
            btn.center = CGPointMake(btn.center.x, self.frame.size.height / 2);
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            [btn setTitle:self.barbutton.title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitleColor:self.TitleColor forState:UIControlStateSelected];
            [btn setImage:self.barbutton.image forState:UIControlStateNormal];
            [btn setImage:self.barbutton.selectedImage forState:UIControlStateSelected];
            [self addSubview:btn];
            if (i == 0) {
                [self btnClick:btn];
            }
        }
        //创建中心按钮
        CustomTabbarButton *CenterBtn = [CustomTabbarButton buttonWithType:UIButtonTypeCustom];
        [CenterBtn addTarget:self action:@selector(CenterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CenterBtn.frame = CGRectMake(0, 0, self.frame.size.width / 5, 40);
        CenterBtn.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [CenterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [CenterBtn setTitle:CenterButtonTilte forState:UIControlStateNormal];
        [CenterBtn setImage:[UIImage imageNamed:CenterButtonImageName] forState:UIControlStateNormal];
        [self addSubview:CenterBtn];
    }
    return self;
}
-(void)CenterButtonClick:(UIButton *)btn
{
    //中心按钮点击事件代理
    if ([_delegate respondsToSelector:@selector(Tabbar:didClickCenterButton:)]) {
        [_delegate Tabbar:self didClickCenterButton:btn];
    }
}
@end
