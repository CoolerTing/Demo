//
//  DetailView.m
//  CustomTabbar
//
//  Created by Rain on 17/3/15.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"DetailView" owner:self options:nil]firstObject];
        self.frame = frame;
        self.Tang.hidden = YES;
    }
    return self;
}
@end
