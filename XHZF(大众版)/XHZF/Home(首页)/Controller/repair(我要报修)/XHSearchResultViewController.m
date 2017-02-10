//
//  XHSearchResultViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/4/15.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSearchResultViewController.h"
#import "XHSubEquipment.h"
#import "XHDepartment.h"
#import "XHConst.h"
@interface XHSearchResultViewController ()
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation XHSearchResultViewController
- (NSMutableArray *)results
{
    if (!_results) {
        _results = [[NSMutableArray alloc]init];
    }
    return _results;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    }
- (void)setSearchEquipment:(NSString *)searchEquipment
{
    _searchEquipment = searchEquipment;
    [self.results removeAllObjects];
    for (XHSubEquipment *subEquipment in self.searchArr) {
        if ([subEquipment.name containsString:searchEquipment]) {
            [self.results addObject:subEquipment];
        }
    }
    [self.tableView reloadData];
}
- (void)setSearchAddress:(NSString *)searchAddress
{
    _searchAddress = searchAddress;
    [self.results removeAllObjects];
    for (XHDepartment *address in self.searchArr) {
        if ([address.name containsString:searchAddress]) {
            [self.results addObject:address];
        }
    }
    [self.tableView reloadData];


}
- (void)setSearchDepartment:(NSString *)searchDepartment
{
    _searchDepartment = searchDepartment;
    [self.results removeAllObjects];
    for (XHDepartment *department in self.searchArr) {
        if ([department.name containsString:searchDepartment]) {
            [self.results addObject:department];
        }
    }
    [self.tableView reloadData];}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%ld个搜索结果", self.results.count];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (self.searchEquipment) {
        XHSubEquipment *subEquipment = self.results[indexPath.row];
        cell.textLabel.text = subEquipment.name;
    }
    if (self.searchAddress) {
        XHDepartment *address = self.results[indexPath.row];
        cell.textLabel.text = address.name;
    }
    if (self.searchDepartment) {
        XHDepartment *department = self.results[indexPath.row];
        cell.textLabel.text = department.name;
    }

    return cell;
    }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchEquipment) {
        XHSubEquipment *subEquipment = self.searchArr[indexPath.row];
        [XHNotificationCenter
         postNotificationName:XHEquipmentDidChangeNotification object:nil userInfo:@{XHSelectEquipment:subEquipment.name,XHSelectEquipmentObjectId:subEquipment.objectId}];
        [self.navigationController popViewControllerAnimated:YES];
    }
   if (self.searchAddress) {
       XHDepartment *address = self.searchArr[indexPath.row];
        [XHNotificationCenter
         postNotificationName:XHAddressDidChangeNotification object:nil userInfo:@{XHSelectAddress:address.name,XHSelectAddressObjectId:address.objectId}];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.searchDepartment) {
        XHDepartment *department = self.results[indexPath.row];
         [XHNotificationCenter
          postNotificationName:XHDepartmentDidChangeNotification object:nil userInfo:@{XHSelectDepartment:department.name,XHSelectDepartmentObjectId:department.objectId
}];
        [self.navigationController popViewControllerAnimated:YES];
    }
  }

@end
