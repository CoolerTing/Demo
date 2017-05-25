//
//  MatchDetailViewController.m
//  CustomTabbar
//
//  Created by Rain on 17/3/13.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//
#define index section < 7 ? section - 2 : section - 4

#import "MatchDetailViewController.h"
#import "TitleView.h"
#import "DetailInDetailViewTableViewCell.h"
#import "DetailView.h"
#import "ResultModel.h"
#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface MatchDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)AFHTTPSessionManager *manager;
@property(nonatomic,strong)NSMutableArray *LoadingImagesArray;
@property(nonatomic,strong)UIImageView *LoadingImage;
@property(nonatomic,strong)NSMutableArray *LabelArray;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *heroesName;
@property(nonatomic,strong)NSMutableArray *Account_id;
@property(nonatomic,assign)BOOL radiant_win;
@property(nonatomic,copy)NSArray *Totalkill;
@property(nonatomic,copy)NSArray *exp;
@property(nonatomic,copy)NSArray *gold;
@property(nonatomic,strong)NSMutableArray *kill;
@property(nonatomic,strong)NSMutableArray *death;
@property(nonatomic,strong)NSMutableArray *assists;
@property(nonatomic,strong)NSMutableArray *damage;
@property(nonatomic,strong)NSMutableArray *PerExp;
@property(nonatomic,strong)NSMutableArray *PerGold;
@property(nonatomic,strong)NSMutableArray *TowerDamage;
@property(nonatomic,strong)NSMutableArray *Cure;
@property(nonatomic,strong)NSMutableArray *Last_hits;
@property(nonatomic,strong)NSMutableArray *Denies;
@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,strong)NSMutableArray *Backitems;
@property(nonatomic,strong)NSMutableArray *IsOpen;
@property(nonatomic,strong)NSMutableDictionary *UserName;
@property(nonatomic,strong)NSMutableDictionary *UserHead;
@property(nonatomic,strong)UIButton *retry;
@end

