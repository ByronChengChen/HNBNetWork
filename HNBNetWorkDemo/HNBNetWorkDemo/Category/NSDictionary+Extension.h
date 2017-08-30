//
//  NSDictionary+Extension.h
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/30.
//  Copyright © 2017年 开发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

/**
 *  将字典转换为json
 */
- (NSString *)jsonString;

- (id)df_objectForKey:(id)key;

+ (NSMutableArray *)removeNullFromArray:(NSArray *)arr;
// 删除Dictionary中的NSNull
+ (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic;

@end
