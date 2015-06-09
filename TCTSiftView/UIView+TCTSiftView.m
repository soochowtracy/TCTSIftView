//
//  UIView+TCTSiftView.m
//  TCTSiftView
//
//  Created by Tracyone on 15/6/9.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import "UIView+TCTSiftView.h"

@implementation UIView (TCTSiftView)

- (void)setTct_x:(CGFloat)tct_x{
    CGRect frame = self.frame;
    frame.origin.x = tct_x;
    self.frame = frame;
}

- (CGFloat)tct_x{
    return self.frame.origin.x;
}

- (void)setTct_y:(CGFloat)tct_y{
    CGRect frame = self.frame;
    frame.origin.x = tct_y;
    self.frame = frame;
}

- (CGFloat)tct_y{
    return self.frame.origin.y;
}

- (void)setTct_w:(CGFloat)tct_w{
    CGRect frame = self.frame;
    frame.size.width = tct_w;
    self.frame = frame;
}

- (CGFloat)tct_w{
    return self.frame.size.width;
}

- (void)setTct_h:(CGFloat)tct_h{
    CGRect frame = self.frame;
    frame.size.width = tct_h;
    self.frame = frame;
}

- (CGFloat)tct_h{
    return self.frame.size.height;
}

- (void)setTct_size:(CGSize)tct_size{
    CGRect frame = self.frame;
    frame.size = tct_size;
    self.frame = frame;
}

- (CGSize)tct_size{
    return self.frame.size;
}

- (void)setTct_origin:(CGPoint)tct_origin{
    CGRect frame = self.frame;
    frame.origin = tct_origin;
    self.frame = frame;
}

- (CGPoint)tct_origin{
    return self.frame.origin;
}
@end
