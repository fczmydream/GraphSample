//
//  FView.m
//  Login
//
//  Created by fcz on 16/5/19.
//  Copyright © 2016年 com.labang. All rights reserved.
//

#import "FView.h"

@implementation FView

-(instancetype)initWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = bgColor;
    }
    return self;
}

@end
