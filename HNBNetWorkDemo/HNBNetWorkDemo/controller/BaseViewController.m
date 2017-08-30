//
//  BaseViewController.m
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/30.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "BaseViewController.h"
#import <pthread/pthread.h>
#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@interface BaseViewController (){
    pthread_mutex_t _lock;
}
@property (nonatomic, weak) NSURLSessionTask *task;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestsRecord = [NSMutableDictionary dictionary];
    pthread_mutex_init(&_lock, NULL);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startApi:(BaseRequest*)api sucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock{
    WS
    __block NSURLSessionTask *task = [api startWithSucessBlock:^(id content, ResponseHead *head) {
        successBlock(content,head);
        [weakSelf.requestsRecord removeObjectForKey:@(task.taskIdentifier)];
        LogResponseGreen(@"callBack success weakSelf.requestsRecord:%@",weakSelf.requestsRecord);
    } failBlock:^(ResponseHead *head) {
        failBlock(head);
        [weakSelf.requestsRecord removeObjectForKey:@(task.taskIdentifier)];
        LogResponseRed(@"callBack business failed weakSelf.requestsRecord:%@",weakSelf.requestsRecord);
    } requestFailBlock:^(NSError *error) {
        requestFailBlock(error);
        [weakSelf.requestsRecord removeObjectForKey:@(task.taskIdentifier)];
        LogResponseRed(@"callBack netWork failed weakSelf.requestsRecord:%@",weakSelf.requestsRecord);
    }];
    self.requestsRecord[@(task.taskIdentifier)] = api;
    LogRequestBlue(@"add request weakSelf.requestsRecord:%@",weakSelf.requestsRecord);
    self.task = task;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)stopAllRequest {
    Lock();
    NSArray *allKeys = [_requestsRecord allKeys];
    Unlock();
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            Lock();
            BaseRequest *request = self.requestsRecord[key];
            Unlock();
            // We are using non-recursive lock.
            // Do not lock `stop`, otherwise deadlock may occur.
            [request stop];
            LogYellow(@"before remove one request self.requestsRecord:%@",self.requestsRecord);
            [self.requestsRecord removeObjectForKey:key];
            LogYellow(@"after remove one request self.requestsRecord:%@",self.requestsRecord);
        }
    }
}

- (void)dealloc{
    [self stopAllRequest];
}

@end
