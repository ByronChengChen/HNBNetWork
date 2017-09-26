//
//  BaseViewController.m
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/30.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "BaseViewController.h"
#import <pthread/pthread.h>
#import "NSObject+HNB.h"
#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@interface BaseViewController (){
    pthread_mutex_t _lock;
}
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

- (void)startApi:(BaseBusinessRequest*)api sucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock{
    WS
    __block NSURLSessionTask *task = [api startWithSucessBlock:^(id content) {
        successBlock(content);
        [weakSelf.requestsRecord removeObjectForKey:@(task.taskIdentifier)];
        LogResponseGreen(@"callBack business success weakSelf.requestsRecord:%@ content:%@",weakSelf.requestsRecord,[content jsonString]);
    } failBlock:^(ResponseHead *head) {
        failBlock(head);
        [weakSelf.requestsRecord removeObjectForKey:@(task.taskIdentifier)];
        LogResponseRed(@"callBack business failed weakSelf.requestsRecord:%@ head:%@",weakSelf.requestsRecord,[[head keyAndVaules] jsonString]);
    } requestFailBlock:^(NSError *error) {
        requestFailBlock(error);
        [weakSelf.requestsRecord removeObjectForKey:@(task.taskIdentifier)];
        LogResponseRed(@"callBack netWork failed weakSelf.requestsRecord:%@ error:%@",weakSelf.requestsRecord,error);
    }];
    self.requestsRecord[@(task.taskIdentifier)] = api;
    LogRequestBlue(@"add request weakSelf.requestsRecord:%@",weakSelf.requestsRecord);
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

//TODO: chengk 网络请求 2 http请求头自定义 这里的jsonString方法需要抽出
- (NSString *)jsonString:(NSDictionary*)dict {
    if(!dict)
        return nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) return nil;
    NSString *json = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    return json;
}


@end
