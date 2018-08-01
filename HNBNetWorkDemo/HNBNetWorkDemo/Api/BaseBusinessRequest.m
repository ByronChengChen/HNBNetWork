//
//  BaseBusinessRequest.m
//  HNBNetWorkDemo
//
//  Created by 程康 on 2017/9/25.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "BaseBusinessRequest.h"

@implementation ResponseHead
@end

@interface BaseBusinessRequest()
@end

@implementation BaseBusinessRequest
- (NSURLSessionTask *)startWithSucessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock requestFailBlock:(RequestFailBlock)requestFailBlock{
    self.cacheDataRefreshUiBlock = successBlock;
    NSURLSessionTask *task = nil;
    self.hnbApiNeedHud == NO ? : [self showHud];
    task = [self hnbStartWithSucessBlock:^(id content) {
        [self hideHud];
        ResponseHead *head = [self commonHeadWithContent:content];
        if(![self isBusinessErrorWithContent:content]){
            successBlock(content);
        }else{
            [self showBusinessErrorWithHeader:head];
            failBlock(head);
        }
    } requestFailBlock:^(NSError *error) {
        [self hideHud];
        [self showNetWorkError:error];
        if(requestFailBlock){
            requestFailBlock(error);
        }
    }];
    return task;
}

- (ResponseHead *)commonHeadWithContent:(NSDictionary *)content{
    ResponseHead *head = [[ResponseHead alloc] init];
    head.code = ((NSNumber *)(content[@"status"])).intValue;
    head.msg = content[@"message"];
    return head;
}

- (BOOL)isBusinessErrorWithContent:(NSDictionary*)content{
    BOOL error = NO;
    ResponseHead *head = [self commonHeadWithContent:content];
    if(head.code != 200){
        error = YES;
    }
    return error;
}

- (void)hnbLoadCacheWithData:(id)cacheDate{
    if(self.cacheDataRefreshUiBlock){
        NSDictionary *content = (NSDictionary *)cacheDate;
        if(![self isBusinessErrorWithContent:content]){
            self.cacheDataRefreshUiBlock(cacheDate);
        }
    }
}

- (void)showHud{
    if([self.delegate respondsToSelector:@selector(showHud)]){
        [self.delegate showHud];
    }else{
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
}

- (void)hideHud{
    if([self.delegate respondsToSelector:@selector(hideHud)]){
        [self.delegate hideHud];
    }else{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }

}

- (void)showBusinessErrorWithHeader:(ResponseHead *)header{
    if([self.delegate respondsToSelector:@selector(showBusinessErrorWithHeader:api:)]){
        [self.delegate showBusinessErrorWithHeader:header api:self];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.label.text = header.msg;
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:3];
    }
}

- (void)showNetWorkError:(NSError *)error{
    
}

- (void)dealloc{
    LogResponseFuchsia(@"class:%@ dealloc",[self class]);
}

@end
