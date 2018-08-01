//
//  BaseBusinessRequest.h
//  HNBNetWorkDemo
//
//  Created by 程康 on 2017/9/25.
//  Copyright © 2017年 开发. All rights reserved.
//

#import <HNBNetWork/HNBNetWork.h>

@interface ResponseHead : NSObject

/**
 *  ret返回0代表接口调用成功，再处理content，否则接口调用失败，直接给予msg提示。如需要特殊处理，ret还是为0，但是需要和服务端协商code码处理特殊逻辑
 */
@property (nonatomic, assign) NSInteger ret;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;

@end

typedef void(^SuccessBlock)(id content);
typedef void(^FailBlock)(ResponseHead *head);

@class BaseBusinessRequest;
@protocol BaseBusinessRequestDelegate <NSObject>
@optional
- (void)showHud;
- (void)hideHud;
- (void)showBusinessErrorWithHeader:(ResponseHead *)header api:(BaseBusinessRequest *)api;
@end

/**
 1 请求业务错误的逻辑处理
 2 hud处理控制
 */
@interface BaseBusinessRequest : HNBBaseRequest
@property (nonatomic, assign) BOOL hnbApiNeedHud;
- (NSURLSessionTask *)startWithSucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock;
//告诉ui该如何加载缓存
@property (nonatomic,copy) SuccessBlock cacheDataRefreshUiBlock;
@property (nonatomic, weak) id <BaseBusinessRequestDelegate> delegate;
@end
