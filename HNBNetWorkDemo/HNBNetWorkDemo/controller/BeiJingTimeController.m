//
//  BeiJingTimeController.m
//  HNBNetWorkDemo
//
//  Created by 程康 on 2017/9/5.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "BeiJingTimeController.h"
#import "BeiJingTimeApi.h"

@interface BeiJingTimeController ()
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
    BeiJingTimeApi *api = [BeiJingTimeApi new];
    [self startApi:api sucessBlock:^(id content) {
        self.timeLB.text = content[@"result"][@"datetime_2"];
    } failBlock:^(ResponseHead *head) {
        
    } requestFailBlock:^(NSError *error) {
        
    }];
}

@end
