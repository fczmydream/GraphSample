//
//  FGraphView.m
//  GraphSample
//
//  Created by fcz on 2017/8/8.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#define Edge 25

#import "FGraphView.h"
#import "GraphCell.h"

@interface FGraphView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CAAnimationDelegate>

@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (assign,nonatomic) DataType graphTypeId;
@property (assign,nonatomic) DateType dateTypeId;
@property (strong,nonatomic) NSArray *colorArray;
@property (strong,nonatomic) CAShapeLayer *shapeLayer;
@property (assign,nonatomic) CGFloat chartH;

@property (strong,nonatomic) UICollectionView *backCollectionView;
@property (strong,nonatomic) NSMutableArray *backDataArray;
@property (assign,nonatomic) CGFloat backItemWidth;

@property (strong,nonatomic) FLabel *minxLabel;
@property (strong,nonatomic) FLabel *midxLabel;
@property (strong,nonatomic) FLabel *maxxLabel;
@property (strong,nonatomic) FLabel *midLeftXL;
@property (strong,nonatomic) FLabel *midRightXL;
@property (strong,nonatomic) FLabel *minYLabel;
@property (strong,nonatomic) FLabel *maxYLabel;
@property (strong,nonatomic) FImageView *midYLine;
@property (strong,nonatomic) FView *legendView; //图例

@property (assign,nonatomic) NSInteger minX;
@property (assign,nonatomic) NSInteger maxX;
@property (assign,nonatomic) NSInteger minY;
@property (assign,nonatomic) NSInteger maxY;
@property (assign,nonatomic) CGFloat itemWidth;


@end

@implementation FGraphView

- (id)initWithFrame:(CGRect)frame graphType:(DataType)graphType dateType:(DateType)dateType
{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:Clear];
        
        _minX = _maxX = -1;
        [self createBaseUI];
        [self setGraphType:graphType dateType:dateType];
    }
    return self;
}

- (void)createBaseUI
{
    _chartH = 85.0f;
    if(SCREEN_HEIGHT == 736) _chartH = 155.0f;
    
    UIColor *baseColor = RGB(69, 69, 69);
    _minxLabel = [[FLabel alloc] initWithFrame:CGRectMake(Edge, 0, 50, 20) text:@"" alignment:0 textColor:baseColor font:Font(10)];
    _minxLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_minxLabel];
    
    _midxLabel = [[FLabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, _minxLabel.y, 50, 20) text:@"" alignment:1 textColor:baseColor font:Font(10)];
    [self addSubview:_midxLabel];
    
    _maxxLabel = [[FLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-Edge-50, _minxLabel.y, 50, 20) text:@"" alignment:2 textColor:baseColor font:Font(10)];
    _maxxLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_maxxLabel];
    
    _midLeftXL = [[FLabel alloc] initWithFrame:CGRectMake(0, _minxLabel.y, 50, 20) text:@"" alignment:1 textColor:baseColor font:Font(10)];
    [self addSubview:_midLeftXL];
    
    _midRightXL = [[FLabel alloc] initWithFrame:CGRectMake(0, _minxLabel.y, 50, 20) text:@"" alignment:1 textColor:baseColor font:Font(10)];
    [self addSubview:_midRightXL];
    
    FView *topLine = [[FView alloc] initWithFrame:CGRectMake(Edge, _minxLabel.maxHeight, SCREEN_WIDTH-Edge*2, 1) bgColor:baseColor];
    [self addSubview:topLine];
    
    FView *bottomLine = [[FView alloc] initWithFrame:CGRectMake(Edge, topLine.maxHeight+_chartH, topLine.width, 1) bgColor:baseColor];
    [self addSubview:bottomLine];
    
    _minYLabel = [[FLabel alloc] initWithFrame:CGRectMake(0, bottomLine.y-10, Edge, 10) text:@"" alignment:1 textColor:baseColor font:Font(7)];
    [self addSubview:_minYLabel];
    
    _maxYLabel = [[FLabel alloc] initWithFrame:CGRectMake(0, topLine.maxHeight, Edge, 10) text:@"" alignment:1 textColor:baseColor font:Font(7)];
    [self addSubview:_maxYLabel];
    
    _midYLine = [[FImageView alloc] initWithFrame:CGRectMake(Edge, topLine.maxHeight+_chartH/2-0.5, topLine.width, 1) contentMode:2 select:nil tag:5];
    _midYLine.image = [UIImage imageNamed:@"midLine"];
    _midYLine.alpha = 0.5;
    _midYLine.hidden = YES;
    [self addSubview:_midYLine];
    
    //心率图例
    _legendView = [[FView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-Edge-40, bottomLine.maxHeight, 40, 10) bgColor:Clear];
    _legendView.hidden = YES;
    [self addSubview:_legendView];
    FView *line = [[FView alloc] initWithFrame:CGRectMake(0, 7, 7, 1) bgColor:RGB(49, 114, 167)];
    [_legendView addSubview:line];
    FLabel *desLabel = [[FLabel alloc] initWithFrame:CGRectMake(10, 2, 30, 10) text:@"最大心率" alignment:1 textColor:Color(125,1) font:Font(10)];
    desLabel.numberOfLines = 1;
    desLabel.adjustsFontSizeToFitWidth = YES;
    [_legendView addSubview:desLabel];
    
}

