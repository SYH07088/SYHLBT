//
//  ViewController.m
//  ScrollImage
//
//  Created by 周剑 on 16/2/26.
//  Copyright © 2016年 bukaopu. All rights reserved.
//

#import "ViewController.h"
#import "XQCarouselFigure.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%02d.jpg", i]];
        
        [imageArray addObject:image];
    }
    
    XQCarouselFigure *xq  = [[XQCarouselFigure alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 200)];
    xq.imageArray = imageArray;
    
    //  block 的实现
    [xq touchImageIndexBlock:^(NSInteger index) {
        NSLog(@"%ld", index);
    }];
    
    [self.view addSubview:xq];
    
}

@end
