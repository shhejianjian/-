//
//  HWSearchBar.m
//  黑马微博2期
//
//  Created by apple on 14-10-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWSearchBar.h"
#import "UIView+Extension.h"
@implementation HWSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"输入或扫描设备码";
        self.background = [UIImage imageNamed:@"background"];
        
        // 通过init来创建初始化绝大部分控件，控件都是没有尺寸
        UILabel *searchIconLabel = [[UILabel alloc]init];
        searchIconLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:30];
        searchIconLabel.text = @"\uf1c3";
        searchIconLabel.textColor = [UIColor whiteColor];
        searchIconLabel.textAlignment = NSTextAlignmentCenter;
        searchIconLabel.width = 30;
        searchIconLabel.height = 30;
        self.leftView = searchIconLabel;
        self.leftViewMode = UITextFieldViewModeAlways;
//        UIImageView *searchIcon = [[UIImageView alloc] init];
//        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
//        searchIcon.width = 30;
//        searchIcon.height = 30;
//        searchIcon.contentMode = UIViewContentModeCenter;
//        self.leftView = searchIcon;
//        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc] init];
}

@end
