//
//  FImageView.h
//  Login
//
//  Created by fcz on 16/5/19.
//  Copyright © 2016年 com.labang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FImageView : UIImageView

#pragma mark 初始化
- (id)initWithFrame:(CGRect)frame contentMode:(UIViewContentMode)contentMode select:(UIntegerBlock)select tag:(NSInteger)tag;

#pragma mark 加载图片
- (void)loadImg:(NSString *)name;

+ (UIImage *)imageWithColor:(UIColor*)color withRect:(CGRect)rect;

@end
