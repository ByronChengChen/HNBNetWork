//
//  BaseViewController.h
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/30.
//  Copyright © 2017年 开发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HNBNetWork/HNBNetWork.h>

@interface BaseViewController : UIViewController
@property (nonatomic,strong) NSMutableDictionary<NSNumber *, BaseBusinessRequest *> *requestsRecord;

- (void)stopAllRequest;

- (void)startApi:(BaseBusinessRequest*)api sucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock;
@end
