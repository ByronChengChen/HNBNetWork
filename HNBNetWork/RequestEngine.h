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
                          successBlock:(IdBlock)successBlock
                          requestFailBlock:(RequestFailBlock)failBlock;
/**
 * 每个公司组织请求的方式可能有不同，在这个方法中重写一下，改成豆瓣的
 */
//TODO: chengk 完成后，将这个改成豆瓣的
- (NSMutableDictionary *)assembleParams:(NSMutableDictionary*)param;
@end
