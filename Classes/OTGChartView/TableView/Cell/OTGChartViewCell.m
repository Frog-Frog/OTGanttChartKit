//
//  OTGChartViewCell.m
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

#import "OTGCommonClass.h"

#import "OTGChartViewCell.h"

#import "OTGChartProcessView.h"
#import "OTGChartPointView.h"

#import "OTGChartDrawView.h"

@interface OTGChartViewCell()<OTGChartDrawViewDelegate>

@end

@implementation OTGChartViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Public
- (void)removeAllSubviews
{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
}


- (void)locationSubviews
{
    [self locationDrawView];
    
    [self locationProcessViews];
    
    [self locationPointViews];
}


#pragma mark - Drawing
- (void)locationDrawView
{
    OTGChartDrawView *drawView = [[OTGChartDrawView alloc]initWithFrame:self.contentView.bounds];
    
    drawView.delegate = self;
    
    drawView.todayLineEnabled = self.todayLineEnabled;
    drawView.todayIndex = [OTGCommonClass foundSameDateIndexFromDateArray:self.showDateArray date:[NSDate date]];
    
    drawView.showDateArray = self.showDateArray;
    
    drawView.rowSeparatorColor = self.rowSeparatorColor;
    drawView.processAreaBackgroundColor = self.processAreaBackgroundColor;
    drawView.pointAreaBackgroundColor = self.pointAreaBackgroundColor;
    drawView.dateSeparatorColor = self.dateSeparatorColor;
    drawView.dotSeparatorColor = self.dotSeparatorColor;
    drawView.todayLineColor = self.todayLineColor;
    
    
    drawView.processAreaHeight = self.processAreaHeight;
    drawView.pointAreaHeight = self.pointAreaHeight;
    
    drawView.dateWidth = self.dateWidth;
    drawView.dateSeparatorWidth = self.dateSeparatorWidth;
    drawView.dotSeparatorWidth = self.dotSeparatorWidth;
    drawView.rowSeparatorWidth = self.rowSeparatorWidth;
    drawView.todayLineWidth = self.todayLineWidth;
    
    [self.contentView addSubview:drawView];
}


- (UIColor *)chartBackgroundColorForDate:(NSDate *)date
{
    if (self.delegate) {
        return [self.delegate chartBackgroundColorForDate:date];
    }
    
    return [UIColor clearColor];
}


#pragma mark - ProcessView
- (void)locationProcessViews
{
    __weak typeof(self) weakSelf = self;
    [self.processViewArray enumerateObjectsUsingBlock:^(OTGChartProcessView *_Nonnull chartProcessView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDate *firstDate = [chartProcessView.dateArray firstObject];
        NSDate *lastDate = [chartProcessView.dateArray lastObject];
        
        BOOL isContainProcess = [OTGCommonClass isContainProcessStartDate:firstDate
                                                          processLastDate:lastDate
                                                            showStartDate:[weakSelf.showDateArray firstObject]
                                                             showLastDate:[weakSelf.showDateArray lastObject]];
        
        if (!isContainProcess) {
            return;
        }
        
        chartProcessView = [weakSelf chartProcessViewVariableSetting:chartProcessView];
        
        NSMutableArray *processViewArray = [NSMutableArray array];
        for (UIView *view in weakSelf.contentView.subviews) {
            if ([view isKindOfClass:[OTGChartProcessView class]]) {
                [processViewArray addObject:view];
            }
        }
        
        processViewArray = [[processViewArray sortedArrayUsingComparator:^NSComparisonResult(UIView * _Nonnull view1, UIView * _Nonnull view2) {
                                return (view1.frame.origin.y > view2.frame.origin.y) ? NSOrderedDescending : NSOrderedAscending;
                            }] mutableCopy];
        
        chartProcessView.frame = [weakSelf createProcessViewFrameFromProcessViews:processViewArray
                                                                        firstDate:firstDate
                                                                         lastDate:lastDate];
        [weakSelf.contentView addSubview:chartProcessView];
        
        [chartProcessView trackingHorizontalScrollWithCurrentXPosition:weakSelf.currentContentOffsetX];
        
    }];
}


- (OTGChartProcessView *)chartProcessViewVariableSetting:(OTGChartProcessView *)chartProcessView
{
    chartProcessView.strokeColor = (chartProcessView.strokeColor)? chartProcessView.strokeColor : self.viewColor;
    chartProcessView.fillColor = (chartProcessView.isFill)? chartProcessView.strokeColor : [UIColor whiteColor];
    chartProcessView.showDateArray = self.showDateArray;
    chartProcessView.dateWidth = self.dateWidth;
    chartProcessView.indexPath = self.indexPath;
    chartProcessView.textBackgroundColor = self.processAreaBackgroundColor;
    chartProcessView.minimumProcessViewWidthDays = self.minimumProcessViewWidthDays;
    
    return chartProcessView;
}


