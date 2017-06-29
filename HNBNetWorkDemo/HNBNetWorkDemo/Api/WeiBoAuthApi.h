//
//  WeiBoAuthApi.h
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/28.
//  Copyright © 2017年 开发. All rights reserved.
//

#import <HNBNetWork/HNBNetWork.h>

@interface WeiBoAuthApi : BaseRequest
@property (nonatomic, strong) NSString *client_id;
@property (nonatomic, strong) NSString *client_secret;
@property (nonatomic, strong) NSString *grant_type;
@property (nonatomic, strong) NSString *redirect_uri;
@property (nonatomic, strong) NSString *code;

@end
