//
//  TitleView.h
//  CustomTabbar
//
//  Created by Rain on 17/3/13.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView
@property(nonatomic,copy)NSString *IsWin;
@property(nonatomic,copy)NSString *kill;
@property(nonatomic,copy)NSString *exp;
@property(nonatomic,copy)NSString *gold;
-(instancetype)initWithFrame:(CGRect)frame WithBackColor:(UIColor *)color WithWhich:(NSString *)which WithWich_CN:(NSString *)which_cn WithIsWin:(NSString *)iswin WithKill:(NSString *)kill WithExp:(NSString *)exp WithGold:(NSString *)gold;
@end
