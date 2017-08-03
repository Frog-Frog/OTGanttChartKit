//
//  OTGChartDrawView.m
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

#import "OTGChartDrawView.h"

#import "OTGDrawingCommonClass.h"

@interface OTGChartDrawView()

@property (nonatomic) NSArray<UIColor *> *dateBackgroundColorArray;

@end

@implementation OTGChartDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
}


- (void)drawRect:(CGRect)rect {
    
    if (self.processAreaHeight > 0) {
        CGRect processRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, self.processAreaHeight);
        [OTGDrawingCommonClass drawBackground:processRect color:self.processAreaBackgroundColor];
    }
    
    if (self.pointAreaHeight > 0) {
        CGRect pointRect = CGRectMake(rect.origin.x, self.processAreaHeight, rect.size.width, self.pointAreaHeight);
        [OTGDrawingCommonClass drawBackground:pointRect color:self.pointAreaBackgroundColor];
    }
    
    
    
    [OTGDrawingCommonClass drawDateSeparator:self
                                        rect:rect
                                   dateWidth:self.dateWidth
                                   lineWidth:self.dateSeparatorWidth
                                       color:self.dateSeparatorColor];
    
    [self drawDateBackground:rect];
    
    
    
    if (self.todayLineEnabled) {
        if (self.todayIndex != NSNotFound) {
            [self drawTodayLine:rect];
        }
    }
    
    
    if(rect.size.height > 0){
        
        [OTGDrawingCommonClass drawCellSeparator:rect
                                           width:self.rowSeparatorWidth
                                           color:self.rowSeparatorColor];
        
        [OTGDrawingCommonClass drawCenterDotLine:rect
                               processAreaHeight:self.processAreaHeight
                                       lineWidth:self.dotSeparatorWidth
                                           color:self.dotSeparatorColor];
        
    }
    
}


- (void)drawDateBackground:(CGRect)rect
{
    __weak typeof(self) weakSelf = self;
    [self.showDateArray enumerateObjectsUsingBlock:^(NSDate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = idx * weakSelf.dateWidth + weakSelf.dateSeparatorWidth;
        CGFloat y = rect.origin.y;
        CGFloat width = weakSelf.dateWidth - weakSelf.dateSeparatorWidth * 2;
        CGFloat height = rect.size.height;
        CGRect backgroundRect = CGRectMake(x,y,width,height);
        
        UIColor *backgroundColor = [weakSelf.delegate chartBackgroundColorForDate:obj];
        
        if ([backgroundColor isEqual:[UIColor clearColor]]) {
            return;
        }
        
        [OTGDrawingCommonClass drawBackground:backgroundRect color:backgroundColor];
    }];
}



- (void)drawTodayLine:(CGRect)rect
{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    [self.todayLineColor setStroke];
    linePath.lineWidth = self.todayLineWidth;
    
    CGFloat x = self.dateWidth * self.todayIndex + self.dateWidth;
    //区切り線座標を指定
    CGPoint startPoint = CGPointMake(x, rect.origin.y);
    [linePath moveToPoint:startPoint];
    CGPoint endPoint = CGPointMake(x, rect.origin.y + rect.size.height);
    [linePath addLineToPoint:endPoint];
    
    [linePath stroke];
}


@end
