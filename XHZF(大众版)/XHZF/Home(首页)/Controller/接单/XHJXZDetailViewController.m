//
//  XHJXZDetailViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/5/12.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHJXZDetailViewController.h"
#import "XHReceiver.h"
#import "XHProcess.h"
#import "UIImageView+WebCache.h"
#import "XHConst.h"
#import "XHProcessCell.h"
@interface XHJXZDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *processTableView;
@property (weak, nonatomic) IBOutlet UILabel *workOrderCodeLable;
@property (weak, nonatomic) IBOutlet UIImageView *receiverIcon;
@property (weak, nonatomic) IBOutlet UILabel *receiverName;
@property (weak, nonatomic) IBOutlet UIButton *receiverPhone;

@end

@implementation XHJXZDetailViewController
static NSString *ID=@"JXZProcessCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updataData];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)btnCallClick:(id)sender {
    NSLog(@"btnCallClick");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.JXZReceiver.telephone]]];
}

- (void)updataData {
    
    self.receiverName.text = self.JXZReceiver.username;
    [self.receiverPhone setTitle:self.JXZReceiver.telephone forState:UIControlStateNormal];
    if (self.JXZReceiver.photo) {
        [self.receiverIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",BaseUrl,XHImageUrl,self.receiverId]] placeholderImage:[UIImage imageNamed:@"receiver_icon"]];
     }
    
    
    self.processTableView.rowHeight = 100;
    self.processTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.workOrderCodeLable.text = [NSString stringWithFormat:@"工单号:%@",self.workOrderCode];
    self.processTableView.bounces = NO;
    
    
    [self.processTableView registerNib:[UINib nibWithNibName:@"XHProcessCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.processTableView reloadData];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.JXZProcesses.count;
}
- (XHProcessCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHProcessCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[XHProcessCell alloc]init];
    }
    cell.process = self.JXZProcesses[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
