//
//  OTGanttChartView.h
//  OTGanttChartView
//
//  Created by Tomosuke Okada on 2017/08/01.
//  Copyright © 2017年 TomosukeOkada. All rights reserved.
//
//  https://github.com/PKPK-Carnage/OTGanttChartKit

/**
 [OTGanttChartView]
 
 Copyright (c) [2017] [Tomosuke Okada]
 
 This software is released under the MIT License.
 http://opensource.org/licenses/mit-license.ph

 */

#import <UIKit/UIKit.h>

#import "OTGCommonClass.h"

typedef NS_ENUM(NSInteger,OTGHorizontalScrollPosition)
{
    OTGHorizontalScrollPositionLeft,
    OTGHorizontalScrollPositionCenter,
    OTGHorizontalScrollPositionRight,
    OTGHorizontalScrollPositionAutomatic,
    OTGHorizontalScrollPositionNone
};

@class OTGanttChartView,OTGChartProcessView,OTGChartPointView;

@protocol OTGanttChartViewDataSource<NSObject>

@required

- (NSDate *)startDateInGanttChartView:(OTGanttChartView *)ganttChartView;

- (NSDate *)lastDateInGanttChartView:(OTGanttChartView *)ganttChartView;

- (NSInteger)ganttChartView:(OTGanttChartView *)ganttChartView numberOfRowsInSection:(NSInteger)section;

- (NSInteger)ganttChartView:(OTGanttChartView *)ganttChartView numberOfProcessViewsForIndexPath:(NSIndexPath *)indexPath;

- (OTGChartProcessView *)ganttChartView:(OTGanttChartView *)ganttChartView chartProcessViewAtIndexPath:(NSIndexPath *)indexPath processNo:(NSInteger)processNo;

- (NSInteger)ganttChartView:(OTGanttChartView *)ganttChartView numberOfPointViewsForIndexPath:(NSIndexPath *)indexPath;

- (OTGChartPointView *)ganttChartView:(OTGanttChartView *)ganttChartView chartPointViewAtIndexPath:(NSIndexPath *)indexPath pointNo:(NSInteger)pointNo;

@optional

- (NSInteger)numberOfSectionsInGanttChartView:(OTGanttChartView *)ganttChartView;

- (NSInteger)ganttChartView:(OTGanttChartView *)ganttChartView numberOfProcessViewsForSection:(NSInteger)section;

- (OTGChartProcessView *)ganttChartView:(OTGanttChartView *)ganttChartView chartProcessViewAtSection:(NSInteger)section processNo:(NSInteger)processNo;

- (NSInteger)ganttChartView:(OTGanttChartView *)ganttChartView numberOfPointViewsForSection:(NSInteger)section;

- (OTGChartPointView *)ganttChartView:(OTGanttChartView *)ganttChartView chartPointViewAtSection:(NSInteger)section pointNo:(NSInteger)pointNo;

@end

@protocol OTGanttChartViewDelegate<NSObject>

@optional

- (void)ganttChartView:(OTGanttChartView *)ganttChartView didVerticalScroll:(UIScrollView *)scrollView;

- (void)ganttChartView:(OTGanttChartView *)ganttChartView didHorizontalScroll:(UIScrollView *)scrollView;

- (UIColor *)ganttChartView:(OTGanttChartView *)ganttChartView chartColorForSection:(NSInteger)section;
- (UIColor *)ganttChartView:(OTGanttChartView *)ganttChartView chartColorForIndexPath:(NSIndexPath *)indexPath;

- (UIColor *)ganttChartView:(OTGanttChartView *)ganttChartView chartBackgroundColorForDate:(NSDate *)date;

// These method is only available when refleshControlEnabled is equal YES;
- (void)ganttChartView:(OTGanttChartView *)ganttChartView scrolledPrevieous:(UIScrollView *)scrollView;
- (void)ganttChartView:(OTGanttChartView *)ganttChartView scrolledNext:(UIScrollView *)scrollView;

- (void)ganttChartView:(OTGanttChartView *)ganttChartView tappedSection:(NSInteger)section;

@end

@interface OTGanttChartView : UIView