- (void)setGraphType:(DataType)graphType dateType:(DateType)dateType
{
    _graphTypeId = graphType;
    _dateTypeId = dateType;
    
    [self configTypeColor];
}

- (void)setMinX:(NSString *)minX maxX:(NSString *)maxX minY:(NSString *)minY maxY:(NSString *)maxY
{
    _minxLabel.text = minX;
    _maxxLabel.text = maxX;
    _minYLabel.text = minY;
    _maxYLabel.text = maxY;
    
    _minY = [minY integerValue];
    _maxY = [maxY integerValue];
    
    if(_dateTypeId == DateTypeWeek){
        _minX = 1;
        _maxX = 7;
    }else{
        _minX = [minX integerValue];
        _maxX = [maxX integerValue];
    }
}

- (void)setGraphData:(id)obj andBackHR:(id)obj1
{
    if(!_backDataArray){
        _backDataArray = [NSMutableArray arrayWithCapacity:0];
    }else{
        [_backDataArray removeAllObjects];
    }
    if(_backCollectionView && !obj1){
        [_backCollectionView reloadData];
        [_backCollectionView setHidden:YES];
    }
    if(obj1){
        _backDataArray = [NSMutableArray arrayWithArray:obj1];
        [self createBackCollectionView:0.5f];
    }
    
    
    if(!_dataArray){
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }else{
        [_dataArray removeAllObjects];
    }
    if(_collectionView) [_collectionView reloadData];
    _dataArray = [NSMutableArray arrayWithArray:obj];
    
    if(_shapeLayer){
        [_shapeLayer removeAllAnimations];
        [_shapeLayer removeFromSuperlayer];
        _shapeLayer = nil;
    }
    _midYLine.hidden = YES;
    _legendView.hidden = YES;
    
    if(_minX == -1 && _maxX == -1) return;
    
    if(_graphTypeId == DataTypeHeart) _midYLine.hidden = NO;
    
    
    if(_dateTypeId == DateTypeDay){
        [self drawChartViewByDay];
    }else if(_dateTypeId == DateTypeWeek){
        [self drawChartViewByWeek];
    }else if(_dateTypeId == DateTypeMonth){
        [self drawChartViewByMonth];
    }
}

- (void)configTypeColor
{
    if(_graphTypeId == DataTypeStep){
        _colorArray = @[RGB(71, 239, 115)];
    }else if(_graphTypeId == DataTypeCalorie){
        _colorArray = @[RGB(255, 252, 26),RGB(255, 101, 26)];
    }else if (_graphTypeId == DataTypeExercise){
        _colorArray = @[RGB(159, 17, 180),RGB(248, 49, 208),RGB(231, 150, 255)];
    }else if(_graphTypeId == DataTypeMind){
        _colorArray = @[RGB(54, 137, 222),RGB(75, 214, 249)];
    }else if(_graphTypeId == DataTypeHeart){
        _colorArray = @[RGB(250, 53, 104)];
    }else if(_graphTypeId == DataTypeSleep){
        _colorArray = @[RGB(102, 109, 239),RGB(177, 149, 241)];
    }
}

