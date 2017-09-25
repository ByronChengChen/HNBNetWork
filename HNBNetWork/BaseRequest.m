//
//  BaseRequest.m
//  HNBNetWork
//
//  Created by 开发 on 2017/6/27.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "BaseRequest.h"
#import "RequestEngine.h"
#import "NSObject+HNB.h"
#import <CommonCrypto/CommonDigest.h>

static NSString * const HNBResponsCachePath = @"HNBResponsCachePath";


@interface BaseRequest()
@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation BaseRequest

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

- (BaseRequest *)init{
    if(self == [super init]){
        self.cachePolicy = HNBRequestNoCachePolicy;
    }
    return self;
}

//基类方法中默认
- (NSString *)baseUrl{
    return @"https://www.baidu.com";
}

- (NSString*)apiUrl{
    return @"";
}

- (ApiMethord)apiMethord{
    return APIPost;
}

- (NSInteger)timeOut{
    return 20;
}

- (NSURLSessionTask *)startWithSucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock{
    NSURLSessionTask *task = nil;
    [self loadCachedDataIfNeedWithSuccessBlock:successBlock failBlock:failBlock];
    task = [[RequestEngine sharedEngine] addRequest:self successBlock:^(NSDictionary *content) {
        //TODO: chengk 未来这里提供一个对外方法，用来验证业务请求成功
        ResponseHead *head = [[ResponseHead alloc] init];
        [head setValuesForKeysWithDictionary:content[@"Head"]];
        if(0 == head.code || (content[@"success"] && [content[@"success"] intValue] == 1)){
            successBlock(content,head);
        }else{
            failBlock(head);
        }
        [self saveCacheWithContent:content];
    }  requestFailBlock:^(NSError *error){
        [self clearCachedData];
        requestFailBlock(error);
    }];
    self.task = task;
    return task;
}

- (void)stop{
    if(self.task){
        [self.task cancel];
    }
}

- (void)saveCacheWithContent:(NSDictionary *)content{
    BOOL requestCached = ((BaseRequest *)self).cachePolicy == HNBRequestCachePriorityPolicy ? YES : NO;
    if(requestCached){
        // 缓存策略 1 存储缓存
        if([self cacheTimeInSeconds] > 0){
            NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:content];
            NSDate *cacheTime = [NSDate date];
            dic[HNBResponseCacheDate] = cacheTime;
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

- (void)loadCachedDataIfNeedWithSuccessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock{
    BOOL requestCached = ((BaseRequest *)self).cachePolicy == HNBRequestCachePriorityPolicy ? YES : NO;
    if(requestCached){
        //缓存策略 2 如果存在缓存，读取缓存数据
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[self cacheFilePath]];
        if(!dic){
            return;
        }
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSDate *date = mutDict[HNBResponseCacheDate];
        BOOL cacheTimeOut = NO;
        if(date){
            NSTimeInterval duration = -[date timeIntervalSinceNow];
            //缓存策略 4 缓存时间判断
            if (duration < 0 || duration > [self cacheTimeInSeconds]) {
                cacheTimeOut = YES;
                [self clearCachedData];
                return;
            }
        }
        
        ResponseHead *head = [[ResponseHead alloc] init];
        NSDictionary *cachedResponseObject = dic;
        [head setValuesForKeysWithDictionary:cachedResponseObject[@"Head"]];
        if(0 == head.code || (cachedResponseObject[@"success"] && [cachedResponseObject[@"success"] intValue] == 1)){
            successBlock(cachedResponseObject,head);
        }else{
            failBlock(head);
        }
    }
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
    NSString *requestUrl = [self apiUrl];
    NSString *baseUrl = [self baseUrl];
    id argument = self.keyAndVaules;
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld Host:%@ Url:%@ Argument:%@",
                             (long)[self apiMethord], baseUrl, requestUrl, argument];
    NSString *cacheFileName = [BaseRequest md5:requestInfo];
    return cacheFileName;
}

//默认缓存三分钟
- (NSInteger)cacheTimeInSeconds {
    return 60 * 1;
}

- (AFHTTPRequestSerializer *)hnbRequestSerializerType{
    return [AFJSONRequestSerializer serializer];
}

@end
