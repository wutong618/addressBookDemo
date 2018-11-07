//
//  ViewController.m
//  AddressBookDemo
//
//  Created by 吴桐 on 2018/11/7.
//  Copyright © 2018年 cowlevel. All rights reserved.
//

#import "ViewController.h"
#import "ZPMAddressBookService.h"
#import "ZPMAddressBookModel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ZPMAddressBookService sharedAddressBookService]getAddressBookWithSucc:^(NSArray *addressArray) {
        self.dataArray = addressArray;
        [self.tableView reloadData];
        
    } andFailed:^(id sender) {
        
    }];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"addressbookCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"addressbookCell"];
    }
    ZPMAddressBookModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.trueName;
    NSDictionary *dic = model.contactList[0];
    cell.detailTextLabel.text = dic[@"contact"];
    return cell;
}


@end
