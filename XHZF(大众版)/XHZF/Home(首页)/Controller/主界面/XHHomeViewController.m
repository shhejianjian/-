//
//  XHHomeViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/3/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHHomeViewController.h"
#import "NSString+FontAwesome.h"
#import "QRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XHRepairViewController.h"
#import "XHCleaningViewController.h"
#import "XHDoctorViewController.h"
#import "XHComplainViewController.h"
#import "XHSatisfactionViewController.h"

#import "XHMoreViewController.h"
#import "XHGuardViewController.h"
#import "BFPaperButton.h"
#import "XHMainOrderViewController.h"
#import "BSHttpTool.h"
#import "XHConst.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "XHWeatherAqi.h"
#import "XHWeatherNow.h"
#import "XHWeatherCond.h"
#import "SVProgressHUD.h"
#import "FMDBTool.h"
#import "XHDepartment.h"
#import "XHEquipment.h"
#import "XHSatification.h"
#import "HWSearchBar.h"
#import "UIView+Extension.h"

#define weatherKey @"37a1bf0b5b18444da9196e6f4cf01d59"
#define cityId @"CN101010100"
#define SCREENWITH   [UIScreen mainScreen].bounds.size.width

@interface XHHomeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *doingLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (strong, nonatomic) IBOutlet BFPaperButton *DjdBtn;
@property (weak, nonatomic) IBOutlet BFPaperButton *jxzBtn;
@property (weak, nonatomic) IBOutlet BFPaperButton *ywcBtn;
@property (weak, nonatomic) IBOutlet UILabel *tmpLable;
@property (weak, nonatomic) IBOutlet UILabel *pm25Lable;
@property (weak, nonatomic) IBOutlet UILabel *qltyLable;
@property (weak, nonatomic) IBOutlet UILabel *txtLable;
@property (weak, nonatomic) IBOutlet UILabel *weatherPicLabel;
@property (nonatomic, copy) NSString *weatherStr;

@property (strong, nonatomic) IBOutlet UIButton *cordBtn;


@property (strong, nonatomic) IBOutlet UIButton *repairBtn;
@property (strong, nonatomic) IBOutlet UIButton *cleanBtn;
@property (strong, nonatomic) IBOutlet UIButton *guardBtn;
@property (strong, nonatomic) IBOutlet UIButton *doctorBtn;
@property (strong, nonatomic) IBOutlet UIButton *complaintBtn;
@property (strong, nonatomic) IBOutlet UIButton *satisfyBtn;
@property (strong, nonatomic) IBOutlet UIButton *addMoreBtn;

@property (strong, nonatomic) IBOutlet UIView *topView;




@end

