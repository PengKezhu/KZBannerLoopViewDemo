//
//  QMTTLoopBannerView.h
//  LoopBannersDemo
//
//  Created by pengkezhu on 2018/12/7.
//  Copyright © 2018 彭柯柱. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QMTTLoopBannerView;
@protocol QMTTLoopBannerViewDelegate <NSObject>

- (UIView *)loopView:(QMTTLoopBannerView *)loopView itemForIndex:(NSInteger)index reuseId:(NSString *)reuseId;

@end

@interface QMTTLoopBannerView : UIView

@property (nonatomic, assign) NSInteger itemsCount;//item的总数量

@property (nonatomic, weak) id <QMTTLoopBannerViewDelegate> delegate;

- (__kindof UIView *)dequeueReusableItemWithIdentifier:(NSString *)identifier;//复用，用法类似UITableView

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
