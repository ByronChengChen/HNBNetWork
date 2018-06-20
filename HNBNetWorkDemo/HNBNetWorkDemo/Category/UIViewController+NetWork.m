//
//  UIViewController+NetWork.m
//  HNBNetWorkDemo
//
//  Created by 程康 on 2018/6/20.
//  Copyright © 2018年 开发. All rights reserved.
//

#import "UIViewController+NetWork.h"
#import <objc/runtime.h>

@interface UIViewController()

@end

@implementation UIViewController (NetWork)

- (void)setRequestsRecord:(id)requestsRecord{
    objc_setAssociatedObject(self, @selector(requestsRecord), requestsRecord, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)requestsRecord{
    NSMutableDictionary *requestsRecord = objc_getAssociatedObject(self, _cmd);
    if(!requestsRecord){
        requestsRecord = [NSMutableDictionary dictionary];
        self.requestsRecord = requestsRecord;
    }
    return requestsRecord;
}

- (void)stopAllRequest{
    NSArray *allKeys = [self.requestsRecord allKeys];
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            HNBBaseRequest *request = self.requestsRecord[key];
            // We are using non-recursive lock.
            // Do not lock `stop`, otherwise deadlock may occur.
            [request stop];
            [self.requestsRecord removeObjectForKey:key];
        }
    }
}

- (void)startApi:(BaseBusinessRequest*)api sucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock{
    __block NSURLSessionTask *task = [api startWithSucessBlock:^(id content) {
        if(successBlock){
            successBlock(content);
        }
        if(![HNBBaseRequest hnbIsUsingCacheData:content]){
            [self requestsRecordRemoveTaskWithId:task.taskIdentifier];
        }
    } failBlock:^(ResponseHead *head) {
        if(failBlock){
            failBlock(head);
        }
        [self requestsRecordRemoveTaskWithId:task.taskIdentifier];
    } requestFailBlock:^(NSError *error) {
        if(requestFailBlock){
            requestFailBlock(error);
        }
        [self requestsRecordRemoveTaskWithId:task.taskIdentifier];
    }];
    self.requestsRecord[@(task.taskIdentifier)] = api;
}

- (void)requestsRecordRemoveTaskWithId:(NSInteger)taskIdentifier{
    [self.requestsRecord removeObjectForKey:@(taskIdentifier)];
}

@end