@implementation XHHomeViewController
XHMainOrderViewController *sMainOrderVC;
- (IBAction)btnCodeClick:(id)sender {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        NSBundle *bundle =[NSBundle mainBundle];
        NSDictionary *info =[bundle infoDictionary];
        NSString *prodName =[info objectForKey:@"CFBundleDisplayName"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法打开相机" message:[NSString stringWithFormat:@"请在用户设置->隐私->相机->%@ 开启相机使用权限",prodName] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else {
        QRCodeScanViewController *qrVC = [[QRCodeScanViewController alloc]initWithNibName:@"QRCodeScanViewController" bundle:nil];
        [self.navigationController pushViewController:qrVC animated:YES];
    }
    NSLog(@"二维码");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self updateWeather];
    [self loadData];
    
    
    
    
}
- (void)loadData
{
    
    if ([FMDBTool departments].count == 0) {
        
        [BSHttpTool get:XHDepartmentUrl params:nil success:^(id json) {
            
            NSArray *arr = [XHDepartment mj_objectArrayWithKeyValuesArray:json];
            
            for (XHDepartment *department in arr) {
                [FMDBTool addDepartment:department];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
        }];
    }
    if ([FMDBTool equipments].count == 0) {
        
        [BSHttpTool get:XHEquipmentUrl params:nil success:^(id json) {
            XHLog(@"设备%@",json);
            NSArray *arr = [XHEquipment mj_objectArrayWithKeyValuesArray:json];
            
            for (XHEquipment *equipment in arr) {
                [FMDBTool addEquipment:equipment];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
        }];
    }
    if ([FMDBTool addresses].count == 0) {
        
        [BSHttpTool get:XHBuildingUrl params:nil success:^(id json) {
            
            NSArray *arr = [XHDepartment mj_objectArrayWithKeyValuesArray:json];
            
            for (XHDepartment *address in arr) {
                [FMDBTool addAddress:address];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
        }];
    }

    
}

- (void)updateWeather
{
    NSString *dateStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"date"];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *nowStr = [dateFormatter stringFromDate:now];
    if ([nowStr isEqualToString:dateStr]) {
        self.txtLable.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"txt"];
        self.tmpLable.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"tmp"];
        self.qltyLable.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"qlty"];
        self.pm25Lable.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"pm25"];
        [self setWeatherPic:[[NSUserDefaults standardUserDefaults]objectForKey:@"txt"]];
           }else{
        [self getWeatherData];
    }
}
- (void)getWeatherData
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSString *weatherUrlStr = [NSString stringWithFormat:@"%@?cityid=%@&key=%@",XHWeatherUrl,cityId,weatherKey];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript",@"text/plain", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:weatherUrlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        XHWeatherNow *weatherNow = [XHWeatherNow mj_objectWithKeyValues:responseObject[@"HeWeather data service 3.0"][0][@"now"]];
        XHWeatherAqi *weatherAqi = [XHWeatherAqi mj_objectWithKeyValues:responseObject[@"HeWeather data service 3.0"][0][@"aqi"][@"city"]];
        XHWeatherCond *weatherCond = weatherNow.cond;
        self.tmpLable.text = [NSString stringWithFormat:@"%@°",weatherNow.tmp];
        self.pm25Lable.text = weatherAqi.pm25;
        self.qltyLable.text = weatherAqi.qlty;
        self.txtLable.text = weatherCond.txt;
        [self setWeatherPic:weatherCond.txt];

        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        [[NSUserDefaults standardUserDefaults]setObject:[dateFormatter stringFromDate:now] forKey:@"date"];
        [[NSUserDefaults standardUserDefaults]setObject:self.txtLable.text forKey:@"txt"];
        [[NSUserDefaults standardUserDefaults]setObject:self.tmpLable.text forKey:@"tmp"];
        [[NSUserDefaults standardUserDefaults]setObject:self.pm25Lable.text forKey:@"pm25"];
        [[NSUserDefaults standardUserDefaults]setObject:self.qltyLable.text forKey:@"qlty"];
        [[NSUserDefaults standardUserDefaults]synchronize];

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        XHLog(@"error%@",error);
            }];


}
- (void)setWeatherPic:(NSString *)weatherStr
{
    self.weatherPicLabel.font = [UIFont fontWithName:@"WeatherIcons-Regular" size:40];
    if ([weatherStr isEqualToString:@"晴"]) {
        self.weatherPicLabel.text = @"\uf00d";
    }else if([weatherStr isEqualToString:@"多云"]){
        self.weatherPicLabel.text = @"\uf013";

    }else if([weatherStr isEqualToString:@"少云"]){
        self.weatherPicLabel.text = @"\uf041";

    }else if([weatherStr isEqualToString:@"晴间多云"]){
        self.weatherPicLabel.text = @"\uf002";

    }else if([weatherStr isEqualToString:@"阴"]){
        self.weatherPicLabel.text = @"\uf06e";

    }else if([weatherStr isEqualToString:@"有风"]||[weatherStr isEqualToString:@"微风"]||[weatherStr isEqualToString:@"和风"]||[weatherStr isEqualToString:@"清风"]){
        self.weatherPicLabel.text = @"\uf001";

    }else if([weatherStr isEqualToString:@"疾风"]||[weatherStr isEqualToString:@"大风"]||[weatherStr isEqualToString:@"烈风"]){
        self.weatherPicLabel.text = @"\uf000";

    }else if([weatherStr isEqualToString:@"风暴"]||[weatherStr isEqualToString:@"狂爆风"]||[weatherStr isEqualToString:@"飓风"]){
        self.weatherPicLabel.text = @"\uf073";

    }else if([weatherStr isEqualToString:@"龙卷风"]||[weatherStr isEqualToString:@"热带风暴"]){
        self.weatherPicLabel.text = @"\uf056";

    }else if([weatherStr isEqualToString:@"阵雨"]){
        self.weatherPicLabel.text = @"\uf008";

    }else if([weatherStr isEqualToString:@"强阵雨"]){
        self.weatherPicLabel.text = @"\uf009";

    }else if([weatherStr isEqualToString:@"雷阵雨"]||[weatherStr isEqualToString:@"强雷阵雨"]){
        self.weatherPicLabel.text = @"\uf010";

    }else if([weatherStr isEqualToString:@"雷阵雨伴有冰雹"]){
        self.weatherPicLabel.text = @"\uf01d";

    }else if([weatherStr isEqualToString:@"小雨"]||[weatherStr isEqualToString:@"中雨"]){
        self.weatherPicLabel.text = @"\uf019";

    }else if([weatherStr isEqualToString:@"大雨"]||[weatherStr isEqualToString:@"暴雨"]||[weatherStr isEqualToString:@"大暴雨"]||[weatherStr isEqualToString:@"特大暴雨"]){
        self.weatherPicLabel.text = @"\uf01a";

    }else if([weatherStr isEqualToString:@"冻雨"]){
        self.weatherPicLabel.text = @"\uf004";

    }else if([weatherStr isEqualToString:@"小雪"]||[weatherStr isEqualToString:@"中雪"]||[weatherStr isEqualToString:@"大雪"]||[weatherStr isEqualToString:@"暴雪"]){
        self.weatherPicLabel.text = @"\uf01b";

    }else if([weatherStr isEqualToString:@"雨夹雪"]||[weatherStr isEqualToString:@"雨雪天气"]||[weatherStr isEqualToString:@"阵雨夹雪"]||[weatherStr isEqualToString:@"阵雪"]){
        self.weatherPicLabel.text = @"\uf0b5";
        
    }else if([weatherStr isEqualToString:@"薄雾"]||[weatherStr isEqualToString:@"雾"]){
        self.weatherPicLabel.text = @"\uf014";
        
    }else if([weatherStr isEqualToString:@"霾"]){
        self.weatherPicLabel.text = @"\uf0b6";
        
    }else if([weatherStr isEqualToString:@"扬沙"]||[weatherStr isEqualToString:@"浮尘"]){
        self.weatherPicLabel.text = @"\uf063";
        
    }else if([weatherStr isEqualToString:@"沙尘暴"]||[weatherStr isEqualToString:@"强沙尘暴"]){
        self.weatherPicLabel.text = @"\uf082";
        
    } else{
     self.weatherPicLabel.text = @"\uf07b";
    }
    
    

}
- (void)setupUI
{
    
    //报修
    self.repairBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:40];
    [self.repairBtn setTitle:@"\uf1ed" forState:UIControlStateNormal];
    [self.repairBtn setTitleColor:XHRepairColor forState:UIControlStateNormal];
    //保洁
    self.cleanBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:50];
    [self.cleanBtn setTitle:@"\uf154" forState:UIControlStateNormal];
    [self.cleanBtn setTitleColor:XHCleanColor forState:UIControlStateNormal];
    //保安
    self.guardBtn.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:40];
    [self.guardBtn setTitle:@"\uf21b" forState:UIControlStateNormal];
    [self.guardBtn setTitleColor:XHGuardColor forState:UIControlStateNormal];
    //导医
    self.doctorBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:45];
    [self.doctorBtn setTitle:@"\uf1a6" forState:UIControlStateNormal];
    [self.doctorBtn setTitleColor:XHDoctorColor forState:UIControlStateNormal];
    //投诉
    self.complaintBtn.titleLabel.font = [UIFont fontWithName:@"Ionicons" size:45];
    [self.complaintBtn setTitle:@"\uf4ef" forState:UIControlStateNormal];
    [self.complaintBtn setTitleColor:XHComplaintColor forState:UIControlStateNormal];
    //满意度
    self.satisfyBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:45];
    [self.satisfyBtn setTitle:@"\uf168" forState:UIControlStateNormal];
    [self.satisfyBtn setTitleColor:XHSatisfyColor forState:UIControlStateNormal];
    //更多
    self.addMoreBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:60];
    [self.addMoreBtn setTitle:@"\uf278" forState:UIControlStateNormal];
    [self.addMoreBtn setTitleColor:XHMoreColor forState:UIControlStateNormal];
    
    
    
    HWSearchBar *search = [[HWSearchBar alloc]initWithFrame:CGRectMake(self.mySearchBar.x, self.topView.height/2-10, SCREENWITH-40, self.mySearchBar.height)];
    [search setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [search setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
//    search.userInteractionEnabled = NO;
    search.delegate = self;
    search.rightView = self.cordBtn;
    search.rightViewMode = UITextFieldViewModeAlways;

    [self.view addSubview:search];
    
//    self.cordBtn.frame = CGRectMake(self.mySearchBar.width-50, self.mySearchBar.y+10, 25, 25);
//    [self.view addSubview:self.cordBtn];
//
    
    self.cordBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
    [self.cordBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconQrcode] forState:UIControlStateNormal];
    self.pm25Lable.layer.cornerRadius = 10.0f;
    self.pm25Lable.layer.masksToBounds = YES;
    
    self.orderLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
    self.orderLabel.text = [NSString fontAwesomeIconStringForEnum:FAIconWrench];
    self.doingLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
    self.doingLabel.text = [NSString fontAwesomeIconStringForEnum:FAIconWarningSign];
    self.finishLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
    self.finishLabel.text = [NSString fontAwesomeIconStringForEnum:FAIconCheck];
    
    
    self.DjdBtn.tapCircleDiameter = 100;
    self.DjdBtn.tapCircleColor = [UIColor colorWithRed:0.3 green:0 blue:0.3 alpha:0.2];
    self.DjdBtn.usesSmartColor = NO;
    self.DjdBtn.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    self.DjdBtn.shadowColor = [UIColor clearColor];
    
    self.jxzBtn.tapCircleDiameter = 100;
    self.jxzBtn.tapCircleColor = [UIColor colorWithRed:0.3 green:0 blue:0.3 alpha:0.2];
    self.jxzBtn.usesSmartColor = NO;
    self.jxzBtn.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    self.jxzBtn.shadowColor = [UIColor clearColor];
    
    self.ywcBtn.tapCircleDiameter = 100;
    self.ywcBtn.tapCircleColor = [UIColor colorWithRed:0.3 green:0 blue:0.3 alpha:0.2];
    self.ywcBtn.usesSmartColor = NO;
    self.ywcBtn.tapCircleDiameter = bfPaperButton_tapCircleDiameterFull;
    self.ywcBtn.shadowColor = [UIColor clearColor];

    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (IBAction)btnRepairClick:(id)sender {
    XHRepairViewController *repairVc = [[XHRepairViewController alloc]init];
    [self.navigationController pushViewController:repairVc animated:YES];
}
- (IBAction)btnCleaningClick:(id)sender {
    XHCleaningViewController *cleaningVc = [[XHCleaningViewController alloc]init];
    [self.navigationController pushViewController:cleaningVc animated:YES];
}
- (IBAction)btnGuardClick:(id)sender {
    XHGuardViewController *guardVc = [[XHGuardViewController alloc]init];
    [self.navigationController pushViewController:guardVc animated:YES];

}
- (IBAction)btnDoctorClick:(id)sender {
    XHDoctorViewController *doctorVc = [[XHDoctorViewController alloc]init];
    [self.navigationController pushViewController:doctorVc animated:YES];
    
}
- (IBAction)btnComplainClick:(id)sender {
    XHComplainViewController *complainVc = [[XHComplainViewController alloc]init];
    [self.navigationController pushViewController:complainVc animated:YES];
    
}
- (IBAction)btnSatisfactionClick:(id)sender {
    [BSHttpTool get:XHSatisfactionUrl params:nil success:^(id json) {
        NSString *result = json[@"result"];
        if (result.intValue == 1) {
        XHSatisfactionViewController *satisfactionVc = [[XHSatisfactionViewController alloc]init];
        satisfactionVc.satisArr = [XHSatification mj_objectArrayWithKeyValuesArray:json[@"assess"][@"contents"]];
        satisfactionVc.satisObjectId = json[@"assess"][@"objectId"];
         [self.navigationController pushViewController:satisfactionVc animated:YES];
        }else if(result.intValue == 0){
        [SVProgressHUD showErrorWithStatus:@"仅限护士长于月末填写满意度调查"];
        }else{
        [SVProgressHUD showSuccessWithStatus:@"本月满意度调查已完成"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
    }];

    }
- (IBAction)btnMoreClick:(id)sender {
    [SVProgressHUD showInfoWithStatus:@"敬请期待"];
}
- (IBAction)btnDjdClick:(id)sender {
    XHMainOrderViewController *mainOrderVC = [[XHMainOrderViewController alloc]init];
    mainOrderVC.willIndex = 0;
    sMainOrderVC = mainOrderVC;

    [self.navigationController pushViewController:mainOrderVC animated:YES];
}
- (IBAction)btnJxzClick:(id)sender {
    XHMainOrderViewController *mainOrderVC = [[XHMainOrderViewController alloc]init];
    mainOrderVC.willIndex = 1;
    sMainOrderVC = mainOrderVC;

    [self.navigationController pushViewController:mainOrderVC animated:YES];
}
- (IBAction)btnYwcClick:(id)sender {
    XHMainOrderViewController *mainOrderVC = [[XHMainOrderViewController alloc]init];
    mainOrderVC.willIndex = 2;
    sMainOrderVC = mainOrderVC;
    [self.navigationController pushViewController:mainOrderVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
@end
