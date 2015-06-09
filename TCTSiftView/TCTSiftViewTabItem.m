//
//  TCTSiftViewTabItem.m
//  TCTSiftView
//
//  Created by Tracyone on 15/6/9.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import "TCTSiftViewTabItem.h"
#import "TCTSiftViewConst.h"

@implementation TCTSiftViewTabItem

@synthesize title = _title;
@synthesize defaultColor = _defaultColor;
@synthesize selectedColor = _selectedColor;
@synthesize selected = _selected;

#pragma mark - life circle
+ (instancetype)siftViewTabItemWithTitle:(NSString *)title{
    TCTSiftViewTabItem *temp = [[TCTSiftViewTabItem alloc] initWithTitle:title
                                                            defaultColor:TCTSiftViewTabDefaultColor
                                                           selectedColor:TCTSiftViewTabSelectedColor
                                                                selected:NO];
    
    return temp;
}

- (instancetype)initWithTitle:(NSString *)title defaultColor:(UIColor *)defaultColor selectedColor:(UIColor *)selectedColor selected:(BOOL)selected{
    if (self = [super init]) {
        self.title = title;
        self.defaultColor = defaultColor;
        self.selectedColor = selectedColor;
        self.selected = selected;
    }
    
    return self;
}
@end
