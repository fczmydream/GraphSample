//
//  ViewController.m
//  GraphSample
//
//  Created by fcz on 2017/8/8.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import "ViewController.h"
#import "FCircleView.h"
#import "FGraphView.h"

@interface ViewController ()

@property (nonatomic,strong) FCircleView *circleView;
@property (nonatomic,strong) FGraphView *graphView;
@property (nonatomic,assign) NSInteger graphType;
@property (nonatomic,assign) NSInteger dateType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = RGB(24, 28, 31);
    self.navigationItem.title = @"GraphSample";
    
    UIButton *graphButton = [UIButton buttonWithType:UIButtonTypeCustom];
    graphButton.frame = CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT-50, 100, 50);
    [graphButton setTitle:@"切换数据类型" forState:UIControlStateNormal];
    [graphButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [graphButton.titleLabel setFont:Font(13)];
    [graphButton addTarget:self action:@selector(graphAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:graphButton];
    
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-50, 100, 50);
    [dateButton setTitle:@"切换时间类型" forState:UIControlStateNormal];
    [dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dateButton.titleLabel setFont:Font(13)];
    [dateButton addTarget:self action:@selector(dateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dateButton];
    
    _graphType = _dateType = 0;
    
    _circleView = [[FCircleView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-210)/2, 130, 210, 210) circleType:_graphType];
    [self.view addSubview:_circleView];
    
    _graphView = [[FGraphView alloc] initWithFrame:CGRectMake(0, _circleView.maxHeight+50, SCREEN_WIDTH, 150) graphType:_graphType dateType:_dateType];
    [self.view addSubview:_graphView];
    
    [self reloadUI];
}

- (void)graphAction
{
    if(_graphType == 5) _graphType = 0;
    else _graphType++;
    
    [self reloadUI];
}

- (void)dateAction
{
    if(_dateType == 2) _dateType = 0;
    else _dateType++;
    
    [self reloadUI];
}

- (void)reloadUI
{
    NSDictionary *resultDic = [self getTestDatas];
    NSDictionary *circleDic = [resultDic objectForKey:@"circle"];
    //圆环
    [_circleView configType:_graphType];
    [_circleView setProgressDatas:[circleDic objectForKey:@"progress"] value:[circleDic objectForKey:@"value"] level:[[circleDic objectForKey:@"level"] integerValue]];
    //图表
    [_graphView setGraphType:_graphType dateType:_dateType];
    if(_dateType == 0){
        [_graphView setMinX:@"0" maxX:@"24" minY:@"" maxY:@""];
    }else if(_dateType == 1){
        [_graphView setMinX:@"1" maxX:@"7" minY:@"" maxY:@""];
    }else if(_dateType == 2){
        [_graphView setMinX:@"1" maxX:@"30" minY:@"" maxY:@""];
    }
    NSArray *graphData = [resultDic objectForKey:@"graph"];
    NSArray *backHRData = [resultDic objectForKey:@"backHR"];
    [_graphView setGraphData:graphData andBackHR:backHRData];
}

