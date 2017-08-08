//
//  FImageView.m
//  Login
//
//  Created by fcz on 16/5/19.
//  Copyright © 2016年 com.labang. All rights reserved.
//

#import "FImageView.h"

@interface FImageView ()
{
    UIntegerBlock _select;
}

@end

@implementation FImageView

#pragma mark 初始化
- (id)initWithFrame:(CGRect)frame contentMode:(UIViewContentMode)contentMode select:(UIntegerBlock)select tag:(NSInteger)tag {
    if (self = [super initWithFrame:frame]) {
        _select = select;
        
        [self setContentMode:contentMode];
        [self setClipsToBounds:YES];
        [self setTag:tag];
        [self setUserInteractionEnabled:YES];
        if (_select) {
            
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select)];
            [self addGestureRecognizer:gesture];
        }
    }
    return self;
}

- (void)select {
    NSInteger tag = [self tag];
    if (_select) _select(tag);
}

#pragma mark 加载图片
- (void)loadImg:(NSString *)name {
    UIImage *img = [UIImage imageNamed:name];
    [self setImage:img];
}

+ (UIImage *)imageWithColor:(UIColor*)color withRect:(CGRect)rect{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage * img  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
    
}

@end
