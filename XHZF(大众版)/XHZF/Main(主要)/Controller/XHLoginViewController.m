//
//  XHLoginViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/3/30.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHLoginViewController.h"
#import "NSString+FontAwesome.h"
#import "XHConst.h"
#import "BSHttpTool.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XHHomeViewController.h"
#import "XHLeftViewController.h"
#import "YRSideViewController.h"
#import "XHLogin.h"
#import "MJExtension.h"
#import "DeformationButton.h"
#import "UIView+Extension.h"
#import "Masonry.h"

#define SCREENWITH   [UIScreen mainScreen].bounds.size.width

@interface XHLoginViewController ()<UITextFieldDelegate>
{
    DeformationButton *_deformationBtn;
}
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *edgeView;


@end

@implementation XHLoginViewController
XHLogin *mLogin;



//NSString *jsessionid;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    [self setupUI];

    // 阴影颜色
    self.edgeView.layer.shadowColor = [UIColor blackColor].CGColor;
    // 阴影偏差
    self.edgeView.layer.shadowOffset = CGSizeMake(0, 1);
    // 阴影不透明度
    self.edgeView.layer.shadowOpacity = 1;
    
    self.navigationController.navigationBarHidden = YES;
    _deformationBtn = [[DeformationButton alloc]initWithFrame:CGRectMake(20, self.edgeView.y + 50, SCREENWITH -20 -20, 40)];

//    NSLog(@"fefess%f",self.edgeView.y);
//    [_deformationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.accountLabel.mas_bottom).offset(100);
//        make.left.mas_equalTo(self.view.mas_left).offset(20);
//        make.right.mas_equalTo(self.view.mas_right).offset(300);
//        make.height.mas_equalTo(80);
//    }];

    _deformationBtn.contentColor = XHGlobalColor;
    _deformationBtn.progressColor = [UIColor whiteColor];
    _deformationBtn.layer.cornerRadius = 5.0f;
    _deformationBtn.layer.masksToBounds = YES;
    [_deformationBtn.forDisplayButton setTitle:@"登录" forState:UIControlStateNormal];
    [_deformationBtn.forDisplayButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_deformationBtn.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deformationBtn.forDisplayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    UIImage *bgImage = [UIImage imageNamed:@"button_bg"];
    [_deformationBtn.forDisplayButton setBackgroundImage:[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    
    [_deformationBtn addTarget:self action:@selector(btnLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deformationBtn];
    
    

    // Do any additional setup after loading the view from its nib.
}
- (void)setupUI
{
    self.accountLabel.font = [UIFont fontWithName:@"Ionicons" size:40];
    self.accountLabel.text = @"\uf47d";
    self.passwordLabel.font = [UIFont fontWithName:@"Ionicons" size:35];
    self.passwordLabel.text = @"\uf4c8";
    self.accountTextField.tintColor = XHGlobalColor;
    self.passwordTextField.tintColor = XHGlobalColor;
}


- (void)btnLoginClick{
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.accountTextField.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
            [_deformationBtn stopLoading];
            return;
        }
        if (self.passwordTextField.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
            [_deformationBtn stopLoading];
            return;
        }
        [self loginWithUsername:self.accountTextField.text Password:self.passwordTextField.text];
    });
}

- (IBAction)btnLoginClick:(UIButton*)sender {
    //  防止连续点击 响应
//    sender.enabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        sender.enabled = YES;
//    });
    
}
- (void)loginWithUsername:(NSString *)username
                 Password:(NSString *)password{
    AFHTTPSessionManager  *manager=[AFHTTPSessionManager  manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"username"] = username;
    params[@"password"] = password;
    [manager POST:XHLoginUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSURLResponse *response = task.response;
        //转换NSURLResponse成为HTTPResponse
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        //获取headerfields
        NSDictionary *fields = [HTTPResponse allHeaderFields];
        if (fields[@"jsessionid"]) {
       XHLogin *login = [XHLogin mj_objectWithKeyValues:fields[@"currentUser"]];
        mLogin = login;
        NSUserDefaults *UserDefaults=[NSUserDefaults standardUserDefaults];
        [UserDefaults setObject:username forKey:@"username"];
        [UserDefaults setObject:password forKey:@"password"];
        [UserDefaults synchronize];
         XHHomeViewController *homeVC=[[XHHomeViewController alloc]init];
         XHLeftViewController *leftVC = [[XHLeftViewController alloc]init];
         YRSideViewController *sideVc = [[YRSideViewController alloc]init];
         sideVc.rootViewController = homeVC;
         sideVc.leftViewController = leftVC;
         sideVc.leftViewShowWidth = [[UIScreen mainScreen] bounds].size.width * 0.8;
        sideVc.needSwipeShowMenu = true;//默认开启的可滑动展示
                        //动画效果可以被自己自定义，具体请看api
        [self.navigationController pushViewController:sideVc animated:YES];
        }
        else {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的用户名或密码"];
                 [_deformationBtn stopLoading];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
        [_deformationBtn stopLoading];
    }];

    }
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
