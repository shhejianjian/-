//
//  XHRepairViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/3/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHRepairViewController.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "XHFirstTableViewCell.h"
#import "XHSecondTableViewCell.h"
#import "XHConst.h"
#import "takePhoto.h"
//#import "JTMaterialSwitch.h"
#import "XHEquipmentViewController.h"
#import "XYPickerView.h"
#import "XHAddressViewController.h"
#import "XHDepartmentViewController.h"
#import "XHDisposalViewController.h"
#import "XHVideoViewController.h"
#import "BSHttpTool.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "XHDepartment.h"
#import "XHFaultType.h"
#import "XHSubFaultType.h"
#import "XHSmallFaultType.h"
#import "XHSubSmallFaultType.h"
#import "XHDisposal.h"
#import "AFNetworking.h"
#import "XHSubEquipment.h"
#import "XHDepartment.h"
#import "XHDisposal.h"
#import "XHFaultType.h"
#import "IQKeyboardManager.h"
#import "XHLogin.h"
#import "XHAttachment.h"
static NSString *identifier1 = @"cell1";
static NSString *identifier2 = @"cell2";
@interface XHRepairViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,XHDisposalViewControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UISwitch *rightSwitch;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *firstArray;
@property(nonatomic, strong)NSMutableArray *sectionArray;//section标题
@property(nonatomic, strong)NSMutableArray *rowInSectionArray;//section中的cell个数
@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击
@property(nonatomic, strong)NSMutableArray *categoryArray;
@property (weak, nonatomic) IBOutlet UIButton *vedioButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (nonatomic,strong) NSMutableArray *departments;
@property (nonatomic, strong) NSMutableArray *faultTypes;

@property (nonatomic, strong) NSString *departmentObjectId;
@property (nonatomic, strong) NSString *addressObjectId;
@property (nonatomic, strong) NSString *equipmentObjectId;
@property (nonatomic, strong) NSString *faultTypeObjectId;
@property (nonatomic, strong) NSString *wayObjectId;
@property (nonatomic, strong) NSString *timeObjectId;
@property (nonatomic, strong) NSString *extentObjectId;
@property (nonatomic ,strong) NSMutableArray *ways;
@property (nonatomic ,strong) NSMutableArray *times;
@property (nonatomic ,strong) NSMutableArray *extents;
@property (nonatomic, strong) NSMutableArray *attachmentPhotos;
@property (nonatomic, strong) NSMutableArray *attachmentVedios;
@property (nonatomic, strong) NSMutableArray *attachments;

@end

@implementation XHRepairViewController
extern XHLogin *mLogin;
//extern NSString *jsessionid;
- (NSMutableArray *)attachmentPhotos
{
    if (!_attachmentPhotos) {
        _attachmentPhotos = [[NSMutableArray alloc]init];
    }
    return _attachmentPhotos;
}
- (NSMutableArray *)faultTypes
{
    if (!_faultTypes) {
        _faultTypes = [NSMutableArray array];
    }
    return _faultTypes;
}
- (NSMutableArray *)departments
{
    if (!_departments) {
        _departments = [NSMutableArray array];
    }
    return _departments;
}

- (NSMutableArray *)firstArray
{
    if (!_firstArray) {
        _firstArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    }
    return _firstArray;
}
- (NSMutableArray *)ways
{
    if (!_ways) {
        _ways = [NSMutableArray array];
    }
    return _ways;
}
- (NSMutableArray *)times
{
    if (!_times) {
        _times = [NSMutableArray array];
    }
    return _times;
}
- (NSMutableArray *)extents
{
    if (!_extents) {
        _extents = [NSMutableArray array];
    }
    return _extents;
}
- (NSMutableArray *)attachments
{
    if (!_attachments) {
        _attachments = [[NSMutableArray alloc]init];
    }
    return _attachments;
}
- (NSMutableArray *)attachmentVedios
{
    if (!_attachmentVedios) {
        _attachmentVedios = [[NSMutableArray alloc]init];
    }
    return _attachmentVedios;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupOther];
    [self setupNotification];
    [self loadDisposalData];
    [self setupUI];
        }
