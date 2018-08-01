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
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    //!!!: chengk info 使用 netWorkManager taskid不同，测试没问题
#if 0
    NSString *timeUrl = @"http://api.k780.com:88/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json";
    NSDictionary *timeParams = @{};
    NSURLSessionTask *timeTask = [[RequestEngine sharedEngine] netWorkManager:manager getUrl:timeUrl params:timeParams success:nil failure:nil];
    NSLog(@"timeTask:%@",timeTask);
    NSString *weatherUrl = @"https://www.sojson.com/open/api/weather/json.shtml";
    NSDictionary *weatherParams = @{@"city":@"北京"};
    NSURLSessionTask *weatherTask = [[RequestEngine sharedEngine] netWorkManager:manager getUrl:weatherUrl params:weatherParams success:nil failure:nil];
    NSLog(@"weatherTask:%@",weatherTask);
#endif
    
    
    BeiJingTimeApi *api = [BeiJingTimeApi new];
    api.hnbApiNeedHud = YES;
    api.delegate = self;
    [self startApi:api sucessBlock:nil failBlock:nil requestFailBlock:nil];
//    NSURLSessionTask *task1 = [api startWithSucessBlock:^(id content) {
//
//    } failBlock:^(ResponseHead *head) {
//
//    } requestFailBlock:^(NSError *error) {
//
//    }];
//    NSLog(@"time task1:%@",task1);

    WeatherApi *weatherApi = [WeatherApi new];
//    weatherApi.hnbApiNeedHud = YES;
//    weatherApi.delegate = self;
    weatherApi.city = @"北京";
    [self startApi:weatherApi sucessBlock:nil failBlock:nil requestFailBlock:nil];
//    NSURLSessionTask *task2 = [weatherApi startWithSucessBlock:^(id content) {
////        NSLog(@"weather content:%@",content);
//    } failBlock:^(ResponseHead *head) {
//
//    } requestFailBlock:^(NSError *error) {
//
//    }];
//    NSLog(@"weather task2:%@",task2);
//    [task2 cancel];
//    NSLog(@"weather task2:%@",task2);
//}
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    for (int i = 0; i<5; i++) {
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
//        NSString *url = @"http://api.k780.com:88/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json";
//        NSDictionary *params = @{};
//        NSURLSessionTask *task = [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        }];
//        NSLog(@"netWorkManager get task.taskIdentifier:%ld",task.taskIdentifier);
//    }
}

#pragma mark -BaseBusinessRequestDelegate

- (void)showHud{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = @"天气预报信息加载中";
}

@end