@implementation MatchDetailViewController
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 108) style:UITableViewStyleGrouped];
        [_tableview registerNib:[UINib nibWithNibName:@"DetailInDetailViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"Detailcell"];
        _tableview.separatorStyle = UIAccessibilityTraitNone;
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}
-(NSMutableDictionary *)UserName
{
    if (!_UserName) {
        _UserName = [NSMutableDictionary dictionary];
    }
    return _UserName;
}
-(NSMutableDictionary *)UserHead
{
    if (!_UserHead) {
        _UserHead = [NSMutableDictionary dictionary];
    }
    return _UserHead;
}
-(NSMutableArray *)IsOpen
{
    if (!_IsOpen) {
        _IsOpen = [NSMutableArray array];
        for (int i = 0; i < self.Account_id.count; i++) {
            [_IsOpen addObject:@0];
        }
    }
    return _IsOpen;
}
-(NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
-(NSMutableArray *)Backitems
{
    if (!_Backitems) {
        _Backitems = [NSMutableArray array];
    }
    return _Backitems;
}
-(NSMutableArray *)kill
{
    if (!_kill) {
        _kill = [NSMutableArray array];
    }
    return _kill;
}
-(NSMutableArray *)death
{
    if (!_death) {
        _death = [NSMutableArray array];
    }
    return _death;
}
-(NSMutableArray *)assists
{
    if (!_assists) {
        _assists = [NSMutableArray array];
    }
    return _assists;
}
-(NSMutableArray *)damage
{
    if (!_damage) {
        _damage = [NSMutableArray array];
    }
    return _damage;
}
-(NSMutableArray *)PerExp
{
    if (!_PerExp) {
        _PerExp = [NSMutableArray array];
    }
    return _PerExp;
}
-(NSMutableArray *)PerGold
{
    if (!_PerGold) {
        _PerGold = [NSMutableArray array];
    }
    return _PerGold;
}
-(NSMutableArray *)TowerDamage
{
    if (!_TowerDamage) {
        _TowerDamage = [NSMutableArray array];
    }
    return _TowerDamage;
}

-(NSMutableArray *)Cure
{
    if (!_Cure) {
        _Cure = [NSMutableArray array];
    }
    return _Cure;
}
-(NSMutableArray *)Last_hits
{
    if (!_Last_hits) {
        _Last_hits = [NSMutableArray array];
    }
    return _Last_hits;
}
-(NSMutableArray *)Denies
{
    if (!_Denies) {
        _Denies = [NSMutableArray array];
    }
    return _Denies;
}
-(NSMutableArray *)Account_id
{
    if (!_Account_id) {
        _Account_id = [NSMutableArray array];
    }
    return _Account_id;
}
-(NSMutableArray *)heroesName
{
    if (!_heroesName) {
        _heroesName = [NSMutableArray array];
    }
    return _heroesName;
}
-(NSMutableArray *)LabelArray
{
    if (!_LabelArray) {
        _LabelArray = [NSMutableArray array];
    }
    return _LabelArray;
}
-(NSMutableArray *)LoadingImagesArray
{
    if (!_LoadingImagesArray) {
        _LoadingImagesArray = [NSMutableArray array];
    }
    return _LoadingImagesArray;
}
-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 20.f;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self SetSimpleDataView];
    [self SetLoadingimage];
    [self SetReTryButton];
    [self GetMatchDetail];
}
-(void)SetSimpleDataView
{
    NSArray *arr = @[@"结束时间",@"持续时间",@"Level",@"比赛模式"];
    UIView *SimpleDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    UIImageView *backgroudImage = [[UIImageView alloc]initWithFrame:SimpleDataView.bounds];
    backgroudImage.image = [UIImage imageNamed:@"NavigationBG"];
    [SimpleDataView addSubview:backgroudImage];
    for (int i = 0; i < 4; i++) {
        UILabel *decriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 + i * (([UIScreen mainScreen].bounds.size.width - 10) / 4), 5, ([UIScreen mainScreen].bounds.size.width - 10) / 4, 12)];
        decriptionLabel.textAlignment = NSTextAlignmentCenter;
        decriptionLabel.textColor = [UIColor lightGrayColor];
        decriptionLabel.font = [UIFont systemFontOfSize:12];
        decriptionLabel.text = arr[i];
        [SimpleDataView addSubview:decriptionLabel];
        
        UILabel *DetailDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 + i * (([UIScreen mainScreen].bounds.size.width - 10) / 4), 22, ([UIScreen mainScreen].bounds.size.width - 10) / 4, 15)];
        DetailDataLabel.textAlignment = NSTextAlignmentCenter;
        DetailDataLabel.textColor = [UIColor whiteColor];
        DetailDataLabel.font = [UIFont systemFontOfSize:13];
        DetailDataLabel.tag = i;
        [self.LabelArray addObject:DetailDataLabel];
        [SimpleDataView addSubview:DetailDataLabel];
    }
    [self.view addSubview:SimpleDataView];
}
-(void)SetReTryButton
{
    UIButton *retry = [UIButton buttonWithType:UIButtonTypeCustom];
    retry.frame = CGRectMake(0, 0, 80, 35);
    [retry setTitle:@"重新加载" forState:UIControlStateNormal];
    [retry setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    retry.titleLabel.font = [UIFont systemFontOfSize:14];
    retry.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    retry.layer.borderColor = [UIColor lightGrayColor].CGColor;
    retry.layer.cornerRadius = 8;
    retry.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 64);
    retry.hidden = YES;
    [retry addTarget:self action:@selector(GetMatchDetail) forControlEvents:UIControlEventTouchUpInside];
    self.retry = retry;
    [self.view addSubview:retry];
}
-(void)SetLoadingimage
{
    self.LoadingImage = [UIImageView new];
    for (int i = 0; i < 40; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"000%.2d",i]];
        [self.LoadingImagesArray addObject:image];
    }
    self.LoadingImage.frame = CGRectMake(0, 0, 50, 50);
    self.LoadingImage.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 64);
    self.LoadingImage.animationImages = self.LoadingImagesArray;
    self.LoadingImage.animationDuration = 0.5;
    self.LoadingImage.animationRepeatCount = MAXFLOAT;
    [self.view addSubview:self.LoadingImage];
}
-(void)GetMatchDetail
{
    [self.LoadingImage startAnimating];
    self.retry.hidden = YES;
    NSDictionary *dic = @{@0:@"无",@1:@"所有选择",@2:@"队长模式",@3:@"随机征召",@4:@"单个征召",@5:@"全部随机",@6:@"",@7:@"夜魇暗潮",@8:@"反队长模式",@9:@"圣诞模式",@10:@"新手模式",@11:@"单中模式",@12:@"生疏模式",@13:@"新英雄模式",@14:@"粗略匹配",@15:@"人机对战",@16:@"",@18:@"",@20:@"死亡随机",@21:@"SOLO",@22:@"天梯匹配"};
    NSInteger localdate = [[NSDate date] timeIntervalSince1970];
    [self.manager GET:self.DetailURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.Totalkill = @[responseObject[@"result"][@"radiant_score"],responseObject[@"result"][@"dire_score"]];
        if ([responseObject[@"result"][@"radiant_win"]intValue]) {
            self.radiant_win = YES;
        }
        ResultModel *model = [ResultModel ModelWithPlayers:responseObject[@"result"][@"players"]];
        for (int i = 0; i < model.players.count; i++) {
            NSMutableArray *itemsarr = [NSMutableArray array];
            NSMutableArray *Backitemsarr = [NSMutableArray array];
            for (int x = 0; x < 6; x++) {
                if ([model.players[i][[NSString stringWithFormat:@"item_%d",x]] isEqual:@0]) {
                    [itemsarr addObject:@"none"];
                }
                for (NSDictionary *dic in [[NSUserDefaults standardUserDefaults] objectForKey:@"items"]) {
                    if ([model.players[i][[NSString stringWithFormat:@"item_%d",x]] isEqual:dic[@"id"]]) {
                        [itemsarr addObject:[dic[@"name"]substringFromIndex:5]];
                    }
                }
            }
            for (int y = 0; y < 3; y++) {
                if ([model.players[i][[NSString stringWithFormat:@"backpack_%d",y]] isEqual:@0]) {
                    [Backitemsarr addObject:@"none"];
                }
                for (NSDictionary *dic in [[NSUserDefaults standardUserDefaults] objectForKey:@"items"]) {
                    if ([model.players[i][[NSString stringWithFormat:@"backpack_%d",y]] isEqual:dic[@"id"]]) {
                        [Backitemsarr addObject:[dic[@"name"]substringFromIndex:5]];
                    }
                }
            }
            [self.Backitems addObject:Backitemsarr];
            [self.items addObject:itemsarr];
            [self.Account_id addObject:model.players[i][@"account_id"]];
            [self.kill addObject:model.players[i][@"kills"]];
            [self.death addObject:model.players[i][@"deaths"]];
            [self.assists addObject:model.players[i][@"assists"]];
            [self.damage addObject:model.players[i][@"hero_damage"]];
            [self.PerExp addObject:model.players[i][@"xp_per_min"]];
            [self.PerGold addObject:model.players[i][@"gold_per_min"]];
            [self.TowerDamage addObject:model.players[i][@"tower_damage"]];
            [self.Cure addObject:model.players[i][@"hero_healing"]];
            [self.Last_hits addObject:model.players[i][@"last_hits"]];
            [self.Denies addObject:model.players[i][@"denies"]];
            for (NSDictionary *dic in [[NSUserDefaults standardUserDefaults] objectForKey:@"heroes"]) {
                if ([model.players[i][@"hero_id"] isEqual:dic[@"id"]]) {
                    [self.heroesName addObject:[dic[@"name"] substringFromIndex:14]];
                }
            }
        }
        NSInteger Gametime = localdate - [responseObject[@"result"][@"start_time"]integerValue];
        NSInteger duration = [responseObject[@"result"][@"duration"]integerValue];
        for (UILabel *label in self.LabelArray) {
            switch (label.tag) {
                case 0:
                    if (Gametime > 60 * 60 * 24) {
                        label.text = [NSString stringWithFormat:@"%ld天前",Gametime / (60 * 60 * 24) + 1];
                    }
                    else if (Gametime > 60 * 60 && Gametime < 60 * 60 * 24)
                    {
                        label.text = [NSString stringWithFormat:@"%ld小时前",Gametime / (60 * 60) + 1];
                    }
                    else
                    {
                        label.text = [NSString stringWithFormat:@"%ld分钟前",Gametime / 60 + 1];
                    }
                    break;
                case 1:
                    label.text = [NSString stringWithFormat:@"%ld分钟",duration / 60];
                    break;
                case 2:
                    label.text = @"Very High";
                    break;
                case 3:
                    label.text = [dic objectForKey:responseObject[@"result"][@"game_mode"]];
                default:
                    break;
            }
        }
        for (int i = 0; i < self.Account_id.count; i++) {
            [self.manager GET:[NSString stringWithFormat:@"http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=5C860AE59710475EE988DB15F9802F63&fomat=json&steamids=%ld",[self.Account_id[i]intValue] + 76561197960265728] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                ResultModel *playersmodel = [ResultModel ModelWithPlayers:responseObject[@"response"][@"players"]];
                if (playersmodel.players.firstObject == nil) {
                    [self.UserName setObject:@"匿名玩家" forKey:@(i)];
                    [self.UserHead setObject:@"none" forKey:@(i)];
                }
                else
                {
                    [self.UserName setObject:playersmodel.players.firstObject[@"personaname"] forKey:@(i)];
                    [self.UserHead setObject:playersmodel.players.firstObject[@"avatarfull"] forKey:@(i)];
                }
                if (self.UserHead.count == self.Account_id.count && self.UserName.count == self.Account_id.count) {
                    [self.view addSubview:self.tableview];
                    self.LoadingImage = nil;
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                self.retry.hidden = NO;
                [self.LoadingImage stopAnimating];
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.retry.hidden = NO;
        [self.LoadingImage stopAnimating];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 15;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 7 || section == 8 || section == 14) {
        return 0;
    }
    else
    {
        if ([self.IsOpen[index] isEqual:@1]) {
            return 1;
        }
        else
        {
            return 0;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailInDetailViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detailcell" forIndexPath:indexPath];
    cell.item0.image = nil;cell.item1.image = nil;cell.item2.image = nil;
    cell.damage.text = [NSString stringWithFormat:@"英雄伤害: %@",self.damage[indexPath.section < 7 ? indexPath.section - 2 : indexPath.section - 4]];
    cell.PerGold.text = [NSString stringWithFormat:@"每分钟金钱: %@",self.PerGold[indexPath.section < 7 ? indexPath.section - 2 : indexPath.section - 4]];
    cell.PerExp.text = [NSString stringWithFormat:@"每分钟经验: %@",self.PerExp[indexPath.section < 7 ? indexPath.section - 2 : indexPath.section - 4]];
    cell.TowerDamage.text = [NSString stringWithFormat:@"建筑伤害: %@",self.TowerDamage[indexPath.section < 7 ? indexPath.section - 2 : indexPath.section - 4]];
    cell.cure.text = [NSString stringWithFormat:@"英雄治疗: %@",self.Cure[indexPath.section < 7 ? indexPath.section - 2 : indexPath.section - 4]];
    cell.Last_hits.text = [NSString stringWithFormat:@"正补: %@",self.Last_hits[indexPath.section < 7 ? indexPath.section - 2 : indexPath.section - 4]];
    cell.Denies.text = [NSString stringWithFormat:@"反补: %@",self.Denies[indexPath.section < 7 ? indexPath.section - 2 : indexPath.section - 4]];
    NSArray *itemsArr = @[cell.item0,cell.item1,cell.item2];
    for (int i = 0; i < itemsArr.count; i++) {
        if (![self.Backitems[indexPath.section < 7 ? indexPath.section - 2 : indexPath.section - 4][i] isEqualToString:@"none"]) {
            [itemsArr[i] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/items/%@_lg.png",self.Backitems[indexPath.section < 7 ? indexPath.section - 2 : indexPath.section - 4][i]]] placeholderImage:nil];
        }
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        TitleView *titleview = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40) WithBackColor:[UIColor colorWithRed:5 / 255.0 green:160 / 255.0 blue:27 / 255.0 alpha:1] WithWhich:@"Radiant" WithWich_CN:@"天辉" WithIsWin:self.radiant_win ? @"胜利" : @"失败" WithKill:self.Totalkill[0] WithExp:@"2670" WithGold:@"2546"];
        return titleview;
    }
    else if (section == 8)
    {
        TitleView *titleview = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40) WithBackColor:[UIColor colorWithRed:164 / 255.0 green:5 / 255.0 blue:48 / 255.0 alpha:1] WithWhich:@"Dire" WithWich_CN:@"夜魇" WithIsWin:!self.radiant_win ? @"胜利" : @"失败" WithKill:self.Totalkill[1] WithExp:@"2670" WithGold:@"2546"];
        return titleview;
    }
    else if (section == 0 || section == 7 || section == 14)
    {
        return nil;
    }
    else
    {
        DetailView *detail = [[DetailView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        if ([self.Account_id[index] isEqual:@190350360]) {
            detail.Tang.hidden = NO;
        }
//        else if ([self.Account_id[index] isEqual:@107191981])
//        {
//            detail.Tang.hidden = NO;
//            detail.Tang.text = @"无敌";
//            detail.Tang.backgroundColor = [UIColor redColor];
//        }
        detail.Account_id.text = [NSString stringWithFormat:@"%@",self.UserName[@(index)]];
        if (![self.UserHead[@(index)] isEqualToString:@"none"]) {
            [detail.UserHead sd_setImageWithURL:[NSURL URLWithString:self.UserHead[@(index)]] placeholderImage:nil];
        }
        else
        {
            [detail.UserHead sd_setImageWithURL:[NSURL URLWithString:@"https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg"] placeholderImage:nil];
        }
        [detail.HeroHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/heroes/%@_lg.png",self.heroesName[index]]] placeholderImage:nil];
        detail.CanZhanLv.text = [NSString stringWithFormat:@"参战率:%.1f%%",([self.kill[index]floatValue] + [self.assists[index]floatValue]) / [self.Totalkill[section < 7 ? 0 : 1]floatValue] * 100];
        detail.KDADetail.text = [NSString stringWithFormat:@"%d/%d/%d",[self.kill[index]intValue],[self.death[index]intValue],[self.assists[index]intValue]];
        detail.KDA.text = [NSString stringWithFormat:@"KDA:%.1f",([self.kill[index]floatValue] + [self.assists[index]floatValue]) / ([self.death[index]floatValue] != 0 ? [self.death[index]floatValue] : 1)];
        detail.damage.text = [NSString stringWithFormat:@"伤害:%.1f%%",[self.damage[index]floatValue] / ([self.damage[section < 7 ? 0 : 5]floatValue] + [self.damage[section < 7 ? 1 : 6]floatValue] + [self.damage[section < 7 ? 2 : 7]floatValue] + [self.damage[section < 7 ? 3 : 8]floatValue] + [self.damage[section < 7 ? 4 : 9]floatValue]) * 100];
        NSArray *itemsArr =@[detail.item0,detail.item1,detail.item2,detail.item3,detail.item4,detail.item5];
        for (int i = 0; i < itemsArr.count; i++) {
            if (![self.items[index][i] isEqualToString:@"none"]) {
                [itemsArr[i] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/items/%@_lg.png",self.items[index][i]]] placeholderImage:nil];
            }
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = detail.bounds;
        button.tag = index;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [detail addSubview:button];
        return detail;
    }
}
-(void)buttonClick:(UIButton *)btn
{
    if ([self.IsOpen[btn.tag] isEqual:@0]) {
        [self.IsOpen removeObjectAtIndex:btn.tag];
        [self.IsOpen insertObject:@1 atIndex:btn.tag];
        [self.tableview insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:btn.tag < 5 ? btn.tag + 2 : btn.tag + 4]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ([self.IsOpen[btn.tag] isEqual:@1])
    {
        [self.IsOpen removeObjectAtIndex:btn.tag];
        [self.IsOpen insertObject:@0 atIndex:btn.tag];
        [self.tableview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:btn.tag < 5 ? btn.tag + 2 : btn.tag + 4]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 8) {
        return 40;
    }
    else if (section == 0 || section == 7 || section == 14)
    {
        return 20;
    }
    else
    {
        return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 7 || section == 8 || section == 14) {
        return 0.01;
    }
    else
    {
        return 2 / [UIScreen mainScreen].scale;
    }
}
@end
