//
//  FLabel.h
//  Login
//
//  Created by fcz on 16/5/19.
//  Copyright © 2016年 com.labang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLabel : UILabel
- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString*)text
                    alignment:(NSTextAlignment)alignment
                    textColor:(UIColor*)textColor
                         font:(UIFont*)font;
- (id)initWithFrame:(CGRect)frame alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font select:(BasicBlock)select;
- (id)initWithFrame:(CGRect)frame alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font longPress:(BasicBlock)longPress;

@end