- (NSDictionary *)getTestDatas
{
    NSDictionary *circleDic = @{};
    NSMutableArray *graphArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *backHR = [NSMutableArray arrayWithCapacity:0];
    NSInteger count = 24;
    if(_dateType == 1) count = 7;
    else if(_dateType == 2) count = 30;
    
    if(_graphType == 0){
        circleDic = @{@"progress":@[@0.5],@"value":@"6900",@"level":@"5"};
        for(NSInteger i=0;i<count;i++){
            CGFloat rate = (arc4random() % 10 + 1) / 10.0;
            [graphArray addObject:@[[NSNumber numberWithFloat:rate]]];
        }
        if(_dateType == 0){
            for(NSInteger i=0;i<325*2;i++){
                CGFloat rate = (arc4random() % 10 + 1) / 10.0;
                [backHR addObject:@{@"h":[NSNumber numberWithFloat:rate],@"tag":[NSNumber numberWithFloat:0]}];
            }
        }else{
            backHR = nil;
        }
    }else if(_graphType == 1){
        circleDic = @{@"progress":@[@0.3,@0.2,@0.2],@"value":@"06:00",@"level":@"3"};
        if(_dateType == 0){
            for(NSInteger i=0;i<325*2;i++){
                CGFloat rate = (arc4random() % 10 + 1) / 10.0;
                CGFloat tag = arc4random() % 4;
                [graphArray addObject:@{@"h":[NSNumber numberWithFloat:rate],@"tag":[NSNumber numberWithFloat:tag]}];
            }
        }else{
            for(NSInteger i=0;i<count;i++){
                CGFloat rate = (arc4random() % 10 + 1) / 10.0 / 3;
                [graphArray addObject:@[[NSNumber numberWithFloat:rate],[NSNumber numberWithFloat:rate],[NSNumber numberWithFloat:rate]]];
            }
        }
        backHR = nil;
    }else if(_graphType == 2){
        circleDic = @{@"progress":@[@0.35,@0.25],@"value":@"3200",@"level":@"4"};
        for(NSInteger i=0;i<count;i++){
            CGFloat rate = (arc4random() % 10 + 1) / 10.0 / 2;
            [graphArray addObject:@[[NSNumber numberWithFloat:rate],[NSNumber numberWithFloat:rate]]];
        }
        if(_dateType == 0){
            for(NSInteger i=0;i<325*2;i++){
                CGFloat rate = (arc4random() % 10 + 1) / 10.0;
                [backHR addObject:@{@"h":[NSNumber numberWithFloat:rate],@"tag":[NSNumber numberWithFloat:0]}];
            }
        }else{
            backHR = nil;
        }
    }else if(_graphType == 3){
        circleDic = @{@"progress":@[@0.5,@0.2],@"value":@"9:00",@"level":@"5"};
        if(_dateType == 0){
            for(NSInteger i=0;i<325*2;i++){
                CGFloat rate = (arc4random() % 10 + 1) / 10.0;
                CGFloat tag = arc4random() % 3;
                [graphArray addObject:@{@"h":[NSNumber numberWithFloat:rate],@"tag":[NSNumber numberWithFloat:tag]}];
            }
        }else{
            for(NSInteger i=0;i<count;i++){
                CGFloat rate = (arc4random() % 10 + 1) / 10.0 / 2;
                [graphArray addObject:@[[NSNumber numberWithFloat:rate],[NSNumber numberWithFloat:rate]]];
            }
        }
        backHR = nil;
    }else if(_graphType == 4){
        circleDic = @{@"progress":@[@0.5],@"value":@"76",@"level":@"5"};
        for(NSInteger i=0;i<count;i++){
            CGFloat rate = (arc4random() % 10 + 1) / 10.0 / 2;
            [graphArray addObject:@[[NSNumber numberWithFloat:rate],[NSNumber numberWithFloat:rate*2]]];
        }
        backHR = nil;
    }else if(_graphType == 5){
        circleDic = @{@"progress":@[@0.25,@0.5],@"value":@"10:00",@"level":@"2"};
        for(NSInteger i=0;i<325*2;i++){
            CGFloat rate = (arc4random() % 10 + 1) / 10.0;
            CGFloat tag = arc4random() % 3;
            [graphArray addObject:@{@"h":[NSNumber numberWithFloat:rate],@"tag":[NSNumber numberWithFloat:tag]}];
        }
    }else{
        for(NSInteger i=0;i<count;i++){
            CGFloat rate = (arc4random() % 10 + 1) / 10.0 / 2;
            [graphArray addObject:@[[NSNumber numberWithFloat:rate],[NSNumber numberWithFloat:rate]]];
        }
        backHR = nil;
    }
    
    NSDictionary *resultDic = @{@"circle":circleDic,@"graph":graphArray};
    if(backHR) resultDic = @{@"circle":circleDic,@"graph":graphArray,@"backHR":backHR};
    
    return resultDic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
