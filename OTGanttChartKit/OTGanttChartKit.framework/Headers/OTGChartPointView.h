//
//  OTGChartPointView.h
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

#import "OTGanttChartConstant.h"

@class OTGChartPointView;

@protocol OTGChartPointViewDelegate <NSObject>

- (void)tappedChartPointView:(OTGChartPointView *)chartPointView;

@end

@interface OTGChartPointView : UIView

@property (nonatomic, weak) id<OTGChartPointViewDelegate> delegate;

@property(nonatomic) NSIndexPath *indexPath;

@property(nonatomic) NSInteger pointNo;

@property(nonatomic) BOOL isFill;

@property(nonatomic) NSDate *date;

@property(nonatomic) OTGFigureType figureType;

@property(nonatomic) UIColor *strokeColor;

@property(nonatomic) UIColor *fillColor;

@property(nonatomic) CGFloat figureLineWidth;

@property(nonatomic) CGFloat figureSize;

@property(nonatomic) CGFloat figureLeftMargin;

@property(nonatomic) CGFloat figureRightMargin;

@property(nonatomic) NSString *title;

@property(nonatomic) CGFloat fontSize;

@property(nonatomic) UIColor *fontColor;

@property(nonatomic) UIColor *textBackgroundColor;


@end