- (void)drawChartViewByDay
{
    _midLeftXL.text = @"";
    _midRightXL.text = @"";
    _midxLabel.text = @"12";
    [_minxLabel setX:Edge];
    [_minxLabel setTextAlignment:0];
    [_maxxLabel setX:SCREEN_WIDTH-Edge-50];
    [_maxxLabel setTextAlignment:2];
    CGFloat itemWidth = 0;
    if(_graphTypeId == DataTypeSleep || _graphTypeId == DataTypeExercise || _graphTypeId == DataTypeMind){
        [_midxLabel setX:(SCREEN_WIDTH-50)/2];
        if(_graphTypeId == DataTypeSleep) _midxLabel.text = @"";
        itemWidth = 0.5f;
    }else{
        itemWidth = (SCREEN_WIDTH-Edge*2)/[self getDifferenceX:_minX maxX:_maxX];
        CGFloat space = (50.0-itemWidth)/2;
        [_midxLabel setX:Edge+itemWidth*11-space];
    }
    
    if(itemWidth < 0.5) return;
    [self createCollectionView:itemWidth];
}

- (void)drawChartViewByWeek
{
    _midxLabel.text = @"";
    _midLeftXL.text = @"";
    _midRightXL.text = @"";
    CGFloat itemWidth = (SCREEN_WIDTH-Edge*2)/[self getDifferenceX:_minX maxX:_maxX];
    CGFloat space = (50.0-itemWidth)/2;
    [_minxLabel setX:Edge-space];
    [_minxLabel setTextAlignment:1];
    [_maxxLabel setX:Edge+itemWidth*6-space];
    [_maxxLabel setTextAlignment:1];
    
    [self createCollectionView:itemWidth];
    if(_graphTypeId == DataTypeHeart && _dataArray.count > 0){
        [self addAnimationLine];
    }
}

- (void)drawChartViewByMonth
{
    _midxLabel.text = @"";
    _midLeftXL.text = @"10";
    _midRightXL.text = @"20";
    [_minxLabel setX:Edge];
    [_minxLabel setTextAlignment:0];
    [_maxxLabel setX:SCREEN_WIDTH-Edge-50];
    [_maxxLabel setTextAlignment:2];
    CGFloat itemWidth = (SCREEN_WIDTH-Edge*2)/[self getDifferenceX:_minX maxX:_maxX];
    CGFloat space = (50.0-itemWidth)/2;
    [_midLeftXL setX:Edge+itemWidth*9-space];
    [_midRightXL setX:Edge+itemWidth*19-space];
    
    [self createCollectionView:itemWidth];
    if(_graphTypeId == DataTypeHeart && _dataArray.count > 0){
        [self addAnimationLine];
    }
}

- (void)createBackCollectionView:(CGFloat)backItemWidth
{
    _backItemWidth = backItemWidth;
    if(!_backCollectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _backCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(Edge, _minxLabel.maxHeight+1, SCREEN_WIDTH-Edge*2, _chartH) collectionViewLayout:flowLayout];
        _backCollectionView.backgroundColor = Clear;
        _backCollectionView.scrollEnabled = NO;
        _backCollectionView.scrollsToTop = NO;
        _backCollectionView.showsHorizontalScrollIndicator = NO;
        _backCollectionView.delegate = self;
        _backCollectionView.dataSource = self;
        _backCollectionView.transform = CGAffineTransformMakeScale(1.0, -1.0);
        [_backCollectionView registerClass:[GraphCell class] forCellWithReuseIdentifier:@"GraphCell"];
        if(_collectionView){
            [self insertSubview:_backCollectionView belowSubview:_collectionView];
        }else{
            [self addSubview:_backCollectionView];
        }
    }else{
        [_backCollectionView setHidden:NO];
        [_backCollectionView reloadData];
    }
}

