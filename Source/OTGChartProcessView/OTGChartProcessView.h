//
//  OTGChartProcessView.h
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

@class OTGChartProcessView;

@protocol OTGChartProcessViewDelegate <NSObject>

- (void)tappedChartProcessView:(OTGChartProcessView *)chartProcessView;

@end


@interface OTGChartProcessView : UIView

@property (nonatomic, weak) id<OTGChartProcessViewDelegate> delegate;

@property(nonatomic) NSIndexPath *indexPath;

@property(nonatomic) NSInteger processNo;

@property(nonatomic) UIColor *strokeColor;

@property(nonatomic) UIColor *fillColor;

@property(nonatomic) NSString *title;

@property(nonatomic) BOOL isDotLine;

@property(nonatomic) BOOL isFill;

@property(nonatomic) OTGFigureType figureType;

@property(nonatomic) CGFloat dateWidth;

@property(nonatomic) CGFloat figureLineWidth;

@property(nonatomic) CGFloat lineWidth;

@property(nonatomic) CGFloat dotLineWidth;

@property(nonatomic) CGFloat dotBlankWidth;

@property(nonatomic) CGFloat dotSolidLineWidth;

@property(nonatomic) CGFloat startRatio;

@property(nonatomic) CGFloat finishRatio;

@property(nonatomic) CGFloat figureSize;

@property(nonatomic) CGFloat figureLeftMargin;

@property(nonatomic) CGFloat figureRightMargin;

@property(nonatomic) CGFloat fontSize;

@property(nonatomic) UIColor *fontColor;

@property(nonatomic) UIColor *textBackgroundColor;

@property(nonatomic) NSArray<NSDate *> *dateArray;

@property(nonatomic) NSArray<NSDate *> *showDateArray;

@end
