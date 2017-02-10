//
//  XHSecondTableViewCell.m
//  XHZF
//
//  Created by 何键键 on 16/4/5.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSecondTableViewCell.h"
@interface XHSecondTableViewCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *previewLabel;

@end

@implementation XHSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        self.previewLabel.hidden = YES;
    }else{
        self.previewLabel.hidden = NO;
    }
}
@end
