//
//  BeiJingTimeController.m
//  HNBNetWorkDemo
//
//  Created by 程康 on 2017/9/5.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "BeiJingTimeController.h"
#import "BeiJingTimeApi.h"
#import "WeatherApi.h"
#import <AFNetworking/AFNetworking.h>
#import <HNBNetWork/RequestEngine.h>
#import "UIViewController+NetWork.h"

@interface BeiJingTimeController ()<BaseBusinessRequestDelegate>
@property (nonatomic, weak) IBOutlet UILabel *timeLB;
@property (nonatomic, weak) IBOutlet UIButton *requestBtn;
@end

@implementation BeiJingTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAction:(id)sender {
    WeatherApi *weatherApi = [WeatherApi new];
    weatherApi.hnbApiNeedHud = YES;
    weatherApi.delegate = self;
    weatherApi.city = @"北京";
    [self startApi:weatherApi sucessBlock:nil failBlock:nil requestFailBlock:nil];
}

#pragma mark -BaseBusinessRequestDelegate

- (void)showHud{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = @"天气预报信息加载中";
}

@end
