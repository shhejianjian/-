//
//  XHDJDViewController.m
//  XHZF
//
//  Created by 何键键 on 16/4/1.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHDJDViewController.h"
#import "XHMainOrderViewController.h"
#import "XHOrderTableViewCell.h"
#import "XHConst.h"
#import "BSHttpTool.h"
#import "XHDJDOrder.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"

static NSString *ID=@"xhJdCell";
@interface XHDJDViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *DjdOrders;
/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 总数 */
@property (nonatomic, assign) NSInteger  totalCount;
@property (weak, nonatomic) IBOutlet UILabel *noDataLable;


@end

@implementation XHDJDViewController
- (NSMutableArray *)DjdOrders
{
    if (!_DjdOrders) {
        _DjdOrders = [NSMutableArray array];
    }
    return _DjdOrders;
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
    NSLog(@"self.currentPage%d",self.currentPage);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"statusCategory"] = @"1";
    params[@"pageNo"] = [NSString stringWithFormat:@"%d",self.currentPage];
    params[@"pageSize"] = @"5";
    [BSHttpTool get:XHOrderUrl params:params success:^(id json) {
        [SVProgressHUD dismiss];
        NSArray *newArr  = [XHDJDOrder mj_objectArrayWithKeyValuesArray:json[@"content"]];
       if (self.currentPage == 1) { // 清除之前的旧数据
           [self.DjdOrders removeAllObjects];
       }
       [self.DjdOrders addObjectsFromArray:newArr];
       self.totalCount = [json[@"totalElements"] integerValue];
       if (self.DjdOrders.count == 0) {
           self.noDataLable.alpha = 1.0;
       }else{
           self.noDataLable.alpha = 0.0;
       }
        [self.myTableView reloadData];
      XHLog(@"XHOrderUrl待接单%@",json);
    } failure:^(NSError *error) {
        XHLog(@"error%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    [self.myTableView.mj_header endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.DjdOrders.count == self.totalCount) {
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.myTableView.mj_footer.state = MJRefreshStateIdle;
}
       return self.DjdOrders.count;
}


- (XHOrderTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XHOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[XHOrderTableViewCell alloc]init];
    }
    cell.Djdorder = self.DjdOrders[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"11");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
