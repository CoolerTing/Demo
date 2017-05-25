//
//  AppDelegate.m
//  CustomTabbar
//
//  Created by Rain on 17/2/22.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "YYFPSLabel.h"
#import <AFNetworking.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBG"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[MainViewController new]];
    navi.navigationBarHidden = YES;
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"heroes"] == nil) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager GET:@"http://api.steampowered.com/IEconDOTA2_570/GetHeroes/v1/?key=5C860AE59710475EE988DB15F9802F63&fomat=json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *arr = responseObject[@"result"][@"heroes"];
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"heroes"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"items"] == nil) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager GET:@"http://api.steampowered.com/IEconDOTA2_570/GetGameItems/v1/?key=5C860AE59710475EE988DB15F9802F63&fomat=json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *arr = responseObject[@"result"][@"items"];
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"items"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    YYFPSLabel *fpsLabel = [YYFPSLabel new];
    fpsLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 25, 50, 30);
    [fpsLabel sizeToFit];
    [[UIApplication sharedApplication].keyWindow addSubview:fpsLabel];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
