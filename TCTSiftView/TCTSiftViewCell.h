//
//  TCTSiftViewCell.h
//  TCTSiftView
//
//  Created by Tracyone on 15/6/10.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TCTSiftViewCellState) {
    TCTSiftViewCellStateNormal       = 0,
    TCTSiftViewCellStateHighlighted  = 1 << 0,
    TCTSiftViewCellStateDisabled     = 1 << 1,
    TCTSiftViewCellStateSelected     = 1 << 2,
};

@protocol TCTSiftViewCell <NSObject>

@property (nonatomic, assign) BOOL chosen;

@end

@interface TCTSiftViewCell : UICollectionViewCell<TCTSiftViewCell>

//@property (nonatomic, assign) BOOL chosen;

- (void)setSiftTitle:(NSString *)siftTitle forState:(TCTSiftViewCellState)state;
- (void)setSiftIcon:(UIImage *)siftIcon forState:(TCTSiftViewCellState)state;

@end
