//
//  ErrorRecordApi.m
//  HNBNetWorkDemo
//
//  Created by 程康 on 2017/9/6.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "ErrorRecordApi.h"

@implementation ErrorRecordApi

- (NSString *)baseUrl{
    return @"https://openapi.hanabi.com";
}

- (NSString *)apiUrl{
    return @"Log/Log/Write";
}

- (ApiMethord )apiMethord{
    return APIPost;
}

- (NSDictionary *)httpHeaderDict{
    return @{@"Logger":@"Hanabi_IOS_trace"};
}

- (AFHTTPRequestSerializer *)hnbRequestSerializerType{
    return [AFHTTPRequestSerializer serializer];
}

@end
