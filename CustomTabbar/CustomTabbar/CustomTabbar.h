//
//  CustomTabbar.h
//  CustomTabbar
//
//  Created by Rain on 17/2/22.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTabbar;
@protocol CustomTabbarDelegate <NSObject>
//代理方法
-(void)Tabbar:(CustomTabbar *)tabbar didClickWithIndex:(NSInteger)index;
-(void)Tabbar:(CustomTabbar *)tabbar didClickCenterButton:(UIButton *)centerButton;
@end


@interface CustomTabbar : UIView
@property(nonatomic,weak)id<CustomTabbarDelegate> delegate;
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame WithTitleColor:(UIColor *)color WithBackgroundColor:(UIColor *)backgroundcolor WithImage:(UIImage *)image WithItems:(NSArray *)items WithCenterButtonTitle:(NSString *)CenterButtonTilte WithCenterButtonImage:(NSString *)CenterButtonImageName;
@end
