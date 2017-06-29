//
//  WeiBoStatusListController.m
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/29.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "WeiBoStatusListController.h"
#import "WeiBoStatusListApi.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "HWAccountTool.h"

@interface WeiBoStatusListController ()
@property (nonatomic, strong) UIButton *btn;
//TODO: chengk BaseViewController 维护一个请求队列，当取消的时候，将所有的请求取消
@property (nonatomic, strong) WeiBoStatusListApi *statusApi;

@end

@implementation WeiBoStatusListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNetWorkRequest)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self loadData];
}

- (void)cancelNetWorkRequest{
    [self.statusApi stop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    WeiBoStatusListApi *statusApi = [WeiBoStatusListApi new];
    HWAccount *account = [HWAccountTool account];
    statusApi.access_token = account.access_token;
    [statusApi startWithSucessBlock:^(id content, ResponseHead *head) {
        
    } failBlock:^(ResponseHead *head) {
        
    } requestFailBlock:^(NSError *error) {
        NSLog(@"statusApi error:%@",error);
    }];
    self.statusApi = statusApi;
}

- (void)dealloc{
    
    NSLog(@"self.statusApi:%@",self.statusApi);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
