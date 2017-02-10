//
//  XHSearchResultViewController.h
//  XHZF
//
//  Created by 谢琰 on 16/4/15.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHSearchResultViewController : UITableViewController
@property (nonatomic, copy) NSString *searchDepartment;
@property (nonatomic, copy) NSString *searchEquipment;
@property (nonatomic, copy) NSString *searchAddress;
@property (nonatomic, strong) NSMutableArray *searchArr;
@end