- (void)createCollectionView:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(Edge, _minxLabel.maxHeight+1, SCREEN_WIDTH-Edge*2, _chartH) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = Clear;
        _collectionView.scrollEnabled = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.transform = CGAffineTransformMakeScale(1.0, -1.0);
        [_collectionView registerClass:[GraphCell class] forCellWithReuseIdentifier:@"GraphCell"];
        [_collectionView registerClass:[HeartCell class] forCellWithReuseIdentifier:@"HeartCell"];
        [self addSubview:_collectionView];
    }else{
        [_collectionView reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _backCollectionView){
        return _backDataArray.count;
    }
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _backCollectionView){
        GraphCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GraphCell" forIndexPath:indexPath];
        [cell setDictionary:_backDataArray[indexPath.row] colors:@[RGB(42, 45, 45)]];
        
        return cell;
    }
    if(_graphTypeId == DataTypeHeart){
        HeartCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeartCell" forIndexPath:indexPath];
        CGFloat minH = [[[_dataArray objectAtIndex:indexPath.row] objectAtIndex:0] floatValue] * _chartH;
        CGFloat maxH = [[[_dataArray objectAtIndex:indexPath.row] objectAtIndex:1] floatValue] * _chartH;
        [cell setHeartMinH:minH maxH:maxH];
        
        return cell;
    }else{
        GraphCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GraphCell" forIndexPath:indexPath];
        if(_dateTypeId == DateTypeDay && (_graphTypeId == DataTypeSleep || _graphTypeId == DataTypeExercise || _graphTypeId == DataTypeMind)){
            NSMutableArray *colors = [NSMutableArray arrayWithCapacity:0];
            [colors addObject:RGB(42, 45, 45)];
            for(int i=0;i<_colorArray.count;i++){
                [colors addObject:_colorArray[i]];
            }
            [cell setDictionary:_dataArray[indexPath.row] colors:colors];
        }else{
            [cell setGraphCellType:_dateTypeId colors:_colorArray heights:[_dataArray objectAtIndex:indexPath.row]];
        }
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _backCollectionView){
        return CGSizeMake(_backItemWidth, _chartH);
    }
    return CGSizeMake(_itemWidth, _chartH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)getDifferenceX:(NSInteger)minX maxX:(NSInteger)maxX
{
    NSInteger difference = 1;
    if(maxX > minX){
        difference = maxX - minX;
    }else if(maxX < minX){
        difference = 24 - minX + maxX;
    }
    if(_dateTypeId != DateTypeDay){
        difference++;
    }
    return difference;
}

- (NSInteger)getDifferenceY:(NSInteger)minY maxY:(NSInteger)maxY
{
    NSInteger difference = 1;
    if(maxY > minY){
        difference = maxY - minY;
    }
    return difference;
}

- (void)addAnimationLine
{
    // 创建layer并设置属性
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth = 1.0f;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.lineJoin = kCALineJoinRound;
    _shapeLayer.strokeColor = RGB(49, 114, 167).CGColor;
    [_collectionView.layer addSublayer:_shapeLayer];
    
    // 创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSInteger points = 0;
    for(NSInteger i=0;i<_dataArray.count;i++){
        CGFloat pointX = _itemWidth * i + _itemWidth / 2;
        CGFloat pointY = [[[_dataArray objectAtIndex:i] lastObject] floatValue] * _chartH;
        if(pointY == 0) continue;
        if(points == 0){
            [path moveToPoint:CGPointMake(pointX, pointY+2)];
        }else{
            [path addLineToPoint:CGPointMake(pointX, pointY+2)];
        }
        points++;
    }
    
    if(points > 1) _legendView.hidden = NO;
    
    
    // 关联layer和贝塞尔路径
    _shapeLayer.path = path.CGPath;
    
    // 创建Animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.autoreverses = NO;
    animation.duration = 2.0;
    animation.delegate = self;
    
    // 设置layer的animation
    [_shapeLayer addAnimation:animation forKey:nil];
    
    // 第一种设置动画完成,不移除结果的方法
    //    animation.fillMode = kCAFillModeForwards;
    //    animation.removedOnCompletion = NO;
    
    // 第二种
    _shapeLayer.strokeEnd = 1;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag) [_shapeLayer removeAllAnimations];
}

- (void)dealloc
{
    NSLog(@"FGraphView dealloc...");
}

@end
