//
//  ViewController.m
//  HNBNetWorkDemo
//
//  Created by 开发 on 2017/6/27.
//  Copyright © 2017年 开发. All rights reserved.
//

#import "ViewController.h"
#import "WeatherViewController.h"
#import "BeiJingTimeController.h"

typedef NS_ENUM(NSUInteger, CellType) {
    CellTypeList = 1
};

static NSString * const g_CellId = @"g_CellId";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - UIScrollViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //返回type的最后一个类型
    CellType type = CellTypeList;
    return type;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:g_CellId];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:g_CellId];
    }
    CellType type = indexPath.row + 1;
    switch (type) {
        case CellTypeList:{
            cell.textLabel.text = @"CellTypeList";
        }
               default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CellType type = indexPath.row + 1;
    switch (type) {
        case CellTypeList:{
//            WeatherViewController *vc = [WeatherViewController new];
            BeiJingTimeController *vc = [BeiJingTimeController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



@end
