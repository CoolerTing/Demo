//
//  MainViewController.m
//  CustomTabbar
//
//  Created by Rain on 17/2/22.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "MainViewController.h"
#import "MeViewController.h"
#import "DataViewController.h"
#import "DiscoveryViewController.h"
#import "LiveViewController.h"
#import "GuessViewController.h"
#import "CustomTabbar.h"
#import "SliderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MainViewController ()<CustomTabbarDelegate,SliderViewDelegate>
//tabbar按钮数组
@property (nonatomic, strong) NSMutableArray *items;
//滑动视图
@property(nonatomic, weak) SliderView *sliderview;
//毛玻璃背景
@property(nonatomic,weak)UIVisualEffectView *BackView;
@end

@implementation MainViewController
-(UIView *)BackView
{
    if (!_BackView) {
        UIVisualEffectView *backview = [[UIVisualEffectView alloc]init];
        backview.frame = self.view.bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DismissSliderView)];
        [backview addGestureRecognizer:tap];
        [self.view addSubview:backview];
        _BackView = backview;
    }
    return _BackView;
}
-(SliderView *)sliderview
{
    if (!_sliderview) {
        SliderView *slider = [[SliderView alloc]initWithFrame:self.view.bounds];
        slider.delegate = self;
        [self.view addSubview:slider];
        _sliderview = slider;
    }
    return _sliderview;
}
- (NSMutableArray *)items{
    if (_items == nil) {
        
        _items = [NSMutableArray array];
    }
    return _items;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化自控制器
    [self SetupChildViewControllers];
    //初始化自定义tabbar
    [self SetUpTabbar];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //移除自带tabbar的tabbarbutton
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:[UIControl class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)SetupChildViewControllers
{
    [self SetupWithChildViewController:[MeViewController new] WithTitle:@"我" WithImage:@"我1" WithSelectedImage:@"我2"];
    [self SetupWithChildViewController:[DataViewController new] WithTitle:@"数据" WithImage:@"数据1" WithSelectedImage:@"数据2"];
    [self SetupWithChildViewController:[DiscoveryViewController new] WithTitle:@"发现" WithImage:@"发现1" WithSelectedImage:@"发现2"];
    [self SetupWithChildViewController:[LiveViewController new] WithTitle:@"直播" WithImage:@"视频1" WithSelectedImage:@"视频2"];
}
-(void)SetUpTabbar
{
    self.tabBar.translucent = NO;
    CustomTabbar *tabbar = [[CustomTabbar alloc]initWithFrame:self.tabBar.bounds WithTitleColor:[UIColor colorWithRed:70 / 255.0 green:76 / 255.0 blue:84 / 255.0 alpha:1] WithBackgroundColor:nil WithImage:nil WithItems:self.items WithCenterButtonTitle:@"竞猜" WithCenterButtonImage:@"活动2"];
    tabbar.delegate = self;
    [self.tabBar addSubview:tabbar];
}
-(void)SetupWithChildViewController:(UIViewController *)ChildViewController WithTitle:(NSString *)title WithImage:(NSString *)ImageName WithSelectedImage:(NSString *)SelectedImageName
{
    ChildViewController.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"max_item_icon_cs"] highlightedImage:[UIImage imageNamed:@"max_item_icon_cs"]];
    ChildViewController.tabBarItem.title = title;
    ChildViewController.tabBarItem.image = [UIImage imageNamed:ImageName];
    ChildViewController.tabBarItem.selectedImage = [UIImage imageNamed:SelectedImageName];
    //自定义左barbuttonitem
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 36, 36);
    barButton.layer.cornerRadius = 18;
    barButton.clipsToBounds = YES;
    [barButton addTarget:self action:@selector(PushSliderView) forControlEvents:UIControlEventTouchUpInside];
    [barButton setImage:[UIImage imageNamed:@"FuZ"] forState:UIControlStateNormal];
    ChildViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barButton];
    [self.items addObject:ChildViewController.tabBarItem];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:ChildViewController];
    [self addChildViewController:navi];
}
//推出滑动视图
-(void)PushSliderView
{
    __weak typeof(self) weakself = self;
    [SDWebImageManager.sharedManager.imageCache calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        [weakself.view addSubview:self.BackView];
        self.sliderview.cache = [NSString stringWithFormat:@"%.2fM",(CGFloat)totalSize / (1024 * 1024)];
        //初始化滑动视图初始位置
        self.sliderview.transform = CGAffineTransformMakeTranslation(-self.sliderview.frame.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            //设置毛玻璃效果
            self.BackView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.sliderview.transform = CGAffineTransformIdentity;
        }];
    }];
}
//收回滑动视图
-(void)DismissSliderView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.BackView.effect = nil;
        self.sliderview.transform = CGAffineTransformMakeTranslation(-self.sliderview.frame.size.width, 0);
    }completion:^(BOOL finished) {
        //销毁对象，释放内存
        [self.BackView removeFromSuperview];
        [self.sliderview removeFromSuperview];
    }];
}
#pragma mark CustomTabbarDelegate
//tabbaritem点击事件
-(void)Tabbar:(CustomTabbar *)tabbar didClickWithIndex:(NSInteger)index
{
    self.selectedIndex = index;
}
//中心按钮点击事件
-(void)Tabbar:(CustomTabbar *)tabbar didClickCenterButton:(UIButton *)centerButton
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:[GuessViewController new] animated:YES];
}
#pragma mark SliderDelegate
//进入按钮点击时间
-(void)EntranceButtonDidClick:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"dota2");
            break;
        case 1:
            NSLog(@"csgo");
        default:
            break;
    }
}
//滑动视图tableviewcell点击事件
-(void)SliderTableviewCellDidClick:(NSIndexPath *)indexPath
{
    NSLog(@"第%ld行被点击",indexPath.row < 5 ? indexPath.row + 1 : indexPath.row);
    if (indexPath.row == 6) {
        self.sliderview.cache = @"0.00M";
        [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];
        [[[SDWebImageManager sharedManager] imageCache] clearMemory];
        [self.sliderview.tableView reloadData];
    }
}
@end
