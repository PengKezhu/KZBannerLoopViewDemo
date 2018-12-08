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
@property (nonatomic, copy) NSArray *dataSource;//数据源

@end

#define BANNER_WIDTH self.view.bounds.size.width
#define BANNER_HEIGHT BANNER_WIDTH

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[
                        @"https://qiniuuwmp3.7mtt.cn/Ftr4_vj33So2GN8AdmwUpincGnTj.jpg?imageView2/1/w/750/h/750",
                        @"https://qiniuuwmp3.7mtt.cn/Fn4kVlJYYoFQdRF5qzlAmNg1rthg.jpg?imageView2/1/w/750/h/750",
                        @"https://qiniuuwmp3.7mtt.cn/FgTl989sP8gZRhJOlbqCOOLrV5af.jpg?imageView2/1/w/750/h/750",
                        @"https://qiniuuwmp3.7mtt.cn/Fq67Pb3mdw-6FndjFsftOE5CMIgj.jpg?imageView2/1/w/750/h/750",
                        @"https://qiniuuwmp3.7mtt.cn/FoEc8fzE5vA-UZqC7F_6xGwUR6Zf.png?imageView2/1/w/750/h/750",
                        @"https://qiniuuwmp3.7mtt.cn/FnTgCOJfoyjvw7aHB9HmTLzrykJS.jpg?imageView2/1/w/750/h/750"
                        ];

    self.bannerLoopView = [[QMTTLoopBannerView alloc] initWithFrame:CGRectMake(0, 50, BANNER_WIDTH, BANNER_HEIGHT)];
    self.bannerLoopView.delegate = self;
    self.bannerLoopView.itemsCount = self.dataSource.count;
    self.bannerLoopView.pageIndicatorTintColor = UIColor.whiteColor;
    self.bannerLoopView.currentPageIndicatorTintColor = UIColor.orangeColor;
    self.bannerLoopView.timeInterval = 2;
    [self.bannerLoopView reloadData];
    [self.view addSubview:self.bannerLoopView];
}

- (UIView *)loopView:(QMTTLoopBannerView *)loopView itemForIndex:(NSInteger)index reuseId:(NSString *)reuseId {
    UILabel *item = [loopView dequeueReusableItemWithIdentifier:reuseId];
    if (!item) {
        item = [[UILabel alloc] init];
        item.backgroundColor = UIColor.grayColor;
        item.textColor = UIColor.blackColor;
        item.font = [UIFont boldSystemFontOfSize:40];
        item.textAlignment = NSTextAlignmentCenter;
    }
    item.text = [NSString stringWithFormat:@"%ld", index];
    
    return item;
}

- (void)loopView:(QMTTLoopBannerView *)loopView didSelectIndex:(NSInteger)index {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:[NSString stringWithFormat:@"第%ld个item被点击了", index]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

@end
