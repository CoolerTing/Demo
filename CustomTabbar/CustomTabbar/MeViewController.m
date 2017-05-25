//
//  MeViewController.m
//  CustomTabbar
//
//  Created by Rain on 17/2/22.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//
#define MatchHistoryURL @"http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1/?key=5C860AE59710475EE988DB15F9802F63&fomat=json&account_id=345206798&matches_requested=8&min_players=6"
#define MatchDetailURL @"http://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/v1/?key=5C860AE59710475EE988DB15F9802F63&match_id="
#define account_id 345206798

#import "MeViewController.h"
#import "MeTableViewCell.h"
#import "ZhanJiTableViewCell.h"
#import "GuessViewController.h"
#import "ResultModel.h"
#import "MatchDetailViewController.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
//天数数组
@property(nonatomic,strong)NSMutableDictionary *DaysDic;
//战绩详情数组
@property(nonatomic,strong)NSMutableDictionary *DetailDic;
//是否胜利数组
@property(nonatomic,strong)NSMutableDictionary *IsWin;

@property(nonatomic,strong)NSMutableArray *HeroesArray;

@property(nonatomic,strong)AFHTTPSessionManager *manager;

@property(nonatomic,strong)NSMutableArray *LoadingImagesArray;

@property(nonatomic,strong)UIImageView *LoadingImage;

@property(nonatomic,strong)NSMutableDictionary *DetailURL;

@property(nonatomic,strong)NSMutableDictionary *MatchID;

@property(nonatomic,strong)UIButton *retry;

@end

