//
//  ResultModel.m
//  CustomTabbar
//
//  Created by Rain on 17/3/10.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "ResultModel.h"

@interface ResultModel()

@end

@implementation ResultModel
+(ResultModel *)ModelWithMatches:(NSArray *)matches
{
    ResultModel *model = [ResultModel new];
    model.matches = matches;
    return model;
}
+(ResultModel *)ModelWithPlayers:(NSArray *)players
{
    ResultModel *model = [ResultModel new];
    model.players = players;
    return model;
}
@end
