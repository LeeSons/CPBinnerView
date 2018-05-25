//
//  CPBinnerView.m
//  zent
//
//  Created by 孙登峰 on 2018/1/23.
//  Copyright © 2018年 zentcm. All rights reserved.
//

#import "CPBinnerView.h"
#import "CPBinnerUtility.h"

#define kTitleHeight 50

@interface CPBinnerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger _rowCount;
}

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation CPBinnerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDefaultValue];
        [self initSubViews];
    }
    return self;
}

- (void)setDefaultValue
{
    _rowCount = 0;
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _autoScrollTimeInterval = 2;
    _infiniteLoop = YES;
    _autoScroll = YES;
    _showPageControl = YES;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)initSubViews
{
    [self addSubview:self.collectionView];
    
    
    [self adjustsScrollViewInsets];
    [self addSubview:self.pageControl];
}

- (void)adjustsScrollViewInsets
{
    if (@available(iOS 11.0, *))
    {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        [[CPBinnerUtility getVC:self] performSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:) withObject:@(NO)];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview)
    {
        [self stopTimer];
    }
}

- (void)dealloc
{
    NSLog(@"释放的很安详~");
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self getRowCount];
    [self setSubViewFrame];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self firstTodo];
    });
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numbers = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsWithBinnerView:)])
    {
        numbers = [self.dataSource numberOfItemsWithBinnerView:self];
    }
    if (_infiniteLoop && numbers > 1)
    {
        return numbers + 2;
    }
    return numbers;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPBinnerCell *cell = nil;
    NSInteger rowCount = _rowCount;
    if (_infiniteLoop && rowCount > 3)
    {
        if (indexPath.row == 0)
        {
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(binnerView:itemForIndex:)])
            {
                cell = [self.dataSource binnerView:self itemForIndex:rowCount - 3];
            }
        }
        else if (indexPath.row == (rowCount - 1))
        {
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(binnerView:itemForIndex:)])
            {
                cell = [self.dataSource binnerView:self itemForIndex:0];
            }
        }
        else
        {
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(binnerView:itemForIndex:)])
            {
                cell = [self.dataSource binnerView:self itemForIndex:indexPath.row - 1];
            }
        }
    }
    else
    {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(binnerView:itemForIndex:)])
        {
            cell = [self.dataSource binnerView:self itemForIndex:indexPath.row];
        }
    }
    cell.showPageControl = self.showPageControl;
    return cell;
}

#pragma mark -- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    if (_infiniteLoop && _rowCount > 3)
    {
        index = indexPath.row - 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(binnerView:didSelectItem:)])
    {
        [self.delegate binnerView:self didSelectItem:index];
    }
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_infiniteLoop && _rowCount > 3)
    {
        [self infiniteLoopScroll];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_autoScroll && _rowCount > 3)
    {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_autoScroll && _rowCount > 3)
    {
        [self startTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = [self currentIndex];
    if (self.delegate && [self.delegate respondsToSelector:@selector(binnerView:didScrollToItem:)])
    {
        [self.delegate binnerView:self didScrollToItem:index];
    }
    if (self.title && ![self.title isEqualToString:@""])
    {
        NSString *currentPage = [NSString stringWithFormat:@"%d / %ld", [self currentIndex], (_infiniteLoop && _rowCount > 3)?(_rowCount - 2):_rowCount];
        self.pageLabel.text = currentPage;
    }
    [self.pageControl setCurrentPage:[self currentIndex] - 1];
}

#pragma mark -- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


#pragma mark -- publick method

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    if (!nib)
    {
        return;
    }
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (CPBinnerCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)reloadData
{
    [self setNeedsLayout];
    [self.collectionView reloadData];
}

#pragma mark -- privite method

- (void)setSubViewFrame
{
    if (self.title && ![self.title isEqualToString:@""])
    {
        self.titleView.frame = CGRectMake(0, 0, self.frame.size.width, kTitleHeight);
        [CPBinnerUtility setLeft:15 view:self.titleLabel];
        [self.titleLabel sizeToFit];
        [CPBinnerUtility setBottom:[CPBinnerUtility getBottom:self.titleView] - 8 view:self.titleLabel];
        
        [CPBinnerUtility setLeft:([CPBinnerUtility getRight:self.titleLabel] + 5) view:self.subTitleLabel];
        [self.subTitleLabel sizeToFit];
        [CPBinnerUtility setBottom:[CPBinnerUtility getBottom:self.titleLabel] view:self.subTitleLabel];
        
        [CPBinnerUtility setWidth:50 view:self.pageLabel];
        [CPBinnerUtility setHeight:[CPBinnerUtility getHeight:self.subTitleLabel] view:self.pageLabel];
        [CPBinnerUtility setRight:self.frame.size.width - 15 view:self.pageLabel];
        [CPBinnerUtility setBottom:[CPBinnerUtility getBottom:self.titleLabel] view:self.pageLabel];
        
        NSString *currentPage = [NSString stringWithFormat:@"%d / %ld", 1, (_infiniteLoop && _rowCount > 3)?(_rowCount - 2):_rowCount];
        self.pageLabel.text = currentPage;
        
        self.collectionView.frame = CGRectMake(0, kTitleHeight, self.frame.size.width, self.frame.size.height - kTitleHeight);
    }
    else
    {
        self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = (_infiniteLoop && _rowCount > 3)?(_rowCount - 2):_rowCount;
    [CPBinnerUtility setWidth:self.frame.size.width view:self.pageControl];
    [CPBinnerUtility setHeight:10 view:self.pageControl];
    [CPBinnerUtility setCenterX:[CPBinnerUtility getCenterX:self] view:self.pageControl];
    [CPBinnerUtility setBottom:[CPBinnerUtility getBottom:self] - 5 view:self.pageControl];
}

- (void)firstTodo
{
    if (_infiniteLoop && _rowCount > 3)
    {
        [self scrollToFirst];
    }
    if (_autoScroll && _rowCount > 3)
    {
        [self startTimer];
    }
}

- (void)getRowCount
{
    NSInteger numbers = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsWithBinnerView:)])
    {
        numbers = [self.dataSource numberOfItemsWithBinnerView:self];
    }
    if (_infiniteLoop && numbers > 1)
    {
        numbers += 2;
    }
    _rowCount = numbers;
}