- (void)setupUI
{
    self.phoneButton.layer.cornerRadius = 20.0f;
    self.vedioButton.layer.cornerRadius = 20.0f;
    self.phoneButton.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:35];
    [self.phoneButton setTitle:@"\uf28c" forState:UIControlStateNormal];
    [self.phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.phoneButton.backgroundColor = XHPhoneColor;
    self.vedioButton.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:40];
    [self.vedioButton setTitle:@"\uf2e0" forState:UIControlStateNormal];
    [self.vedioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.vedioButton.backgroundColor = XHVideoColor;

}
- (void)setupNav
{
    self.navigationItem.title = @"我要报修";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)setupOther
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    self.rowInSectionArray = [NSMutableArray arrayWithObjects:@"5",@"1", nil];//每个分区中cell的个数
    self.selectedArray = [NSMutableArray arrayWithObjects:@"0",@"1", nil];//这个用于判断展开还是缩回当前section的cell
    self.categoryArray = [NSMutableArray arrayWithObjects:@"请选择待维修的设备",@"故障类型",@"维修地址",@"报修部门",@"处理方式", nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"XHFirstTableViewCell" bundle:nil] forCellReuseIdentifier:identifier1];
    [self.tableView registerNib:[UINib nibWithNibName:@"XHSecondTableViewCell" bundle:nil] forCellReuseIdentifier:identifier2];
    
    //键盘处理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;

}
- (void)setupNotification
{
    //监听报修部门改变
    [XHNotificationCenter addObserver:self selector:@selector(departmentDidChange:) name:XHDepartmentDidChangeNotification object:nil];
    //监听维修地址改变
    [XHNotificationCenter addObserver:self selector:@selector(addressDidChange:) name:XHAddressDidChangeNotification object:nil];
    //监听设备改变改变
    [XHNotificationCenter addObserver:self selector:@selector(equipmentDidChange:) name:XHEquipmentDidChangeNotification object:nil];
}
- (void)departmentDidChange:(NSNotification *)notification
{
    self.firstArray[3] = notification.userInfo[XHSelectDepartment];
    self.departmentObjectId = notification.userInfo[XHSelectDepartmentObjectId];
    [self.tableView reloadData];
}
- (void)addressDidChange:(NSNotification *)notification
{
    self.firstArray[2] = notification.userInfo[XHSelectAddress];
    self.addressObjectId = notification.userInfo[XHSelectAddressObjectId];
    [self.tableView reloadData];
}
- (void)equipmentDidChange:(NSNotification *)notification
{
    self.firstArray[0] = notification.userInfo[XHSelectEquipment];
    self.categoryArray[0] = @"";
    self.firstArray[1] = @"";
    self.equipmentObjectId = notification.userInfo[XHSelectEquipmentObjectId];
    [self.tableView reloadData];
}
- (void)cancle
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finish
{
    if (!self.rightSwitch.isOn) {
        XHSecondTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        if (cell.textView.text.length != 0) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定下单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alertView show];
           
                   }else{
            [SVProgressHUD showErrorWithStatus:@"请填写报修说明"];
        }
        
    }else{
        if (self.equipmentObjectId.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择待维修的设备"];
            return;
        }
        if (self.faultTypeObjectId.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择故障类型"];
            return;
        }
        if (self.addressObjectId.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择维修地址"];
            return;
        }
        if (self.departmentObjectId.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择报修部门"];
            return;
        }
        if (self.wayObjectId.length == 0 || self.timeObjectId.length==0 || self.extentObjectId.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择处理方式"];
            return;
        }
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定下单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alertView show];
    }
}

