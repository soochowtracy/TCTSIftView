//
//  TCTSiftViewCell.m
//  TCTSiftView
//
//  Created by Tracyone on 15/6/10.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import "TCTSiftViewCell.h"

@interface TCTSiftViewCell ()

@end

@implementation TCTSiftViewCell

- (void)prepareForReuse{
    self.siftIcon.image = nil;
    self.siftTitle.text = nil;

}
@end
