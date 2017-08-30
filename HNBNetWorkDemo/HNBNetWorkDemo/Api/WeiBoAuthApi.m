//
//  WeiBoAuthApi.m
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/28.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "WeiBoAuthApi.h"

@implementation WeiBoAuthApi

- (NSString *)baseUrl{
    return @"https://api.weibo.com";
}

- (NSString*)apiUrl{
    return @"oauth2/access_token";
}

- (ApiMethord)apiMethord{
    return APIPost;
}

//- (NSInteger)timeOut{
//    return <#timeOut#>;
//}

@end
