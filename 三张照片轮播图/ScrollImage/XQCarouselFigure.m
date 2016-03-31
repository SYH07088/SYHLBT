//
//  XQCarouselFigure.m
//  ScrollImage
//
//  Created by 周剑 on 16/2/26.
//  Copyright © 2016年 bukaopu. All rights reserved.
//


#define k_self_width self.frame.size.width
#define k_self_height self.frame.size.height

#import "XQCarouselFigure.h"

@interface XQCarouselFigure ()<UIScrollViewDelegate>

// 三张image实现图片轮播
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

// 记录当前imageview显示图片的下标
@property (nonatomic, assign) NSInteger imageIndex;

// 定时器
@property (nonatomic, strong) NSTimer *timer;

// 回调的block
@property (nonatomic, copy) void (^block) ();

@end

@implementation XQCarouselFigure

// 重写scrollview的init方法,通过这个方法创建三张imageview
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 设置偏移量
        self.contentOffset = CGPointMake(k_self_width, 0);
        // 显示下标赋值
        self.imageIndex = 1;
        // 滚动的范围
        self.contentSize = CGSizeMake(k_self_width * 3, k_self_height);
        
        // 创建并添加视图
        [self createImageView];
        
        // 设置本身的代理
        self.delegate = self;
        
        // 立马执行
        self.pagingEnabled = YES;
    }
    return self;
}

#pragma mark - 创建imageView
- (void)createImageView {
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height)];
    
    // 添加imageview到scrollview
    [self addSubview:self.leftImageView];
    [self addSubview:self.centerImageView];
    [self addSubview:self.rightImageView];
}

#pragma mark - 重写array的setter方法
- (void)setImageArray:(NSArray *)imageArray {
    // 数组赋值
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:imageArray];
    
    id temp = mutableArray.lastObject;
    [mutableArray removeObject:temp];
    [mutableArray insertObject:temp atIndex:0];
    
    _imageArray = mutableArray;
    // 添加image
    _leftImageView.image = _imageArray.firstObject;
    _centerImageView.image = [_imageArray objectAtIndex:1];
    _rightImageView.image = [_imageArray objectAtIndex:2];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

#pragma mark - 实现定时器方法
- (void)timerAction {
    // 设置偏移量
    [self setContentOffset:CGPointMake(k_self_width * 2, 0) animated:YES];
    // 手动调用代理方法
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(timerDidEndAction) userInfo:nil repeats:YES];
}

#pragma mark - 定时器结束开始另一个定时器
- (void)timerDidEndAction {
    [self scrollViewDidEndDecelerating:self];
}


#pragma mark - 实现scrollview的代理方法
// scrollview结束时的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 记录下角标
    NSInteger leftIndex = 0;
    NSInteger rightIndex = 0;
    
    if (scrollView.contentOffset.x == 0) {
        // 向左滑动
        _imageIndex--;
        // 判断当前显示
        if (_imageIndex == 0) {
            leftIndex = _imageArray.count - 1;
            rightIndex = 1;
        }else if (_imageIndex < 0) {
            _imageIndex = _imageArray.count - 1;
            leftIndex = _imageIndex - 1;
            rightIndex = 0;
        }else {
            leftIndex = _imageIndex - 1;
            rightIndex = _imageIndex + 1;
        }
    }else if (scrollView.contentOffset.x == k_self_width * 2) {
        
        // 向右滑动
        _imageIndex++;
        // 判断当前显示
        if (_imageIndex == _imageArray.count - 1) {
            leftIndex = _imageArray.count - 1;
            rightIndex = 0;
        }else if (_imageIndex > _imageArray.count - 1) {
            _imageIndex = 0;
            leftIndex = _imageArray.count - 1;
            rightIndex = _imageIndex + 1;
        }else {
            leftIndex = _imageIndex - 1;
            rightIndex = _imageIndex + 1;
        }
    }else {
        return;
    }
    
    // 保证显示的是中间的imageview
    self.contentOffset = CGPointMake(k_self_width, 0);
    
    // 定时器重新设置时间
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3.0]];
    
    // 图片的重新赋值
    self.leftImageView.image = _imageArray[leftIndex];
    self.centerImageView.image = _imageArray[_imageIndex];
    self.rightImageView.image = _imageArray[rightIndex];
    
}


#pragma mark - 重写touchbegan方法,实现点击触发事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 回调
    if (self.block) {
        self.block();
    }
}

- (void)touchImageIndexBlock:(void (^)(NSInteger))block {
    
     __block XQCarouselFigure *me = self;
    
    // XQCarouselFigure *me = self;
    self.block = ^() {
        if (block) {
            block((me.imageIndex != 0 ? (me.imageIndex - 1) : (me.imageArray.count - 1)));
        }
    };
}


@end
