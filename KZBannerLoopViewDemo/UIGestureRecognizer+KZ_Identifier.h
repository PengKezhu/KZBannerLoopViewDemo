//
//  UIGestureRecognizer+KZ_Identifier.h
//  QMTTBannerLoopDemo
//
//  Created by pengkezhu on 2018/12/13.
//  Copyright © 2018 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (KZ_Identifier)
@property (nonatomic, copy) NSString *identifier;
@end

NS_ASSUME_NONNULL_END
