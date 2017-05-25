//
//  UIImage+GetVedioURLImage.m
//  CustomTabbar
//
//  Created by Rain on 17/3/20.
//  Copyright © 2017年 cdhykj.Rain. All rights reserved.
//

#import "UIImage+GetVedioURLImage.h"
#import <AVFoundation/AVFoundation.h>
@implementation UIImage (GetVedioURLImage)
+(UIImage *)getThumbnailImage:(NSString *)videoURL

{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(1.0, 60);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    if (error) {
        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}
@end
