//
//  NSObject+HNB.m
//  Pods
//
//  Created by 开发 on 2017/6/28.
//
//

#import "NSObject+HNB.h"
#import <objc/runtime.h>

@implementation NSObject (HNB)
/* 获取对象的所有属性和属性内容 */
- (NSDictionary *)keyAndVaules {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties =class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}
@end
