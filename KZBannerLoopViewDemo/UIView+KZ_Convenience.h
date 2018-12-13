//
//  UIView+KZ_Convenience.h
//  QMTTBannerLoopDemo
//
//  Created by pengkezhu on 2018/12/13.
//  Copyright © 2018 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (KZ_Convenience)

- (void)kz_setX:(CGFloat)originX;
- (void)kz_setBottom:(CGFloat)bottom;
- (void)kz_setCenterX:(CGFloat)centerX;
- (void)kz_setSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
