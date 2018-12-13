//
//  UIGestureRecognizer+KZ_Identifier.m
//  QMTTBannerLoopDemo
//
//  Created by pengkezhu on 2018/12/13.
//  Copyright © 2018 Kevin. All rights reserved.
//

#import "UIGestureRecognizer+KZ_Identifier.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (KZ_Identifier)

- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, @selector(setIdentifier:), identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)identifier {
    return objc_getAssociatedObject(self, @selector(setIdentifier:));
}

@end
