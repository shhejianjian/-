//
//  UIBarButtonItem+Extension.m
//  微博(谢琰)
//
//  Created by 谢琰 on 15/8/12.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn=[[UIButton alloc]init];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage]forState:UIControlStateHighlighted];
    btn.size=btn.currentImage.size;
    btn.contentMode=UIViewContentModeCenter;
     return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
@end
