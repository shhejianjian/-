//
//  XHJXZViewController.m
//  XHZF
//
//  Created by 何键键 on 16/4/1.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHJXZViewController.h"
#import "XHMainOrderViewController.h"
#import "XHOrderTableViewCell.h"
#import "BSHttpTool.h"
#import "XHConst.h"
#import "XHDJDOrder.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XHJXZDetailViewController.h"
#import "XHReceiver.h"
#import "XHProcess.h"
#import "SVProgressHUD.h"
static NSString *ID=@"xhJdCell";
extern XHMainOrderViewController *sMainOrderVC;

@interface XHJXZViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noDataLable;
@property (nonatomic, strong) NSMutableArray *JXZOrders;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 总数 */
@property (nonatomic, assign) NSInteger  totalCount;
@end

@implementation XHJXZViewController
- (NSMutableArray *)JXZOrders
{
    if (!_JXZOrders) {
        _JXZOrders = [[NSMutableArray alloc]init];
    }
    return _JXZOrders;
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
    params[@"statusCategory"] = @"2";
    params[@"pageNo"] = [NSString stringWithFormat:@"%d",self.currentPage];
    params[@"pageSize"] = @"5";
    [BSHttpTool get:XHOrderUrl params:params success:^(id json) {
        [SVProgressHUD dismiss];
        NSArray *newArr  = [XHDJDOrder mj_objectArrayWithKeyValuesArray:json[@"content"]];
        if (self.currentPage == 1) { // 清除之前的旧数据
            [self.JXZOrders removeAllObjects];
        }
        
        [self.JXZOrders addObjectsFromArray:newArr];
        
        self.totalCount = [json[@"totalElements"] integerValue];
        if (self.JXZOrders.count == 0) {
            self.noDataLable.alpha = 1.0;
        }else{
            self.noDataLable.alpha = 0.0;
        }
        [self.myTableView reloadData];
        XHLog(@"XHOrderUrl进行中%@",json);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        XHLog(@"error%@",error);
    }];
    [self.myTableView.mj_header endRefreshing];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.JXZOrders.count == self.totalCount) {
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.myTableView.mj_footer.state = MJRefreshStateIdle;
    }
    return self.JXZOrders.count;
}


- (XHOrderTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    XHOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[XHOrderTableViewCell alloc]init];
    }
    cell.Djdorder = self.JXZOrders[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    XHDJDOrder *JxzOrder = self.JXZOrders[indexPath.row];
    NSString *receiverUrlStr = [NSString stringWithFormat:@"%@/%@",XHArtificerUrl,JxzOrder.receiverId];
    [BSHttpTool get:receiverUrlStr params:nil success:^(id json) {
        XHReceiver *receiver = [XHReceiver mj_objectWithKeyValues:json];
        NSString *processUrlStr = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/process",JxzOrder.workOrderId];
        [BSHttpTool get:processUrlStr params:nil success:^(id json) {
            [SVProgressHUD dismiss];
             NSArray *processes = [XHProcess mj_objectArrayWithKeyValuesArray:json];
            XHJXZDetailViewController *JXZVC = [[XHJXZDetailViewController alloc]init];
            JXZVC.JXZReceiver = receiver;
            JXZVC.JXZProcesses = processes;
            JXZVC.workOrderCode = JxzOrder.workOrderCode;
            JXZVC.receiverId = JxzOrder.receiverId;
            [sMainOrderVC.navigationController pushViewController:JXZVC animated:YES];
            [self.navigationController pushViewController:JXZVC animated:YES];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            
        }];

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    
   
}

@end
