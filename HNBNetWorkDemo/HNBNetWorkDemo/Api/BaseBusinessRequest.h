//
//  BaseBusinessRequest.h
//  HNBNetWorkDemo
//
//  Created by 程康 on 2017/9/25.
//  Copyright © 2017年 开发. All rights reserved.
//

#import <HNBNetWork/HNBNetWork.h>
typedef void(^SuccessBlock)(id content);
typedef void(^FailBlock)(ResponseHead *head);

@interface BaseBusinessRequest : BaseRequest
- (NSURLSessionTask *)startWithSucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock;
//告诉ui该如何加载缓存
@property (nonatomic,copy) SuccessBlock cacheDataRefreshUiBlock;
@end
