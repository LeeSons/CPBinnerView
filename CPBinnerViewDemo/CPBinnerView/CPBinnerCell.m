//
//  CPBinnerCell.m
//  zent
//
//  Created by 孙登峰 on 2018/1/23.
//  Copyright © 2018年 zentcm. All rights reserved.
//

#import "CPBinnerCell.h"
#import "CPBinnerUtility.h"

@interface CPBinnerCell ()

@end

@implementation CPBinnerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_showPageControl)
    {
        [CPBinnerUtility setHeight:self.frame.size.height - 20 view:self.contentView];
    }
    else
    {
        [CPBinnerUtility setHeight:self.frame.size.height view:self.contentView];
    }
}

@end
