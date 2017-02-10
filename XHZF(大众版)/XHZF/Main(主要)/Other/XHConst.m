//
//  XHConst.m
//  XHZF
//
//  Created by 谢琰 on 16/3/30.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

//URL  192.168.7.100:8080
NSString *const BaseUrl = @"http://115.28.239.33:80/hems";
NSString *const XHLoginUrl = @"http://115.28.239.33:80/hems/login";
NSString *const XHWayUrl = @"api/v1/hems/workOrder/code/ProcessingMode";
NSString *const XHTimeUrl = @"api/v1/hems/workOrder/code/ProcessingTimeLimit";
NSString *const XHEmergencyUrl = @"api/v1/hems/workOrder/code/EmergencyDegree";
NSString *const XHEquipmentUrl = @"api/v1/hems/equipment/all";
NSString *const XHBuildingUrl = @"api/v1/hems/building/tree?id=1&fetchChild=true";
NSString *const XHDepartmentUrl = @"api/v1/hems/department/tree?id=1&fetchChild=true";
NSString *const XHWorkOrderUrl = @"api/v1/hems/workOrder/issue";
NSString *const XHQuickWorkOrderUrl =@"api/v1/hems/workOrder/quick";
NSString *const XHCleanUrl = @"api/v1/hems/workOrder/serve/Clean";
NSString *const XHGuardUrl = @"api/v1/hems/workOrder/serve/Security";
NSString *const XHDoctorUrl = @"api/v1/hems/workOrder/serve/MedicalAdvice";
NSString *const XHComplaintUrl = @"api/v1/hems/workOrder/serve/Complaint";
NSString *const XHOrderUrl = @"api/v1/hems/workOrder/info";
NSString *const XHWeatherUrl = @"https://api.heweather.com/x3/weather";
NSString *const XHLogOutUrl = @"logout";
NSString *const XHAttachmentUrl = @"api/v1/system/file/upload";
NSString *const XHSatisfactionUrl = @"api/v1/hems/satisfactionAssess/current";
NSString *const XHSatisfactionFormUrl = @"api/v1/hems/satisfactionAssess/form";
NSString *const XHArtificerUrl = @"api/v1/hems/artificer";
NSString *const XHImageUrl = @"api/v1/hems/artificer/picture";

//通知
NSString *const XHDepartmentDidChangeNotification = @"XHDepartmentDidChangeNotification";
NSString *const XHSelectDepartment = @"XHSelectDepartment";
NSString *const XHSelectDepartmentObjectId = @"XHSelectDepartmentObjectId";


NSString *const XHAddressDidChangeNotification = @"XHAddressDidChangeNotification";
NSString *const XHSelectAddress = @"XHSelectAddress";
NSString *const XHSelectAddressObjectId = @"XHSelectAddressObjectId";


NSString *const XHEquipmentDidChangeNotification = @"XHEquipmentDidChangeNotification";
NSString *const XHSelectEquipment = @"XHSelectEquipment";
NSString *const XHSelectEquipmentObjectId = @"XHSelectEquipmentObjectId";

NSString *const XHCategoryDidClick = @"XHCategoryDidClick";
NSString *const XHSelectedCategory = @"XHSelectedCategory";




