//
//  ErrorRecordApi.h
//  HNBNetWorkDemo
//
//  Created by 程康 on 2017/9/6.
//  Copyright © 2017年 开发. All rights reserved.
//

#import <HNBNetWork/HNBNetWork.h>

/**
 *  这里的请求使用的不是 AFJSONResponseSerializer方式，而是AFHTTPRequestSerializer方式
 */
@interface ErrorRecordApi : BaseBusinessRequest
@property (nonatomic, strong) NSString *date;
@end
