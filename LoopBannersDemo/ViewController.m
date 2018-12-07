//
//  ViewController.m
//  LoopBannersDemo
//
//  Created by 彭柯柱 on 2018/12/6.
//  Copyright © 2018 彭柯柱. All rights reserved.
//

#import "ViewController.h"
#import "QMTTLoopBannerView.h"

@interface ViewController ()<UIScrollViewDelegate, QMTTLoopBannerViewDelegate>

@property (nonatomic, strong) QMTTLoopBannerView *bannerLoopView;


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *label1;//复用的最左边的item
@property (nonatomic, strong) UILabel *label2;//复用的中间的item
@property (nonatomic, strong) UILabel *label3;//复用的最右边的item

@property (nonatomic, copy) NSArray *dataSource;//数据源

@property (nonatomic, assign) NSInteger currentStartIndex;//最左边item对应的数组index

@end

#define BANNER_WIDTH self.view.bounds.size.width
#define BANNER_HEIGHT 300

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[
                        @"https://qiniuuwmp3.7mtt.cn/new_read.png",
                        @"https://qiniuuwmp3.7mtt.cn/new_read.png",
                        @"https://qiniuuwmp3.7mtt.cn/new_read.png"
                        ];

    self.bannerLoopView = [[QMTTLoopBannerView alloc] initWithFrame:CGRectMake(0, 50, BANNER_WIDTH, 200)];
    self.bannerLoopView.delegate = self;
    self.bannerLoopView.itemsCount = self.dataSource.count;
    [self.bannerLoopView reloadData];
    [self.view addSubview:self.bannerLoopView];
    
//    self.currentStartIndex = self.dataSource.count - 1;
//
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300, BANNER_WIDTH, BANNER_HEIGHT)];
//    self.scrollView.backgroundColor = UIColor.grayColor;
//    self.scrollView.delegate = self;
//    self.scrollView.contentSize = CGSizeMake(BANNER_WIDTH * 3, BANNER_HEIGHT);
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    [self.view addSubview:self.scrollView];
//    [self.scrollView setContentOffset:CGPointMake(BANNER_WIDTH, 0)];
//
//    self.label1 = [self createLabel:self.dataSource.lastObject index:0];
//    self.label2 = [self createLabel:self.dataSource.firstObject index:1];
//    self.label3 = [self createLabel:self.dataSource[1] index:2];
}

- (UIView *)loopView:(QMTTLoopBannerView *)loopView itemForIndex:(NSInteger)index reuseId:(NSString *)reuseId {
    UIImageView *label = [loopView dequeueReusableItemWithIdentifier:reuseId];
    if (!label) {
        label = [[UIImageView alloc] init];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont boldSystemFontOfSize:40.f];
//        label.textColor = UIColor.blackColor;
    }
//    label.text = self.dataSource[index];
    label.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.dataSource[index]]]];
    label.backgroundColor = UIColor.whiteColor;
    return label;
}

- (UILabel *)createLabel:(NSString *)text index:(int)index {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(index * BANNER_WIDTH, 0, BANNER_WIDTH, BANNER_HEIGHT)];
    label.textColor = UIColor.blackColor;
    label.font = [UIFont boldSystemFontOfSize:40];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:label];
    return label;
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
    if (self.currentStartIndex == self.dataSource.count) {
        self.currentStartIndex = 0;
    } else if (self.currentStartIndex == -1) {
        self.currentStartIndex = self.dataSource.count - 1;
    } else {
        self.currentStartIndex = _currentStartIndex;
    }
    [self.scrollView setContentOffset:CGPointMake(BANNER_WIDTH, 0)];
}

- (void)setCurrentStartIndex:(NSInteger)currentStartIndex {
    _currentStartIndex = currentStartIndex;
    NSInteger n = self.dataSource.count;
    self.label1.text = self.dataSource[currentStartIndex];
    
    NSInteger secondItemIndex = currentStartIndex + 1;
    if (secondItemIndex == n) {
        secondItemIndex = 0;
    }
    self.label2.text = self.dataSource[secondItemIndex];
    
    NSInteger thirdItemIndex = secondItemIndex + 1;
    if (thirdItemIndex == n) {
        thirdItemIndex = 0;
    }
    self.label3.text = self.dataSource[thirdItemIndex];
}

@end
