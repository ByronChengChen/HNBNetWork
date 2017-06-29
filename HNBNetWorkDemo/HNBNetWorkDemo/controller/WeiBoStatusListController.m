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
@property (nonatomic, strong) WeiBoStatusListApi *statusApi;

@end

@implementation WeiBoStatusListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 100, 100, 100);
        [self.view addSubview:btn];
        [btn setTitle:@"click" forState:UIControlStateNormal];
        btn;
    });
//
//    
    self.view.backgroundColor = [UIColor greenColor];
    self.navigationController.navigationBar.hidden = NO;
    [[self.navigationController rac_signalForSelector:@selector(popViewControllerAnimated:)] subscribeNext:^(RACTuple * _Nullable x) {
        [self.statusApi stop];
    }];
    [self loadData];
}

- (void)loadData{
    WeiBoStatusListApi *statusApi = [WeiBoStatusListApi new];
    HWAccount *account = [HWAccountTool account];
    statusApi.access_token = account.access_token;
    [statusApi startWithSucessBlock:^(id content, ResponseHead *head) {
        
    } failBlock:^(ResponseHead *head) {
        
    } requestFailBlock:^(NSError *error) {
        
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
