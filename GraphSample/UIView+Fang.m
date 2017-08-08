//
//  UIView+Fang.m
//  Login
//
//  Created by fcz on 16/5/19.
//  Copyright © 2016年 com.labang. All rights reserved.
//

#import "UIView+Fang.h"
#import "AppDelegate.h"

@implementation UIView (Fang)

#pragma mark 全屏居中
- (void)setFrameToScreenCenter
{
    [self setFrame:CGRectMake(0, -(SCREEN_HEIGHT-SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

#pragma mark 获取x,y,width,height
- (CGFloat)x
{
    return CGRectGetMinX([self frame]);
}

- (CGFloat)y
{
    return CGRectGetMinY([self frame]);
}

- (CGFloat)width
{
    return CGRectGetWidth([self frame]);
}

- (CGFloat)height
{
    return CGRectGetHeight([self frame]);
}

#pragma mark 改变x,y,width,height
- (void)setX:(CGFloat)x
{
    CGRect frame = [self frame];
    frame.origin.x = x;
    [self setFrame:frame];
}

- (void)setY:(CGFloat)y
{
    CGRect frame = [self frame];
    frame.origin.y = y;
    [self setFrame:frame];
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = [self frame];
    frame.size.width = width;
    [self setFrame:frame];
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = [self frame];
    frame.size.height = height;
    [self setFrame:frame];
}

- (void)setX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    [self setFrame:CGRectMake(x, y, width, height)];
}

#pragma mark 获取y+height,x+width
- (CGFloat)maxWidth
{
    return [self x]+[self width];
}

- (CGFloat)maxHeight
{
    return [self y]+[self height];
}

#pragma mark 打印坐标
- (void)logFrame {
    NSLog(@"frame = %@", NSStringFromCGRect([self frame]));
}

#pragma mark 设置为圆形
- (void)setCircle {
    [[self layer] setCornerRadius:[self width]/2];
}
- (void)setCornerRadius:(CGFloat)radius
            borderWidth:(CGFloat)width
            borderColor:(UIColor*)color{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}
#pragma mark 隐藏显示
- (void)hide
{
    [self setHidden:YES];
}

- (void)show
{
    [self setHidden:NO];
}

#pragma mark 设置两个view之间的间距
- (void)setXDistance:(CGFloat)xDistance toView:(UIView *)view
{
    if (xDistance == 0)
    {
        return;
    }
    else if (xDistance > 0)
    {
        [self setX:[view x]+[view width]+xDistance];
    }
    else
    {
        [self setX:[view x]-[self width]+xDistance];
    }
}

- (void)setYDistance:(CGFloat)yDistance toView:(UIView *)view
{
    if (yDistance == 0)
    {
        return;
    }
    else if (yDistance > 0)
    {
        [self setY:[view y]+[view height]+yDistance];
    }
    else
    {
        [self setY:[view y]-[self height]+yDistance];
    }
}

#pragma mari 居中对齐
- (void)setXCenterToView:(UIView *)view
{
    [self setX:([view width]-[self width])/2+[view x]];
}

- (void)setYCenterToView:(UIView *)view
{
    [self setY:([view height]-[self height])/2+[view x]];
}

#pragma mark 允许,禁止点击
- (void)allowTouch:(BOOL)isAllow
{
    if (isAllow)
    {
        [self setUserInteractionEnabled:YES];
    }
    else
    {
        [self setUserInteractionEnabled:NO];
    }
}

#pragma mark 添加到窗口
- (void)addToWindow {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[appDelegate window] addSubview:self];
}


#pragma mark 将背景向上,向下移动
- (void)moveUpWithDistance:(CGFloat)distance
{
    [UIView animateWithDuration:0.25 animations:^
     {
         [self setY:distance];
     }];
}

- (void)moveDown
{
    if ([self y] != 0)
    {
        [UIView animateWithDuration:0.25 animations:^
         {
             [self setY:0];
         }];
    }
}



#pragma mark 心跳动画
- (void)startHeartAnimation
{
    [UIView animateWithDuration:0.2 animations:^
     {
         [self setTransform:CGAffineTransformMakeScale(1.3, 1.3)];
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.3 animations:^
          {
              [self setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.2 animations:^
               {
                   [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
               }];
          }];
     }];
}

#pragma mark 收藏后图标变大，向上飘动过程中隐藏
- (void)startCollectAnimation
{
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    __block CGRect frame = self.frame;
    
    [UIView animateWithDuration:0.6 animations:^
     {
         frame.origin.y -= 40;
         self.frame = frame;
         
         self.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         self.transform = CGAffineTransformMakeScale(1.0, 1.0);
         self.alpha = 1;
         
         frame.origin.y += 40;
         self.frame = frame;
     }];
}

#pragma mark 从两侧弹出视图
- (void)startShowMenuFromDirection:(BOOL)isLeft
{
    self.alpha = 0.2;
    
    __block CGRect selfFrame = self.frame;
    
    if (isLeft)
    {
        selfFrame.origin.x -= selfFrame.size.width;
    }
    else
    {
        selfFrame.origin.x += selfFrame.size.width;
    }
    self.frame = selfFrame;
    
    [UIView animateWithDuration:0.3 animations:^
     {
         [UIView setAnimationCurve:1];
         self.alpha = 0.4;
         
         if (isLeft)
         {
             selfFrame.origin.x += selfFrame.size.width*2;
         }
         else
         {
             selfFrame.origin.x -= selfFrame.size.width*2;
         }
         self.frame = selfFrame;
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              if (isLeft)
              {
                  selfFrame.origin.x -= selfFrame.size.width+40;
              }
              else
              {
                  selfFrame.origin.x += selfFrame.size.width+40;
              }
              self.frame = selfFrame;
              
              self.alpha = 0.6;
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.1 animations:^
               {
                   [UIView setAnimationCurve:2];
                   if (isLeft)
                   {
                       selfFrame.origin.x += 40;
                   }
                   else
                   {
                       selfFrame.origin.x -= 40;
                   }
                   self.frame = selfFrame;
                   
                   self.alpha = 1;
               }];
          }];
     }];
}

#pragma mark 旋转加号
- (void)startSpinAnimation:(BOOL)isAdd {
    [UIView animateWithDuration:0.25 animations:^{
        if (isAdd) {
            [self setTransform:CGAffineTransformRotate([self transform], M_PI+M_PI_4)];
        } else {
            [self setTransform:CGAffineTransformRotate([self transform], M_PI-M_PI_4)];
        }
    }];
}
#pragma mark 同时添加多个视图
- (void)addSubviewArray:(NSArray *)subviews{
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:view];
    }];
}

- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

@end
