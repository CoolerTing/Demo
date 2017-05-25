//
//  ResultModel.h
//  CustomTabbar
//
//  Created by Rain on 17/3/10.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject
@property(nonatomic,copy)NSArray *matches;
@property(nonatomic,copy)NSArray *players;
+(ResultModel *)ModelWithMatches:(NSArray *)matches;
+(ResultModel *)ModelWithPlayers:(NSArray *)players;
@end
