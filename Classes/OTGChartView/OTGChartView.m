//
//  OTGChartView.m
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

#import "OTGCommonClass.h"

#import "OTGChartView.h"

#import "OTGDateView.h"
#import "OTGTodayFigureView.h"

#import "OTGChartSectionView.h"
#import "OTGChartViewCell.h"

@interface OTGChartView() <UITableViewDelegate,UITableViewDataSource,OTGChartSectionViewDelegate,OTGChartViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet OTGDateView *dateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateViewHeightConstraint;
@property (weak, nonatomic) IBOutlet OTGTodayFigureView *todayFigureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayFigureHeightConstraint;


@property (nonatomic) NSInteger todayIndex;

@end

@implementation OTGChartView

#pragma mark - Initialize
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


/**
 画面の初期化を行います。
 
 @param aDecoder アーカイブ
 
 @return 自身
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // 初期化処理
        [self initialize];
    }
    return self;
}


/**
 初期化処理を行います。
 */
- (void)initialize
{
    // nib設定
    NSString *nibName = NSStringFromClass([self class]);
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    UINib *nib = [UINib nibWithNibName:nibName bundle:frameworkBundle];
    UIView *subView = [nib instantiateWithOwner:self options:nil][0];
    subView.frame = self.bounds;
    [self addSubview:subView];
    [self sendSubviewToBack:subView];

    [self prepareTableView];
}


- (void)prepareTableView
{
    NSString *cellName = NSStringFromClass([OTGChartViewCell class]);
    [self.tableView registerClass:[OTGChartViewCell class] forCellReuseIdentifier:cellName];
    
    NSString *sectionName = NSStringFromClass([OTGChartSectionView class]);
    [self.tableView registerClass:[OTGChartSectionView class] forHeaderFooterViewReuseIdentifier:sectionName];
}


#pragma mark - Setter
- (void)setShowDateArray:(NSArray *)showDateArray
{
    _showDateArray = showDateArray;
    self.dateView.showDateArray = showDateArray;
    self.todayIndex = [OTGCommonClass foundSameDateIndexFromDateArray:self.showDateArray date:[NSDate date]];
}


- (void)setTodayIndex:(NSInteger)todayIndex
{
    _todayIndex = todayIndex;
    self.dateView.todayIndex = todayIndex;
    self.todayFigureView.todayIndex = todayIndex;
}


#pragma mark Color
- (void)setDateAreaBackgroundColor:(UIColor *)dateAreaBackgroundColor
{
    _dateAreaBackgroundColor = dateAreaBackgroundColor;
    self.dateView.dateAreaBackgroundColor = dateAreaBackgroundColor;
}


- (void)setDateTextColor:(UIColor *)dateTextColor
{
    _dateTextColor = dateTextColor;
    self.dateView.dateTextColor = dateTextColor;
}


- (void)setTodayHiligtedDateTextColor:(UIColor *)todayHiligtedDateTextColor
{
    _todayHiligtedDateTextColor = todayHiligtedDateTextColor;
    self.dateView.todayHiligtedDateTextColor = todayHiligtedDateTextColor;
}


- (void)setTodayHiligtedBackgroundColor:(UIColor *)todayHiligtedBackgroundColor
{
    _todayHiligtedBackgroundColor = todayHiligtedBackgroundColor;
    self.dateView.todayHiligtedBackgroundColor = todayHiligtedBackgroundColor;
}


- (void)setDateSeparatorColor:(UIColor *)dateSeparatorColor
{
    _dateSeparatorColor = dateSeparatorColor;
    self.dateView.dateSeparatorColor = dateSeparatorColor;
}


- (void)setTodayLineColor:(UIColor *)todayLineColor
{
    _todayLineColor = todayLineColor;
    self.todayFigureView.todayLineColor = todayLineColor;
}


#pragma mark Locale
- (void)setLocaleIdentifier:(NSString *)localeIdentifier
{
    _localeIdentifier = localeIdentifier;
    self.dateView.localeIdentifier = localeIdentifier;
}


#pragma mark Size
- (void)setShowDateAreaHeight:(CGFloat)showDateAreaHeight
{
    _showDateAreaHeight = showDateAreaHeight;
    self.dateViewHeightConstraint.constant = showDateAreaHeight;
}