@property(nonatomic,weak) id<OTGanttChartViewDataSource> dataSource;

@property(nonatomic,weak) id<OTGanttChartViewDelegate> delegate;

// Default is OTGThemeModeDark.
@property(nonatomic) OTGThemeMode themeMode;

// Color
@property(nonatomic) UIColor *dateSeparatorColor;
@property(nonatomic) UIColor *dotSeparatorColor;
@property(nonatomic) UIColor *chartBorderColor;
@property(nonatomic) UIColor *todayHiligtedBackgroundColor;
@property(nonatomic) UIColor *processAreaBackgroundColor;
@property(nonatomic) UIColor *pointAreaBackgroundColor;
@property(nonatomic) UIColor *dateAreaBackgroundColor;
@property(nonatomic) UIColor *scrollBackgroundColor;
@property(nonatomic) UIColor *rowSeparatorColor;
@property(nonatomic) UIColor *refreshArrowColor;
@property(nonatomic) UIColor *dateTextColor;
@property(nonatomic) UIColor *todayHiligtedDateTextColor;
@property(nonatomic) UIColor *todayLineColor;

@property(nonatomic,copy) NSString *localeIdentifier;

@property(nonatomic) CGFloat showDateAreaHeight;
@property(nonatomic) CGFloat dateWidth;
@property(nonatomic) CGFloat dateSeparatorWidth;
@property(nonatomic) CGFloat dateFontSize;
@property(nonatomic) CGFloat chartBorderWidth;
@property(nonatomic) CGFloat rowSeparatorWidth;
@property(nonatomic) CGFloat dotSeparatorWidth;
@property(nonatomic) CGFloat todayLineWidth;
@property(nonatomic) CGFloat todayFigureSize;

// Margin's default value = 0;
@property(nonatomic) CGFloat processAreaTopMargin;
@property(nonatomic) CGFloat processAreaUnderMargin;
@property(nonatomic) CGFloat pointAreaTopMargin;
@property(nonatomic) CGFloat pointAreaUnderMargin;


@property(nonatomic) CGFloat processViewHeight;
@property(nonatomic) CGFloat pointViewHeight;

@property(nonatomic) OTGFigureType todayFigureType;

@property(nonatomic) CGFloat minimumSectionProcessAreaHeight;
@property(nonatomic) CGFloat minimumSectionPointAreaHeight;

@property(nonatomic) CGFloat minimumRowProcessAreaHeight;
@property(nonatomic) CGFloat minimumRowPointAreaHeight;

@property(nonatomic) NSInteger minimumProcessViewWidthDays;
@property(nonatomic) NSInteger minimumPointViewWidthDays;

@property(nonatomic) BOOL todayLineEnabled;
@property(nonatomic) BOOL leftRefreshControlEnabled;
@property(nonatomic) BOOL rightRefreshControlEnabled;

@property(nonatomic,readonly) NSDate *currentStartDate;
@property(nonatomic,readonly) NSDate *currentLastDate;

// reload OTGanttChartView
- (void)reloadData;

// reload OTGanttChartView. But OTGanttChartView hold current horizontal scroll contentOffset.
- (void)redrawData;

// reload OTGanttChartView's row.
- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)rowAnimation;

// reload OTGanttChartView's sections.
- (void)reloadSections:(NSIndexSet *)indexSet withRowAnimation:(UITableViewRowAnimation)animation;

// If argument date were not showing, set contentOffset CGpointZero.
- (void)setHorizontalContentOffsetFromDate:(NSDate *)date atPosition:(OTGHorizontalScrollPosition)position animated:(BOOL)animated;


- (void)setHorizontalContentOffset:(CGPoint)offset;
- (void)setVerticalContentOffset:(CGPoint)offset;

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

//
- (NSDate *)getcurrentLeftDate;
- (NSDate *)getCurrentCenterDate;
- (NSDate *)getcurrentRightDate;

// If you use left menu, yow must use these method and get
- (CGFloat)getSectionHeightAtSection:(NSInteger)section;
- (CGFloat)getRowHeightAtIndexPath:(NSIndexPath *)indexPath;

@end
