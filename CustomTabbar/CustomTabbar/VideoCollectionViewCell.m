//
//  VideoCollectionViewCell.m
//  CustomTabbar
//
//  Created by Rain on 17/3/20.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "VideoCollectionViewCell.h"

@implementation VideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.VedioImage.contentMode = UIViewContentModeScaleAspectFit;
}

@end
