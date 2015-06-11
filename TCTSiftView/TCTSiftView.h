//
//  TCTSiftView.h
//  TCTSiftView
//
//  Created by Tracyone on 15/6/9.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCTSiftViewTabItem.h"

typedef NS_ENUM(NSUInteger, TCTSiftViewType) {
    TCTSiftViewTypeSystem,
    TCTSiftViewTypeTop,
    TCTSiftViewTypeBottom,
};


@protocol TCTSiftViewDelegate, TCTSiftViewDatasource;

@interface TCTSiftView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(TCTSiftViewType)type;

@property (nonatomic, readonly) TCTSiftViewType siftViewType;
@property (nonatomic, weak) id<TCTSiftViewDatasource>datasource;
@property (nonatomic, weak) id<TCTSiftViewDelegate>delegate;

@property (nonatomic) CGFloat tabHeight;
@property (nonatomic) CGFloat contentContainerHeight;

//@property(nonatomic, readwrite, strong) UIView *backgroundView;

- (void)reloadData;

- (void)showContentViewAtIndex:(NSInteger)index;
- (void)dismissContentView;

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;
@end


@protocol TCTSiftViewDelegate <NSObject>

@required

@optional
- (CGFloat)heightOfTabInSiftView:(TCTSiftView *)siftView;
- (CGFloat)estimateheightOfContentInSiftView:(TCTSiftView *)siftView;

- (CGFloat)siftView:(TCTSiftView *)siftView heightOfContentAtIndex:(NSInteger)index;
- (void)siftView:(TCTSiftView *)siftView didSelectTabAtIndex:(NSInteger)index;
- (BOOL)siftView:(TCTSiftView *)siftView shouldShowContentAtIndex:(NSInteger)index;

@end

//UITableView
@protocol TCTSiftViewDatasource <NSObject>

@required
- (NSInteger)numberOfTabsInSiftView:(TCTSiftView *)siftView;

- (UICollectionViewCell *)siftView:(TCTSiftView *)siftView viewForTabAtIndex:(NSInteger)index;
- (id<TCTSiftViewTabItem>)siftView:(TCTSiftView *)siftView itemForTabAtIndex:(NSInteger)index;

- (UIView *)siftView:(TCTSiftView *)siftView viewForContentAtIndex:(NSInteger)index;

@optional


@end












