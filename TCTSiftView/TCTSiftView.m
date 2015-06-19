//
//  TCTSiftView.m
//  TCTSiftView
//
//  Created by Tracyone on 15/6/9.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import "TCTSiftView.h"

#import "TCTSiftViewConst.h"
#import "UIView+TCTSiftView.h"

#import "TCTSiftViewTypeStrategySystem.h"

#import "TCTSiftViewCell.h"

static NSString * const siftViewDefaultTabCellIdentifier = @"TCTSiftViewCell";

static inline NSInteger TCT_IndexFromIndexPath(NSIndexPath *indexPath){
    return indexPath.row;
}

static inline NSIndexPath *TCT_IndexPathFromIndex(NSInteger index){
    return [NSIndexPath indexPathForItem:index inSection:0];
}

@interface TCTSiftView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *siftTab;
@property (nonatomic, weak) UIView *siftContentContainer;
@property (nonatomic, weak) UIControl *siftBackground;

@property (nonatomic, strong) NSMutableArray *cachedContents;
@property (nonatomic, strong) NSMutableDictionary *availableContents;
@property (nonatomic, assign) NSInteger currentShownContent;

@property (nonatomic, readwrite) TCTSiftViewType siftViewType;
@property (nonatomic, strong) id<TCTSiftViewTypeStrategy>siftViewTypeStrategy;
@end

@implementation TCTSiftView{
    struct {
        unsigned numberOfTabsInSiftView : 1;
        unsigned itemForTabAtIndex : 1;
        unsigned cellForTabAtIndex : 1;
        unsigned viewForContentAtIndex : 1;
    } _dataSourceHas;
    
    struct {
        unsigned widthOfTabAtIndex : 1;
        unsigned heightOfContentAtIndex : 1;
        unsigned willShowContentAtIndex : 1;
        unsigned didShowContentAtIndex : 1;
        unsigned shouldShowContentAtIndex : 1;
        unsigned didClickTabAtIndex : 1;
        
    } _delegateHas;
}

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame type:(TCTSiftViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        self.siftViewType = type;
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame type:TCTSiftViewTypeSystem];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutBackgroundView];
    [self layoutSiftViewTab];
    [self layoutSiftViewContentContainer];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    
//}

#pragma mark - private
- (void)commonInit{
    self.siftViewType = TCTSiftViewTypeSystem;
    self.backgroundColor = [UIColor clearColor];
    self.siftBackground.alpha = 0.0;
    
    self.currentShownContent = NSIntegerMax;
}

- (void)layoutSiftViewTab{
#warning 临界值判断
    CGFloat w = self.tct_w;
    CGFloat h = [self heightOfTab];
    CGFloat x = 0;
    CGFloat y = self.tct_h - h;
    
    self.siftTab.frame = CGRectMake(x, y, w, h);
}

- (void)layoutBackgroundView{
    
    self.siftBackground.frame = self.bounds;
}

- (void)layoutSiftViewContentContainer{
    CGFloat w = self.tct_w;
    CGFloat h = [self heightOfContentAtIndex:0];
    CGFloat x = 0;
    CGFloat y = self.tct_h;
    self.siftContentContainer.frame = CGRectMake(x, y, w, h);
    
    if (_dataSourceHas.viewForContentAtIndex) {
        NSInteger numberOfTabs = [self numberOfTabs];
        for (NSInteger i = 0; i < numberOfTabs; i++) {
            
            UIView *temp = [self.availableContents objectForKey:@(i)] ?: [_datasource siftView:self viewForContentAtIndex:i];
            if (temp) {
                [self.availableContents setObject:temp forKey:@(i)];
                [self.siftContentContainer addSubview:temp];
                temp.frame = self.siftContentContainer.bounds;
            }
            
        }
    }
    
}

- (NSInteger)numberOfTabs{
    if (_dataSourceHas.numberOfTabsInSiftView) {
        return [_datasource numberOfTabsInSiftView:self];
    }else{
        return TCTSiftViewNumberOfTabs;
    }
}

- (UICollectionViewCell *)cellForTabAtIndex:(NSInteger)index{
    
    if (_dataSourceHas.cellForTabAtIndex) {
        return [_datasource siftView:self cellForTabAtIndex:index];
    }else{
        TCTSiftViewCell *tempCell = [self.siftTab dequeueReusableCellWithReuseIdentifier:siftViewDefaultTabCellIdentifier forIndexPath:TCT_IndexPathFromIndex(index)];
        
        if (_dataSourceHas.itemForTabAtIndex) {
            id<TCTSiftViewTabItem> tempItem = [_datasource siftView:self itemForTabAtIndex:index];
            if ([tempItem isSelected]) {
                tempCell.siftIcon.image = [tempItem selectedImage];
                tempCell.siftTitle.textColor = [tempItem selectedTitleColor];
            }else{
                tempCell.siftIcon.image = [tempItem defaultImage];
                tempCell.siftTitle.textColor = [tempItem defaultTitleColor];
            }
            tempCell.siftTitle.text = [tempItem title];
        }
        
        return tempCell;
    }
}

