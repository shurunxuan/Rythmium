//
//  MediaLibExport.m
//  MusicGame
//
//  Created by 舒润萱 on 15/5/12.
//  Copyright (c) 2015年 SRX. All rights reserved.
//

#import "MediaLibExport.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FileClass.h"

@implementation MediaLibExport

- (id) init {
    Done = NO;
    End = NO;
    Dismissed = NO;
    return self;
}

/*- (void) dealloc {
    [super dealloc];
}*/

#pragma mark conveniences
NSString* myDocumentsDirectory() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];;
}

//获取Tmp目录
NSString* myTempDirectory() {
    //[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    NSString *tmpDirectory = NSTemporaryDirectory();
    return tmpDirectory;
}

void myDeleteFile (NSString* path) {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *deleteErr = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&deleteErr];
        if (deleteErr) {
            NSLog (@"Can't delete %@: %@", path, deleteErr);
        }
    }
}

static void CheckResult(OSStatus result, const char *operation)
{
    if (result == noErr) return;
    
    char errorString[20];
    // see if it appears to be a 4-char-code
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(result);
    if (isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    } else
        // no, format it as an integer
        sprintf(errorString, "%d", (int)result);
    
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    
    exit(1);
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [super viewDidUnload];
}

BOOL coreAudioCanOpenURL (NSURL* url) {
    OSStatus openErr = noErr;
    AudioFileID audioFile = NULL;
    openErr = AudioFileOpenURL((__bridge CFURLRef) url,
                               kAudioFileReadPermission ,
                               0,
                               &audioFile);
    if (audioFile) {
        AudioFileClose (audioFile);
    }
    return openErr ? NO : YES;
}

- (void) ChooseSong {
    // show picker
    Done = NO;
    End = NO;
    Dismissed = NO;
    MPMediaPickerController *pickerController =	[[MPMediaPickerController alloc]
                                                 initWithMediaTypes: MPMediaTypeMusic];
    //pickerController.prompt = @"Choose song to export";
    pickerController.allowsPickingMultipleItems = NO;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

-(void) Export {
    // get the special URL
    if (! song) {
        NSLog(@"export failed");
        return;
    }
    NSURL *assetURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                        initWithAsset: songAsset
                                        presetName: AVAssetExportPresetAppleM4A];
    exporter.outputFileType = @"com.apple.m4a-audio";
    NSString *exportFile = [myDocumentsDirectory() stringByAppendingPathComponent: @"exported.m4a"];
    
    // set up export (hang on to exportURL so convert to PCM can find it)
    myDeleteFile(exportFile);
    //[exportURL release];
    exportURL = [NSURL fileURLWithPath:exportFile];
    exporter.outputURL = exportURL;
        
    // do the export
        
    [self Convert];

}

#pragma mark MPMediaPickerControllerDelegate
- (void) mediaPicker: (MPMediaPickerController *)mediaPicker
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    if ([mediaItemCollection count] < 1) {
        return;
    }
    song = [[mediaItemCollection items] objectAtIndex:0];
    NSLog(@"opened file %@", song);

    
    title = [song valueForProperty:MPMediaItemPropertyTitle];
    artist = [song valueForProperty:MPMediaItemPropertyArtist];
    artWork = [song valueForProperty:MPMediaItemPropertyArtwork];


    userIsScrubbing = NO;
    NSURL *assetURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
    [self setUpAVPlayerForURL: assetURL];//]exporter.outputURL];
    [self dismissViewControllerAnimated:true completion:nil];
    Done = YES;
    
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:true completion:nil];
    Done = YES;
    Dismissed = YES;
}

