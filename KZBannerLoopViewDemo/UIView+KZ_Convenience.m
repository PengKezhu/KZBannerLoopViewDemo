//
//  UIView+KZ_Convenience.m
//  QMTTBannerLoopDemo
//
//  Created by pengkezhu on 2018/12/13.
//  Copyright © 2018 Kevin. All rights reserved.
//

#import "UIView+KZ_Convenience.h"

@implementation UIView (KZ_Convenience)

- (void)kz_setX:(CGFloat)originX {
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (void)kz_setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - CGRectGetHeight(self.frame);
    self.frame = frame;
}

- (void)kz_setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)kz_setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

@end
