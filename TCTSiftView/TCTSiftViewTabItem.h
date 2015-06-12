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
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end

@interface TCTSiftViewTabItem : NSObject<TCTSiftViewTabItem>

+ (instancetype)siftViewTabItemWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title defaultImage:(UIImage *)defaultImage selectedImage:(UIImage *)selectedImage selected:(BOOL)selected;

@end