- (void) Convert {
    NSURL *assetURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
    // open an ExtAudioFile
    ExtAudioFileRef inputFile;
    CheckResult (ExtAudioFileOpenURL((__bridge CFURLRef)assetURL, &inputFile),
                 "ExtAudioFileOpenURL failed");
    
    // prepare to convert to a plain ol' PCM format
    AudioStreamBasicDescription myPCMFormat;
    myPCMFormat.mSampleRate = 44100; // todo: or use source rate?
    myPCMFormat.mFormatID = kAudioFormatLinearPCM ;
    myPCMFormat.mFormatFlags =  kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
    myPCMFormat.mChannelsPerFrame = 2;
    myPCMFormat.mFramesPerPacket = 1;
    myPCMFormat.mBitsPerChannel = 16;
    myPCMFormat.mBytesPerPacket = 4;
    myPCMFormat.mBytesPerFrame = 4;
    
    CheckResult (ExtAudioFileSetProperty(inputFile, kExtAudioFileProperty_ClientDataFormat,
                                         sizeof (myPCMFormat), &myPCMFormat),
                 "ExtAudioFileSetProperty failed");
    
    // allocate a big buffer. size can be arbitrary for ExtAudioFile.
    // you have 64 KB to spare, right?
    UInt32 outputBufferSize = 0x10000000;
    void* ioBuf = malloc (outputBufferSize);
    UInt32 sizePerPacket = myPCMFormat.mBytesPerPacket;
    UInt32 packetsPerBuffer = outputBufferSize / sizePerPacket;
    
    // set up output file
    NSString *outputPath = [myDocumentsDirectory() stringByAppendingPathComponent:@"export-pcm.caf"];
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    NSLog (@"creating output file %@", outputURL);
    AudioFileID outputFile;
    CheckResult(AudioFileCreateWithURL((__bridge CFURLRef)outputURL,
                                       kAudioFileCAFType,
                                       &myPCMFormat,
                                       kAudioFileFlags_EraseFile,
                                       &outputFile),
                "AudioFileCreateWithURL failed");
    
    // start convertin'
    UInt32 outputFilePacketPosition = 0; //in bytes
    
    while (true) {
        // wrap the destination buffer in an AudioBufferList
        AudioBufferList convertedData;
        convertedData.mNumberBuffers = 1;
        convertedData.mBuffers[0].mNumberChannels = myPCMFormat.mChannelsPerFrame;
        convertedData.mBuffers[0].mDataByteSize = outputBufferSize;
        convertedData.mBuffers[0].mData = ioBuf;
        
        UInt32 frameCount = packetsPerBuffer;
        
        // read from the extaudiofile
        CheckResult (ExtAudioFileRead(inputFile,
                                      &frameCount,
                                      &convertedData),
                     "Couldn't read from input file");
        
        if (frameCount == 0) {
            break;
        }
        
        // write the converted data to the output file
        CheckResult (AudioFileWritePackets(outputFile,
                                           false,
                                           frameCount,
                                           NULL,
                                           outputFilePacketPosition / myPCMFormat.mBytesPerPacket,
                                           &frameCount,
                                           convertedData.mBuffers[0].mData),
                     "Couldn't write packets to file");
        
        NSLog (@"Converted %u bytes", (unsigned int)outputFilePacketPosition);
        
        // advance the output file write location
        outputFilePacketPosition += (frameCount * myPCMFormat.mBytesPerPacket);
    }
    
    // clean up
    ExtAudioFileDispose(inputFile);
    AudioFileClose(outputFile);
    
    free(ioBuf);
}

- (MPMediaItem*) Song {
    return song;
}


- (BOOL) isDone {
    return Done && !End;
}

- (void) setEnd {
    End = YES;
}

- (BOOL) isEnd {
    return End;
}

- (BOOL) isDismissed {
    return Dismissed;
}

- (void) setUpAVPlayerForURL: (NSURL*) url {
    player = [[AVPlayer alloc] initWithURL: url];
    if (player) {
        userIsScrubbing = NO;
         [self createPlaybackTimer];
        // timer needs to be set up on main thread (in default run loop mode), which is
        // not what calls back from export completion
        //[self performSelectorOnMainThread:@selector (createPlaybackTimer)
          //                     withObject:nil
            //                waitUntilDone:YES];
    }
}

- (void) play {
    [player play];
}

-(void) createPlaybackTimer {
    if (playbackTimer) {
        [playbackTimer invalidate];
    }
    //playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
      //                                                target:self
        //                                            selector:@selector(playerTimerUpdate:)
          //                                          userInfo:nil
            //                                         repeats:YES];
}

- (unsigned long long) songID {
    return [song persistentID];
}

- (void) playerToNil {
    player = nil;
}

//songLabel.text = [song valueForProperty:MPMediaItemPropertyTitle];
//artistLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];
//coverArtView.image = [[song valueForProperty:MPMediaItemPropertyArtwork]
//                      imageWithSize: coverArtView.bounds.size];

- (NSString*) songTitle {
    return title;
}

- (NSString*) songArtist {
    return artist;
}

- (UIImage*) artView {
    return artWork;
}

- (AVPlayer*) player {
    return player;
}


@end

