//
//  XYPickerView.h
//  picker
//
//  Created by 谢琰 on 16/3/14.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYPickerView : UIView
-(instancetype)initWithFrame:(CGRect)frame DataArr:(NSArray *)dataArr;
-(void)showPickerView;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) void(^returnPickerStrBlock)(NSString *pickerStr);
@end
