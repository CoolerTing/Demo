//
//  SliderView.m
//  CustomTabbar
//
//  Created by Rain on 17/2/27.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "SliderView.h"
#import "SliderButton.h"
#import "ProfileTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SliderView()<UITableViewDelegate,UITableViewDataSource>
//选中的按钮
@property(nonatomic,strong)UIButton *SelectedButton;
//进入按钮
@property(nonatomic,strong)UIButton *EntranceButton;
//表行标题
@property(nonatomic,strong)NSArray *tableArr;
@end

@implementation SliderView
static int Index;
-(UILabel *)CacheLabel
{
    if (!_CacheLabel) {
        _CacheLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        _CacheLabel.font = [UIFont systemFontOfSize:13];
        _CacheLabel.textColor = [UIColor lightGrayColor];
        _CacheLabel.center = CGPointMake(self.tableView.frame.size.width - 60, 20);
    }
    return _CacheLabel;
}
-(NSArray *)tableArr
{
    if (!_tableArr) {
        _tableArr = @[@"我的消息",@"我的收藏",@"M币商城",@"会员中心",@"清除缓存",@"关于Max+",@"退出登录"];
    }
    return _tableArr;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(52, 20, self.frame.size.width  - 52, self.frame.size.height - 120) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        //注册ProfileTableViewCell
        [_tableView registerNib:[UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProfileTableViewCell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //取消分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消滑动指示器
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    NSArray *Image = @[@"Dota",@"Csgo"];
    NSArray *SelectedImage = @[@"DotaSelected",@"CsgoSelected"];
    if (self) {
        self.frame = CGRectMake(0, 0, frame.size.width * 9 / 10, frame.size.height);
        self.backgroundColor = [UIColor colorWithRed:35 / 255.0 green:42 / 255.0 blue:51 / 255.0 alpha:1];
        //左侧按钮栏视图
        UIView *ButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 52, frame.size.height)];
        ButtonView.backgroundColor = [UIColor colorWithRed:30 / 255.0 green:38 / 255.0 blue:46 / 255.0 alpha:1];
        [self addSubview:ButtonView];
        //左上方Max标志
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, 52, 52)];
        imageview.image = [UIImage imageNamed:@"max_logo"];
        imageview.alpha = 0.1;
        [ButtonView addSubview:imageview];
        //创建左侧按钮
        for (int i = 0; i < 2; i++) {
            SliderButton *button = [SliderButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.frame = CGRectMake(0, 100 + i * 52, 52, 52);
            [button setImage:[UIImage imageNamed:Image[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:SelectedImage[i]] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [self ButtonClick:button];
            }
            [ButtonView addSubview:button];
        }
        //创建进入按钮
        UIButton *EntranceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        EntranceButton.frame = CGRectMake(0, 0, (self.frame.size.width - 52) * 2 / 3, 44);
        EntranceButton.layer.cornerRadius = 22;
        EntranceButton.center = CGPointMake(self.frame.size.width / 2 + 26, self.frame.size.height - 60);
        [EntranceButton setTitle:@"DOTA2" forState:UIControlStateNormal];
        EntranceButton.backgroundColor = [UIColor colorWithRed:30 / 255.0 green:38 / 255.0 blue:46 / 255.0 alpha:1];
        EntranceButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [EntranceButton addTarget:self action:@selector(EntranceButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.EntranceButton = EntranceButton;
        [self addSubview:EntranceButton];
    }
    [self addSubview:self.tableView];
    return self;
}
//进入按钮点击事件
-(void)EntranceButtonClick
{
    //点击事件代理
    if ([_delegate respondsToSelector:@selector(EntranceButtonDidClick:)]) {
        [_delegate EntranceButtonDidClick:Index];
    }
}
//左侧按钮点击事件
-(void)ButtonClick:(UIButton *)btn
{
    self.SelectedButton.selected = NO;
    btn.selected = YES;
    self.SelectedButton = btn;
    switch (btn.tag) {
        case 0:
            [self.EntranceButton setTitle:@"DOTA2" forState:UIControlStateNormal];
            Index = 0;
            break;
        case 1:
            [self.EntranceButton setTitle:@"CSGO" forState:UIControlStateNormal];
            Index = 1;
            break;
        default:
            break;
    }
}
#pragma mark tableViewDelegate、tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row != 5) {
        if (indexPath.row == 6) {
            self.CacheLabel.text = self.cache;
            [cell addSubview:self.CacheLabel];
        }
        cell.textLabel.text = self.tableArr[indexPath.row < 6 ? indexPath.row - 1:indexPath.row - 2];
        cell.textLabel.textColor = [UIColor colorWithRed:101 / 255.0 green:120 / 255.0 blue:143 / 255.0 alpha:1];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"honour_%ld",indexPath.row < 6 ? indexPath.row:indexPath.row - 1]];
    }
    else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 22, self.tableView.frame.size.width - 10, 1)];
        view.backgroundColor = [UIColor colorWithRed:40 / 255.0 green:47 / 255.0 blue:57 / 255.0 alpha:1];
        [cell addSubview:view];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //cell点击事件代理
    if (indexPath.row != 5) {
        if ([_delegate respondsToSelector:@selector(SliderTableviewCellDidClick:)]) {
            [_delegate SliderTableviewCellDidClick:indexPath];
        }
    }
}
@end
