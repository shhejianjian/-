//
//  XHFirstTableViewCell.m
//  XHZF
//
//  Created by 何键键 on 16/4/5.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHFirstTableViewCell.h"
@interface XHFirstTableViewCell ()


@end

@implementation XHFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.logoLabel.layer.cornerRadius = 20.0f;
    self.logoLabel.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
