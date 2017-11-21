//
//  ViewController.m
//  IndexViewDemo
//
//  Created by 张桂杨 on 2017/11/21.
//  Copyright © 2017年 DD. All rights reserved.
//

#import "ViewController.h"
#import "DDIndexView.h"
@interface ViewController ()<DDIndexViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)  DDIndexView *indexView;
@property (nonatomic, assign) CGPoint startContentOffset;
@end

@implementation ViewController
#pragma mark - overwrite
#pragma mark ---UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    _indexView = [[DDIndexView alloc] init];
    
    _indexView.delegate = self;
    [self.view addSubview:_indexView];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _startContentOffset = self.tableView.contentOffset;
}

#pragma mark - deleagte
#pragma mark ---DDIndexViewDelegate
- (NSArray <NSString *>*)titlesForIndexView:(DDIndexView *)indexView {
    return @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
}

- (void)indexView:(DDIndexView *)indexView didSelectedIndex:(NSInteger)index complete:(void (^)(NSInteger finalSelectedIndex))complete {
    if (index >=0 && index < _tableView.numberOfSections) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    CGPoint p = CGPointMake(0, _tableView.contentOffset.y - _startContentOffset.y);
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    complete(indexPath.section);
}

#pragma mark ---UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%td--%td",indexPath.section,indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 9;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @(section).stringValue;
}
#pragma mark ---UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint p = CGPointMake(0, scrollView.contentOffset.y - _startContentOffset.y);
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    [_indexView updateSelectedIndex:indexPath.section];
}

#pragma mark - setter && getter
- (UITableView *)tableView {
    if (!_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = 120;
    }
    return _tableView;
}
@end

