//
//  XHConst.h
//  XHZF
//
//  Created by 谢琰 on 16/3/30.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef DEBUG
#define XHLog(...) NSLog(__VA_ARGS__)
#else
#define XHLog(...)
#endif

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

#define XHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XHGlobalColor XHColor(29, 125, 101)

#define XHPhoneColor XHColor(244, 163, 59)
#define XHVideoColor XHColor(216, 77, 71)


#define XHRepairColor XHColor(102, 112, 191)
#define XHCleanColor XHColor(67, 181, 245)
#define XHGuardColor XHColor(78, 106, 120)
#define XHDoctorColor XHColor(160, 207, 110)
#define XHComplaintColor XHColor(143, 117, 107)
#define XHSatisfyColor XHColor(237, 84, 78)
#define XHMoreColor XHColor(65, 168, 156)
#define XHGrayColor XHColor(234, 234, 234)


#define XHNotificationCenter [NSNotificationCenter defaultCenter]
//根目录地址
extern NSString *const BaseUrl;
//登录地址
extern NSString *const XHLoginUrl;
//处理方式
extern NSString *const XHWayUrl;
//处理时限
extern NSString *const XHTimeUrl;
//紧急程度
extern NSString *const XHEmergencyUrl;
//所有设备
extern NSString *const XHEquipmentUrl;
//所有建筑
extern NSString *const XHBuildingUrl;
//所有部门
extern NSString *const XHDepartmentUrl ;
//下单
extern NSString *const XHWorkOrderUrl;
//快速下单
extern NSString *const XHQuickWorkOrderUrl;
//下单情况
extern NSString *const XHOrderUrl;
//我要保洁下单
extern NSString *const XHCleanUrl;
//我要保安下单
extern NSString *const XHGuardUrl;
//我要导医下单
extern NSString *const XHDoctorUrl;
//我要投诉下单
extern NSString *const XHComplaintUrl;
//天气
extern NSString *const XHWeatherUrl;
//退出
extern NSString *const XHLogOutUrl;
//上传附件
extern NSString *const XHAttachmentUrl;
//满意度调查问卷数据
extern NSString *const  XHSatisfactionUrl;
//满意度调查问卷提交
extern NSString *const XHSatisfactionFormUrl;
//工单的技师信息
extern NSString *const XHArtificerUrl;
//头像路径
extern NSString *const XHImageUrl;
//通知
extern NSString  *const XHDepartmentDidChangeNotification;
extern NSString  *const XHSelectDepartment;
extern NSString  *const XHSelectDepartmentObjectId;


extern NSString  *const XHAddressDidChangeNotification;
extern NSString  *const XHSelectAddress;
extern NSString  *const XHSelectAddressObjectId;


extern NSString  *const XHEquipmentDidChangeNotification;
extern NSString  *const XHSelectEquipment;
extern NSString  *const XHSelectEquipmentObjectId;

extern NSString  *const XHCategoryDidClick;
extern NSString  *const XHSelectedCategory;

