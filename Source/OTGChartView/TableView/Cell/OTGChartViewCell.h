//
//  OTGChartViewCell.h
//  OTGanttChartView
//
//  Created by Tomosuke Okada on 2017/08/01.
//  Copyright © 2017年 TomosukeOkada. All rights reserved.
//
//  https://github.com/prprstream/OTGanttChartView

/**
 [OTGanttChartView]
 
 Copyright (c) [2017] [Tomosuke Okada]
 
 This software is released under the MIT License.
 http://opensource.org/licenses/mit-license.ph
 
 */

#import <UIKit/UIKit.h>
@class OTGChartViewCell,OTGChartProcessView,OTGChartPointView;

@protocol OTGChartViewCellDelegate <NSObject>

- (UIColor *)chartBackgroundColorForDate:(NSDate *)date;

@end

@interface OTGChartViewCell : UITableViewCell

#pragma mark - Property
@property(nonatomic) id<OTGChartViewCellDelegate> delegate;

@property(nonatomic) NSIndexPath *indexPath;

@property(nonatomic) UIColor *viewColor;

@property(nonatomic) UIColor *dateSeparatorColor;
@property(nonatomic) UIColor *dotSeparatorColor;
@property(nonatomic) UIColor *processAreaBackgroundColor;
@property(nonatomic) UIColor *pointAreaBackgroundColor;
@property(nonatomic) UIColor *rowSeparatorColor;
@property(nonatomic) UIColor *todayLineColor;

@property(nonatomic) CGFloat dateWidth;
@property(nonatomic) CGFloat dateSeparatorWidth;
@property(nonatomic) CGFloat rowSeparatorWidth;
@property(nonatomic) CGFloat dotSeparatorWidth;
@property(nonatomic) CGFloat todayLineWidth;
@property(nonatomic) CGFloat processViewHeight;
@property(nonatomic) CGFloat pointViewHeight;

@property(nonatomic) CGFloat processAreaTopMargin;
@property(nonatomic) CGFloat pointAreaTopMargin;

@property(nonatomic) CGFloat processAreaHeight;
@property(nonatomic) CGFloat pointAreaHeight;

@property(nonatomic) NSInteger minimumProcessViewWidthDays;
@property(nonatomic) NSInteger minimumPointViewWidthDays;

@property(nonatomic) BOOL todayLineEnabled;

@property(nonatomic) NSArray<NSDate *> *showDateArray;

@property(nonatomic) NSArray<OTGChartProcessView *> *processViewArray;
@property(nonatomic) NSArray<OTGChartPointView *> *pointViewArray;

#pragma mark - PublicMethod
- (void)removeAllSubviews;

- (void)locationSubviews;

@end
