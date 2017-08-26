//
//  OTGChartView.h
//  OTGanttChartKit
//
//  Created by Tomosuke Okada on 2017/08/01.
//  Copyright © 2017年 TomosukeOkada. All rights reserved.
//
//  https://github.com/PKPK-Carnage/OTGanttChartKit

/**
 [OTGanttChartKit]
 
 Copyright (c) [2017] [Tomosuke Okada]
 
 This software is released under the MIT License.
 http://opensource.org/licenses/mit-license.ph
 
 */

#import <UIKit/UIKit.h>

@class OTGChartView,OTGChartSectionView,OTGChartProcessView,OTGChartPointView;

@protocol OTGChartViewDataSource<NSObject>

- (NSInteger)numberOfSectionInChartView;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

@end

@protocol OTGChartViewDelegate <NSObject>

- (UIColor *)chartColorForIndexPath:(NSIndexPath *)indexPath;

- (UIColor *)chartColorForSection:(NSInteger)section;

- (UIColor *)chartBackgroundColorForDate:(NSDate *)date;

- (void)tappedSection:(NSInteger)section;

- (void)didVerticalScroll:(UIScrollView *)scrollView;

@end


@interface OTGChartView : UIView

//protocl
@property(nonatomic,weak) id<OTGChartViewDataSource> dataSource;
@property(nonatomic,weak) id<OTGChartViewDelegate> delegate;

//color
@property(nonatomic) UIColor *dateSeparatorColor;
@property(nonatomic) UIColor *dotSeparatorColor;
@property(nonatomic) UIColor *chartBorderColor;
@property(nonatomic) UIColor *todayHiligtedBackgroundColor;
@property(nonatomic) UIColor *processAreaBackgroundColor;
@property(nonatomic) UIColor *pointAreaBackgroundColor;
@property(nonatomic) UIColor *dateAreaBackgroundColor;
@property(nonatomic) UIColor *rowSeparatorColor;
@property(nonatomic) UIColor *dateTextColor;
@property(nonatomic) UIColor *todayHiligtedDateTextColor;
@property(nonatomic) UIColor *todayLineColor;

//LocaleIdentifier
@property(nonatomic,copy) NSString *localeIdentifier;

//size
@property(nonatomic) CGFloat showDateAreaHeight;
@property(nonatomic) CGFloat dateWidth;
@property(nonatomic) CGFloat dateSeparatorWidth;
@property(nonatomic) CGFloat dateFontSize;
@property(nonatomic) CGFloat chartBorderWidth;
@property(nonatomic) CGFloat rowSeparatorWidth;
@property(nonatomic) CGFloat dotSeparatorWidth;
@property(nonatomic) CGFloat todayLineWidth;
@property(nonatomic) CGFloat todayFigureSize;

@property(nonatomic) CGFloat processAreaTopMargin;
@property(nonatomic) CGFloat pointAreaTopMargin;

@property(nonatomic) CGFloat processViewHeight;
@property(nonatomic) CGFloat pointViewHeight;

@property(nonatomic) NSInteger minimumProcessViewWidthDays;
@property(nonatomic) NSInteger minimumPointViewWidthDays;

@property(nonatomic) OTGFigureType todayFigureType;

@property(nonatomic) BOOL todayLineEnabled;

//data
@property(nonatomic) NSArray<NSDate *> *showDateArray;

@property (nonatomic) NSArray<NSArray<OTGChartProcessView *> *> *allSectionProcessViewArray;
@property (nonatomic) NSArray<NSArray<OTGChartPointView *> *> *allSectionPointViewArray;
@property (nonatomic) NSArray<NSNumber *> *allSectionProcessHeightArray;
@property (nonatomic) NSArray<NSNumber *> *allSectionPointHeightArray;

@property (nonatomic) NSArray<NSArray<NSArray<OTGChartProcessView *> *> *> *allRowProcessViewArray;
@property (nonatomic) NSArray<NSArray<NSArray<OTGChartPointView *> *> *> *allRowPointViewArray;
@property (nonatomic) NSArray<NSArray<NSNumber *> *> *allRowProcessHeightArray;
@property (nonatomic) NSArray<NSArray<NSNumber *> *> *allRowPointHeightArray;

@property(nonatomic) CGFloat currentContentOffsetX;

//public
- (void)reloadData;

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)reloadSections:(NSIndexSet *)indexSet withRowAnimation:(UITableViewRowAnimation)animation;

- (void)setVerticalContentOffset:(CGPoint)offset;

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

@end
