//
//  FLabel.m
//  Login
//
//  Created by fcz on 16/5/19.
//  Copyright © 2016年 com.labang. All rights reserved.
//

#import "FLabel.h"

@implementation FLabel
{
    BasicBlock _select;
    BasicBlock _longPress;
}

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString*)text
                    alignment:(NSTextAlignment)alignment
                    textColor:(UIColor*)textColor
                         font:(UIFont*)font {
    if (self = [super initWithFrame:frame]) {
        
        self.text = text;
        self.textAlignment = alignment;
        self.textColor = textColor;
        self.font = font;
        self.numberOfLines = 0;
    }
    return self;
}
- (void)setText:(NSString *)text{
    if (text==nil ||  text.length == 0 || [text isEqualToString:@"null"] || [text isKindOfClass:[NSNull class]]) {
        text = @"";
    }
    [super setText:text];
}

- (id)initWithFrame:(CGRect)frame alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font select:(BasicBlock)select {
    if (self = [super initWithFrame:frame]) {
        _select = select;
        
        [self setTextAlignment:alignment];
        [self setTextColor:textColor];
        [self setFont:font];
        self.numberOfLines = 0;
        
        if (_select) {
            [self setUserInteractionEnabled:YES];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select)];
            [self addGestureRecognizer:gesture];
        }
        [self setTranslatesAutoresizingMaskIntoConstraints:YES];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(UIFont *)font longPress:(BasicBlock)longPress
{
    if (self = [super initWithFrame:frame]) {
        _longPress = longPress;
        
        [self setTextAlignment:alignment];
        [self setTextColor:textColor];
        [self setFont:font];
        self.numberOfLines = 0;
        
        if (_longPress) {
            [self setUserInteractionEnabled:YES];
            UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [self addGestureRecognizer:gesture];
        }
        [self setTranslatesAutoresizingMaskIntoConstraints:YES];
    }
    return self;

}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan){
        [self longClickAllContext];
        if(_longPress) _longPress();
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        [self removeLongClickArea];
    }
}

- (void)select {
    if (_select) _select();
}

- (void)longClickAllContext{
    
    UIView *myselfSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    myselfSelected.tag = 10102;
    [self insertSubview:myselfSelected belowSubview:self];
    myselfSelected.backgroundColor = Color(30, 0.3);
    
    
}

- (void)removeLongClickArea{
    
    if ([self viewWithTag:10102]) {
        [[self viewWithTag:10102] removeFromSuperview];

    }
    
}


@end
