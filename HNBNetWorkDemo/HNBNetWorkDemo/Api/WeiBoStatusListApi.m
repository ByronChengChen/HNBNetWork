//
//  WeiBoStatusListApi.m
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/29.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "WeiBoStatusListApi.h"

@implementation WeiBoStatusListApi

- (NSString *)baseUrl{
    return @"https://api.weibo.com";
}

- (NSString*)apiUrl{
    return @"2/statuses/friends_timeline.json";
}

- (ApiMethord)apiMethord{
    return APIGet;
}

//- (NSInteger)timeOut{
//    return <#timeOut#>;
//}

@end
