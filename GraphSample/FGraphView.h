//
//  FGraphView.h
//  GraphSample
//
//  Created by fcz on 2017/8/8.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGraphView : UIView

- (id)initWithFrame:(CGRect)frame graphType:(DataType)graphType dateType:(DateType)dateType;

- (void)setGraphType:(DataType)graphType dateType:(DateType)dateType;

- (void)setMinX:(NSString *)minX maxX:(NSString *)maxX minY:(NSString *)minY maxY:(NSString *)maxY;

- (void)setGraphData:(id)obj andBackHR:(id)obj1;

@end
