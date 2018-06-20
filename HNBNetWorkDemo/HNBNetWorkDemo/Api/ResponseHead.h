//
//  ResponseHead.h
//  Pods
//
//  Created by 开发 on 2017/6/28.
//
//

#import <Foundation/Foundation.h>

@interface ResponseHead : NSObject

/**
 *  ret返回0代表接口调用成功，再处理content，否则接口调用失败，直接给予msg提示。如需要特殊处理，ret还是为0，但是需要和服务端协商code码处理特殊逻辑
 */
@property (nonatomic, assign) NSInteger ret;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;

@end
