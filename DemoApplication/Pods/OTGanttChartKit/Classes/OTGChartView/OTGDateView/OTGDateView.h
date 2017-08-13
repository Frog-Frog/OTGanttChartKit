//
//  OTGDateView.h
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

@interface OTGDateView : UIView

@property(nonatomic) UIColor *dateSeparatorColor;
@property(nonatomic) UIColor *chartBorderColor;
@property(nonatomic) UIColor *todayHiligtedBackgroundColor;
@property(nonatomic) UIColor *dateTextColor;
@property(nonatomic) UIColor *dateAreaBackgroundColor;
@property(nonatomic) UIColor *todayHiligtedDateTextColor;

@property(nonatomic) CGFloat dateWidth;
@property(nonatomic) CGFloat dateSeparatorWidth;
@property(nonatomic) CGFloat chartBorderWidth;

@property(nonatomic) CGFloat dateFontSize;

@property(nonatomic) NSInteger todayIndex;

@property(nonatomic,copy) NSString *localeIdentifier;

@property(nonatomic) NSArray<NSDate *> *showDateArray;

@end
