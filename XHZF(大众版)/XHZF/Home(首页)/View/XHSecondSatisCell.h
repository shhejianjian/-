//
//  XHSecondSatisCell.h
//  XHZF
//
//  Created by 谢琰 on 16/5/10.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHSecondSatisCell;
@protocol XHSecondSatisCellDelegate <NSObject>

@optional

- (void)secondSatisCellCellSubmitButtonDidClick:(XHSecondSatisCell *)cell;
@end
@interface XHSecondSatisCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) id<XHSecondSatisCellDelegate>delegate;
@end
