//
//  ViewController.m
//  LoopBannersDemo
//
//  Created by 彭柯柱 on 2018/12/6.
//  Copyright © 2018 彭柯柱. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, assign) CGFloat preOffsetX;

@property (nonatomic, assign) int leftIndex;
@property (nonatomic, assign) int rightIndex;

@property (nonatomic, assign) BOOL isLeft;

@end

#define BANNER_WIDTH self.view.bounds.size.width
#define BANNER_HEIGHT 300

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.leftIndex = 1;
    self.rightIndex = 3;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, BANNER_WIDTH, BANNER_HEIGHT)];
    self.scrollView.backgroundColor = UIColor.grayColor;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(BANNER_WIDTH * 3, BANNER_HEIGHT);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView setContentOffset:CGPointMake(BANNER_WIDTH, 0)];
    
    self.label1 = [self createLabel:1];
    self.label2 = [self createLabel:2];
    self.label3 = [self createLabel:3];
}

- (UILabel *)createLabel:(int)index {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((index-1) * BANNER_WIDTH, 0, BANNER_WIDTH, BANNER_HEIGHT)];
    label.textColor = UIColor.whiteColor;
    label.font = [UIFont boldSystemFontOfSize:40];
    label.text = [NSString stringWithFormat:@"%d", index];
    label.textAlignment = NSTextAlignmentCenter;
    if (index == 1) {
        label.backgroundColor = UIColor.redColor;
    } else if (index == 2) {
        label.backgroundColor = UIColor.greenColor;
    } if (index == 3) {
        label.backgroundColor = UIColor.blackColor;
    }
    [self.scrollView addSubview:label];
    return label;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX <= 0) {
        if (!self.isLeft) {
            switch (self.rightIndex+1) {
                case 4:
                    self.leftIndex = 1;
                    break;
                case 5:
                    self.leftIndex = 3;
                    break;
                case 6:
                    self.leftIndex = 2;
                    break;
                default:
                    break;
            }
        }
        switch (self.leftIndex) {
            case 1:
            {
                [self changeView:self.label1 x:BANNER_WIDTH];
                [self changeView:self.label2 x:BANNER_WIDTH * 2];
                [self changeView:self.label3 x:BANNER_WIDTH * 0];
            }
                break;
            case 2:
            {
                [self changeView:self.label3 x:BANNER_WIDTH];
                [self changeView:self.label1 x:BANNER_WIDTH * 2];
                [self changeView:self.label2 x:BANNER_WIDTH * 0];
            }
                break;
            case 3:
            {
                [self changeView:self.label2 x:BANNER_WIDTH];
                [self changeView:self.label3 x:BANNER_WIDTH * 2];
                [self changeView:self.label1 x:BANNER_WIDTH * 0];
            }
                break;

            default:
                break;
        }
        [scrollView setContentOffset:CGPointMake(BANNER_WIDTH, 0)];
        self.leftIndex++;
        if (self.leftIndex % 4 == 0) {
            self.leftIndex = 1;
        }
        self.isLeft = YES;
    } else if (offsetX >= 2 * BANNER_WIDTH) {
        if (self.isLeft) {
            switch (self.leftIndex-1) {
                case 1:
                    self.rightIndex = 5;
                    break;
                case 2:
                    self.rightIndex = 4;
                    break;
                case 0:
                    self.rightIndex = 3;
                    break;
                default:
                    break;
            }
        }
        switch (self.rightIndex) {
            case 5:
            {
                [self changeView:self.label2 x:BANNER_WIDTH];
                [self changeView:self.label3 x:BANNER_WIDTH * 2];
                [self changeView:self.label1 x:BANNER_WIDTH * 0];
                
            }
                break;
            case 4:
            {
                [self changeView:self.label1 x:BANNER_WIDTH];
                [self changeView:self.label2 x:BANNER_WIDTH * 2];
                [self changeView:self.label3 x:BANNER_WIDTH * 0];
                
            }
                break;
            case 3:
            {
                [self changeView:self.label3 x:BANNER_WIDTH];
                [self changeView:self.label1 x:BANNER_WIDTH * 2];
                [self changeView:self.label2 x:BANNER_WIDTH * 0];
            }
                break;
                
            default:
                break;
        }
        [scrollView setContentOffset:CGPointMake(BANNER_WIDTH, 0)];
        self.rightIndex++;
        if (self.rightIndex % 6 == 0) {
            self.rightIndex = 3;
        }
        self.isLeft = NO;
    }
    self.preOffsetX = scrollView.contentOffset.x;
}

- (void)changeView:(UIView *)view x:(CGFloat)newX {
    CGRect frame = view.frame;
    frame.origin.x = newX;
    view.frame = frame;
}

- (void)reloadLable:(UILabel *)label index:(int)index {
    if (index == 1) {
        label.backgroundColor = UIColor.redColor;
    } else if (index == 2) {
        label.backgroundColor = UIColor.greenColor;
    } if (index == 3) {
        label.backgroundColor = UIColor.blackColor;
    }

}

@end
