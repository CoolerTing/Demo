//
//  LiveViewController.m
//  CustomTabbar
//
//  Created by Rain on 17/2/22.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "LiveViewController.h"
#import "VideoCollectionViewCell.h"
#import "VideoViewController.h"
#import "UIImage+GetVedioURLImage.h"
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh.h>
@interface LiveViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *VedioArr;
@property(nonatomic,strong)NSMutableArray *LoadingImagesArray;
@end

@implementation LiveViewController
-(NSMutableArray *)LoadingImagesArray
{
    if (!_LoadingImagesArray) {
        _LoadingImagesArray = [NSMutableArray array];
        for (int i = 0; i < 40; i ++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"000%.2d",i]];
            [_LoadingImagesArray addObject:image];
        }
    }
    return _LoadingImagesArray;
}
-(NSArray *)VedioArr
{
    if (!_VedioArr) {
        _VedioArr = @[@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4",@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4 ",@"http://www.jxgbwlxy.gov.cn/tm/course/041629011/sco1/1.mp4",@"http://www.jxgbwlxy.gov.cn/tm/course/041629011/sco1/1.mp4",@"http://www.jxgbwlxy.gov.cn/tm/course/041629011/sco1/1.mp4",@"http://www.jxgbwlxy.gov.cn/tm/course/041629011/sco1/1.mp4",@"http://www.jxgbwlxy.gov.cn/tm/course/041629011/sco1/1.mp4",@"http://www.jxgbwlxy.gov.cn/tm/course/041629011/sco1/1.mp4",@"http://www.jxgbwlxy.gov.cn/tm/course/041629011/sco1/1.mp4",@"http://www.jxgbwlxy.gov.cn/tm/course/041629011/sco1/1.mp4"];
    }
    return _VedioArr;
}
-(UICollectionView *)collectionview
{
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 30) / 2, ([UIScreen mainScreen].bounds.size.width - 30) / 3);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 113) collectionViewLayout:layout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.backgroundColor = [UIColor whiteColor];
        [_collectionview registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionview];
    [self setupRefresh];
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
    self.collectionview.mj_header = header;
}
-(void)LoadNewData
{
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionview reloadData];
        
        // 结束刷新
        [weakSelf.collectionview.mj_header endRefreshing];
    });
}
#pragma mark CollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage getThumbnailImage:self.VedioArr[indexPath.row]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.VedioImage.image = image;
        });
    });
    cell.VideoName.text = [[self.VedioArr[indexPath.row] componentsSeparatedByString:@"/"]lastObject];
    
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoViewController *video = [VideoViewController new];
    video.VedioURL = self.VedioArr[indexPath.row];
    video.Title = [[self.VedioArr[indexPath.row] componentsSeparatedByString:@"/"]lastObject];
    video.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:video animated:YES];
}
@end
