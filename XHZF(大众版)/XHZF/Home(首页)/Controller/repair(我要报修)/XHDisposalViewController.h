//
//  XHDisposalViewController.h
//  XHZF
//
//  Created by 谢琰 on 16/4/6.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHDisposalViewController,XHDisposal;
@protocol XHDisposalViewControllerDelegate <NSObject>
@optional
- (void)disposalViewControllerSureButtonDidClick:(XHDisposalViewController *)disposalVC Way:(XHDisposal *)wayDisposal time:(XHDisposal *)timeDisposal extent:(XHDisposal *)extentDisposal ;
@end

@interface XHDisposalViewController : UIViewController
@property (nonatomic ,strong) NSMutableArray *ways;
@property (nonatomic ,strong) NSMutableArray *times;
@property (nonatomic ,strong) NSMutableArray *extents;
@property (nonatomic, copy) NSString *originalStr;
@property (nonatomic, weak) id<XHDisposalViewControllerDelegate>delegate;
@end
