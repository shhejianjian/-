//
//  XHYWCViewController.m
//  XHZF
//
//  Created by 何键键 on 16/4/1.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHYWCViewController.h"
#import "XHMainOrderViewController.h"
#import "XHOrderTableViewCell.h"
#import "BSHttpTool.h"
#import "XHConst.h"
#import "XHDJDOrder.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "XHReceiver.h"
#import "XHProcess.h"
#import "XHYWCDetailViewController.h"
static NSString *ID=@"xhJdCell";

@interface XHYWCViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLable;
@property (nonatomic, strong) NSMutableArray *YWCOrders;
/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 总数 */
@property (nonatomic, assign) NSInteger  totalCount;

@end

@implementation XHYWCViewController
extern XHMainOrderViewController *sMainOrderVC;

- (NSMutableArray *)YWCOrders
{
    if (!_YWCOrders) {
        _YWCOrders = [[NSMutableArray alloc]init];
    }
    return _YWCOrders;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.myTableView registerNib:[UINib nibWithNibName:@"XHOrderTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.myTableView.mj_header beginRefreshing];

}
- (void)loadNewData
{
    self.currentPage =1;
    [self loadData];
}

- (void)loadMoreData
{
    self.currentPage ++;
    [self loadData];
    [self.myTableView.mj_footer endRefreshing];
}

- (void)loadData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"statusCategory"] = @"3";
    params[@"pageNo"] = [NSString stringWithFormat:@"%d",self.currentPage];
    params[@"pageSize"] = @"5";
    [BSHttpTool get:XHOrderUrl params:params success:^(id json) {
        NSLog(@"已完成%@",json);
        [SVProgressHUD dismiss];
        NSArray *newArr  = [XHDJDOrder mj_objectArrayWithKeyValuesArray:json[@"content"]];
        if (self.currentPage == 1) { // 清除之前的旧数据
            [self.YWCOrders removeAllObjects];
        }
        
        [self.YWCOrders addObjectsFromArray:newArr];
        
        self.totalCount = [json[@"totalElements"] integerValue];
        if (self.YWCOrders.count == 0) {
            self.noDataLable.alpha = 1.0;
        }else{
            self.noDataLable.alpha = 0.0;
        }
        [self.myTableView reloadData];
//        XHLog(@"XHOrderUrlywc%@--%d",json,self.YWCOrders.count);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        XHLog(@"error%@",error);
    }];
    [self.myTableView.mj_header endRefreshing];
    
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.YWCOrders.count == self.totalCount) {
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.myTableView.mj_footer.state = MJRefreshStateIdle;
    }
    return self.YWCOrders.count;
}


- (XHOrderTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XHOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[XHOrderTableViewCell alloc]init];
    }
    cell.Djdorder = self.YWCOrders[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHDJDOrder *YwcOrder = self.YWCOrders[indexPath.row];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    NSString *receiverUrlStr = [NSString stringWithFormat:@"%@/%@",XHArtificerUrl,YwcOrder.receiverId];
    [BSHttpTool get:receiverUrlStr params:nil success:^(id json) {
        XHReceiver *receiver = [XHReceiver mj_objectWithKeyValues:json];
        NSString *processUrlStr = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/process",YwcOrder.workOrderId];
        [BSHttpTool get:processUrlStr params:nil success:^(id json) {
//            NSLog(@"已完成%@",json);
            [SVProgressHUD dismiss];
            NSArray *processes = [XHProcess mj_objectArrayWithKeyValuesArray:json];
            XHYWCDetailViewController *JXZVC = [[XHYWCDetailViewController alloc]init];
            JXZVC.YWCReceiver = receiver;
            JXZVC.YWCProcesses = processes;
            JXZVC.workOrderCode = YwcOrder.workOrderCode;
            JXZVC.receiverId = YwcOrder.receiverId;
            [sMainOrderVC.navigationController pushViewController:JXZVC animated:YES];
            [self.navigationController pushViewController:JXZVC animated:YES];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];

 

}

@end
