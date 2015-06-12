//
//  TCTSiftViewCell.m
//  TCTSiftView
//
//  Created by Tracyone on 15/6/10.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import "TCTSiftViewCell.h"

@interface TCTSiftViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *siftIcon;
@property (weak, nonatomic) IBOutlet UILabel *siftTitle;

@property (nonatomic, strong) NSMutableDictionary *siftStateTitles;
@property (nonatomic, strong) NSMutableDictionary *siftStateIcons;
@end

@implementation TCTSiftViewCell

@synthesize chosen = _chosen;

- (void)prepareForReuse{
    self.siftIcon.image = nil;
    self.siftTitle.text = nil;
    self.siftStateIcons = nil;
    self.siftStateTitles = nil;
    
}

- (void)setChosen:(BOOL)chosen{
    _chosen = chosen;
    if (!chosen) {
        self.siftTitle.text = [self.siftStateTitles objectForKey:@(TCTSiftViewCellStateNormal)];
        self.siftIcon.image = [self.siftStateIcons objectForKey:@(TCTSiftViewCellStateNormal)];
    }else{
        self.siftTitle.text = [self.siftStateTitles objectForKey:@(TCTSiftViewCellStateNormal)];
//        UIImage *temp = [self.siftStateIcons objectForKey:@(TCTSiftViewCellStateSelected)];
//        temp = temp ? temp : [self.siftStateIcons objectForKey:@(TCTSiftViewCellStateNormal)];
        self.siftIcon.image = [self.siftStateIcons objectForKey:@(TCTSiftViewCellStateSelected)];
    }
}

- (void)setSiftTitle:(NSString *)siftTitle forState:(TCTSiftViewCellState)state{
    [self.siftStateTitles setObject:siftTitle forKey:@(state)];
}

- (void)setSiftIcon:(UIImage *)siftIcon forState:(TCTSiftViewCellState)state{
    [self.siftStateIcons setObject:siftIcon forKey:@(state)];
}

#pragma mark - accessor

- (NSMutableDictionary *)siftStateTitles{
    if (!_siftStateTitles) {
        _siftStateTitles = [[NSMutableDictionary alloc] init];
    }
    return _siftStateTitles;
}

- (NSMutableDictionary *)siftStateIcons{
    if (!_siftStateIcons) {
        _siftStateIcons = [[NSMutableDictionary alloc] init];
    }
    return _siftStateIcons;
}
@end
