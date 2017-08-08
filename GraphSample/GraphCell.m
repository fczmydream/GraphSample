//
//  GraphCell.m
//  GraphSample
//
//  Created by fcz on 2017/8/8.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import "GraphCell.h"

@interface GraphCell ()

@property (strong,nonatomic) FView *graphView;
@property (strong,nonatomic) FView *graphMidView;
@property (strong,nonatomic) FView *graphTopView;

@end

@implementation GraphCell

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self.contentView setBackgroundColor:Clear];
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _graphView = [[FView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) bgColor:Clear];
    [self.contentView addSubview:_graphView];
    
    _graphMidView = [[FView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) bgColor:Clear];
    [self.contentView addSubview:_graphMidView];
    
    _graphTopView = [[FView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) bgColor:Clear];
    [self.contentView addSubview:_graphTopView];
}

- (void)setGraphCellType:(DateType)typeId colors:(NSArray *)colors heights:(NSArray *)heights
{
    CGFloat graphWidth = 10.0f;
    CGFloat H = self.height;
    if(typeId == DateTypeMonth){
        if(SCREEN_WIDTH == 320){
            graphWidth = 5.0f;
        }else if(SCREEN_WIDTH == 375){
            graphWidth = 7.5f;
        }
    }else if(typeId == DateTypeDay){
        if(SCREEN_WIDTH == 320){
            graphWidth = 7.5f;
        }
    }else if(typeId == DateTypeWeek){
        if(SCREEN_WIDTH != 320){
            graphWidth = 20.0f;
        }
    }
    CGFloat graphX = (self.width-graphWidth)/2;
    [_graphView setBackgroundColor:colors[0]];
    [_graphView setFrame:CGRectMake(graphX, 0, graphWidth, 0)];
    [_graphMidView setFrame:CGRectMake(graphX, 0, graphWidth, 0)];
    [_graphTopView setFrame:CGRectMake(graphX, 0, graphWidth, 0)];
    if(colors.count == 1 && heights.count == 1){
        [UIView animateWithDuration:1.0 animations:^{
            [_graphView setHeight:[heights[0] floatValue] * H];
        }];
    }else if(colors.count == 2 && heights.count == 2){
        [_graphMidView setBackgroundColor:colors[1]];
        [_graphMidView setFrame:CGRectMake(graphX, [heights[0] floatValue] * H, graphWidth, 0)];
        [UIView animateWithDuration:0.5 animations:^{
            [_graphView setHeight:[heights[0] floatValue] * H];
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [_graphMidView setHeight:[heights[1] floatValue] * H];
        }];
    }else if(colors.count == 3 && heights.count == 3){
        [_graphMidView setBackgroundColor:colors[1]];
        [_graphMidView setFrame:CGRectMake(graphX, [heights[0] floatValue] * H, graphWidth, 0)];
        [_graphTopView setBackgroundColor:colors[2]];
        [_graphTopView setFrame:CGRectMake(graphX, [heights[0] floatValue] * H + [heights[1] floatValue] * H, graphWidth, 0)];
        [UIView animateWithDuration:0.5 animations:^{
            [_graphView setHeight:[heights[0] floatValue] * H];
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [_graphMidView setHeight:[heights[1] floatValue] * H];
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [_graphTopView setHeight:[heights[2] floatValue] * H];
        }];
    }
}

- (void)setDictionary:(NSDictionary *)dic colors:(NSArray *)colors
{
    [_graphView setFrame:CGRectMake(0, 0, self.width, 0)];
    [_graphMidView setFrame:CGRectMake(0, 0, self.width, 0)];
    [_graphTopView setFrame:CGRectMake(0, 0, self.width, 0)];
    CGFloat height = [[dic objectForKey:@"h"] floatValue] * self.height;
    NSInteger tag = [[dic objectForKey:@"tag"] integerValue];
    UIColor *color = [colors objectAtIndex:tag];
    _graphView.backgroundColor = color;
    [UIView animateWithDuration:1.0f animations:^{
        _graphView.height = height;
    }];
}


@end




@interface HeartCell ()

@property (strong,nonatomic) FView *heartView;
@property (strong,nonatomic) FImageView *maxCircle;
@property (strong,nonatomic) FImageView *minCircle;
@property (assign,nonatomic) CGFloat heartX;

@end

@implementation HeartCell

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:Clear];
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _heartX = (self.width-5)/2;
    _heartView = [[FView alloc] initWithFrame:CGRectMake(_heartX, 0, 5, 0) bgColor:RGBA(109, 56, 63, 0.5)];
    [self.contentView addSubview:_heartView];
    
    _minCircle = [[FImageView alloc] initWithFrame:CGRectMake(_heartX+0.5, 0, 4, 4) contentMode:2 select:nil tag:1];
    _minCircle.image = [UIImage imageNamed:@"heart_circle"];
    [self.contentView addSubview:_minCircle];
    
    _maxCircle = [[FImageView alloc] initWithFrame:CGRectMake(_heartX+0.5, 0, 4, 4) contentMode:2 select:nil tag:1];
    _maxCircle.image = [UIImage imageNamed:@"heart_circle"];
    [self.contentView addSubview:_maxCircle];
}

- (void)setHeartMinH:(CGFloat)minH maxH:(CGFloat)maxH
{
    _heartX = (self.width-5)/2;
    [_heartView setFrame:CGRectMake(_heartX, minH, 5, 0)];
    [_minCircle setFrame:CGRectMake(_heartX+0.5, minH, 4, 4)];
    [_maxCircle setFrame:CGRectMake(_heartX+0.5, minH, 4, 4)];
    _minCircle.hidden = maxH <= 0;
    _maxCircle.hidden = maxH <= minH;
    if(_maxCircle.hidden) return;
    
    CGFloat height = maxH - minH > 10 ? maxH - minH : 10;
    CGFloat maxY = minH + height - 4;
    [UIView animateWithDuration:1.0 animations:^{
        [_heartView setHeight:height];
        [_maxCircle setY:maxY];
    }];
}

@end

