//
//  XHDepartmentViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/4/6.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHDepartmentViewController.h"
#import "XHConst.h"
#import "BSHttpTool.h"
#import "SVProgressHUD.h"
#import "XHDepartment.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "UIView+AutoLayout.h"
#import "XHSearchResultViewController.h"
#import "FMDBTool.h"

@interface XHDepartmentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy,nonatomic) NSString *selectedDepartmentName;
@property (nonatomic,strong) NSMutableArray *departments;
@property (nonatomic,strong) NSMutableArray *smallDepartments;
@property (nonatomic,strong) NSMutableArray *subDepartmentNames;
@property (nonatomic,copy) NSString *selectDepartmentStr;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic,strong) XHSearchResultViewController *searchResult;
@property (nonatomic,copy) NSString *objectIdStr;

@end

@implementation XHDepartmentViewController
extern NSString *jsessionid;
- (NSMutableArray *)searchArr
{
    if (!_searchArr) {
        _searchArr = [[NSMutableArray alloc]init];
    }
    return _searchArr;
}
- (XHSearchResultViewController *)searchResult
{
    if (!_searchResult) {
        XHSearchResultViewController *searchResult = [[XHSearchResultViewController alloc] init];
        [self addChildViewController:searchResult];
        self.searchResult = searchResult;
        [self.view addSubview:self.searchResult.view];
        [self.searchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.searchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:0];
    }
    return _searchResult;
}

- (NSMutableArray *)departments
{
    if (!_departments) {
        _departments = [NSMutableArray array];
    }
    return _departments;
}
- (NSMutableArray *)subDepartmentNames
{
    if (!_subDepartmentNames) {
        _subDepartmentNames = [NSMutableArray array];
    }
    return _subDepartmentNames;
}

- (NSMutableArray *)smallDepartments
{
    if (!_smallDepartments) {
        _smallDepartments = [NSMutableArray array];
    }
    return _smallDepartments;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self loadDepartment];
    self.tableView.bounces = NO;
    self.subTableView.showsVerticalScrollIndicator = NO;
}

- (void)loadDepartment
{
    
    self.departments = (NSMutableArray *)[FMDBTool departments];
    //如果有数据，默认选中第一行并请求第一行的数据
    if(self.departments.count>0)
    {
        for (int i = 0; i < self.departments.count; i++) {
            XHDepartment *department = (XHDepartment *)self.departments[i];
            for (int i = 0; i < department.items.count ; i++) {
                XHDepartment *subDepartment = (XHDepartment *)department.items[i];
                for (int i = 0; i < subDepartment.items.count; i ++) {
                    XHDepartment *smallDepartment = (XHDepartment *)subDepartment.items[i];
                    XHDepartment *depart = [[XHDepartment alloc]init];
                    depart.name = [NSString stringWithFormat:@"%@ / %@ / %@",department.name,subDepartment.name,smallDepartment.name];
                    depart.objectId = smallDepartment.objectId;
                    [self.searchArr addObject:depart];
                }
            }
        }
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
    }
    
}
- (void)setupNav
{
    self.navigationItem.title = @"选择报修部门";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

}
- (void)cancle
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finish
{
    if (self.selectDepartmentStr) {
        [XHNotificationCenter
         postNotificationName:XHDepartmentDidChangeNotification object:nil userInfo:@{XHSelectDepartment:self.selectDepartmentStr,XHSelectDepartmentObjectId:self.objectIdStr}];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请先选择保修部门"];
    }
}
#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.departments.count;
    }
    else{
        return self.smallDepartments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    if (tableView == self.tableView) {
        static NSString *mainID=@"main-cell";
        cell = [tableView dequeueReusableCellWithIdentifier:mainID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainID];
        }
        cell.backgroundColor = XHColor(231, 232, 234);
        XHDepartment *department=self.departments[indexPath.row];
        cell.textLabel.text=department.name;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font=[UIFont systemFontOfSize:13];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];

    }else{
        static NSString *subID = @"sub-cell";
        cell = [tableView dequeueReusableCellWithIdentifier:subID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subID];
        }
        XHDepartment *smallDepartment = self.smallDepartments[indexPath.row];
        NSString *subName = self.subDepartmentNames[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@/%@",subName,smallDepartment.name];
        cell.textLabel.font=[UIFont systemFontOfSize:13];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = XHGlobalColor;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView == self.tableView) {
        [self.smallDepartments removeAllObjects];
        [self.subDepartmentNames removeAllObjects];
        self.selectDepartmentStr = nil;
        XHDepartment *department = self.departments[indexPath.row];
        self.selectedDepartmentName = department.name;
        for (XHDepartment *subDepartment in department.items) {
            [self.smallDepartments addObjectsFromArray:subDepartment.items];
            for (XHDepartment *smallDepartment in subDepartment.items) {
             [self.subDepartmentNames addObject:subDepartment.name];
            }
        }
        [self.subTableView reloadData];
    }
    else{
    XHDepartment *smallDepartment = self.smallDepartments[indexPath.row];
    NSString *subName = self.subDepartmentNames[indexPath.row];
    self.selectDepartmentStr = [NSString stringWithFormat:@"%@/%@/%@",self.selectedDepartmentName,subName,smallDepartment.name];
    self.objectIdStr = smallDepartment.objectId;
        }

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        self.searchResult.view.hidden=NO;
    }else{
        self.searchResult.view.hidden=YES;
    }
    self.searchResult.searchArr = self.searchArr;
    self.searchResult.searchDepartment = searchText;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchResult.view.hidden = YES;
}


@end
