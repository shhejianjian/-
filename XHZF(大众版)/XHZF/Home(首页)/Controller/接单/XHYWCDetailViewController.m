//
//  XHYWCDetailViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/5/12.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHYWCDetailViewController.h"
#import "XHReceiver.h"
#import "XHProcess.h"
#import "UIImageView+WebCache.h"
#import "XHConst.h"
#import "XHProcessCell.h"
@interface XHYWCDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *processTableView;
@property (weak, nonatomic) IBOutlet UILabel *workOrderCodeLable;
@property (weak, nonatomic) IBOutlet UIImageView *receiverIcon;
@property (weak, nonatomic) IBOutlet UILabel *receiverName;
@property (weak, nonatomic) IBOutlet UIButton *receiverPhone;
@end

@implementation XHYWCDetailViewController
static NSString *ID=@"YWCProcessCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updataData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)updataData {
    
    self.receiverName.text = self.YWCReceiver.username;
    [self.receiverPhone setTitle:self.YWCReceiver.telephone forState:UIControlStateNormal];
    if (self.YWCReceiver.photo) {
  [self.receiverIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",BaseUrl,XHImageUrl,self.receiverId]] placeholderImage:[UIImage imageNamed:@"receiver_icon"]];
        
    }
    self.processTableView.rowHeight = 100;
    self.processTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.workOrderCodeLable.text = [NSString stringWithFormat:@"工单号:%@",self.workOrderCode];
    self.processTableView.bounces = NO;
    [self.processTableView registerNib:[UINib nibWithNibName:@"XHProcessCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.processTableView reloadData];
}

- (IBAction)btnCallClick:(id)sender {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.YWCReceiver.telephone]]];
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.YWCProcesses.count;
}
- (XHProcessCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHProcessCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[XHProcessCell alloc]init];
    }
    cell.process = self.YWCProcesses[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
