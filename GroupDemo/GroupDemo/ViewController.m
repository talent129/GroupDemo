//
//  ViewController.m
//  GroupDemo
//
//  Created by iMac on 16/5/5.
//  Copyright © 2016年 Cai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_groups;
    BOOL cls[10];
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor greenColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"friends" ofType:@"plist"];
    self.data = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *groups = [NSMutableArray array];
    for (NSDictionary *dic in self.data) {
        NSString *group = [dic objectForKey:@"group"];
        [groups addObject:group];
    }
    _groups = groups;
    NSLog(@"group--%@", _groups);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!cls[section]) {
        return 0;
    }
    
    NSDictionary *dic = self.data[section];
    NSArray *friends = [dic objectForKey:@"friends"];
    return friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.data[indexPath.section];
    NSArray *friends = [dic objectForKey:@"friends"];
    cell.textLabel.text = friends[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 0, 50);
    btn.tag = section;
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:_groups[section] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"tableCell_common.png"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -256, 0, 0)];
    return btn;
}

- (void)btnClick:(UIButton *)btn
{
    NSInteger section = btn.tag;
    //修改展开或收起的状态
    cls[section] = !cls[section];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
