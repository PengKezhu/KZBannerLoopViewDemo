//
//  ViewController.m
//  LoopBannersDemo
//
//  Created by 彭柯柱 on 2018/12/13.
//  Copyright © 2018 彭柯柱. All rights reserved.
//

#import "ViewController.h"
#import "KZBannerLoopView.h"

@interface ViewController ()<UIScrollViewDelegate, KZBannerLoopViewDelegate>

@property (nonatomic, strong) KZBannerLoopView *bannerLoopView;
@property (nonatomic, copy) NSArray *dataSource;//数据源

@end

#define BANNER_WIDTH self.view.bounds.size.width
#define BANNER_HEIGHT BANNER_WIDTH

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[
                        @"1",
                        @"2",
                        @"3",
                        @"4",
                        @"5"
                        ];
    
    self.bannerLoopView = [[KZBannerLoopView alloc] initWithFrame:CGRectMake(0, 50, BANNER_WIDTH, BANNER_HEIGHT)];
    self.bannerLoopView.delegate = self;
    self.bannerLoopView.itemsCount = self.dataSource.count;
    self.bannerLoopView.pageIndicatorTintColor = UIColor.whiteColor;
    self.bannerLoopView.currentPageIndicatorTintColor = UIColor.orangeColor;
    self.bannerLoopView.timeInterval = 2;
    [self.bannerLoopView reloadData];
    [self.view addSubview:self.bannerLoopView];
}

- (UIView *)loopView:(KZBannerLoopView *)loopView itemForIndex:(NSInteger)index reuseId:(NSString *)reuseId {
    UILabel *item = [loopView dequeueReusableItemWithIdentifier:reuseId];
    if (!item) {
        item = [[UILabel alloc] init];
        item.backgroundColor = UIColor.grayColor;
        item.textColor = UIColor.blackColor;
        item.font = [UIFont boldSystemFontOfSize:40];
        item.textAlignment = NSTextAlignmentCenter;
    }
    item.text = self.dataSource[index];
    
    return item;
}

- (void)loopView:(KZBannerLoopView *)loopView didSelectIndex:(NSInteger)index {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:[NSString stringWithFormat:@"第%ld个item被点击了", index]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

@end
