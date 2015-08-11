//
//  MPMediaItemArtwork+Resize.m
//  MusicGame
//
//  Created by 舒润萱 on 15/5/25.
//  Copyright (c) 2015年 SRX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMediaItemArtwork+Resize.h"
#import "UIImage+Resize.h"


@implementation MPMediaItemArtwork (Resize)
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    return [[self imageWithSize:newSize] resizedImage: newSize interpolationQuality: quality];
}
@end