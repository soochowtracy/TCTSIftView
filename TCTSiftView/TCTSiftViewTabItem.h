//
//  TCTSiftViewTabItem.h
//  TCTSiftView
//
//  Created by Tracyone on 15/6/9.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol TCTSiftViewTabItem <NSObject>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end

@interface TCTSiftViewTabItem : NSObject<TCTSiftViewTabItem>

+ (instancetype)siftViewTabItemWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title defaultColor:(UIColor *)defaultColor selectedColor:(UIColor *)selectedColor selected:(BOOL)selected;

@end
