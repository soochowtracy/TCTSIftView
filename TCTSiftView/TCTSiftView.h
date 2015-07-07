//
//  TCTSiftView.h
//  TCTSiftView
//
//  Created by Tracyone on 15/6/9.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCTSiftViewTabItem.h"

//几种类型在第二期中加入，敬请期待。
typedef NS_ENUM(NSUInteger, TCTSiftViewType) {
    TCTSiftViewTypeSystem,
    TCTSiftViewTypeTop,
    TCTSiftViewTypeBottom,
};


@protocol TCTSiftViewDelegate, TCTSiftViewDatasource, TCTSiftViewCell;

@interface TCTSiftView : UIView

/**
 *  Initializes and returns a newly allocated siftView object with the specified frame rectangle and type.
 *
 *  The new siftView object must be inserted into the view hierarchy of a window before it can be used. If you create a siftView object programmatically, this method is the designated initializer for the TCTSiftView class. Subclasses can override this method to perform any custom initialization but must call super at the beginning of their implementation.
 *
 *  @param frame  The frame rectangle for the siftView, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
 *  @param type  The siftView type. See TCTSiftViewType for the possible values.
 *
 *  @return An initialized siftView object or nil if the object couldn't be created.
 */
- (instancetype)initWithFrame:(CGRect)frame type:(TCTSiftViewType)type;
@property (nonatomic, readonly) TCTSiftViewType siftViewType;

@property (nonatomic, weak) id<TCTSiftViewDatasource>datasource;
@property (nonatomic, weak) id<TCTSiftViewDelegate>delegate;

/**
 *  The height of tab in the sift view.
 *
 *  Tab height is nonnegative and is expressed in points. You may set the tab height if the default height doesn’t satisfy. If you do not explicitly set the tab height, TCTSiftView sets it to a standard value.
 *
 */
@property (nonatomic) CGFloat tabHeight;

/**
 *  The height of contentView in the sift view.
 *
 *  Content view height is nonnegative and is expressed in points. You may set the content height if the default height doesn’t satisfy. If you do not explicitly set the tab height, TCTSiftView sets it to a standard value. Or you can using siftView: heightOfContentAtIndex: when you want to have different heigth of content view.
 *
 */
@property (nonatomic) CGFloat contentViewHeight;

/**
 *  Reloads the tabs and contents of the sift view.
 *
 *  Call this method to reload all the data that is used to construct the sift view, including tabs, contents and so on. For efficiency, the sift view redisplays only those tabs that are visible. It adjusts offsets if the sift shrinks as a result of the reload. The sift view’s delegate or data source calls this method when it wants the table view to completely reload its data.
 */
- (void)reloadData;


/**
 *  Registers a nib object containing a cell with the sift view under a specified identifier.
 *
 *  Before dequeueing any cells, call this method or the registerClass:forCellReuseIdentifier: method to tell the sift view how to create new cells. If a cell of the specified type is not currently in a reuse queue, the sift view uses the provided information to create a new cell object automatically.
 *
 *  @param nib        A nib object that specifies the nib file to use to create the cell. This parameter cannot be nil.
 *  @param identifier The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
 */
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

/**
 *  Registers a class for use in creating new table cells.
 *
 *  Prior to dequeueing any cells, call this method or the registerNib:forCellReuseIdentifier: method to tell the sift view how to create new cells. If a cell of the specified type is not currently in a reuse queue, the sift view uses the provided information to create a new cell object automatically.
 *
 *  @param cellClass  The class of a cell that you want to use in the sift.
 *  @param identifier The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
 */
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

/**
 *  Returns a reusable sift-view cell object for the specified reuse identifier.
 *  For performance reasons, a sift view’s data source should generally reuse UICollectionViewCell objects when it assigns cells to rows in its siftView:cellForTabAtIndex: method. A sift view maintains a queue or list of UICollectionViewCell objects that the data source has marked for reuse. Call this method from your data source object when asked to provide a new cell for the sift view. This method dequeues an existing cell if one is available or creates a new one based on the class or nib file you previously registered.
 *
 *  You must register a class or nib file using the registerNib:forCellReuseIdentifier: or registerClass:forCellReuseIdentifier: method before calling this method.If you registered a class for the specified identifier and a new cell must be created, this method initializes the cell by calling its initWithStyle:reuseIdentifier: method. For nib-based cells, this method loads the cell object from the provided nib file. If an existing cell was available for reuse, this method calls the cell’s prepareForReuse method instead.
 *
 *  @param identifier A string identifying the cell object to be reused. This parameter must not be nil.
 *  @param index      The index path specifying the location of the cell. The data source receives this information when it is asked for the cell and should just pass it along. This method uses the index to perform additional configuration based on the cell’s position in the sift view.
 *
 *  @return A UICollectionViewCell object with the associated reuse identifier. This method always returns a valid cell.
 */
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;
@end


@protocol TCTSiftViewDelegate <NSObject>

@optional

/**
 *  Asks the delegate for the width to use for a tab in a specified location.
 *
 *  The method allows the delegate to specify tabs with varying widths. If this method is implemented, the value it returns overrides the value shared out equally.
 *
 *  @param siftView The sift-view object requesting this information.
 *  @param index    An index that locates a tab in siftView.
 *
 *  @return A nonnegative floating-point value that specifies the height (in points) that tab should be.
 */
