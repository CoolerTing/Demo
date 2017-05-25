//
//  GuessViewController.m
//  CustomTabbar
//
//  Created by Rain on 17/2/22.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "GuessViewController.h"
#import "MainViewController.h"
#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface GuessViewController ()
@property(nonatomic,strong)CAShapeLayer *layer;
@property(nonatomic,weak)CABasicAnimation *basic;
@end

@implementation GuessViewController
-(CAShapeLayer *)layer
{
    if (!_layer) {
        _layer = [CAShapeLayer layer];
        _layer.frame = CGRectMake(0, 2, self.view.frame.size.width, 4);
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        [bezier moveToPoint:CGPointMake(0, 0)];
        [bezier addLineToPoint:CGPointMake(self.view.frame.size.width, 0)];
        _layer.path = bezier.CGPath;
        _layer.strokeColor = [UIColor blueColor].CGColor;
        _layer.strokeStart = 0;
        _layer.strokeEnd = 0;
        _layer.lineWidth = 4;
        [self.view.layer addSublayer:self.layer];
        self.basic = [CABasicAnimation animation];
        self.basic.duration = 0.3;
        self.basic.fillMode = kCAFillModeForwards;
        self.basic.removedOnCompletion = NO;
        self.basic.fromValue = @1;
        self.basic.toValue = @0;
    }
    return _layer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.frame = self.view.bounds;
    [imageview sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489120311477&di=864c3ca9f11593351e59249f0cbbef3e&imgtype=0&src=http%3A%2F%2Fimg.sgamer.com%2Fdota2_sgamer_com%2Fimages%2F140424%2F20140424152302.png"] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layer.strokeEnd = (CGFloat)receivedSize / expectedSize;
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self.layer addAnimation:self.basic forKey:@"opacity"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.layer removeFromSuperlayer];
        });
    }];
    [self.view addSubview:imageview];
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] isKindOfClass:[MainViewController class]]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers[0] isKindOfClass:[MainViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    NSLog(@"dealloc");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
