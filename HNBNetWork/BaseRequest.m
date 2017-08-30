//
//  BaseRequest.m
//  HNBNetWork
//
//  Created by 开发 on 2017/6/27.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "BaseRequest.h"
#import "RequestEngine.h"

@interface BaseRequest()
@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation BaseRequest

//基类方法中默认
- (NSString *)baseUrl{
    return @"https://mi.rongzi.com";
}

- (NSString*)apiUrl{
    return @"";
}

- (ApiMethord)apiMethord{
    return APIPost;
}

- (NSInteger)timeOut{
    return 20;
}

- (NSURLSessionTask *)startWithSucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock{
    NSURLSessionTask *task = nil;
    task = [[RequestEngine sharedEngine] addRequest:self successBlock:^(NSDictionary *content) {
        ResponseHead *head = [[ResponseHead alloc] init];
        [head setValuesForKeysWithDictionary:content[@"Head"]];
        if(0 == head.code){
            successBlock(content,head);
        }else{
            failBlock(head);
        }
    }  requestFailBlock:requestFailBlock];
    self.task = task;
    return task;
}

- (void)stop{
    if(self.task){
        [self.task cancel];
    }
}

@end