- (void)loadDisposalData
{
     [BSHttpTool get:XHWayUrl params:nil success:^(id json) {
        self.ways = [XHDisposal mj_objectArrayWithKeyValuesArray:json];
        [BSHttpTool get:XHTimeUrl params:nil success:^(id json) {
            self.times = [XHDisposal mj_objectArrayWithKeyValuesArray:json];
            [BSHttpTool get:XHEmergencyUrl params:nil success:^(id json) {
                
                self.extents = [XHDisposal mj_objectArrayWithKeyValuesArray:json];
                XHDisposal *wayDisposal = self.ways[0];
                XHDisposal *extentDisposal = self.extents[0];
                XHDisposal *timeDisposal = self.times[0];
                self.wayObjectId = wayDisposal.objectId;
                self.timeObjectId = timeDisposal.objectId;
                self.extentObjectId = extentDisposal.objectId;
                self.firstArray[4] = [NSString stringWithFormat:@"%@/%@/%@",wayDisposal.name,timeDisposal.name,extentDisposal.name];
                [self.tableView reloadData];
                
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
            }];

        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
        }];

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
    }];
    
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    XHSecondTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    if (buttonIndex == 1) {
        if (!self.rightSwitch.isOn) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"description"] = cell.textView.text;
            if (self.attachmentPhotos.count > 0 || self.attachmentVedios.count > 0) {
                if (self.attachmentPhotos.count > 0) {
                    for (NSString *filename in self.attachmentPhotos) {
                        XHAttachment *attach = [[XHAttachment alloc]init];
                        attach.type = @"Picture";
                        attach.filename = filename;
                        [self.attachments addObject:attach.mj_keyValues];
                    }
                }
                if (self.attachmentVedios.count > 0) {
                    for (NSString *filename in self.attachmentVedios) {
                        XHAttachment *attach = [[XHAttachment alloc]init];
                        attach.type = @"Vedio";
                        attach.filename = filename;
                        [self.attachments addObject:attach.mj_keyValues];
                    }
                    
                }
                params[@"attachmentList"] = self.attachments;
            }            [BSHttpTool post:XHQuickWorkOrderUrl params:params success:^(id json) {
                [SVProgressHUD showSuccessWithStatus:@"下单成功"];
        [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"下单失败"];
            }];
        }else{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            XHDisposal *equipment = [[XHDisposal alloc]init];
            equipment.objectId = self.equipmentObjectId;
            params[@"equipment"] = equipment.mj_keyValues;
            
            XHDisposal *faultType = [[XHDisposal alloc]init];
            faultType.objectId = self.faultTypeObjectId;
            params[@"faultType"] = faultType.mj_keyValues;
            
            XHDisposal *address = [[XHDisposal alloc]init];
            address.objectId = self.addressObjectId;
            params[@"building"] = address.mj_keyValues;

            XHDisposal *department = [[XHDisposal alloc]init];
            department.objectId = self.departmentObjectId;
            params[@"requestDepartment"] = department.mj_keyValues;
            
            XHDisposal *way = [[XHDisposal alloc]init];
            way.objectId = self.wayObjectId;
            params[@"processingMode"] = way.mj_keyValues;
            
            XHDisposal *time = [[XHDisposal alloc]init];
            time.objectId = self.timeObjectId;
            params[@"processingTimeLimit"] = time.mj_keyValues;
            
            XHDisposal *extent = [[XHDisposal alloc]init];
            extent.objectId = self.extentObjectId;
            params[@"emergencyDegree"] = extent.mj_keyValues;
            
            XHDisposal *source = [[XHDisposal alloc]init];
            source.tag = @"App";
            params[@"source"] = source.mj_keyValues;
            
            params[@"requestUserNo"] = mLogin.account;
            params[@"requestUser"] = mLogin.username;
            params[@"description"] = cell.textView.text;
            
            UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
            NSString *strTime = [NSString stringWithFormat:@"%llu",recordTime];
            params[@"requestTime"] = strTime;
            if (self.attachmentPhotos.count > 0 || self.attachmentVedios.count > 0) {
                if (self.attachmentPhotos.count > 0) {
                    for (NSString *filename in self.attachmentPhotos) {
                        XHAttachment *attach = [[XHAttachment alloc]init];
                        attach.type = @"Picture";
                        attach.filename = filename;
                        [self.attachments addObject:attach.mj_keyValues];
                    }
                }
                if (self.attachmentVedios.count > 0) {
                    for (NSString *filename in self.attachmentVedios) {
                        XHAttachment *attach = [[XHAttachment alloc]init];
                        attach.type = @"Vedio";
                        attach.filename = filename;
                        [self.attachments addObject:attach.mj_keyValues];
                    }
                    
                }
                params[@"attachmentList"] = self.attachments;
            }
           
            AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,XHWorkOrderUrl];
            [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                [SVProgressHUD showSuccessWithStatus:@"下单成功"];
                [self.navigationController popViewControllerAnimated:YES];

            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:@"下单失败"];
            }];

        }
    }
}
#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.selectedArray[section] isEqualToString:@"1"])
    {
        return [self.rowInSectionArray[section] integerValue];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
       XHFirstTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!firstCell) {
        firstCell = [[XHFirstTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
                    }
        firstCell.contentLabel.text = self.firstArray[indexPath.row];
        if (indexPath.row == 0) {
            firstCell.logoLabel.hidden = NO;
            firstCell.repairLabel.hidden = NO;
            firstCell.repairLabel.text = self.categoryArray[indexPath.row];
            firstCell.categoryLabel.hidden = YES;

        }else{
            firstCell.logoLabel.hidden = YES;
            firstCell.repairLabel.hidden = YES;
            firstCell.categoryLabel.hidden = NO;
            firstCell.categoryLabel.text = self.categoryArray[indexPath.row];
        }
        cell = firstCell;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       
    } else {
        XHSecondTableViewCell *secondCell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!secondCell) {
            secondCell = [[XHSecondTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        }
        cell = secondCell;
        self.indexPath = indexPath;
    }
       return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80;
        } else {
            return 44;
        }
    } else if (indexPath.section == 1) {
        return self.view.bounds.size.height - 120 - 64 -2*40;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    sectionView.backgroundColor = XHColor(250, 250, 255);
    UIButton *sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sectionButton.frame = CGRectMake(10, 0, self.view.width -10, 40);
       sectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (section == 0) {
        self.rightSwitch = [[UISwitch alloc]init];
        self.rightSwitch.onTintColor = XHGlobalColor;
        self.rightSwitch.center = CGPointMake(self.view.width - 30, 20);
        if ([self.selectedArray[0] isEqualToString:@"1"]){
            [self.rightSwitch setOn:YES animated:NO];
        }else{
            [self.rightSwitch setOn:NO animated:NO];
        }
         [sectionView addSubview:self.rightSwitch];
         [sectionButton setTitle:@"详情模式" forState:UIControlStateNormal];
        }else{
            
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - 30, 5, 30, 30)];
         self.rightImageView.image = [UIImage imageNamed:@"ic_arrow_right.png"];
         self.rightImageView.transform = CGAffineTransformMakeRotation((90 * M_PI) / 180.0f);
        [sectionView addSubview:self.rightImageView];
        [sectionButton setTitle:@"报修说明" forState:UIControlStateNormal];
            
         }
        [sectionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sectionButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        sectionButton.tag = section;
        [sectionView addSubview:sectionButton];
          return sectionView;
}
-(void)btnClick:(UIButton *)button
{
    if (button.tag == 0) {
        if ([self.selectedArray[button.tag] isEqualToString:@"1"]) {
                self.selectedArray[button.tag] = @"0";
        }else{
            self.selectedArray[button.tag] = @"1";
                   }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationFade];

        if ([self.selectedArray[0] isEqualToString:@"1"])
        [self.rightSwitch setOn:YES animated:YES];

    }else{
        if ([self.selectedArray[button.tag] isEqualToString:@"1"]) {
            self.selectedArray[button.tag] = @"0";
        }else{
            self.selectedArray[button.tag] = @"1";
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationFade];
        if ([self.selectedArray[1] isEqualToString:@"1"])
            [UIView animateWithDuration:0.5 animations:^{
                self.rightImageView.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);}];
        else{
         [UIView animateWithDuration:0.5 animations:^{
             [UIView animateWithDuration:0.5 animations:^{
                 self.rightImageView.transform = CGAffineTransformMakeRotation((0 * M_PI) / 180.0f);}];
         }];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                XHEquipmentViewController *equipVC = [[XHEquipmentViewController alloc]init];
                [self.navigationController pushViewController:equipVC animated:YES];
            }
                break;
            case 1:
            {
        if (self.equipmentObjectId) {
            NSString *urlStr = [NSString stringWithFormat:@"api/v1/hems/equipment/%@/faultType",self.equipmentObjectId];
            [BSHttpTool get:urlStr params:nil success:^(id json) {
             self.faultTypes = [XHFaultType mj_objectArrayWithKeyValuesArray:json];
             NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (XHFaultType *faultType in self.faultTypes) {
                            [arr addObject:faultType.name];
                        }
            if (arr.count) {
            XYPickerView * pickerView = [[XYPickerView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-250, self.view.bounds.size.width, 200) DataArr:arr];
            pickerView.title = @"选择故障类型";
            [pickerView showPickerView];
            pickerView.returnPickerStrBlock = ^(NSString *pickerStr){
                            self.firstArray[1] = pickerStr;
                for (XHFaultType *faultType in self.faultTypes) {
                    if ([faultType.name isEqualToString:pickerStr]) {
                        self.faultTypeObjectId = faultType.objectId;
                    }
                }
                [self.tableView reloadData];
                            };
                        }else{
            [SVProgressHUD showErrorWithStatus:@"所选设备故障类型未录入"];
                        }
                    } failure:^(NSError *error) {
                        XHLog(@"error%@",error);
                    }];

                }else{
                    [SVProgressHUD showErrorWithStatus:@"请先选择待维修设备"];
                
                }
                           }
                break;
            case 2:
               
            {
                XHAddressViewController *addressVC = [[XHAddressViewController alloc]init];
                [self.navigationController pushViewController:addressVC animated:YES];
            }
                break;
            case 3:
                
            {
                XHDepartmentViewController *departmentVC = [[XHDepartmentViewController alloc]init];
                [self.navigationController pushViewController:departmentVC animated:YES];
            }
                break;
            case 4:
            {
                XHDisposalViewController *disposalVC = [[XHDisposalViewController alloc]init];
                disposalVC.ways = self.ways;
                disposalVC.extents = self.extents;
                disposalVC.times = self.times;
                disposalVC.delegate = self;
                disposalVC.originalStr = self.firstArray[4];
                [self.navigationController pushViewController:disposalVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)disposalViewControllerSureButtonDidClick:(XHDisposalViewController *)disposalVC Way:(XHDisposal *)wayDisposal time:(XHDisposal *)timeDisposal extent:(XHDisposal *)extentDisposal
{
    
    self.firstArray[4] = [NSString stringWithFormat:@"%@/%@/%@",wayDisposal.name,timeDisposal.name,extentDisposal.name];
    XHLog(@"%@--%@--%@",wayDisposal.objectId,timeDisposal.objectId,extentDisposal.objectId);
    self.extentObjectId = extentDisposal.objectId;
    self.timeObjectId = timeDisposal.objectId;
    self.wayObjectId = wayDisposal.objectId;
    [self.tableView reloadData];
}
- (IBAction)btnTakePhoneClick:(id)sender {
    [takePhoto sharePicture:^(UIImage *image) {
        // 1.请求管理者
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,XHAttachmentUrl];
        
        // 2.发送请求
        [mgr POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            // 拼接文件数据
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            [formData appendPartWithFileData:data name:@"attachment" fileName:@"att.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            [self.attachmentPhotos addObject:responseObject[@"tempFilename"]];
            NSLog(@"上传成功%@",responseObject[@"tempFilename"]);
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }];

    }];
}
- (IBAction)btnVedioClick:(id)sender {
    XHVideoViewController *videoVC = [[XHVideoViewController alloc]init];
    videoVC.returnFileNameBlock = ^(NSString *fileName){
    };
    [self.navigationController pushViewController:videoVC animated:YES];
    }
@end
