//
//  XQCarouselFigure.h
//  ScrollImage
//
//  Created by 周剑 on 16/2/26.
//  Copyright © 2016年 bukaopu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQCarouselFigure : UIScrollView

// 直接访问的数组,也就是存放图片的数组
@property (nonatomic, strong) NSArray *imageArray;

// 点击回调的方法
- (void)touchImageIndexBlock:(void(^)(NSInteger index))block;

@end
