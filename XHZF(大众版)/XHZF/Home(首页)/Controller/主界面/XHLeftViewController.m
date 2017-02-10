//
//  XHLeftViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/3/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHLeftViewController.h"
#import "XHLoginViewController.h"
#import "NSString+FontAwesome.h"
#import "XHConst.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "XHLogin.h"
@interface XHLeftViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

@end

@implementation XHLeftViewController
extern XHLogin *mLogin;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.headImageView.layer.cornerRadius = 40.f;
    self.headImageView.layer.masksToBounds = YES;
    self.usernameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.iconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
    self.iconLabel.text = [NSString fontAwesomeIconStringForEnum:FAIconForward];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)btnLoginClick:(id)sender {
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"您确定要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logOff];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (void)logOff
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,XHLogOutUrl];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        XHLoginViewController *loginVc = [[XHLoginViewController alloc]init];
        mLogin = nil;
        [self.navigationController pushViewController:loginVc animated:YES];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"退出失败"];
    }];

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