@implementation MeViewController
static int x = 0;
-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 15.f;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return _manager;
}
-(NSMutableDictionary *)MatchID
{
    if (!_MatchID) {
        _MatchID = [NSMutableDictionary dictionary];
    }
    return _MatchID;
}
-(NSMutableDictionary *)DetailURL
{
    if (!_DetailURL) {
        _DetailURL = [NSMutableDictionary dictionary];
    }
    return _DetailURL;
}
-(NSMutableArray *)LoadingImagesArray
{
    if (!_LoadingImagesArray) {
        _LoadingImagesArray = [NSMutableArray array];
    }
    return _LoadingImagesArray;
}
-(NSMutableArray *)HeroesArray
{
    if (!_HeroesArray) {
        _HeroesArray = [NSMutableArray array];
    }
    return _HeroesArray;
}
-(NSMutableDictionary *)DaysDic
{
    if (!_DaysDic) {
        _DaysDic = [NSMutableDictionary dictionary];
    }
    return _DaysDic;
}
-(NSMutableDictionary *)DetailDic
{
    if (!_DetailDic) {
        _DetailDic = [NSMutableDictionary dictionary];
    }
    return _DetailDic;
}
-(NSMutableDictionary *)IsWin
{
    if (!_IsWin) {
        _IsWin = [NSMutableDictionary dictionary];
    }
    return _IsWin;
}
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 113) style:UITableViewStyleGrouped];
        _tableview.showsVerticalScrollIndicator = NO;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
        //注册MeTableViewCell
        [_tableview registerNib:[UINib nibWithNibName:@"MeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        //注册ZhanJiTableViewCell
        [_tableview registerNib:[UINib nibWithNibName:@"ZhanJiTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
        //分割线从头显示
        _tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetLoadingimage];
    [self SetReTryButton];
    //初始化MJRresh
    [self setupRefresh];
    [self GetMatchHistoryList];
//    NSDictionary *dic = @{
//                          @"search_key":@"",
//                          @"start":@"1",
//                          @"limit":@"10",
//                          @"phone":@"138XXXXXXXX",
//                          @"start_date":@"",
//                          @"end_date":@""
//                          };
//    [self.manager POST:@"http://222.209.210.70:8085/zcgoldInvoice/invoice/einvoice/listEInvoice.do" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
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
    [retry addTarget:self action:@selector(GetMatchHistoryList) forControlEvents:UIControlEventTouchUpInside];
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
- (void)setupRefresh
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
    
    [header setImages:self.LoadingImagesArray forState:1];
    [header setImages:self.LoadingImagesArray duration:0.5 forState:2];
    header.automaticallyChangeAlpha = YES;
    //隐藏更新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
    header.stateLabel.hidden = YES;
    self.tableview.mj_header = header;
}
//刷新数据
-(void)LoadNewData
{
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf GetMatchHistoryList];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark tableViewDelegate、tableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
    }
    ZhanJiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    cell.Detail.text = self.DetailDic[@(indexPath.row)];
    if (self.DaysDic.count < 8)
    {
        cell.DaysAgo.text = @"";
    }
    else
    {
        cell.DaysAgo.text = self.DaysDic[@(indexPath.row)];
    }
    if (self.IsWin.count < 8) {
        cell.IsWin.text = @"";
    }
    else
    {
        cell.IsWin.text = self.IsWin[@(indexPath.row)];
        cell.IsWin.textColor = [cell.IsWin.text isEqualToString:@"胜利"] ? [UIColor colorWithRed:27 / 255.0 green:139 / 255.0 blue:79 / 255.0 alpha:1] :[UIColor redColor];
    }
    [cell.HeadImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/heroes/%@_lg.png",[self.HeroesArray[indexPath.row] substringFromIndex:14]]] placeholderImage:nil options:SDWebImageRetryFailed];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 180;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    view.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 15)];
    view1.center = CGPointMake(view1.center.x, view.frame.size.height / 2 + 5);
    view1.backgroundColor = [UIColor grayColor];
    [view addSubview:view1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 15)];
    label.center = CGPointMake(label.center.x, view.frame.size.height / 2 + 5);
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    [view addSubview:label];
    if (section == 1) {
        label.text = @"我的关注";
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 60, 20);
        [btn setTitle:@"关注列表" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.layer.backgroundColor = [UIColor whiteColor].CGColor;
        btn.layer.cornerRadius = 10;
        btn.layer.shadowRadius = 0.5;
        btn.layer.shadowOffset = CGSizeMake(0, 0);
        btn.layer.shadowOpacity = 0.7;
        btn.layer.shadowColor = [UIColor grayColor].CGColor;
        btn.center = CGPointMake(view.frame.size.width - 30 - 10, view.frame.size.height / 2);
        [view addSubview:btn];
        return view;
    }
    label.text = @"我的帐号";
    return view;
}
-(void)push
{
    GuessViewController *view = [GuessViewController new];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MatchDetailViewController *detail = [MatchDetailViewController new];
    detail.DetailURL = [self.DetailURL objectForKey:@(indexPath.row)];
    detail.title = [NSString stringWithFormat:@"比赛:%@",[self.MatchID objectForKey:@(indexPath.row)]];
    detail.hidesBottomBarWhenPushed = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)GetMatchHistoryList
{
    x = 1;
    [self.LoadingImage startAnimating];
    self.retry.hidden = YES;
    NSInteger localdate = [[NSDate date] timeIntervalSince1970];
    NSArray *heroes = [[NSUserDefaults standardUserDefaults] objectForKey:@"heroes"];
    [self.HeroesArray removeAllObjects];
    [self.manager GET:MatchHistoryURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ResultModel *model = [ResultModel ModelWithMatches:responseObject[@"result"][@"matches"]];
        for (int i = 0; i < model.matches.count ; i++) {
            for (int j = 0; j < [model.matches[i][@"players"]count]; j++) {
            if ([model.matches[i][@"players"][j][@"account_id"] isEqual:@(account_id)]) {
                for (int y = 0; y < heroes.count; y++) {
                    if (model.matches[i][@"players"][j][@"hero_id"] == heroes[y][@"id"]) {
                        [self.HeroesArray
                         addObject:heroes[y][@"name"]];
                    }
                }
            }
        }
            [self.DetailURL setObject:[NSString stringWithFormat:@"%@%@",MatchDetailURL,model.matches[i][@"match_id"]] forKey:@(i)];
            [self.MatchID setObject:model.matches[i][@"match_id"] forKey:@(i)];
            [self.manager GET:[self.DetailURL objectForKey:@(i)] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSInteger Gametime = localdate - [responseObject[@"result"][@"start_time"]integerValue];
                ResultModel *PlayersModel = [ResultModel ModelWithPlayers:responseObject[@"result"][@"players"]];
                if (Gametime > 60 * 60 * 24) {
                    [self.DaysDic setObject:[NSString stringWithFormat:@"%ld天前",Gametime / (60 * 60 * 24) + 1] forKey:@(i)];
                }
                else if (Gametime > 60 * 60 && Gametime < 60 * 60 * 24)
                {
                    [self.DaysDic setObject:[NSString stringWithFormat:@"%ld小时前",Gametime / (60 * 60) + 1] forKey:@(i)];
                }
                else
                {
                    [self.DaysDic setObject:[NSString stringWithFormat:@"%ld分钟前",Gametime / 60 + 1] forKey:@(i)];
                }
                for (int j = 0; j < PlayersModel.players.count; j++) {
                    if ([PlayersModel.players[j][@"account_id"] isEqual:@(account_id)]) {
                        if (([PlayersModel.players[j][@"player_slot"] intValue] > 4 && [responseObject[@"result"][@"radiant_win"] isEqual:@0]) || ([PlayersModel.players[j][@"player_slot"] intValue] <= 4 && [responseObject[@"result"][@"radiant_win"] isEqual:@1])) {
                            [self.IsWin setObject:@"胜利" forKey:@(i)];
                        }
                        else
                        {
                            [self.IsWin setObject:@"失败" forKey:@(i)];
                        }
                        [self.DetailDic setObject:[NSString stringWithFormat:@"%@/%@/%@",PlayersModel.players[j][@"kills"],PlayersModel.players[j][@"deaths"],PlayersModel.players[j][@"assists"]] forKey:@(i)];
                        if (self.DetailDic.count == 8 && self.DaysDic.count == 8 && self.IsWin.count == 8) {
                            if (self.HeroesArray.count == 8) {
                                [self.tableview.mj_header endRefreshing];
                                [self.tableview reloadData];
                            }
                            else
                            {
                                [self GetHeroesArrayWithModel:model];
                            }
                            if (x == 1) {
                                [self.view addSubview:self.tableview];
                            }
                            if (self.LoadingImage) {
                                self.LoadingImage = nil;
                            }
                        }
                    }
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
-(void)GetHeroesArrayWithModel:(ResultModel *)model
{
    NSArray *heroes = [[NSUserDefaults standardUserDefaults] objectForKey:@"heroes"];
    if (heroes == nil) {
        [self GetHeroesArrayWithModel:model];
    }
    else
    {
        for (int i = 0; i < model.matches.count ; i++) {
            for (int j = 0; j < [model.matches[i][@"players"]count]; j++) {
                if ([model.matches[i][@"players"][j][@"account_id"] isEqual:@(account_id)]) {
                    for (int y = 0; y < heroes.count; y++) {
                        if (model.matches[i][@"players"][j][@"hero_id"] == heroes[y][@"id"]) {
                            [self.HeroesArray
                             addObject:heroes[y][@"name"]];
                        }
                    }
                }
            }
        }
        [self.tableview.mj_header endRefreshing];
        [self.tableview reloadData];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    if (self.LoadingImage != nil) {
        [self.LoadingImage startAnimating];
    }
}
@end
