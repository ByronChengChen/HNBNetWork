//
//  BaseRequest.h
//  HNBNetWork
//
//  Created by 开发 on 2017/6/27.
//  Copyright © 2017年 开发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNBConstantSymbol.h"
#import <AFNetworking/AFNetworking.h>
static NSString * const HNBResponseCacheDate = @"HNBResponseCacheDate";

typedef NS_ENUM(NSUInteger, HNBRequestCachePolicy) {
    /**
     *  不适用缓存，默认
     */
    HNBRequestNoCachePolicy,
    /**
     *  缓存优先
     */
    HNBRequestCachePriorityPolicy
};

@interface BaseRequest : NSObject
//@property (nonatomic,strong) NSMutableDictionary *params;
@property (nonatomic, assign) HNBRequestCachePolicy cachePolicy;

- (NSURLSessionTask *)startWithSucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock;
//指定请求的方式，默认请求序列为json
- (AFHTTPRequestSerializer *)hnbRequestSerializerType;
- (NSDictionary *)httpHeaderDict;

- (NSString *)apiUrl;
- (ApiMethord)apiMethord;
- (NSInteger)timeOut;
- (NSString *)baseUrl;
- (void)stop;

@end
