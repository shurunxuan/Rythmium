//
//  MPMediaItemArtwork+Resize.h
//  MusicGame
//
//  Created by 舒润萱 on 15/5/25.
//  Copyright (c) 2015年 SRX. All rights reserved.
//

#ifndef MusicGame_MPMediaItemArtwork_Resize_h
#define MusicGame_MPMediaItemArtwork_Resize_h

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface MPMediaItemArtwork ()
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
@end

#endif
