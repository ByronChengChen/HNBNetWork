//
//  HNBBaseRequest.m
//  HNBNetWork
//
//  Created by 开发 on 2017/6/27.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "HNBBaseRequest.h"
#import "RequestEngine.h"
#import "NSObject+HNB.h"
#import <CommonCrypto/CommonDigest.h>

static NSString * const HNBResponsCachePath = @"HNBResponsCachePath";
NSString * const HNBUsingCacheKey = @"HNBUsingCacheKey";

@interface HNBBaseRequest()

@end

@implementation HNBBaseRequest

/**
 *  md5加密
 */
+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (HNBBaseRequest *)init{
    if(self == [super init]){
        self.cachePolicy = HNBRequestNoCachePolicy;
    }
    return self;
}

#pragma mark -缓存策略
- (NSURLSessionTask *)hnbStartWithSucessBlock:(NetWorkSuccessBlock)successBlock requestFailBlock:(RequestFailBlock)requestFailBlock{
    NSURLSessionTask *task = nil;
    [self loadCachedData];
    task = [[RequestEngine sharedEngine] addRequest:self successBlock:^(NSDictionary *content) {
        if(successBlock){
            successBlock(content);
        }
        [self saveCacheWithContent:content];
    }  requestFailBlock:^(NSError *error){
        [self clearCachedData];
        requestFailBlock(error);
    }];
    self.task = task;
    return task;
}

- (void)saveCacheWithContent:(NSDictionary *)content{
    BOOL requestCached = ((HNBBaseRequest *)self).cachePolicy == HNBRequestCachePriorityPolicy ? YES : NO;
    if(requestCached){
        // 缓存策略 1 存储缓存
        if([self cacheTimeInSeconds] > 0){
            NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:content];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *cacheTime = [NSDate date];
            NSString *strDate = [dateFormatter stringFromDate:cacheTime];
            dic[HNBResponseCacheDate] = strDate;
            if (dic != nil) {
                @try {
                    
                    // New data will always overwrite old data.
                    if([self basePathIsExit]){
                        [dic writeToFile:[self cacheFilePath] atomically:YES];
                    }
                } @catch (NSException *exception) {

                }
            }
            
        }
    }
}

- (void)loadCachedData{
    BOOL requestCached = ((HNBBaseRequest *)self).cachePolicy == HNBRequestCachePriorityPolicy ? YES : NO;
    if(requestCached){
        //缓存策略 2 如果存在缓存，读取缓存数据
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[self cacheFilePath]];
        if(!dic){
            return;
        }
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString *dateStr = mutDict[HNBResponseCacheDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = nil;
        if([dateStr isKindOfClass:[NSString class]]){
            date = [dateFormatter dateFromString:dateStr];
        }
        BOOL cacheTimeOut = NO;
        if(date){
            NSTimeInterval duration = -[date timeIntervalSinceNow];
            //缓存策略 4 缓存时间判断
            if (duration < 0 || duration > [self cacheTimeInSeconds]) {
                cacheTimeOut = YES;
                [self clearCachedData];
                return;
            }else{
                NSMutableDictionary *cachedResponseObject = [NSMutableDictionary dictionaryWithDictionary:dic];
                cachedResponseObject[HNBUsingCacheKey] = @(YES);
                if([self respondsToSelector:@selector(hnbLoadCacheWithData:)]){
                    [self hnbLoadCacheWithData:cachedResponseObject];
                }
            }
        }
    }
}

+ (BOOL)hnbIsUsingCacheData:(NSDictionary *)data{
    BOOL usingCacheData = NO;
    if(data && [data isKindOfClass:[NSDictionary class]]){
        if(data[HNBUsingCacheKey] && ((NSNumber *)(data[HNBUsingCacheKey])).boolValue){
            usingCacheData = YES;
        }
    }
    return usingCacheData;
}

// 缓存策略 3 请求失败或者缓存超时，缓存清除
- (void)clearCachedData{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self cacheFilePath] error:nil];
    
}

- (NSString *)cacheFilePath {
    NSString *cacheFileName = [self cacheFileName];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}

//缓存的基础文件夹
- (NSString *)cacheBasePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:HNBResponsCachePath];
    [self createDirectoryIfNeeded:path];
    return path;
}

- (BOOL)basePathIsExit{
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:HNBResponsCachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    return [fileManager fileExistsAtPath:path isDirectory:&isDir];
}

- (void)createDirectoryIfNeeded:(NSString *)path {
    if (![self basePathIsExit]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                                   attributes:nil error:&error];
    }
}

- (NSString *)cacheFileName {
    NSString *requestUrl = [self hnbApiUrl];
    NSString *baseUrl = [self hnbBaseUrl];
    id argument = self.keyAndVaules;
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld Host:%@ Url:%@ Argument:%@",
                             (long)[self hnbApiMethord], baseUrl, requestUrl, argument];
    NSString *cacheFileName = [HNBBaseRequest md5:requestInfo];
    return cacheFileName;
}

//默认缓存三分钟
- (NSInteger)cacheTimeInSeconds {
    return 60 * 1;
}

#pragma mark -抽象方法，子类可能会覆盖
- (AFHTTPRequestSerializer *)hnbRequestSerializerType{
    return [AFJSONRequestSerializer serializer];
}

//基类方法中默认
- (NSString *)hnbBaseUrl{
    return @"https://www.baidu.com";
}

- (NSString*)hnbApiUrl{
    return @"";
}

- (ApiMethord)hnbApiMethord{
    return APIPost;
}

- (NSInteger)hnbTimeOut{
    return 20;
}

#pragma mark -stop
- (void)stop{
    if(self.task){
        [self.task cancel];
    }
}

@end
