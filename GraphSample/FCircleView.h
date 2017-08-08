//
//  FCircleView.h
//  GraphSample
//
//  Created by fcz on 2017/8/8.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCircleView : UIView

- (id)initWithFrame:(CGRect)frame circleType:(DataType)type;

- (void)configType:(DataType)typeId;

- (void)setProgressDatas:(NSArray *)datas value:(NSString *)value level:(NSInteger)level;

@end
