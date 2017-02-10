
//
//  XHProcessCell.m
//  XHZF
//
//  Created by 谢琰 on 16/5/13.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHProcessCell.h"
#import "XHProcess.h"
#import "XHConst.h"
@interface XHProcessCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UIImageView *isfinishImageView;
@property (weak, nonatomic) IBOutlet UILabel *operatorLable;
@property (weak, nonatomic) IBOutlet UILabel *operationLable;

@end

@implementation XHProcessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProcess:(XHProcess *)process
{
    _process = process;
    self.operationLable.text = process.operationName;
    if ([process.operatorName isEqualToString:@"结单"]) {
        self.isfinishImageView.image = [UIImage imageNamed:@"finish"];
        self.operatorLable.textColor = [UIColor lightGrayColor];
        self.operationLable.textColor = [UIColor lightGrayColor];
      
    }else{
        self.isfinishImageView.image = [UIImage imageNamed:@"arrow_down"];
        self.operatorLable.textColor = XHGlobalColor;
        self.operationLable.textColor = XHGlobalColor;
    }
    #warning 先这样 后面要拼接号码
    self.operatorLable.text = process.operatorName;
    NSString *timeString = [self covertToDateStringFromString:process.eventTime];
    self.timeLable.text = [timeString substringFromIndex:11];
    self.dateLable.text = [timeString substringToIndex:11];
}
- (NSString *)covertToDateStringFromString:(NSString *)Str
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[Str longLongValue]/1000.0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [dateFormatter stringFromDate:date];
}

@end
