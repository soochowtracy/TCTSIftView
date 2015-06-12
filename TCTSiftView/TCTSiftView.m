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

@property (nonatomic, readwrite) TCTSiftViewType siftViewType;
@property (nonatomic, strong) id<TCTSiftViewTypeStrategy>siftViewTypeStrategy;
@end

@implementation TCTSiftView{
    struct {
        unsigned numberOfTabsInSiftView : 1;
        unsigned itemForTabAtIndex : 1;
        unsigned cellForTabAtIndex : 1;
        unsigned viewForContentAtIndex : 1;
//        unsigned canEditRowAtIndexPath : 1;
    } _dataSourceHas;
    
    struct {
        unsigned heightOfTabInSiftView : 1;
        unsigned heightOfContentAtIndex : 1;
        unsigned didSelectTabAtIndex : 1;
        unsigned shouldShowContentAtIndex : 1;
        unsigned estimateheightOfContentInSiftView : 1;
        
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
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContentView)];
//    [self.backgroundView addGestureRecognizer:tapGesture];
    
    self.siftContentContainer.backgroundColor = [UIColor redColor];
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

- (UICollectionViewCell<TCTSiftViewCell> *)cellForTabAtIndex:(NSInteger)index{
    
    if (_dataSourceHas.cellForTabAtIndex) {
        return [_datasource siftView:self cellForTabAtIndex:index];
    }else{
        TCTSiftViewCell *tempCell = [self.siftTab dequeueReusableCellWithReuseIdentifier:siftViewDefaultTabCellIdentifier forIndexPath:TCT_IndexPathFromIndex(index)];
        
        if (_dataSourceHas.itemForTabAtIndex) {
            id<TCTSiftViewTabItem> tempItem = [_datasource siftView:self itemForTabAtIndex:index];
            [tempCell setSiftTitle:[tempItem title] forState:TCTSiftViewCellStateNormal];
            [tempCell setSiftIcon:[tempItem defaultImage] forState:TCTSiftViewCellStateNormal];
            [tempCell setSiftIcon:[tempItem selectedImage] forState:TCTSiftViewCellStateSelected];
            [tempCell setChosen:[tempItem isSelected]];
        }
        
        return tempCell;
    }
}

- (CGFloat)heightOfTab{
    if (_delegateHas.heightOfTabInSiftView) {
        return [_delegate heightOfTabInSiftView:self];
    }else{
        return TCTSiftViewTabHeight;
    }
}

- (CGFloat)estimateHeightOfContent{
    if (_delegateHas.estimateheightOfContentInSiftView) {
        return [_delegate estimateheightOfContentInSiftView:self];
    }else{
        return TCTSiftViewContentContainerHeight;
    }
}

- (CGFloat)heightOfContentAtIndex:(NSInteger)index{
    if (_delegateHas.heightOfContentAtIndex) {
        return [_delegate siftView:self heightOfContentAtIndex:index];
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
#pragma mark - public

- (void)reloadData{
    [self.siftTab reloadData];
    
    [[self.availableContents allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.availableContents removeAllObjects];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)showContentViewAtIndex:(NSInteger)index{
    
    [[self.availableContents allValues] makeObjectsPerformSelector:@selector(setHidden:) withObject:@YES];
    UIView *temp = [self.availableContents objectForKey:@(index)];
    temp.hidden = NO;
    
    CGFloat h = [self heightOfContentAtIndex:index];
    self.siftBackground.alpha = 0.1;
    [UIView animateWithDuration:TCTSiftViewShowContentDuration
                          delay:TCTSiftViewShowContentDelay
         usingSpringWithDamping:0.9
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.siftBackground.alpha = 1.0;
                         self.siftContentContainer.frame = CGRectMake(self.siftContentContainer.tct_x, self.siftContentContainer.tct_y - h, self.siftContentContainer.tct_w, h);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)selectTabAtIndex:(NSInteger)index{
    if (index < [self numberOfTabs]) {
        UICollectionViewCell<TCTSiftViewCell> *temp = (UICollectionViewCell<TCTSiftViewCell> *)[self.siftTab cellForItemAtIndexPath:TCT_IndexPathFromIndex(index)];
        temp.chosen = YES;
//        [self.siftTab reloadData];
    }
}

- (void)deselectTabAtIndex:(NSInteger)index{
    if (index < [self numberOfTabs]) {
        UICollectionViewCell<TCTSiftViewCell> *temp = (UICollectionViewCell<TCTSiftViewCell> *)[self.siftTab cellForItemAtIndexPath:TCT_IndexPathFromIndex(index)];
        temp.chosen = NO;
    }
}

- (void)dismissContentView{
    CGFloat h = [self estimateHeightOfContent];
    [UIView animateWithDuration:TCTSiftViewShowContentDuration
                     animations:^{
                         
                         self.siftContentContainer.frame = CGRectMake(self.siftContentContainer.tct_x, self.tct_h, self.siftContentContainer.tct_w, h);
                     }
                     completion:^(BOOL finished) {
                         self.siftBackground.alpha = 0.0;
                     }];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier{
    [self.siftTab registerNib:nib forCellWithReuseIdentifier:identifier];
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
        [self showContentViewAtIndex:TCT_IndexFromIndexPath(indexPath)];
    }
    
    if (_delegateHas.didSelectTabAtIndex) {
        [_delegate siftView:self didSelectTabAtIndex:TCT_IndexFromIndexPath(indexPath)];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize temp= CGSizeMake(self.tct_w/[self numberOfTabs], self.siftTab.tct_h);
    
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
        temp.backgroundColor = [UIColor blackColor];
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
    
    _delegateHas.heightOfTabInSiftView = [_delegate respondsToSelector:@selector(heightOfTabInSiftView:)];
    _delegateHas.estimateheightOfContentInSiftView = [_delegate respondsToSelector:@selector(estimateheightOfContentInSiftView:)];
    _delegateHas.heightOfContentAtIndex = [_delegate respondsToSelector:@selector(siftView:heightOfContentAtIndex:)];
    
    _delegateHas.didSelectTabAtIndex = [_delegate respondsToSelector:@selector(siftView:didSelectTabAtIndex:)];
    _delegateHas.shouldShowContentAtIndex = [_delegate respondsToSelector:@selector(siftView:shouldShowContentAtIndex:)];
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
