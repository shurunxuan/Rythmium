//
//  MediaLibExport.h
//  MusicGame
//
//  Created by 舒润萱 on 15/5/12.
//  Copyright (c) 2015年 SRX. All rights reserved.
//

#ifndef MusicGame_MediaLibExport_h
#define MusicGame_MediaLibExport_h

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface MediaLibExport : UIViewController <MPMediaPickerControllerDelegate> {
//@interface MediaLibExport : NSObject {
    MPMediaItem *song;
    BOOL userIsScrubbing;
    NSURL *exportURL;
    BOOL Done;
    BOOL End;
    BOOL Dismissed;
    AVPlayer *player;
    NSTimer *playbackTimer;
    BOOL NeedExport;
    NSString *title;
    NSString *artist;
    UIImage *artWork;
}


- (void) ChooseSong;
- (void) Export;
- (void) Convert;

- (MPMediaItem*) Song;
- (BOOL) isDone;
- (void) setEnd;
- (BOOL) isEnd;
- (BOOL) isDismissed;

- (void) play;

- (void) playerToNil;

- (unsigned long long) songID;

- (NSString*) songTitle;
- (NSString*) songArtist;
- (UIImage*) artView;

- (AVPlayer*) player;

@end

#endif
