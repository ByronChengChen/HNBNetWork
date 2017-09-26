//
//  RequestEngine.h
//  Pods
//
//  Created by 开发 on 2017/6/28.
//
//

#import <Foundation/Foundation.h>
#import "HNBConstantSymbol.h"
#import "BaseRequest.h"

@interface RequestEngine : NSObject
+ (instancetype)sharedEngine;

-(NSURLSessionTask *)addRequest:(BaseRequest*)baseRequest
                          successBlock:(NetWorkSuccessBlock)successBlock
                          requestFailBlock:(RequestFailBlock)failBlock;
@end
