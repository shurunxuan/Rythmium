//
//  FileClass.h
//  MusicGame
//
//  Created by 舒润萱 on 15/5/12.
//  Copyright (c) 2015年 SRX. All rights reserved.
//

#ifndef MusicGame_FileClass_h
#define MusicGame_FileClass_h

@interface FileClass : NSObject {
    NSString* Name;
    NSData* BinaryReader;
    long offset;
}

- (BOOL) OpenFile: (NSString*)FileName;
- (BOOL) CreateFile: (NSString*)FileName;
- (BOOL) Write: (NSString*)Content;
- (NSString*) Read;
- (BOOL) DeleteFile;

- (long) ReadBinary: (long)Length;
- (long) ReadBinary;

- (void) Peek: (long)Offset;

+ (BOOL) isExist: (NSString*)FileName;
- (BOOL) isExist;

- (long) OFFSET;
@end

#endif
