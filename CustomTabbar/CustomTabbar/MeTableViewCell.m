//
//  MeTableViewCell.m
//  CustomTabbar
//
//  Created by Rain on 17/2/23.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "MeTableViewCell.h"

@interface MeTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *Button;

@end


@implementation MeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.Button.imageView.contentMode = UIViewContentModeScaleAspectFill & UIViewContentModeTopRight;
}
- (IBAction)ZhanjiDetail:(id)sender {
    NSLog(@"战绩详情");
}
- (IBAction)ProfileDetail:(id)sender {
    NSLog(@"个人详情");
}
- (IBAction)MissionCenter:(id)sender {
    NSLog(@"任务中心");
}
- (IBAction)ActivityCenter:(id)sender {
    NSLog(@"专题活动");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
