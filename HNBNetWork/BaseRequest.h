//
//  BaseRequest.h
//  HNBNetWork
//
//  Created by 开发 on 2017/6/27.
//  Copyright © 2017年 开发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNBConstantSymbol.h"

@interface BaseRequest : NSObject
//@property (nonatomic,strong) NSMutableDictionary *params;

- (NSURLSessionTask *)startWithSucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock;

- (NSString *)apiUrl;
- (ApiMethord)apiMethord;
- (NSInteger)timeOut;
- (NSString *)baseUrl;
- (void)stop;

@end
