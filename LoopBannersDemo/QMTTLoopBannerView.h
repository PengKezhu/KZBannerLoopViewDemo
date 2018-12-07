//
//  QMTTLoopBannerView.h
//  LoopBannersDemo
//
//  Created by pengkezhu on 2018/12/7.
//  Copyright © 2018 彭柯柱. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMTTLoopBannerView : UIView

@property (nonatomic, copy) NSArray *imgs;//可以是NSData, imgUrlString, imageURL, UIImage
@property (nonatomic, copy) NSString *placeholderImg;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
