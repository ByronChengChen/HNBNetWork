//
//  WeatherApi.m
//  TestHNBNetWork
//
//  Created by 开发 on 2017/6/29.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "WeatherApi.h"

@implementation WeatherApi

- (NSString *)baseUrl{
    return @"https://www.sojson.com";
}

- (NSString*)apiUrl{
    return @"open/api/weather/json.shtml";
}

- (ApiMethord)apiMethord{
    return APIGet;
}

//- (NSInteger)timeOut{
//    return <#timeOut#>;
//}

@end
