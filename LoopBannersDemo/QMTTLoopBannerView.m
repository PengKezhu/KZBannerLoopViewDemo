//
//  QMTTLoopBannerView.m
//  LoopBannersDemo
//
//  Created by pengkezhu on 2018/12/7.
//  Copyright © 2018 彭柯柱. All rights reserved.
//

#import "QMTTLoopBannerView.h"
#import <objc/runtime.h>

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

@interface UIGestureRecognizer (LoopBannerIdentifier)
@property (nonatomic, copy) NSString *identifier;
@end

@implementation UIGestureRecognizer (LoopBannerIdentifier)

- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, @selector(setIdentifier:), identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)identifier {
    return objc_getAssociatedObject(self, @selector(setIdentifier:));
}

@end

//广告轮播图
//原理：scrollView放三个item，起始是[ITEM_n-1][ITEM_0][ITEM_1], 每次滑动到下一个item后，将scrollView归位到中间item，且取下一轮相邻三个数据并刷新

@interface QMTTLoopBannerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) NSMutableDictionary *reusableItems;//复用的items，包括leftItem，midItem，rightItem
@property (nonatomic, assign) NSInteger currentStartIndex;//最左边item对应的index

@property (nonatomic, strong) NSTimer *timer;

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
        [self defaultCongiure];
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

- (void)defaultCongiure {
    self.isAutoLoop = YES;
    self.pageIndicatorTintColor = UIColor.whiteColor;
    self.currentPageIndicatorTintColor = UIColor.grayColor;
    self.timeInterval = 3;
}

#pragma mark - public methods

- (void)setItemsCount:(NSInteger)itemsCount {
    _itemsCount = itemsCount;
    _currentStartIndex = self.itemsCount - 1;
}

- (__kindof UIView *)dequeueReusableItemWithIdentifier:(NSString *)identifier {
    return self.reusableItems[identifier];
}

- (void)reloadData {
    self.pageControl.numberOfPages = 0;
    
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    if (!self.itemsCount) {
        return;
    }
    
    [self updatePageControl];
    
    //重置复用元素
    [self.reusableItems removeObjectForKey:kBannerViewLeftItemReuseId];
    [self.reusableItems removeObjectForKey:kBannerViewMiddleItemReuseId];
    [self.reusableItems removeObjectForKey:kBannerViewRightItemReuseId];

    __kindof UIView *leftItem = [self.delegate loopView:self itemForIndex:self.itemsCount - 1 reuseId:kBannerViewLeftItemReuseId];
    __kindof UIView *midItem = [self.delegate loopView:self itemForIndex:0 reuseId:kBannerViewMiddleItemReuseId];
    __kindof UIView *rightItem = [self.delegate loopView:self itemForIndex:(self.itemsCount == 1) ? 0 : 1 reuseId:kBannerViewRightItemReuseId];
    
    //添加点击事件
    midItem.userInteractionEnabled = YES;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemDidClicked:)];
    self.tapGesture.identifier = [NSString stringWithFormat:@"%ld", (self.currentStartIndex+1) % self.itemsCount];
    [midItem addGestureRecognizer:self.tapGesture];
    
    //设置复用元素
    [self.reusableItems setObject:leftItem forKey:kBannerViewLeftItemReuseId];
    [self.reusableItems setObject:midItem forKey:kBannerViewMiddleItemReuseId];
    [self.reusableItems setObject:rightItem forKey:kBannerViewRightItemReuseId];
    
    //layout初始化
    [self resizeItem:leftItem];
    [leftItem qm_setX:0 * BANNER_WIDTH];
    [self.scrollView addSubview:leftItem];
    
    [self resizeItem:midItem];
    [midItem qm_setX:1 * BANNER_WIDTH];
    [self.scrollView addSubview:midItem];
    
    [self resizeItem:rightItem];
    [rightItem qm_setX:2 * BANNER_WIDTH];
    [self.scrollView addSubview:rightItem];
    
    [self resumeTimer];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX <= 0) {
        self.currentStartIndex--;
        [self resumeScrollViewOffset];
        [self updateItemsAndPageControl];
    } else if (offsetX >= 2 * BANNER_WIDTH) {
        self.currentStartIndex++;
        [self updateItemsAndPageControl];
        [self resumeScrollViewOffset];
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self resumeTimer];
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

- (void)resumeScrollViewOffset {
    [self.scrollView setContentOffset:CGPointMake(BANNER_WIDTH, 0)];
}

- (void)setCurrentStartIndex:(NSInteger)currentStartIndex {
    if (currentStartIndex == self.itemsCount) {//最后一个卡片再左滑还原到第一个
        currentStartIndex = 0;
    } else if (currentStartIndex == -1) {//第一个卡片右滑还原到最后一个
        currentStartIndex = self.itemsCount - 1;
    }
    _currentStartIndex = currentStartIndex;
}

- (void)updateItemsAndPageControl {
    NSAssert([self.delegate respondsToSelector:@selector(loopView:itemForIndex:reuseId:)], @"No delegate conformed!");
    
    [self.delegate loopView:self itemForIndex:(self.currentStartIndex + 0) % self.itemsCount reuseId:kBannerViewLeftItemReuseId];
    [self.delegate loopView:self itemForIndex:(self.currentStartIndex + 1) % self.itemsCount reuseId:kBannerViewMiddleItemReuseId];
    [self.delegate loopView:self itemForIndex:(self.currentStartIndex + 2) % self.itemsCount reuseId:kBannerViewRightItemReuseId];
    
    self.pageControl.currentPage = (self.currentStartIndex + 1) % self.itemsCount;
    self.tapGesture.identifier = [NSString stringWithFormat:@"%ld", (self.currentStartIndex+1) % self.itemsCount];
}

- (void)resizeItem:(__kindof UIView *)item {
    [item qm_setSize:CGSizeMake(BANNER_WIDTH, BANNER_HEIGHT)];
}

- (void)resumeTimer {
    if (self.timer) {
        return;
    }
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scheduledLoop:(NSTimer *)timer {
    if (self.isAutoLoop) {
        [self.scrollView setContentOffset:CGPointMake(BANNER_WIDTH * 2, 0) animated:YES];
    }
}

#pragma mark - Action

- (void)itemDidClicked:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(loopView:didSelectIndex:)]) {
        [self.delegate loopView:self didSelectIndex:gesture.identifier.integerValue];
    }
}

#pragma mark - getter

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(scheduledLoop:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)dealloc {
    [self stopTimer];
}

@end

