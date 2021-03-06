//
//  WeatherApi.m
//  TestHNBNetWork
//
//  Created by 开发 on 2017/6/29.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "WeatherApi.h"

@implementation WeatherApi

- (NSString *)hnbBaseUrl{
    return @"https://www.sojson.com";
}

- (NSString*)hnbApiUrl{
    return @"open/api/weather/json.shtml";
}

- (ApiMethord)hnbApiMethord{
    return APIGet;
}

- (HNBRequestCachePolicy)cachePolicy{
    return HNBRequestCachePriorityPolicy;
}

@end
