//
//  TCTSiftViewConst.h
//  TCTSiftView
//
//  Created by Tracyone on 15/6/9.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import <UIKit/UIKit.h>

//siftview base configure
extern const CGFloat TCTSiftViewTabHeight;
extern const CGFloat TCTSiftViewContentContainerHeight;
extern const NSInteger TCTSiftViewNumberOfTabs;
extern const BOOL TCTSiftViewShouldShowContent;

//animation duration
extern const NSTimeInterval TCTSiftViewShowContentDuration;
extern const NSTimeInterval TCTSiftViewBackgroundDuration;
extern const NSTimeInterval TCTSiftViewDismissContentDuration;
extern const NSTimeInterval TCTSiftViewShowContentDelay;

//siftview color
#define TCTSiftViewTabTitleDefaultColor TCT_RGBA(187,187,187,1)
#define TCTSiftViewTabTitleSelectedColor TCT_RGBA(187,187,187,1)

#define TCTSiftViewTabBackgroundColor TCT_RGBA(46,52,59,0.97)
#define TCTSiftViewBackgroundColor TCT_RGBA(0,0,0,0.6)

//function
#define TCT_RGBA(r,g,b,a)						[UIColor colorWithRed:(float)(r/255.0f) green:(float)(g/255.0f) blue:(float)(b/255.0f) alpha:a]






