//
//  BigFileUploadController.m
//  HNBNetWorkDemo
//
//  Created by 程康 on 2017/9/8.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "BigFileUploadController.h"
#import "ErrorRecordApi.h"

@interface BigFileUploadController ()

@end

@implementation BigFileUploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadAction:(id)sender {
    ErrorRecordApi *api = [ErrorRecordApi new];
    api.date = @"2017.09.25";
    [self startApi:api sucessBlock:^(id content) {
        
    } failBlock:^(ResponseHead *head) {
        
    } requestFailBlock:^(NSError *error) {
        
    }];
    //TODO: chengk 解决内容较大的异常数据上传
    
}

- (HNBRequestCachePolicy)cachePolicy{
    return HNBRequestCachePriorityPolicy;
}

@end
