//
//  FStarView.m
//  GraphSample
//
//  Created by fcz on 2017/8/8.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#define StarWidth 13
#define MaxStar 5

#import "FStarView.h"

@interface FStarView () <CAAnimationDelegate>

@property (strong,nonatomic) NSMutableArray *stars;

@end

@implementation FStarView

- (id)initWithFrame:(CGRect)frame andLevel:(NSInteger)level
{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:Clear];
        
        _stars = [NSMutableArray arrayWithCapacity:0];
        [self setLevel:level];
    }
    return self;
}

- (void)setLevel:(NSInteger)level
{
    [self removeAnimation];
    for(FImageView *imageView in self.subviews){
        [imageView removeFromSuperview];
    }
    [_stars removeAllObjects];
    
    CGFloat space = (self.width-StarWidth*MaxStar)/(MaxStar-1);
    CGFloat levelWidth = level*StarWidth+(level-1)*space;
    CGFloat startX = (self.width-levelWidth)/2;
    CGFloat levelY = (self.height-12.5)/2;
    for(int i=0;i<level;i++){
        CGFloat levelX = startX+(StarWidth+space)*i;
        FImageView *starImageView = [[FImageView alloc] initWithFrame:CGRectMake(levelX, levelY, StarWidth, 12.5) contentMode:2 select:nil tag:i];
        [starImageView setImage:[UIImage imageNamed:@"star_level"]];
        [starImageView setAlpha:0];
        [_stars addObject:starImageView];
        [self addSubview:starImageView];
    }
    
    [self startAnimation];
}

- (void)startAnimation
{
    if(_stars.count == 0){
        [self removeAnimation];
        return;
    }
    
    FImageView *imageView = [_stars objectAtIndex:0];
    [self addAnimation:imageView];
    [UIView animateWithDuration:0.2 animations:^{
        imageView.alpha = 1;
    } completion:^(BOOL finished) {
        if(_stars.count > 0){
            [_stars removeObjectAtIndex:0];
        }
        [self startAnimation];
    }];
    
}

- (void)addAnimation:(FImageView *)imageView
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    animation.delegate = self;
    [imageView.layer addAnimation:animation forKey:@"animation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"FStarView animationDidStop...%d",flag);
}

- (void)removeAnimation
{
    for(FImageView *imageView in self.subviews){
        [imageView.layer removeAllAnimations];
    }
}

- (void)dealloc
{
    NSLog(@"FStarView dealloc...");
}


@end
