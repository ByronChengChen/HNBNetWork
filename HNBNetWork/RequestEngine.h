//
//  RequestEngine.h
//  Pods
//
//  Created by 开发 on 2017/6/28.
//
//

#import <Foundation/Foundation.h>
#import "HNBConstantSymbol.h"
#import "HNBBaseRequest.h"

@interface RequestEngine : NSObject
+ (instancetype)sharedEngine;

-(NSURLSessionTask *)addRequest:(HNBBaseRequest*)baseRequest
                          successBlock:(NetWorkSuccessBlock)successBlock
                          requestFailBlock:(RequestFailBlock)failBlock;
-(NSURLSessionTask *)addRequest:(HNBBaseRequest*)baseRequest
                   responseBlock:(HNBResponseBlock)responseBlock
               requestFailBlock:(RequestFailBlock)failBlock;
@end
