//
//  FileClass.m
//  MusicGame
//
//  Created by 舒润萱 on 15/5/12.
//  Copyright (c) 2015年 SRX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileClass.h"

@implementation FileClass

- (BOOL) OpenFile:(NSString *)FileName {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *testPath = [documentsPath stringByAppendingPathComponent:FileName];
    Name = testPath;
    BinaryReader = [NSData dataWithContentsOfFile:Name];
    offset = 0;
    if ([self isExist]) {
        return YES;
    } else
        return [self CreateFile:FileName];
}

- (BOOL) CreateFile:(NSString *)FileName {
    //创建文件
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *testDirectory = FileName;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [documentsPath stringByAppendingPathComponent:FileName];
    BOOL res=[fileManager createFileAtPath:testPath contents:nil attributes:nil];
    if (res) {
        Name = testPath;
        BinaryReader = [NSData dataWithContentsOfFile:Name];
        offset = 0;
    }
    return res;
}

- (BOOL) Write:(NSString*)Content {
    NSString *testPath = Name;
    BOOL res=[Content writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (res) {
        offset += [Content length];
    }
    return res;
}

- (NSString*) Read {
    NSString *testPath = Name;
    NSString *content=[NSString stringWithContentsOfFile:testPath encoding:NSUTF8StringEncoding error:nil];
    offset += [content length];
    return content;
}

- (BOOL) DeleteFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = Name;
    BOOL res=[fileManager removeItemAtPath:testPath error:nil];
    return res;
}

- (long) ReadBinary:(long)Length {
    long value = 0;
    [BinaryReader getBytes:&value range:NSMakeRange(offset, Length)];
    offset += Length;
    return value;
}

- (int16_t) ReadBinary {
    int16_t value = 0;
    [BinaryReader getBytes:&value range:NSMakeRange(offset, 2)];
    offset += 2;
    return value;
}

- (void) Peek:(long)Offset {
    offset = Offset;
}

+ (BOOL) isExist: (NSString*)FileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:FileName]];
}

- (BOOL) isExist {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:Name];
}

- (long) OFFSET {
    return offset;
}

@end
