//
//  XHLayout.m
//  XHZF
//
//  Created by 谢琰 on 16/5/9.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHLayout.h"

@implementation XHLayout
- (void)prepareLayout
{
    [super prepareLayout];
    // 每个cell的尺寸
//    self.itemSize = self.collectionView.frame.size;
    // 设置水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;

     }

@end
