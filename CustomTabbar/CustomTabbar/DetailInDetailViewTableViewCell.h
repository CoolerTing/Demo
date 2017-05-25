//
//  DetailInDetailViewTableViewCell.h
//  CustomTabbar
//
//  Created by Rain on 17/3/13.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailInDetailViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *damage;
@property (weak, nonatomic) IBOutlet UILabel *PerExp;
@property (weak, nonatomic) IBOutlet UILabel *PerGold;
@property (weak, nonatomic) IBOutlet UILabel *TowerDamage;
@property (weak, nonatomic) IBOutlet UILabel *cure;
@property (weak, nonatomic) IBOutlet UIImageView *item0;
@property (weak, nonatomic) IBOutlet UIImageView *item1;
@property (weak, nonatomic) IBOutlet UIImageView *item2;
@property (weak, nonatomic) IBOutlet UILabel *Last_hits;
@property (weak, nonatomic) IBOutlet UILabel *Denies;


@end
