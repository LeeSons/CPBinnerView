//
//  TableViewCell.m
//  CPBinnerViewDemo
//
//  Created by 孙登峰 on 2018/1/25.
//  Copyright © 2018年 zentcm. All rights reserved.
//

#import "TableViewCell.h"
#import "CPBinnerView.h"

#import "BinnerCell1.h"
#import "BinnerCell2.h"
#import "BinnerCell3.h"
#import "BinnerCell4.h"
#import "BinnerCell5.h"

@interface TableViewCell ()<CPBinnerViewDataSource, CPBinnerViewDelegate>

@property (nonatomic, strong) CPBinnerView *binnerView;

@end

@implementation TableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    if (_binnerView)
    {
        [_binnerView removeFromSuperview];
        _binnerView = nil;
    }
    _binnerView = [[CPBinnerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _binnerView.delegate = self;
    _binnerView.dataSource = self;
    if (index == 0)
    {
        [_binnerView registerClass:[BinnerCell1 class] forCellWithReuseIdentifier:@"cell1"];
        
        _binnerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _binnerView.title = @"";
        _binnerView.showPageControl = YES;
    }
    if (index == 1)
    {
        [_binnerView registerNib:[UINib nibWithNibName:@"BinnerCell2" bundle:nil] forCellWithReuseIdentifier:@"cell2"];
        _binnerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _binnerView.title = @"风景推荐";
        _binnerView.showPageControl = YES;
    }
    if (index == 2)
    {
        [_binnerView registerNib:[UINib nibWithNibName:@"BinnerCell3" bundle:nil] forCellWithReuseIdentifier:@"cell3"];
        _binnerView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _binnerView.title = @"";
        _binnerView.showPageControl = NO;
    }
    if (index == 3)
    {
        [_binnerView registerNib:[UINib nibWithNibName:@"BinnerCell4" bundle:nil] forCellWithReuseIdentifier:@"cell4"];
        [_binnerView registerNib:[UINib nibWithNibName:@"BinnerCell5" bundle:nil] forCellWithReuseIdentifier:@"cell5"];
        _binnerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _binnerView.title = @"";
        _binnerView.showPageControl = NO;
    }
    [self.contentView addSubview:_binnerView];
}

- (NSInteger)numberOfItemsWithBinnerView:(CPBinnerView *)binnerView
{
    return 4;
}

- (CPBinnerCell *)binnerView:(CPBinnerView *)binnerView itemForIndex:(NSInteger)index
{
    if (self.index == 0)
    {
        BinnerCell1 *cell = (BinnerCell1 *)[binnerView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndex:index];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", index + 1]];
        return cell;
        
    }
    if (self.index == 1)
    {
        BinnerCell2 *cell = (BinnerCell2 *)[binnerView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndex:index];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", index + 1]];
        cell.title.text = @"风景如画";
        cell.subTitle.text = @"这里真的是美不胜收啊！";
        return cell;
    }
    if (self.index == 2)
    {
        BinnerCell3 *cell = (BinnerCell3 *)[binnerView dequeueReusableCellWithReuseIdentifier:@"cell3" forIndex:index];
        return cell;
    }
    if (self.index == 3)
    {
        if (index == 0)
        {
            BinnerCell4 *cell = (BinnerCell4 *)[binnerView dequeueReusableCellWithReuseIdentifier:@"cell4" forIndex:index];
            return cell;
        }
        if (index == 1)
        {
            BinnerCell5 *cell = (BinnerCell5 *)[binnerView dequeueReusableCellWithReuseIdentifier:@"cell5" forIndex:index];
            return cell;
        }
        if (index == 2)
        {
            BinnerCell4 *cell = (BinnerCell4 *)[binnerView dequeueReusableCellWithReuseIdentifier:@"cell4" forIndex:index];
            return cell;
        }
        if (index == 3)
        {
            BinnerCell5 *cell = (BinnerCell5 *)[binnerView dequeueReusableCellWithReuseIdentifier:@"cell5" forIndex:index];
            return cell;
        }
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
