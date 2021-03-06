//
//  FileManager.m
//  AudioFileDownLoader
//
//  Created by BJQingniuJJ on 2017/12/14.
//  Copyright © 2017年 周建. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

/**
 如果目录不存在, 则创建
 
 @param path 路径
 @return YES 创建成功  NO 创建成功
 */
+ (BOOL)createDirectoryIfNotExists:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:path]) {
        NSError *error;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) return NO;
    }
    return YES;
}

/**
 文件是否存在
 
 @param path 路径
 @return YES 文件存在  NO 文件不存在
 */
+ (BOOL)fileExistsAtPath:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:path];
}

/**
 文件大小
 
 @param path 路径
 @return 文件大小
 */
+ (long long)fileSizeAtPath:(NSString *)path{
 
    if (![self fileExistsAtPath:path]) return 0;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDictionary *fileInfoDic = [manager attributesOfItemAtPath:path error:nil];
    return  [fileInfoDic[NSFileSize] longLongValue];
}

/**
 删除文件
 
 @param path 删除指定文件
 */
+ (void)removeFileAtPath:(NSString *)path{
    if (![self fileExistsAtPath:path]) return;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:path error:nil];
}


/**
 移动文件
 
 @param sourcePath 源文件路劲
 @param toPath 目标文件路径
 */
+ (void)moveFileWithPath:(NSString *)sourcePath toPath:(NSString *)toPath{
    if (![self fileExistsAtPath:sourcePath]) return;
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager moveItemAtPath:sourcePath toPath:toPath error:nil];
}


/**
 获取缓存路径文件大小
 
 @param path 缓存路径
 @return 文件大小
 */
+ (CGFloat)getsCacheSizeWithFilePath:(NSString *)path{
    // 总大小
    unsigned long long size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL exist = [manager fileExistsAtPath:path isDirectory:&isDir];
    
    // 判断路径是否存在
    if (!exist) return size;
    if (isDir) { // 是文件夹
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:path];
        for (NSString *subPath in enumerator) {
            NSString *fullPath = [path stringByAppendingPathComponent:subPath];
            size += [manager attributesOfItemAtPath:fullPath error:nil].fileSize;
        }
    } else { // 是文件
        size += [manager attributesOfItemAtPath:path error:nil].fileSize;
    }
    return size/1024.0/1024.0;
}


@end
