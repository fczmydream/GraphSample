//
//  UIView+Fang.h
//  Login
//
//  Created by fcz on 16/5/19.
//  Copyright © 2016年 com.labang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIViewAutoresizingFlexibleAll (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)


@interface UIView (Fang)

#pragma mark - Frame

#pragma mark 改变x,y,width,height
- (void)setX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

#pragma mark 设置两个view之间的间距
- (void)setXDistance:(CGFloat)xDistance toView:(UIView *)view;
- (void)setYDistance:(CGFloat)yDistance toView:(UIView *)view;

#pragma mari 居中对齐
- (void)setXCenterToView:(UIView *)view;
- (void)setYCenterToView:(UIView *)view;

#pragma mark 全屏居中
- (void)setFrameToScreenCenter;

#pragma mark 获取x+width,y+height
- (CGFloat)maxWidth;
- (CGFloat)maxHeight;

#pragma mark 设置为圆形
- (void)setCircle;

#pragma mark 获取x,y,width,height
- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)x;
- (CGFloat)y;

#pragma mark 打印坐标
- (void)logFrame;


#pragma mark - Often

#pragma mark 将背景向上,向下移动
- (void)moveUpWithDistance:(CGFloat)distance;
- (void)moveDown;

#pragma mark 允许,禁止点击
- (void)allowTouch:(BOOL)isAllow;

#pragma mark 添加到窗口
- (void)addToWindow;

#pragma mark 隐藏显示
- (void)hide;
- (void)show;

- (void)setCornerRadius:(CGFloat)radius
            borderWidth:(CGFloat)width
            borderColor:(UIColor*)color;

#pragma mark - Animation

#pragma mark 从两侧弹出视图
- (void)startShowMenuFromDirection:(BOOL)isLeft;

#pragma mark 收藏后图标变大，向上飘动过程中隐藏
- (void)startCollectAnimation;

#pragma mark 心跳动画
- (void)startHeartAnimation;

#pragma mark 旋转加号
- (void)startSpinAnimation:(BOOL)isAdd;

#pragma mark 同时添加多个视图
- (void)addSubviewArray:(NSArray*)subviews;


- (UIViewController *)viewController;


@end
