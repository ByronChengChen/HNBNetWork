//
//  WeatherViewController.m
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/30.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherApi.h"
#import "BeiJingTimeApi.h"


@interface WeatherViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) UILabel *loadResponseDateLB;
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor greenColor];
    
    self.btn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 100, 100, 100);
        [btn setTitle:@"loadData" forState:UIControlStateNormal];
        [self.view addSubview:btn];
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self loadData];
        }];
        btn;
    });
    
    self.loadResponseDateLB = ({
        UILabel *loadResponseDateLB = [UILabel new];
        loadResponseDateLB.frame = CGRectMake(0, 200, 320 , 40);
        [self.view addSubview:loadResponseDateLB];
        loadResponseDateLB;
    });
    
}

- (void)loadData{
    //数据返回成当前时间的数据，不要使用天气数据，测试的现象不明显
    WeatherApi *weatherApi = [WeatherApi new];
    weatherApi.city = @"北京";
    [self startApi:weatherApi sucessBlock:^(NSDictionary *content, ResponseHead *head) {
        [self.btn setTitle:[content[@"status"] stringValue] forState:UIControlStateNormal];
        NSLog(@"self.btn.textChanged");
        NSString *text = [NSString stringWithFormat:@"%@date%@",content[@"city"],content[HNBResponseCacheDate]];
        self.loadResponseDateLB.text = text;
        NSLog(@"text:%@",text);
    } failBlock:^(ResponseHead *head) {
        
    } requestFailBlock:^(NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.btn setTitle:self.status forState:UIControlStateNormal];
    NSLog(@"self.btn.textChanged");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"dealloc");
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