- (CGFloat)heightOfTab{
    if (self.tabHeight > 0.1) {
        return self.tabHeight;
    }else{
        return TCTSiftViewTabHeight;
    }
}

- (CGFloat)widthOfTabAtIndex:(NSInteger)index{
    if (_delegateHas.widthOfTabAtIndex) {
        return [_delegate siftView:self widthOfTabAtIndex:index];
    }else{
        return self.tct_w/[self numberOfTabs];
    }
}

- (CGFloat)estimateHeightOfContent{
    if (self.estimatecontentViewHeight > 0.1) {
        return self.estimatecontentViewHeight;
    }else if (self.contentViewHeight > 0.1){
        return self.contentViewHeight;
    }else{
        return TCTSiftViewContentContainerHeight;
    }
}

- (CGFloat)heightOfContentAtIndex:(NSInteger)index{
    if (_delegateHas.heightOfContentAtIndex) {
        return [_delegate siftView:self heightOfContentAtIndex:index];
    }else if(self.contentViewHeight > 0.1){
        return self.contentViewHeight;
    }else{
        return TCTSiftViewContentContainerHeight;
    }
}

- (BOOL)shouldShowContentAtIndex:(NSInteger)index{
    if (_delegateHas.shouldShowContentAtIndex) {
        return [_delegate siftView:self shouldShowContentAtIndex:index];
    }else{
        return TCTSiftViewShouldShowContent;
    }
}

- (BOOL)isShownNewContentViewAtIndex:(NSInteger)index{
        return self.currentShownContent == NSIntegerMax;
}

#pragma mark - public

