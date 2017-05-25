//
//  SliderView.h
//  CustomTabbar
//
//  Created by Rain on 17/2/27.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SliderView;
@protocol SliderViewDelegate <NSObject>

//代理方法
-(void)EntranceButtonDidClick:(NSInteger)index;
-(void)SliderTableviewCellDidClick:(NSIndexPath *)indexPath;

@end
@interface SliderView : UIView

@property(nonatomic,weak)id<SliderViewDelegate>delegate;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSString *cache;
@property(nonatomic,strong)UILabel *CacheLabel;
@end
