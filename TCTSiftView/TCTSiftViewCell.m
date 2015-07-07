//
//  TCTSiftViewCell.m
//  TCTSiftView
//
//  Created by Tracyone on 15/6/10.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import "TCTSiftViewCell.h"
#import "UIView+TCTSiftView.h"

@interface TCTSiftViewCell ()

@end

@implementation TCTSiftViewCell



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.siftIcon];
        [self addSubview:self.siftTitle];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)prepareForReuse{
    self.siftIcon.image = nil;
    self.siftTitle.text = nil;

}

- (void)updateConstraints{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[siftIcon(15)]-0-[siftTitle]"
                                                                 options:NSLayoutFormatAlignAllCenterX
                                                                 metrics:nil views:@{@"siftIcon": self.siftIcon, @"siftTitle": self.siftTitle}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[siftIcon(15)]"
                                                                 options:0
                                                                 metrics:nil views:@{@"siftIcon": self.siftIcon}]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.siftIcon
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [super updateConstraints];
}

- (UIImageView *)siftIcon{
    if (!_siftIcon) {
        _siftIcon = [[UIImageView alloc] init];
        _siftIcon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _siftIcon;
}

- (UILabel *)siftTitle{
    if (!_siftTitle) {
        _siftTitle = [[UILabel alloc] init];
        _siftTitle.font = [UIFont systemFontOfSize:12.0];
        _siftTitle.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _siftTitle;
}

@end
