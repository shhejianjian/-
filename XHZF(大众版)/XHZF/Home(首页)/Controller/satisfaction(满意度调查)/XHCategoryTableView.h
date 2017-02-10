//
//  XHCategoryTableView.h
//  XHZF
//
//  Created by 谢琰 on 16/5/10.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface XHCategoryTableView : UIView

//从外面传进来的数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;

//弹出
- (void)pop;

//隐藏
- (void)dismiss;


@end
