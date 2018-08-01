//
//  BeiJingTimeApi.m
//  HNBNetWorkDemo
//
//  Created by 程康 on 2017/9/4.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "BeiJingTimeApi.h"

@implementation BeiJingTimeApi

- (NSString *)hnbBaseUrl{
    return @"http://api.k780.com:88";
}

- (NSString*)hnbApiUrl{
    return @"?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json";
}

- (ApiMethord)hnbApiMethord{
    return APIGet;
}

//- (HNBRequestCachePolicy)cachePolicy{
//    return HNBRequestCachePriorityPolicy;
//}

@end
