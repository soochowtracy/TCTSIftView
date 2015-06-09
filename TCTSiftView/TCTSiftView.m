//
//  TCTSiftView.m
//  TCTSiftView
//
//  Created by Tracyone on 15/6/9.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import "TCTSiftView.h"

#import "UIView+TCTSiftView.h"

@interface TCTSiftView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak)UICollectionView *siftTab;
@property (nonatomic, weak)UIView *siftContentContainer;

@end

@implementation TCTSiftView{
    
    TCTSiftViewType _siftViewType;
}

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame type:(TCTSiftViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        _siftViewType = type;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame type:TCTSiftViewTypeSystem];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    
}

#pragma mark - private
//- (void)commonInit{
//    _siftViewType = TCTSiftViewTypeSystem;
//}

#pragma mark - public



#pragma mark - accessor
- (UICollectionView *)siftTab{
    if (_siftTab) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        UICollectionView *temp = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
        temp.dataSource = self;
        temp.delegate = self;
        
        [self addSubview:_siftTab = temp];
    }
    
    return _siftTab;
}

- (UIView *)siftContentContainer{
    if (!_siftContentContainer) {
        UIView *temp = [[UIView alloc] initWithFrame:self.frame];
        
        [self addSubview:_siftContentContainer = temp];
    }
    
    return _siftContentContainer;
}

@end
