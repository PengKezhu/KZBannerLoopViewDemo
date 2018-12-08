//
//  QMTTLoopBannerView.m
//  LoopBannersDemo
//
//  Created by pengkezhu on 2018/12/7.
//  Copyright © 2018 彭柯柱. All rights reserved.
//

#import "QMTTLoopBannerView.h"

@interface UIView (LoopBannerConvenience)

- (void)qm_setX:(CGFloat)originX;
- (void)qm_setBottom:(CGFloat)bottom;
- (void)qm_setCenterX:(CGFloat)centerX;
- (void)qm_setSize:(CGSize)size;

@end

@implementation UIView (LoopBannerConvenience)

- (void)qm_setX:(CGFloat)originX {
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (void)qm_setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - CGRectGetHeight(self.frame);
    self.frame = frame;
}

- (void)qm_setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)qm_setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

@end

//广告轮播图
//原理：scrollView放三个item，起始是[ITEM_n-1][ITEM_0][ITEM_1], 每次滑动到下一个item后，将scrollView归位到中间item，且取下一轮相邻三个数据并刷新

@interface QMTTLoopBannerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableDictionary *reusableItems;//复用的items，包括leftItem，midItem，rightItem
@property (nonatomic, assign) NSInteger currentStartIndex;//最左边item对应的index

@end

NSString *const kBannerViewLeftItemReuseId   = @"kBannerViewLeftItemReuseId";
NSString *const kBannerViewMiddleItemReuseId = @"kBannerViewMiddleItemReuseId";
NSString *const kBannerViewRightItemReuseId  = @"kBannerViewRightItemReuseId";

@implementation QMTTLoopBannerView

#define BANNER_WIDTH self.scrollView.bounds.size.width
#define BANNER_HEIGHT self.scrollView.bounds.size.height

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)prepare {
    self.reusableItems = [NSMutableDictionary dictionary];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(BANNER_WIDTH * 3, BANNER_HEIGHT);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView setContentOffset:CGPointMake(BANNER_WIDTH, 0)];
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.defersCurrentPageDisplay = YES;
    [self addSubview:self.pageControl];
}

- (void)setItemsCount:(NSInteger)itemsCount {
    _itemsCount = itemsCount;
    _currentStartIndex = self.itemsCount - 1;
    [self reloadData];
}

- (void)reloadData {
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    if (!self.itemsCount) {
        return;
    }
    
    [self updatePageControl];
    
    [self.reusableItems removeObjectForKey:kBannerViewLeftItemReuseId];
    [self.reusableItems removeObjectForKey:kBannerViewMiddleItemReuseId];
    [self.reusableItems removeObjectForKey:kBannerViewRightItemReuseId];

    __kindof UIView *leftItem = [self.delegate loopView:self itemForIndex:self.itemsCount - 1 reuseId:kBannerViewLeftItemReuseId];
    __kindof UIView *midItem = [self.delegate loopView:self itemForIndex:0 reuseId:kBannerViewLeftItemReuseId];
    __kindof UIView *rightItem = [self.delegate loopView:self itemForIndex:(self.itemsCount == 1) ? 0 : 1 reuseId:kBannerViewLeftItemReuseId];
    
    [self.reusableItems setObject:leftItem forKey:kBannerViewLeftItemReuseId];
    [self.reusableItems setObject:midItem forKey:kBannerViewMiddleItemReuseId];
    [self.reusableItems setObject:rightItem forKey:kBannerViewRightItemReuseId];
    
    [self resizeItem:leftItem];
    [leftItem qm_setX:0 * BANNER_WIDTH];
    [self.scrollView addSubview:leftItem];
    
    [self resizeItem:midItem];
    [midItem qm_setX:1 * BANNER_WIDTH];
    [self.scrollView addSubview:midItem];
    
    [self resizeItem:rightItem];
    [rightItem qm_setX:2 * BANNER_WIDTH];
    [self.scrollView addSubview:rightItem];
}

- (void)resizeItem:(__kindof UIView *)item {
    [item qm_setSize:CGSizeMake(BANNER_WIDTH, BANNER_HEIGHT)];
}

- (__kindof UIView *)dequeueReusableItemWithIdentifier:(NSString *)identifier {
    return self.reusableItems[identifier];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX <= 0) {
        _currentStartIndex--;
        [self updateScrollView];
    } else if (offsetX >= 2 * BANNER_WIDTH) {
        _currentStartIndex++;
        [self updateScrollView];
    }
}

#pragma mark - private methods

- (void)updatePageControl {
    self.pageControl.numberOfPages = self.itemsCount;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
    [self.pageControl qm_setSize:CGSizeMake(self.itemsCount * 8.f, 8.f)];
    [self.pageControl qm_setCenterX:self.frame.size.width / 2.f];
    [self.pageControl qm_setBottom:CGRectGetHeight(self.frame) - 10.f];
    [self bringSubviewToFront:self.pageControl];
}

- (void)updateScrollView {
    if (self.currentStartIndex == self.itemsCount) {
        self.currentStartIndex = 0;
    } else if (self.currentStartIndex == -1) {
        self.currentStartIndex = self.itemsCount - 1;
    } else {
        self.currentStartIndex = _currentStartIndex;
    }
    [self.scrollView setContentOffset:CGPointMake(BANNER_WIDTH, 0)];
}

- (void)setCurrentStartIndex:(NSInteger)currentStartIndex {
    _currentStartIndex = currentStartIndex;
    NSInteger n = self.itemsCount;
    
    [self.delegate loopView:self itemForIndex:currentStartIndex reuseId:kBannerViewLeftItemReuseId];
    
    NSInteger secondItemIndex = currentStartIndex + 1;
    if (secondItemIndex == n) {
        secondItemIndex = 0;
    }
    [self.delegate loopView:self itemForIndex:secondItemIndex reuseId:kBannerViewMiddleItemReuseId];
    self.pageControl.currentPage = secondItemIndex;

    NSInteger thirdItemIndex = secondItemIndex + 1;
    if (thirdItemIndex == n) {
        thirdItemIndex = 0;
    }
    [self.delegate loopView:self itemForIndex:thirdItemIndex reuseId:kBannerViewRightItemReuseId];
}

@end

