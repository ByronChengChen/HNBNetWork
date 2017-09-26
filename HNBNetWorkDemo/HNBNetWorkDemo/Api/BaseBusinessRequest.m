//
//  BaseBusinessRequest.m
//  HNBNetWorkDemo
//
//  Created by 程康 on 2017/9/25.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "BaseBusinessRequest.h"

@implementation BaseBusinessRequest
- (NSURLSessionTask *)startWithSucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock{
    self.cacheDataRefreshUiBlock = successBlock;
    NSURLSessionTask *task = nil;
    task = [self hnbStartWithSucessBlock:^(id content) {
        ResponseHead *head = [[ResponseHead alloc] init];
        [head setValuesForKeysWithDictionary:content[@"Head"]];
        if(10000 == head.code || 0 == head.code || (content[@"success"] && [content[@"success"] intValue] == 1)){
            successBlock(content);
        }else{
            failBlock(head);
        }
    } requestFailBlock:^(NSError *error) {
        if(requestFailBlock){
            requestFailBlock(error);
        }
    }];
    return task;
}

- (void)loadCacheWithData:(id)cacheDate{
    if(self.cacheDataRefreshUiBlock){
        NSDictionary *content = (NSDictionary *)cacheDate;
        ResponseHead *head = [[ResponseHead alloc] init];
        [head setValuesForKeysWithDictionary:content[@"Head"]];
        if(0 == head.code || (content[@"success"] && [content[@"success"] intValue] == 1)){
            self.cacheDataRefreshUiBlock(cacheDate);
        }
    }
}

- (void)dealloc{
    LogResponseFuchsia(@"class:%@ dealloc",[self class]);
}

@end
