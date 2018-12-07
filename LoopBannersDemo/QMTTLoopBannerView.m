//
//  QMTTLoopBannerView.m
//  LoopBannersDemo
//
//  Created by pengkezhu on 2018/12/7.
//  Copyright © 2018 彭柯柱. All rights reserved.
//

#import "QMTTLoopBannerView.h"

@interface UIView (LoopBannerConvenience)

- (void)setX:(CGFloat)originX;
- (void)setSize:(CGSize)size;

@end

@implementation UIView (LoopBannerConvenience)

- (void)setX:(CGFloat)originX {
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

@end

@interface QMTTLoopBannerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableDictionary *reusableItems;
@property (nonatomic, assign) NSInteger currentStartIndex;//最左边item对应的数组index

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
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(BANNER_WIDTH * 3, BANNER_HEIGHT);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView setContentOffset:CGPointMake(BANNER_WIDTH, 0)];
    [self addSubview:self.scrollView];
    
    self.reusableItems = [NSMutableDictionary dictionary];
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
    
    [self.reusableItems removeObjectForKey:kBannerViewLeftItemReuseId];
    [self.reusableItems removeObjectForKey:kBannerViewMiddleItemReuseId];
    [self.reusableItems removeObjectForKey:kBannerViewRightItemReuseId];

    if (self.itemsCount == 1) {
        
    }
    __kindof UIView *leftItem = [self.delegate loopView:self itemForIndex:self.itemsCount - 1 reuseId:kBannerViewLeftItemReuseId];
    __kindof UIView *midItem = [self.delegate loopView:self itemForIndex:0 reuseId:kBannerViewLeftItemReuseId];
    __kindof UIView *rightItem = [self.delegate loopView:self itemForIndex:(self.itemsCount == 1) ? 0 : 1 reuseId:kBannerViewLeftItemReuseId];
    
    [self.reusableItems setObject:leftItem forKey:kBannerViewLeftItemReuseId];
    [self.reusableItems setObject:midItem forKey:kBannerViewMiddleItemReuseId];
    [self.reusableItems setObject:rightItem forKey:kBannerViewRightItemReuseId];
    
    [self resizeItem:leftItem];
    [leftItem setX:0 * BANNER_WIDTH];
    [self.scrollView addSubview:leftItem];
    
    [self resizeItem:midItem];
    [midItem setX:1 * BANNER_WIDTH];
    [self.scrollView addSubview:midItem];
    
    [self resizeItem:rightItem];
    [rightItem setX:2 * BANNER_WIDTH];
    [self.scrollView addSubview:rightItem];
}

- (void)resizeItem:(__kindof UIView *)item {
    [item setSize:CGSizeMake(BANNER_WIDTH, BANNER_HEIGHT)];
}

- (__kindof UIView *)dequeueReusableItemWithIdentifier:(NSString *)identifier {
    return self.reusableItems[identifier];
}

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

    NSInteger thirdItemIndex = secondItemIndex + 1;
    if (thirdItemIndex == n) {
        thirdItemIndex = 0;
    }
    [self.delegate loopView:self itemForIndex:thirdItemIndex reuseId:kBannerViewRightItemReuseId];
}

@end

