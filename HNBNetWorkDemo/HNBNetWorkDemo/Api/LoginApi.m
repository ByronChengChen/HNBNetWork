//
//  LoginApi.m
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/28.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "LoginApi.h"

@implementation LoginApi

- (NSString *)apiUrl{
    return @"mi/account/loginv3";
}

- (ApiMethord)apiMethord{
    return APIPost;
}


@end