/**
 ProcessViewの配置が被らない位置を生成する

 @param array 配置済みのProcessViewのリスト
 @param firstDate 開始日
 @param lastDate 最終日
 @return フレーム
 */
- (CGRect)createProcessViewFrameFromProcessViews:(NSArray *)array
                                       firstDate:(NSDate *)firstDate
                                        lastDate:(NSDate *)lastDate
{
    NSInteger firstDateIndex = [OTGCommonClass foundSameDateIndexFromDateArray:self.showDateArray date:firstDate];
    
    if (firstDateIndex == NSNotFound) {
        firstDateIndex = 0;
        firstDate = [self.showDateArray firstObject];
    }
    
    NSInteger lastDateIndex = [OTGCommonClass foundSameDateIndexFromDateArray:self.showDateArray date:lastDate];
    
    if (lastDateIndex == NSNotFound) {
        lastDate = [self.showDateArray lastObject];
    }
    
    CGFloat x = self.dateWidth * firstDateIndex + 1;
    __block CGFloat y = self.processAreaTopMargin;
    
    NSInteger daysCount = [OTGCommonClass daysCountFromStartDate:firstDate
                                                        lastDate:lastDate
                                                isCountStartDate:YES];
    
    CGFloat width = self.dateWidth * daysCount - self.dateSeparatorWidth * 2;
    CGFloat minimumProcessWidth = self.dateWidth * self.minimumProcessViewWidthDays - self.dateSeparatorWidth * 2;
    width = (minimumProcessWidth > width)? minimumProcessWidth : width;
    
    __weak typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(UIView *_Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect newProcessViewRect = CGRectMake(x, y, width, weakSelf.processViewHeight);
        CGRect rect = view.frame;
        if (CGRectIntersectsRect(rect, newProcessViewRect)) {
            //重なっている他のViewがある時はyの位置をずらす
            y += weakSelf.processViewHeight;
        }
    }];
    
    return CGRectMake(x, y, width, self.processViewHeight);
}


#pragma mark - PointView
- (void)locationPointViews
{
    __weak typeof(self) weakSelf = self;
    [self.pointViewArray enumerateObjectsUsingBlock:^(OTGChartPointView *_Nonnull chartPointView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger sameDateIndex = [OTGCommonClass foundSameDateIndexFromDateArray:self.showDateArray date:chartPointView.date];
        if (sameDateIndex == NSNotFound) {
            return;
        }
        
        chartPointView = [weakSelf chartPointViewVariableSetting:chartPointView];
        
        NSMutableArray *pointViewArray = [NSMutableArray array];
        for (UIView *view in weakSelf.contentView.subviews) {
            if ([view isKindOfClass:[OTGChartPointView class]]) {
                [pointViewArray addObject:view];
            }
        }
        
        pointViewArray = [[pointViewArray sortedArrayUsingComparator:^NSComparisonResult(UIView * _Nonnull view1, UIView * _Nonnull view2) {
            return (view1.frame.origin.y > view2.frame.origin.y) ? NSOrderedDescending : NSOrderedAscending;
        }] mutableCopy];
        
        
        
        chartPointView.frame = [weakSelf createPointViewFrameFromPointViews:pointViewArray
                                                              dateIndex:sameDateIndex];
        [weakSelf.contentView addSubview:chartPointView];
    }];
}


/**
 OTGChartPointViewの変数を入れる

 @param chartPointView OTGChartPointView
 @return OTGChartPointView
 */
- (OTGChartPointView *)chartPointViewVariableSetting:(OTGChartPointView *)chartPointView
{
    chartPointView.strokeColor = (chartPointView.strokeColor)? chartPointView.strokeColor:self.viewColor;
    chartPointView.fillColor = (chartPointView.isFill)? chartPointView.strokeColor:chartPointView.fillColor;
    chartPointView.indexPath = self.indexPath;
    chartPointView.textBackgroundColor = self.pointAreaBackgroundColor;
    return chartPointView;
}


/**
 pointView同士が被らない位置になるフレームを作成する

 @param array すでに置かれているpointViewのリスト
 @param dateIndex チャートに表示されている初日から何日目に表示されるか
 @return フレーム
 */
- (CGRect)createPointViewFrameFromPointViews:(NSArray *)array
                                   dateIndex:(NSInteger)dateIndex
{
    CGFloat x = self.dateWidth * dateIndex + self.dateSeparatorWidth;
    __block CGFloat y = self.processAreaHeight + self.pointAreaTopMargin;
    
    CGFloat width = self.dateWidth * self.minimumPointViewWidthDays + self.dateSeparatorWidth * 2;
    
    __weak typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(UIView *_Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect newPointViewRect = CGRectMake(x, y, width, weakSelf.pointViewHeight);
        CGRect rect = view.frame;
        
        if (CGRectIntersectsRect(rect, newPointViewRect)) {
            y += weakSelf.pointViewHeight;
        }
    }];
    
    return CGRectMake(x, y, width, self.pointViewHeight);
}


@end
