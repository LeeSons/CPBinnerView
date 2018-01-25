//
//  BinnerCell1.m
//  CPBinnerViewDemo
//
//  Created by 孙登峰 on 2018/1/25.
//  Copyright © 2018年 zentcm. All rights reserved.
//

#import "BinnerCell1.h"

@implementation BinnerCell1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end