- (void)reloadData{
    [self.siftTab reloadData];
    
    [[self.availableContents allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.availableContents removeAllObjects];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier{
    [self.siftTab registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier{
    [self.siftTab registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index{
    return [self.siftTab dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:TCT_IndexPathFromIndex(index)];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self numberOfTabs];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    return [self cellForTabAtIndex:TCT_IndexFromIndexPath(indexPath)];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self shouldShowContentAtIndex:TCT_IndexFromIndexPath(indexPath)]) {
        if (_delegateHas.willShowContentAtIndex) {
            [_delegate siftView:self willShowContentAtIndex:TCT_IndexFromIndexPath(indexPath)];
        }
        
        NSInteger index = TCT_IndexFromIndexPath(indexPath);
        
        if (self.currentShownContent == index) {
            [self dismissContentView];
        }else{
            [self showContentViewAtIndex:index];
        }

        if (_delegateHas.didShowContentAtIndex) {
            [_delegate siftView:self didShowContentAtIndex:TCT_IndexFromIndexPath(indexPath)];
        }
    }else{
        if (![self isShownNewContentViewAtIndex:TCT_IndexFromIndexPath(indexPath)]) {
            [self dismissContentView];
        }
    }
    
    if (_delegateHas.didClickTabAtIndex) {
        [_delegate siftView:self didClickTabAtIndex:TCT_IndexFromIndexPath(indexPath)];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = [self widthOfTabAtIndex:TCT_IndexFromIndexPath(indexPath)];
    CGSize temp= CGSizeMake(width, self.siftTab.tct_h);
    
    return temp;
}

#pragma mark - accessor
- (UICollectionView *)siftTab{
    if (!_siftTab) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.minimumLineSpacing = 0.0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *temp = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
        [temp registerNib:[UINib nibWithNibName:NSStringFromClass([TCTSiftViewCell class]) bundle:nil] forCellWithReuseIdentifier:siftViewDefaultTabCellIdentifier];
        temp.backgroundColor = TCTSiftViewTabBackgroundColor;
        temp.dataSource = self;
        temp.delegate = self;
        
        [self addSubview:_siftTab = temp];
    }
    
    return _siftTab;
}

- (UIView *)siftContentContainer{
    if (!_siftContentContainer) {
        UIView *temp = [[UIView alloc] initWithFrame:self.frame];
        [self insertSubview:_siftContentContainer = temp aboveSubview:self.siftTab];
    }
    
    return _siftContentContainer;
}

- (UIControl *)siftBackground{
    if (!_siftBackground) {
        UIControl *temp = [[UIControl alloc] init];
        temp.backgroundColor = TCTSiftViewBackgroundColor;
        [temp addTarget:self action:@selector(dismissContentView) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:_siftBackground = temp belowSubview:self.siftTab];
    }
    
    return _siftBackground;
}



- (void)setSiftViewType:(TCTSiftViewType)siftViewType{
    _siftViewType = siftViewType;
    
    switch (_siftViewType) {
        case TCTSiftViewTypeSystem:{
            self.siftViewTypeStrategy = [[TCTSiftViewTypeStrategySystem alloc] init];
        }
            break;
            
        default:
            break;
    }
}

- (void)setDatasource:(id<TCTSiftViewDatasource>)datasource{
    _datasource = datasource;
    
    _dataSourceHas.numberOfTabsInSiftView = [_datasource respondsToSelector:@selector(numberOfTabsInSiftView:)];
    _dataSourceHas.cellForTabAtIndex = [_datasource respondsToSelector:@selector(siftView:cellForTabAtIndex:)];
    _dataSourceHas.itemForTabAtIndex = [_datasource respondsToSelector:@selector(siftView:itemForTabAtIndex:)];
    _dataSourceHas.viewForContentAtIndex = [_datasource respondsToSelector:@selector(siftView:viewForContentAtIndex:)];
}

- (void)setDelegate:(id<TCTSiftViewDelegate>)delegate{
    _delegate = delegate;
    
    _delegateHas.widthOfTabAtIndex = [_delegate respondsToSelector:@selector(siftView:widthOfTabAtIndex:)];
    _delegateHas.heightOfContentAtIndex = [_delegate respondsToSelector:@selector(siftView:heightOfContentAtIndex:)];
    
    _delegateHas.willShowContentAtIndex = [_delegate respondsToSelector:@selector(siftView:willShowContentAtIndex:)];
    _delegateHas.didShowContentAtIndex = [_delegate respondsToSelector:@selector(siftView:didShowContentAtIndex:)];
    _delegateHas.shouldShowContentAtIndex = [_delegate respondsToSelector:@selector(siftView:shouldShowContentAtIndex:)];
    
    _delegateHas.didClickTabAtIndex = [_delegate respondsToSelector:@selector(siftView:didClickTabAtIndex:)];
}

- (NSMutableArray *)cachedContents{
    if (!_cachedContents) {
        _cachedContents = [[NSMutableArray alloc] init];
    }
    
    return _cachedContents;
}

- (NSMutableDictionary *)availableContents{
    if (!_availableContents) {
        _availableContents = [[NSMutableDictionary alloc] init];
    }
    
    return _availableContents;
}

@end


@implementation TCTSiftView (Animation)

- (void)showNewContentViewAtIndex:(NSInteger)index{
    self.currentShownContent = index;
    [[self.availableContents allValues] makeObjectsPerformSelector:@selector(setHidden:) withObject:@YES];
    UIView *temp = [self.availableContents objectForKey:@(index)];
    temp.hidden = NO;
    
    CGFloat h = [self heightOfContentAtIndex:index];
    
    [UIView animateWithDuration:TCTSiftViewBackgroundDuration animations:^{
        self.siftBackground.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:TCTSiftViewShowContentDuration
                              delay:TCTSiftViewShowContentDelay
             usingSpringWithDamping:0.9
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.siftContentContainer.frame = CGRectMake(self.siftContentContainer.tct_x, self.siftContentContainer.tct_y - h, self.siftContentContainer.tct_w, h);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
    }];
    
}

- (void)showOtherContentViewAtIndex:(NSInteger)index{
    
    CGFloat originH = [self heightOfContentAtIndex:self.currentShownContent];
    CGFloat destH = [self heightOfContentAtIndex:index];
    
    self.currentShownContent = index;
    [UIView animateWithDuration:TCTSiftViewDismissContentDuration animations:^{
        self.siftContentContainer.frame = CGRectMake(self.siftContentContainer.tct_x, self.tct_h, self.siftContentContainer.tct_w, originH);
    } completion:^(BOOL finished) {
        [[self.availableContents allValues] makeObjectsPerformSelector:@selector(setHidden:) withObject:@YES];
        UIView *temp = [self.availableContents objectForKey:@(index)];
        temp.hidden = NO;
        [UIView animateWithDuration:TCTSiftViewShowContentDuration
                              delay:TCTSiftViewShowContentDelay
             usingSpringWithDamping:0.9
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.siftContentContainer.frame = CGRectMake(self.siftContentContainer.tct_x, self.siftContentContainer.tct_y - destH, self.siftContentContainer.tct_w, destH);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
    }];
    
}

- (void)showContentViewAtIndex:(NSInteger)index{
    if ([self isShownNewContentViewAtIndex:index]) {
        [self showNewContentViewAtIndex:index];
    }else{
        [self showOtherContentViewAtIndex:index];
    }
}

- (void)dismissContentView{
    self.currentShownContent = NSIntegerMax;
    CGFloat h = [self estimateHeightOfContent];
    [UIView animateWithDuration:TCTSiftViewDismissContentDuration
                     animations:^{
                         self.siftContentContainer.frame = CGRectMake(self.siftContentContainer.tct_x, self.tct_h, self.siftContentContainer.tct_w, h);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:TCTSiftViewBackgroundDuration animations:^{
                             self.siftBackground.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             
                         }];
                         
                     }];
}

@end

