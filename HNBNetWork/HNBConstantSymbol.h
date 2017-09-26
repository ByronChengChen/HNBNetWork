//
//  HNBConstantSymbol.h
//  Pods
//
//  Created by 开发 on 2017/6/28.
//
//

#ifndef HNBConstantSymbol_h
#define HNBConstantSymbol_h
#import <Foundation/Foundation.h>
#import "ResponseHead.h"

static NSString * const HNBConstantToken = @"HNBConstantToken";
static NSString * const HNBConstantSession = @"HNBConstantSession";
static NSString * const HNBConstantCookie = @"HNBConstantCookie";

typedef NS_ENUM(NSUInteger, ApiMethord) {
    /**
     *  get
     */
    APIGet,
    /**
     *  post
     */
    APIPost
};
typedef void(^NetWorkSuccessBlock)(id content);
typedef void(^RequestFailBlock)(NSError *error);

#endif /* HNBConstantSymbol_h */
