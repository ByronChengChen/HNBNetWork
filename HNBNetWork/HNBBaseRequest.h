//
//  HNBBaseRequest.h
//  HNBNetWork
//  本类处理cache 和 自定义请求参数 header,url,params,timeout等等
//  Created by 开发 on 2017/6/27.
//  Copyright © 2017年 开发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNBConstantSymbol.h"
#import <AFNetworking/AFNetworking.h>
static NSString * const HNBResponseCacheDate = @"HNBResponseCacheDate";
extern NSString * const HNBUsingCacheKey;

typedef NS_ENUM(NSUInteger, HNBRequestCachePolicy) {
    /**
     *  不使用缓存，默认
     */
    HNBRequestNoCachePolicy,
    /**
     *  缓存优先
     */
    HNBRequestCachePriorityPolicy
};

@interface HNBBaseRequest : NSObject
@property (nonatomic, assign) HNBRequestCachePolicy cachePolicy;
@property (nonatomic, strong) NSURLSessionTask *task;
- (NSURLSessionTask *)hnbStartWithSucessBlock:(NetWorkSuccessBlock)successBlock requestFailBlock:(RequestFailBlock)requestFailBlock;

//rquest methord begin
/**
 *  指定http请求头，抽象方法，本类不实现，子类实现
 */
- (NSDictionary *)httpHeaderDict;

/**
 * 对于某些业务，需要在params里面包一层数据，例如需要在请求体里面加上token之类的操作，抽象方法，本类不实现，子类实现
 */
- (NSMutableDictionary *)assembleParams:(NSMutableDictionary*)param;

/**
 *  指定请求的方式，默认请求序列为json
 */
- (AFHTTPRequestSerializer *)hnbRequestSerializerType;

/**
 *  告知如何通过缓存刷新页面，抽象方法
 */
- (void)hnbLoadCacheWithData:(id)cacheDate;
+ (BOOL)hnbIsUsingCacheData:(NSDictionary *)data;

- (NSString *)hnbApiUrl;
- (ApiMethord)hnbApiMethord;
- (NSInteger)hnbTimeOut;
- (NSString *)hnbBaseUrl;
//rquest methord end

- (void)stop;

@end
