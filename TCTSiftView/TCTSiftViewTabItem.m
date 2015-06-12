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
@synthesize defaultImage = _defaultImage;
@synthesize selectedImage = _selectedImage;
@synthesize selected = _selected;

#pragma mark - life circle
//+ (instancetype)siftViewTabItemWithTitle:(NSString *)title{
//    TCTSiftViewTabItem *temp = [[TCTSiftViewTabItem alloc] initWithTitle:title
//                                                            defaultImage:TCTSiftViewTabDefaultColor
//                                                           selectedImage:TCTSiftViewTabSelectedColor
//                                                                selected:NO];
//    
//    return temp;
//}

- (instancetype)initWithTitle:(NSString *)title defaultImage:(UIImage *)defaultImage selectedImage:(UIImage *)selectedImage selected:(BOOL)selected{
    if (self = [super init]) {
        self.title = title;
        self.defaultImage = defaultImage;
        self.selectedImage = selectedImage;
        self.selected = selected;
    }
    
    return self;
}

@end
