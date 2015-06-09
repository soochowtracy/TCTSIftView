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

@property(nonatomic, readwrite, strong) UIView *backgroundView;

- (void)reloadData;

@end


@protocol TCTSiftViewDelegate <NSObject>

@required

@optional
- (CGFloat)heightOfTabInSiftView:(TCTSiftView *)siftView;

- (CGFloat)heightOfContentContainerInSiftView:(TCTSiftView *)siftView;
@end

//UITableView
@protocol TCTSiftViewDatasource <NSObject>

@required
- (NSInteger)numberOfTabsInSiftView:(TCTSiftView *)siftView;

- (id<TCTSiftViewTabItem>)siftView:(TCTSiftView *)siftView itemForTabAtIndex:(NSInteger)index;

@end












