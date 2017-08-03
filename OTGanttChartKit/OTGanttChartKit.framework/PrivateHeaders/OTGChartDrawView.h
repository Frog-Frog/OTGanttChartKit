//
//  OTGChartDrawView.h
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

#import "OTGCommonClass.h"

@protocol OTGChartDrawViewDelegate <NSObject>

- (UIColor *)chartBackgroundColorForDate:(NSDate *)date;

@end

@interface OTGChartDrawView : UIView

@property(nonatomic,weak) id<OTGChartDrawViewDelegate> delegate;

@property(nonatomic) OTGThemeMode themeMode;

@property(nonatomic) CGFloat processAreaHeight;
@property(nonatomic) CGFloat pointAreaHeight;

@property(nonatomic) BOOL todayLineEnabled;

@property(nonatomic) NSArray<NSDate *> *showDateArray;

@property(nonatomic) NSInteger todayIndex;

//color
@property(nonatomic) UIColor *dateSeparatorColor;
@property(nonatomic) UIColor *dotSeparatorColor;
@property(nonatomic) UIColor *processAreaBackgroundColor;
@property(nonatomic) UIColor *pointAreaBackgroundColor;
@property(nonatomic) UIColor *rowSeparatorColor;
@property(nonatomic) UIColor *todayLineColor;

//size
@property(nonatomic) CGFloat dateWidth;
@property(nonatomic) CGFloat dateSeparatorWidth;
@property(nonatomic) CGFloat rowSeparatorWidth;
@property(nonatomic) CGFloat dotSeparatorWidth;
@property(nonatomic) CGFloat todayLineWidth;

@end
