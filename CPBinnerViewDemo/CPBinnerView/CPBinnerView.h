//
//  CPBinnerView.h
//  zent
//
//  Created by 孙登峰 on 2018/1/23.
//  Copyright © 2018年 zentcm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPBinnerCell.h"

@class CPBinnerView;

@protocol CPBinnerViewDelegate <NSObject>

@optional
- (void)binnerView:(CPBinnerView *)binnerView didSelectItem:(NSInteger)index;
- (void)binnerView:(CPBinnerView *)binnerView didScrollToItem:(NSInteger)index;

@end

@protocol CPBinnerViewDataSource <NSObject>

- (NSInteger)numberOfItemsWithBinnerView:(CPBinnerView *)binnerView;

- (CPBinnerCell *)binnerView:(CPBinnerView *)binnerView itemForIndex:(NSInteger)index;

@end

@interface CPBinnerView : UIView

@property (nonatomic, assign) id<CPBinnerViewDataSource> dataSource;
@property (nonatomic, assign) id<CPBinnerViewDelegate> delegate;

/**
 滚动方向 默认横向 UICollectionViewScrollDirectionHorizontal
 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/**
 自动滚动时间
 */
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

/**
 是否无限 默认 是
 */
@property (nonatomic, assign) BOOL infiniteLoop;

/**
 是否自动滚 默认 是
 */
@property (nonatomic, assign) BOOL autoScroll;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 子标题
 */
@property (nonatomic, copy) NSString *subTitle;

/**
 是否显示分页控制
 */
@property (nonatomic, assign) BOOL showPageControl;

- (void)reloadData;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (CPBinnerCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

@end
