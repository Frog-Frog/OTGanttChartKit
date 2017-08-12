//
//  OTGTodayFigureView.h
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

#import "OTGanttChartConstant.h"

@interface OTGTodayFigureView : UIView

@property(nonatomic) UIColor *todayLineColor;

@property(nonatomic) CGFloat todayFigureSize;

@property(nonatomic) CGFloat dateWidth;

@property(nonatomic) NSInteger todayIndex;

@property(nonatomic) OTGFigureType todayFigureType;

@end
