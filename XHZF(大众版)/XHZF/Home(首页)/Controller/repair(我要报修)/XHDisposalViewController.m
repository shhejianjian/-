//
//  XHDisposalViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/4/6.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHDisposalViewController.h"
#import "XYPickerView.h"
#import "XHConst.h"
#import "BSHttpTool.h"
#import "XHDisposal.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"

@interface XHDisposalViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *extentLabel;
@property (weak, nonatomic) IBOutlet UILabel *wayLabel;
@property (nonatomic, strong) XHDisposal *extentDisposal;
@property (nonatomic, strong) XHDisposal *timeDisposal;
@property (nonatomic, strong) XHDisposal *wayDisposal;
@property (nonatomic, strong) NSMutableArray *pickerArr;

@end

@implementation XHDisposalViewController
extern NSString *jsessionid;
- (XHDisposal *)wayDisposal
{
    if (!_wayDisposal) {
        _wayDisposal = [[XHDisposal alloc]init];
    }
    return _wayDisposal;
}
- (XHDisposal *)timeDisposal
{
    if (!_timeDisposal) {
        _timeDisposal = [[XHDisposal alloc]init];
    }
    return _timeDisposal;
}
- (XHDisposal *)extentDisposal
{
    if (!_extentDisposal) {
        _extentDisposal = [[XHDisposal alloc]init];
    }
    return _extentDisposal;
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
- (NSMutableArray *)pickerArr
{
    if (!_pickerArr) {
        _pickerArr = [NSMutableArray array];
    }
    return _pickerArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self updataData];
//    [self loadData];
}
- (void)setupNav
{
    self.navigationItem.title = @"处理方式";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

}
- (void)updataData
{
//    NSRange firstRange = [self.originalStr rangeOfString:@"/"];
//    NSRange secondRange = [self.originalStr rangeOfString:@"/" options:NSBackwardsSearch];
//    self.wayLabel.text = [self.originalStr substringToIndex:firstRange.location];
//    self.extentLabel.text = [self.originalStr substringFromIndex:secondRange.location + 1];
//    NSRange midRange = NSMakeRange(firstRange.location + 1, secondRange.location - firstRange.location -1);
//    self.timeLabel.text = [self.originalStr substringWithRange:midRange];
    self.wayDisposal = self.ways[0];
    self.wayLabel.text = self.wayDisposal.name;
    
    self.timeDisposal = self.times[0];
    self.timeLabel.text = self.timeDisposal.name;
    
    self.extentDisposal = self.extents[0];
    self.extentLabel.text = self.extentDisposal.name;
}
#pragma  mark - 与服务器交互
//- (void)loadData
//{
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"jsessionid"] = jsessionid;
//        [BSHttpTool get:XHWayUrl params:param success:^(id json) {
//            self.ways = [XHDisposal mj_objectArrayWithKeyValuesArray:json];
////            for (XHDisposal *way in wayArr) {
////                [self.ways addObject:way.name];
////            }
//        } failure:^(NSError *error) {
//            [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
//        }];
//    [BSHttpTool get:XHTimeUrl params:param success:^(id json) {
//         self.times = [XHDisposal mj_objectArrayWithKeyValuesArray:json];
////        for (XHDisposal *time in timeArr) {
////            [self.times addObject:time.name];
////        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
//    }];
//    [BSHttpTool get:XHEmergencyUrl params:param success:^(id json) {
// 
//        self.extents = [XHDisposal mj_objectArrayWithKeyValuesArray:json];
////        for (XHDisposal *extent in extentArr) {
////            [self.extents addObject:extent.name];
////        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
//    }];
//
//   
//}
- (void)cancle
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finish
{
    if ([self.delegate respondsToSelector:@selector(disposalViewControllerSureButtonDidClick:Way:time:extent:)]) {
        [self.delegate disposalViewControllerSureButtonDidClick:self Way:self.wayDisposal time:self.timeDisposal extent:self.extentDisposal];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - IBAction
- (IBAction)btnWayClick:(id)sender {
    [self.pickerArr removeAllObjects];
    for (XHDisposal *way in self.ways) {
        [self.pickerArr addObject:way.name];
    }
    XYPickerView * pickerView = [[XYPickerView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-250, self.view.bounds.size.width, 200) DataArr:self.pickerArr];
    pickerView.title = @"请选择处理方式";
    [pickerView showPickerView];
    pickerView.returnPickerStrBlock = ^(NSString *pickerStr){
        self.wayDisposal.name = pickerStr;
        for (XHDisposal *disposal in self.ways) {
            if ([disposal.name isEqualToString:pickerStr]) {
                self.wayDisposal.objectId = disposal.objectId;
            }
        }
        self.wayLabel.text = pickerStr;
    };

}
- (IBAction)btnTimeClick:(id)sender {
    [self.pickerArr removeAllObjects];
    for (XHDisposal *time in self.times) {
        [self.pickerArr addObject:time.name];
    }
    XYPickerView * pickerView = [[XYPickerView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-250, self.view.bounds.size.width, 200) DataArr:self.pickerArr];
    pickerView.title = @"请选择处理时限";
    [pickerView showPickerView];
    pickerView.returnPickerStrBlock = ^(NSString *pickerStr){
        self.timeDisposal.name = pickerStr;
        for (XHDisposal *disposal in self.times) {
            if ([disposal.name isEqualToString:pickerStr]) {
                self.timeDisposal.objectId = disposal.objectId;
            }
        }

        self.timeLabel.text = pickerStr;
    };

}
- (IBAction)btnExtentClick:(id)sender {
    [self.pickerArr removeAllObjects];
    for (XHDisposal *extent in self.extents) {
        [self.pickerArr addObject:extent.name];
    }

    XYPickerView * pickerView = [[XYPickerView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-250, self.view.bounds.size.width, 200) DataArr:self.pickerArr];
    pickerView.title = @"请选择紧急程度";
    [pickerView showPickerView];
    pickerView.returnPickerStrBlock = ^(NSString *pickerStr){
        self.extentDisposal.name = pickerStr;
        for (XHDisposal *disposal in self.extents) {
            if ([disposal.name isEqualToString:pickerStr]) {
                self.extentDisposal.objectId = disposal.objectId;
            }
        }
        self.extentLabel.text = pickerStr;
    };

}

@end
