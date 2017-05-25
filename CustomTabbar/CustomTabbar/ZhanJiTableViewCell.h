//
//  ZhanJiTableViewCell.h
//  CustomTabbar
//
//  Created by Rain on 17/2/23.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhanJiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *IsWin;
@property (weak, nonatomic) IBOutlet UILabel *DaysAgo;
@property (weak, nonatomic) IBOutlet UILabel *Detail;
@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;
@end
