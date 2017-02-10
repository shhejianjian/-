//
//  XHAddressViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/4/6.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHAddressViewController.h"
#import "XHConst.h"
#import "SVProgressHUD.h"
#import "BSHttpTool.h"
#import "XHDepartment.h"
#import "MJExtension.h"
#import "UIView+AutoLayout.h"
#import "XHSearchResultViewController.h"
#import "FMDBTool.h"

@interface XHAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) NSMutableArray *addresses;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *subAddresses;
@property (nonatomic,copy) NSString *selectedAddressName;
@property (nonatomic,copy) NSString * selectAddressStr;
@property (nonatomic,strong) XHSearchResultViewController *searchResult;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic,copy) NSString *objectIdStr;

@end

@implementation XHAddressViewController
extern NSString *jsessionid;
- (NSMutableArray *)addresses
{
    if (!_addresses) {
        _addresses = [NSMutableArray array];
    }
    return _addresses;
}
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

- (NSMutableArray *)subAddressNames
{
    if (!_subAddresses) {
        _subAddresses = [NSMutableArray array];
    }
    return _subAddresses;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self loadAddress];
    self.tableView.bounces = NO;
    self.subTableView.showsVerticalScrollIndicator = NO;
}
- (void)setupNav
{
    self.navigationItem.title = @"选择维修地址";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
- (void)loadAddress
{
    self.addresses = (NSMutableArray *)[FMDBTool addresses];
    for (XHDepartment *address in self.addresses) {
        for (XHDepartment *subAddress in address.items) {
            XHDepartment *addr = [[XHDepartment alloc]init];
            addr.name = [NSString stringWithFormat:@"%@ / %@",address.name,subAddress.name];
            addr.objectId = subAddress.objectId;
            [self.searchArr addObject:addr];
        }
    }
    [self.tableView reloadData];
    //如果有数据，默认选中第一行并请求第一行的数据
    if(self.addresses.count>0)
    {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
    }

}
- (void)cancle
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finish
{
    if (self.selectAddressStr) {
        [XHNotificationCenter
         postNotificationName:XHAddressDidChangeNotification object:nil userInfo:@{XHSelectAddress:self.selectAddressStr,XHSelectAddressObjectId:self.objectIdStr}];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请先选择维修地址"];
    }
}


#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.addresses.count;
    }
    else{
        return self.subAddressNames.count;
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
        XHDepartment *address=self.addresses[indexPath.row];
        cell.textLabel.text = address.name;
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
        XHDepartment *subAddress = self.subAddresses[indexPath.row];
        cell.textLabel.text = subAddress.name;
        cell.textLabel.font=[UIFont systemFontOfSize:13];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = XHGlobalColor;
    }
    
    return cell;
}
#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView) {
        [self.subAddressNames removeAllObjects];
        self.selectAddressStr = nil;
        XHDepartment *address = self.addresses[indexPath.row];
        self.selectedAddressName = address.name;
        for (XHDepartment *subAddress in address.items) {
            [self.subAddresses addObject:subAddress];
           
        }
        [self.subTableView reloadData];
    }
    else{
        XHDepartment *subAddress = self.subAddresses[indexPath.row];
        self.selectAddressStr = [NSString stringWithFormat:@"%@ / %@",self.selectedAddressName,subAddress.name];
        self.objectIdStr = subAddress.objectId;
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
    self.searchResult.searchAddress = searchText;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchResult.view.hidden = YES;
}


@end
