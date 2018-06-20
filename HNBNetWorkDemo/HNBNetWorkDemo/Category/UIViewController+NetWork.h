//
//  UIViewController+NetWork.h
//  HNBNetWorkDemo
//
//  Created by 程康 on 2018/6/20.
//  Copyright © 2018年 开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NetWork)
@property (nonatomic,strong) NSMutableDictionary<NSNumber *, BaseBusinessRequest *> *requestsRecord;

- (void)stopAllRequest;

- (void)startApi:(BaseBusinessRequest*)api sucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock;
@end