- (void)setDateWidth:(CGFloat)dateWidth
{
    _dateWidth = dateWidth;
    self.dateView.dateWidth = dateWidth;
    self.todayFigureView.dateWidth = dateWidth;
}


- (void)setDateFontSize:(CGFloat)dateFontSize
{
    _dateFontSize = dateFontSize;
    self.dateView.dateFontSize = dateFontSize;
}


- (void)setDateSeparatorWidth:(CGFloat)dateSeparatorWidth
{
    _dateSeparatorWidth = dateSeparatorWidth;
    self.dateView.dateSeparatorWidth = dateSeparatorWidth;
}


- (void)setChartBorderWidth:(CGFloat)chartBorderWidth
{
    _chartBorderWidth = chartBorderWidth;
    self.dateView.chartBorderWidth = chartBorderWidth;
}


- (void)setTodayFigureSize:(CGFloat)todayFigureSize
{
    _todayFigureSize = todayFigureSize;
    self.todayFigureHeightConstraint.constant = todayFigureSize;
    self.todayFigureView.todayFigureSize = todayFigureSize;
}


- (void)setTodayLineEnabled:(BOOL)todayLineEnabled
{
    _todayLineEnabled = todayLineEnabled;
    self.todayFigureView.hidden = (todayLineEnabled)? NO:YES;
}

- (void)setTodayFigureType:(OTGFigureType)todayFigureType
{
    _todayFigureType = todayFigureType;
    self.todayFigureView.todayFigureType = todayFigureType;
}


#pragma mark - Public Method
- (void)reloadData
{
    [self.dateView setNeedsDisplay];
    [self.todayFigureView setNeedsDisplay];
    [self layoutIfNeeded];
    [self.tableView reloadData];
}


- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
    [self.tableView reloadRowsAtIndexPaths:indexPaths
                          withRowAnimation:rowAnimation];
}


- (void)reloadSections:(NSIndexSet *)indexSet withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.tableView reloadSections:indexSet
                  withRowAnimation:animation];
}


- (void)setVerticalContentOffset:(CGPoint)offset
{
    self.tableView.contentOffset = offset;
}


- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:scrollPosition
                                  animated:animated];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource numberOfSectionInChartView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = NSStringFromClass([OTGChartViewCell class]);
    OTGChartViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName
                                                             forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.indexPath = indexPath;
    
    cell.todayLineEnabled = self.todayLineEnabled;

    cell.viewColor = [self.delegate chartColorForIndexPath:indexPath];
    
    cell.showDateArray = self.showDateArray;
    
    cell.dateSeparatorColor = self.dateSeparatorColor;
    cell.dotSeparatorColor = self.dotSeparatorColor;
    cell.pointAreaBackgroundColor = self.pointAreaBackgroundColor;
    cell.processAreaBackgroundColor = self.processAreaBackgroundColor;
    cell.rowSeparatorColor = self.rowSeparatorColor;
    cell.todayLineColor = self.todayLineColor;
    
    cell.dateWidth = self.dateWidth;
    cell.rowSeparatorWidth = self.rowSeparatorWidth;
    cell.dotSeparatorWidth = self.dotSeparatorWidth;
    cell.dateSeparatorWidth = self.dateSeparatorWidth;
    cell.todayLineWidth = self.todayLineWidth;
    cell.processViewHeight = self.processViewHeight;
    cell.pointViewHeight = self.pointViewHeight;
    cell.processAreaTopMargin = self.processAreaTopMargin;
    cell.pointAreaTopMargin = self.pointAreaTopMargin;
    
    cell.processAreaHeight = [self.allRowProcessHeightArray[indexPath.section][indexPath.row] floatValue];
    cell.pointAreaHeight = [self.allRowPointHeightArray[indexPath.section][indexPath.row] floatValue];
    
    cell.minimumProcessViewWidthDays = self.minimumProcessViewWidthDays;
    cell.minimumPointViewWidthDays = self.minimumPointViewWidthDays;
    
    cell.processViewArray = self.allRowProcessViewArray[indexPath.section][indexPath.row];
    cell.pointViewArray = self.allRowPointViewArray[indexPath.section][indexPath.row];
    
    cell.currentContentOffsetX = self.currentContentOffsetX;
    
    [cell removeAllSubviews];
    
    [cell locationSubviews];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = NSStringFromClass([OTGChartSectionView class]);
    
    OTGChartSectionView *chartSectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionName];
    
    CGFloat height = [self.allSectionProcessHeightArray[section] floatValue] + [self.allSectionPointHeightArray[section] floatValue];
    CGRect sectionFrame = CGRectMake(0, 0, self.frame.size.width, height);
    
    chartSectionView.frame = sectionFrame;
    
    chartSectionView.delegate = self;
    
    chartSectionView.section = section;
    
    chartSectionView.todayLineEnabled = self.todayLineEnabled;
    
    chartSectionView.viewColor = [self.delegate chartColorForSection:section];
    
    chartSectionView.showDateArray = self.showDateArray;
    
    chartSectionView.dateSeparatorColor = self.dateSeparatorColor;
    chartSectionView.dotSeparatorColor = self.dotSeparatorColor;
    chartSectionView.processAreaBackgroundColor = self.processAreaBackgroundColor;
    chartSectionView.pointAreaBackgroundColor = self.pointAreaBackgroundColor;
    chartSectionView.rowSeparatorColor = self.rowSeparatorColor;
    chartSectionView.todayLineColor = self.todayLineColor;
    
    chartSectionView.dateWidth = self.dateWidth;
    chartSectionView.dateSeparatorWidth = self.dateSeparatorWidth;
    chartSectionView.rowSeparatorWidth = self.rowSeparatorWidth;
    chartSectionView.dotSeparatorWidth = self.dotSeparatorWidth;
    chartSectionView.todayLineWidth = self.todayLineWidth;
    chartSectionView.processViewHeight = self.processViewHeight;
    chartSectionView.pointViewHeight = self.pointViewHeight;
    chartSectionView.processAreaTopMargin = self.processAreaTopMargin;
    chartSectionView.pointAreaTopMargin = self.pointAreaTopMargin;
    
    chartSectionView.processAreaHeight = [self.allSectionProcessHeightArray[section] floatValue];
    chartSectionView.pointAreaHeight = [self.allSectionPointHeightArray[section] floatValue];
    
    chartSectionView.minimumProcessViewWidthDays = self.minimumProcessViewWidthDays;
    chartSectionView.minimumPointViewWidthDays = self.minimumPointViewWidthDays;
    
    chartSectionView.processViewArray = self.allSectionProcessViewArray[section];
    chartSectionView.pointViewArray = self.allSectionPointViewArray[section];
    
    chartSectionView.currentContentOffsetX = self.currentContentOffsetX;
    
    [chartSectionView removeAllSubviews];
    
    [chartSectionView locationSubviews];
    
    return chartSectionView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat processAreaHeight = [self.allRowProcessHeightArray[indexPath.section][indexPath.row] floatValue];
    CGFloat pointAreaHeight = [self.allRowPointHeightArray[indexPath.section][indexPath.row] floatValue];
    return processAreaHeight + pointAreaHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat processAreaHeight = [self.allSectionProcessHeightArray[section] floatValue];
    CGFloat pointAreaHeight = [self.allSectionPointHeightArray[section] floatValue];
    return processAreaHeight + pointAreaHeight;
}


/**
 これをしないとcellの背景色が透明にならない

 @param tableView tableView
 @param cell cell
 @param indexPath indexPath
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}


#pragma mark - OTGChartSectionViewDelegate & OTGChartViewCellDelegate
- (UIColor *)chartBackgroundColorForDate:(NSDate *)date
{
    if (self.delegate) {
        return [self.delegate chartBackgroundColorForDate:date];
    }
    
    return [UIColor clearColor];
}

#pragma mark - OTGChartSectionViewDelegate
- (void)ganttChartSectionView:(OTGChartSectionView *)sectionView tappedSection:(NSInteger)section
{
    if (self.delegate) {
        [self.delegate tappedSection:section];
    }
}


#pragma mark - ConnectWorkCategoryTableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate) {
        [self.delegate didVerticalScroll:scrollView];
    }
}

@end