- (CGFloat)siftView:(TCTSiftView *)siftView widthOfTabAtIndex:(NSInteger)index;

/**
 *  Asks the delegate for the heigth to use for a content view in a specified location.
 *
 *  The method allows the delegate to specify content with varying height. If this method is implemented, the value it returns overrides the value contentViewHeight provide.
 *
 *  @param siftView The sift-view object requesting this information.
 *  @param index    An index that locates a tab in siftView.
 *
 *  @return A nonnegative floating-point value that specifies the height (in points) that content should be.
 */
- (CGFloat)siftView:(TCTSiftView *)siftView heightOfContentAtIndex:(NSInteger)index;


/**
 *  Asks the delegate if the content view should be shown for a certain tab.
 *
 *  You can do something away from sift, such as sequence, so you can return NO, and the content view will not shown. You can use selectTabAtIndex: in 
 *
 *  @param siftView The sift-view object requesting this information.
 *  @param index    An index that locates a tab in siftView.
 *
 *  @return YES if the content view should be shown positioned near the tab and pointing to it, otherwise NO. The default value is YES.
 */
- (BOOL)siftView:(TCTSiftView *)siftView shouldShowContentAtIndex:(NSInteger)index;

/**
 *  Tells the delegate that a specified content is about to be shown.
 *  
 *  This method is not called until users touch a tab and then lift their finger; the content isn't shown until then.
 *
 *  @param siftView The sift-view object requesting this information.
 *  @param index    An index that locates a content in siftView.
 */
- (void)siftView:(TCTSiftView *)siftView willShowContentAtIndex:(NSInteger)index;

/**
 *  Tells the delegate that a specified content is now shown.
 *
 *  This method is called after content is shown and then.
 *
 *  @param siftView The sift-view object requesting this information.
 *  @param index    An index that locates a content in siftView.
 */
- (void)siftView:(TCTSiftView *)siftView didShowContentAtIndex:(NSInteger)index;

/**
 *  Tells the delegate that the specified tab is now clicked.
 *
 *  @param siftView The sift-view object requesting this information.
 *  @param index    An index that locates a content in siftView.
 */
- (void)siftView:(TCTSiftView *)siftView didClickTabAtIndex:(NSInteger)index;

@end

@protocol TCTSiftViewDatasource <NSObject>

@optional

/**
 *  Asks the data source to return the number of tabs in the sift view.
 *
 *  @param siftView The sift-view object requesting this information.
 *
 *  @return The number of tabs in siftView. The default value is 4.
 */
- (NSInteger)numberOfTabsInSiftView:(TCTSiftView *)siftView;


/**
 *  Asks the data source for a cell item to congfigure the cell in a particular location of the sift view.
 *
 *  @param siftView The sift-view object requesting this information.
 *  @param index    An index that locates a content in siftView.
 *
 *  @return An object conforming to TCTSiftViewTabItem protocal that the sift view can use for configuring the specified tab. An assertion is raised if you return nil.
 */
- (id<TCTSiftViewTabItem>)siftView:(TCTSiftView *)siftView itemForTabAtIndex:(NSInteger)index;


/**
 *  Asks the data source for a cell to insert in a particular location of the sift view.
 *
 *  The returned UICollectionViewCell object is frequently one that the application reuses for performance reasons. You should fetch a previously created cell object that is marked for reuse by sending a dequeueReusableCellWithIdentifier: message to siftView.
 *
 *  If you don't conform, it will provide a default style cell for tab which contains an image and title. And you need to give detail imformation using siftView: itemForTabAtIndex: method.
 *
 *  @param siftView The sift-view object requesting this information.
 *  @param index    An index that locates a cell in siftView.
 *
 *  @return An object inheriting from UICollectionViewCell that the sift view can use for the specified tab. An assertion is raised if you return nil.
 */
- (UICollectionViewCell *)siftView:(TCTSiftView *)siftView cellForTabAtIndex:(NSInteger)index;


/**
 *  Asks the data source for a view to insert in a particular location of the sift content view.
 *
 *  @param siftView The sift-view object requesting this information.
 *  @param index    An index that locates a content in siftView.
 *
 *  @return An object inheriting from UIView that the sift view can use for the specified content view. An assertion is raised if you return nil.
 */
- (UIView *)siftView:(TCTSiftView *)siftView viewForContentAtIndex:(NSInteger)index;

@end


@interface TCTSiftView (Animation)

/**
 *  Show the content view at specific index manually
 *
 *  This method will be called if you don't reject the default select behave when you click the tab. when this method is called, the content view will present above the tab with spring animation. You can custom your content view's height in - (CGFloat)siftView:(TCTSiftView *)siftView heightOfContentAtIndex:(NSInteger)index; or use the default height.
 *
 *  @param index The index of content view to show
 */
- (void)showContentViewAtIndex:(NSInteger)index;

/**
 *  Dismiss the content view which is presented.
 *
 *  This method will dismiss the content view on shown and it will be called when you click the background view with an easy in animation.
 */
- (void)dismissContentView;


@end