- (void)infiniteLoopScroll
{
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        if (self.collectionView.contentOffset.x >= (_rowCount - 1) * self.collectionView.frame.size.width)
        {
            [self scrollToFirst];
        }
        if (self.collectionView.contentOffset.x <= 0)
        {
            [self scrollToLast];
        }
    }
    else
    {
        if (self.collectionView.contentOffset.y >= (_rowCount - 1) * self.collectionView.frame.size.height)
        {
            [self scrollToFirst];
        }
        if (self.collectionView.contentOffset.y <= 0)
        {
            [self scrollToLast];
        }
    }
}

- (void)scrollToFirst
{
    CGFloat x = 0.0f, y = 0.0f;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        x = self.collectionView.frame.size.width * 1;
    }
    else
    {
        y = self.collectionView.frame.size.height * 1;
    }
    [self.collectionView setContentOffset:CGPointMake(x, y)];
}

- (void)scrollToLast
{
    CGFloat x = 0.0f, y = 0.0f;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        x = self.collectionView.frame.size.width * (_rowCount - 2);
    }
    else
    {
        y = self.collectionView.frame.size.height * (_rowCount - 2);
    }
    [self.collectionView setContentOffset:CGPointMake(x, y)];
}

- (void)startTimer
{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(timerClick:) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerClick:(NSTimer *)sender
{
    if (_rowCount == 0)
    {
        return;
    }
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)stopTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (int)currentIndex
{
    int index = 0;
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        index = self.collectionView.contentOffset.x / self.frame.size.width;
    }
    else
    {
        index = self.collectionView.contentOffset.y / self.frame.size.height;
    }
    return MAX(0, index);
}

- (void)scrollToIndex:(NSInteger)targetIndex
{
    if (_infiniteLoop && _rowCount > 3)
    {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    else
    {
        if (targetIndex == _rowCount)
        {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            return;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

#pragma mark -- setter
- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    if (autoScroll && _rowCount > 3)
    {
        [self startTimer];
    }
    else
    {
        [self stopTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    [self.layout setScrollDirection:scrollDirection];
    [self.collectionView setCollectionViewLayout:_layout animated:YES];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if (title && ![title isEqualToString:@""])
    {
        [CPBinnerUtility removeAllSubviews:self.titleView];
        [self.titleView removeFromSuperview];
        [self addSubview:self.titleView];
        [self.titleView addSubview:self.titleLabel];
        [self.titleView addSubview:self.subTitleLabel];
        [self.titleView addSubview:self.pageLabel];
        self.titleLabel.text = title;
        self.subTitleLabel.text = [[CPBinnerUtility transformToPinyin:title] uppercaseString];
    }
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    if (showPageControl)
    {
        self.pageControl.hidden = NO;
    }
    else
    {
        self.pageControl.hidden = YES;
    }
}

#pragma mark -- lazy load

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView setContentOffset:CGPointMake(0, 0)];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout)
    {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = self.scrollDirection;
        _layout.estimatedItemSize = CGSizeZero;
    }
    return _layout;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    }
    return _pageControl;
}

- (UIView *)titleView
{
    if (!_titleView)
    {
        if (!_titleLabel)
        {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _titleLabel.font = [UIFont boldSystemFontOfSize:20];
            _titleLabel.textColor = [UIColor blackColor];
        }
        if (!_subTitleLabel)
        {
            _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _subTitleLabel.font = [UIFont systemFontOfSize:13];
            _subTitleLabel.textColor = [UIColor darkGrayColor];
        }
        if (!_pageLabel)
        {
            _pageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _pageLabel.font = [UIFont systemFontOfSize:13];
            _pageLabel.textColor = [UIColor darkGrayColor];
            _pageLabel.textAlignment = NSTextAlignmentRight;
        }
        _titleView = [[UIView alloc] initWithFrame:CGRectZero];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    return _titleView;
}

@end
