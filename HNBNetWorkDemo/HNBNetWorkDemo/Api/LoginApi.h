//
//  LoginApi.h
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/28.
//  Copyright © 2017年 开发. All rights reserved.
//

#import <HNBNetWork/HNBNetWork.h>

@interface LoginApi : BaseRequest
@property (nonatomic,strong) NSString *Account;
@property (nonatomic,strong) NSString *Pwd;

@end
