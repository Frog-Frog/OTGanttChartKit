//
//  OTGTodayFigureView.m
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

#import "OTGTodayFigureView.h"

#import "OTGDrawingCommonClass.h"


@implementation OTGTodayFigureView

- (void)drawRect:(CGRect)rect {
    [self drawTodayFigure:rect];
}

- (void)drawTodayFigure:(CGRect)rect
{
    
    if (self.todayIndex == NSNotFound) {
        return;
    }
    
    
    
    CGFloat x = self.dateWidth * self.todayIndex + self.dateWidth - self.todayFigureSize/2;
    CGRect figureRect = CGRectMake(x, 0, self.todayFigureSize, self.todayFigureSize);
    
    switch (self.todayFigureType) {
        case OTGFigureTypeCircle:
        {
            [OTGDrawingCommonClass drawCircle:figureRect
                                    lineWidth:0
                                  strokeColor:self.todayLineColor
                                    fillColor:self.todayLineColor];
            break;
        }
        case OTGFigureTypeSquare:
        {
            [OTGDrawingCommonClass drawSquare:figureRect
                                    lineWidth:0
                                  strokeColor:self.todayLineColor
                                    fillColor:self.todayLineColor];
            break;
        }
        case OTGFigureTypeTriangle:
        {
            [OTGDrawingCommonClass drawTriangle:figureRect
                                      lineWidth:0
                                    strokeColor:self.todayLineColor
                                      fillColor:self.todayLineColor];
            break;
        }
        case OTGFigureTypeDiamond:
        {
            [OTGDrawingCommonClass drawDiamond:figureRect
                                     lineWidth:0
                                   strokeColor:self.todayLineColor
                                     fillColor:self.todayLineColor];
        }
        default:
            break;
    }
    
}



@end
