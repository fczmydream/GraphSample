//
//  FCircleView.m
//  GraphSample
//
//  Created by fcz on 2017/8/8.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#define StrokeWidth 3
#define CircleRadius 105


#import "FCircleView.h"
#import "FStarView.h"

@interface FCircleView () <CAAnimationDelegate>

@property (assign,nonatomic) DataType typeId;
@property (strong,nonatomic) NSArray *colorArray;
@property (strong,nonatomic) UIBezierPath *circlePath;
@property (strong,nonatomic) UIBezierPath *mindPath;
@property (strong,nonatomic) NSMutableArray *progressLayers;
@property (assign,nonatomic) NSInteger currentIndex;
@property (assign,nonatomic) NSInteger animations;

@property (strong,nonatomic) FStarView *starView;
@property (strong,nonatomic) FLabel *valueLabel;
@property (strong,nonatomic) FLabel *unitLabel;
@property (strong,nonatomic) NSString *unit;

@end

@implementation FCircleView

- (id)initWithFrame:(CGRect)frame circleType:(DataType)type
{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:Clear];
        
        _progressLayers = [NSMutableArray arrayWithCapacity:0];
        [self drawUIWithType:type];
    }
    return self;
}

- (void)drawUIWithType:(DataType)typeId
{
    [self configType:typeId];
    
    CGPoint arcCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.circlePath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                     radius:CircleRadius
                                                 startAngle:-M_PI/2
                                                   endAngle:M_PI+M_PI_2
                                                  clockwise:YES];
    self.mindPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                   radius:CircleRadius
                                               startAngle:M_PI+M_PI_2
                                                 endAngle:-M_PI/2
                                                clockwise:NO];
    
    CAShapeLayer *backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.path = self.circlePath.CGPath;
    backgroundLayer.strokeColor = RGB(42, 45, 45).CGColor;
    backgroundLayer.fillColor = [[UIColor clearColor] CGColor];
    backgroundLayer.lineWidth = StrokeWidth;
    [self.layer addSublayer:backgroundLayer];
    
    
    _valueLabel = [[FLabel alloc] initWithFrame:CGRectMake(30, 80, 150, 50) text:@"" alignment:1 textColor:White font:[UIFont fontWithName:@"ADELE" size:55]];
    _valueLabel.numberOfLines = 1;
    _valueLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_valueLabel];
    
    _unitLabel = [[FLabel alloc] initWithFrame:CGRectMake(50, _valueLabel.maxHeight+7, 110, 25) text:@"" alignment:1 textColor:Color(143, 1) font:FontBold(15)];
    [self addSubview:_unitLabel];
}

- (void)configType:(DataType)typeId
{
    _unit = @"";
    _typeId = typeId;
    if(_typeId == DataTypeStep){
        _unit = @"步数";
        _colorArray = @[RGB(71, 239, 115)];
    }else if(_typeId == DataTypeCalorie){
        _unit = @"大卡";
        _colorArray = @[RGB(255, 252, 26),RGB(255, 101, 26)];
    }else if (_typeId == DataTypeExercise){
        _unit = @"活动";
        _colorArray = @[RGB(159, 17, 180),RGB(248, 49, 208),RGB(231, 150, 255)];
    }else if(_typeId == DataTypeMind){
        _unit = @"心情";
        _colorArray = @[RGB(54, 137, 222),RGB(75, 214, 249)];
    }else if(_typeId == DataTypeHeart){
        _unit = @"平均心率";
        _colorArray = @[RGB(250, 53, 104)];
    }else if(_typeId == DataTypeSleep){
        _unit = @"睡眠";
        _colorArray = @[RGB(102, 109, 239),RGB(177, 149, 241)];
    }
}

- (void)setProgressDatas:(NSArray *)datas value:(NSString *)value level:(NSInteger)level
{
    [self removeAnimation];
    for(CAShapeLayer *layer in _progressLayers){
        [layer removeFromSuperlayer];
    }
    [_progressLayers removeAllObjects];
    
    _animations = 0;
    _currentIndex = 0;
    CGFloat strokeProgress = 0.0f;
    CGFloat strokeBegin = 0.0f;
    NSInteger count = datas.count;
    for(NSInteger m=count-1;m>=0;m--)
    {
        strokeProgress += [[datas objectAtIndex:m] floatValue];
    }
    for(NSInteger i=count-1;i>=0;i--)
    {
        if(_typeId == DataTypeMind) strokeProgress = [[datas objectAtIndex:i] floatValue];
        else if(i < count-1) strokeProgress -= [[datas objectAtIndex:i+1] floatValue];
        CGColorRef strokeColor = [[_colorArray objectAtIndex:i] CGColor];
        [self addProgressLayer:strokeBegin progress:strokeProgress strokeColor:strokeColor];
        _currentIndex++;
    }
    
    
    _valueLabel.text = value;
    _unitLabel.text = _unit;
    
    if(!_starView){
        _starView = [[FStarView alloc] initWithFrame:CGRectMake(_valueLabel.x+37.5, _valueLabel.y-32, 75, 14.5) andLevel:level];
        [self addSubview:_starView];
    }else{
        [_starView setY:_valueLabel.y-32];
        [_starView setLevel:level];
    }
    
}

- (void)addProgressLayer:(CGFloat)start progress:(CGFloat)progress strokeColor:(CGColorRef)colorRef
{
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    if(_typeId == DataTypeMind && _currentIndex == 1) progressLayer.path = self.mindPath.CGPath;
    else progressLayer.path = self.circlePath.CGPath;
    progressLayer.strokeColor = colorRef;
    progressLayer.fillColor = [[UIColor clearColor] CGColor];
    progressLayer.lineWidth = StrokeWidth;
    progressLayer.strokeStart = 0.0;
    progressLayer.strokeEnd = start + progress;
    [self.layer addSublayer:progressLayer];
    [self.progressLayers addObject:progressLayer];
    [self addAnimation:progressLayer.strokeStart strokeEnd:progressLayer.strokeEnd];
}

- (void)addAnimation:(CGFloat)strokeStart strokeEnd:(CGFloat)strokeEnd
{
    CAShapeLayer *progressLayer = [_progressLayers objectAtIndex:_currentIndex];
    CABasicAnimation *strokeEndAnimation = nil;
    strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = 1.5;
    strokeEndAnimation.fromValue = @(strokeStart);
    strokeEndAnimation.toValue = @(strokeEnd);
    strokeEndAnimation.autoreverses = NO;
    strokeEndAnimation.repeatCount = 0.f;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    strokeEndAnimation.delegate = self;
    [progressLayer addAnimation:strokeEndAnimation forKey:@"strokeEndAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"FCircleView animationDidStop...%d",flag);
    
    if(flag) _animations++;
    if(_animations == _progressLayers.count && flag){
        [self removeAnimation];
    }
}

- (void)removeAnimation
{
    NSLog(@"FCircleView removeAnimation...");
    
    for (CAShapeLayer *progressLayer in self.progressLayers)
    {
        progressLayer.strokeStart = [progressLayer.presentationLayer strokeStart];
        progressLayer.strokeEnd = [progressLayer.presentationLayer strokeEnd];
        [progressLayer removeAllAnimations];
    }
}

- (void)dealloc
{
    NSLog(@"FCircleView dealloc...");
}


@end
