//
//  OTGanttChartView.m
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

#import "OTGanttChartView.h"

#import "OTGChartView.h"

#import "OTGChartPointView.h"
#import "OTGChartProcessView.h"
#import "OTGChartSectionView.h"

@interface OTGanttChartView()<UIScrollViewDelegate,OTGChartViewDataSource,OTGChartViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *ganttScrollView;
@property (weak, nonatomic) IBOutlet OTGChartView *chartView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *leftArrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;

@property (nonatomic) NSArray<NSDate *> *showDateArray;

@property (nonatomic) NSArray<NSArray<OTGChartProcessView *> *> *allSectionProcessViewArray;
@property (nonatomic) NSArray<NSArray<OTGChartPointView *> *> *allSectionPointViewArray;
@property (nonatomic) NSArray<NSNumber *> *allSectionProcessHeightArray;
@property (nonatomic) NSArray<NSNumber *> *allSectionPointHeightArray;

@property (nonatomic) NSArray<NSArray<NSArray<OTGChartProcessView *> *> *> *allRowProcessViewArray;
@property (nonatomic) NSArray<NSArray<NSArray<OTGChartPointView *> *> *> *allRowPointViewArray;
@property (nonatomic) NSArray<NSArray<NSNumber *> *> *allRowProcessHeightArray;
@property (nonatomic) NSArray<NSArray<NSNumber *> *> *allRowPointHeightArray;

@end

@implementation OTGanttChartView

#pragma mark - initialize

//From code
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


//From xib
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    NSString *nibName = NSStringFromClass([self class]);
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    UINib *nib = [UINib nibWithNibName:nibName bundle:frameworkBundle];
    UIView *subView = [nib instantiateWithOwner:self options:nil][0];
    subView.frame = self.bounds;
    [self addSubview:subView];
    [self sendSubviewToBack:subView];
    [self initVariable];
    [self initProtocol];
}


- (void)initVariable
{
    self.themeMode = OTGThemeModeDark;
    
    self.todayLineEnabled = NO;
    self.leftRefreshControlEnabled = NO;
    self.rightRefreshControlEnabled = NO;
    
    self.dateWidth = OTGDateWidth;
    self.dateSeparatorWidth = OTGChartSeparatorWidth;
    self.dateFontSize = OTGDateViewFontSize;
    self.chartBorderWidth = OTGChartBorderWidth;
    self.rowSeparatorWidth = OTGChartSeparatorWidth;
    self.dotSeparatorWidth = OTGChartSeparatorWidth;
    self.todayLineWidth = OTGTodayLineWidth;
    self.todayFigureSize = OTGTodayFigureSize;
    
    self.processViewHeight = OTGProcessHeight;
    self.pointViewHeight = OTGPointHeight;
    
    self.minimumProcessViewWidthDays = OTGProcessViewMinimumWidthDays;
    self.minimumPointViewWidthDays = OTGPointViewMinimumWidthDays;
    
    self.processAreaTopMargin = OTGProcessAreaTopMargin;
    self.processAreaUnderMargin = OTGProcessAreaUnderMargin;
    
    self.pointAreaTopMargin = OTGPointAreaTopMargin;
    self.pointAreaUnderMargin = OTGPointAreaUnderMargin;
    
    self.showDateAreaHeight = OTGDateViewHeight;
    
    self.todayFigureType = OTGFigureTypeNone;
    
    self.minimumRowProcessAreaHeight = OTGMinimumRowProcessAreaHeight;
    self.minimumRowPointAreaHeight = OTGMinimumRowPointAreaHeight;
    
    self.minimumSectionProcessAreaHeight = OTGMinimumSectionProcessAreaHeight;
    self.minimumSectionPointAreaHeight = OTGMinimumSectionPointAreaHeight;
    
    self.localeIdentifier = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
}


- (void)initProtocol
{
    self.ganttScrollView.delegate = self;
    self.chartView.dataSource = self;
    self.chartView.delegate = self;
}



#pragma mark - LifeCycle
- (void)didMoveToWindow
{
    [super didMoveToWindow];
    [self reloadData];
}


#pragma mark - prepare
/**
 チャートの設定
 */
- (void)prepareChartView
{
    if (self.dataSource) {
        _currentStartDate = [OTGCommonClass adjustZeroClock:[self.dataSource startDateInGanttChartView:self]];
    }
    
    if (self.dataSource) {
        _currentLastDate = [OTGCommonClass adjustZeroClock:[self.dataSource lastDateInGanttChartView:self]];
    }
    
    if ([self.currentStartDate compare:self.currentLastDate] == NSOrderedDescending) {
        //開始日が終了日より後の場合、エラー表示して止める
         [[NSException exceptionWithName:@"OTGanntChartShowDateException" reason:@"Input a startDate before the lastDate." userInfo:nil] raise];
    }
    
    self.showDateArray = [self createShowDateArrayFromStartDate:self.currentStartDate
                                                       lastDate:self.currentLastDate];
    
    self.allSectionProcessViewArray = [self createAllSectionProcessViewArray];
    self.allSectionPointViewArray = [self createAllSectionPointViewArray];
    
    self.allSectionProcessHeightArray = [self createSectionProcessHeightArray:self.allSectionProcessViewArray
                                                                minimumHeight:self.minimumSectionProcessAreaHeight];
    self.allSectionPointHeightArray = [self createSectionPointHeightArray:self.allSectionPointViewArray
                                                            minimumHeight:self.minimumSectionPointAreaHeight];
    
    self.allRowProcessViewArray = [self createAllRowProcessViewArray];
    self.allRowPointViewArray = [self createAllRowPointViewArray];
    
    self.allRowProcessHeightArray = [self createAllRowProcessHeightArray];
    self.allRowPointHeightArray = [self createAllRowPointHeightArray];
    
    [self prepareChartSizeFromStartDate:self.currentStartDate
                               lastDate:self.currentLastDate];
}


- (void)prepareChartSizeFromStartDate:(NSDate *)startDate
                             lastDate:(NSDate *)lastDate
{
    self.chartViewWidthConstraint.constant = self.dateWidth * [OTGCommonClass daysCountFromStartDate:startDate lastDate:lastDate isCountStartDate:YES] + OTGChartSeparatorWidth;
    
    self.ganttScrollView.contentSize = CGSizeMake(self.chartViewWidthConstraint.constant, self.ganttScrollView.frame.size.height);
}


/**
 背景色を決める
 */
- (void)prepareThemeColor
{
    self.todayHiligtedBackgroundColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeTodayHighlitedBackground];
    self.todayHiligtedDateTextColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeTodayHighlitedDateText];
    self.processAreaBackgroundColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeProcessAreaBackground];
    self.pointAreaBackgroundColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypePointAreaBackground];
    self.dateAreaBackgroundColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeDateAreaBackground];
    self.scrollBackgroundColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeScrollBackground];
    self.dateSeparatorColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeDateText];
    self.rowSeparatorColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeRowSeparator];
    self.refreshArrowColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeRefreshArrowImage];
    self.dotSeparatorColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeDotSeparator];
    self.chartBorderColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeChartBorder];
    self.todayLineColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeTodayLineColor];
    self.dateTextColor = [OTGCommonClass colorFromThemeMode:self.themeMode partsType:OTGPartsTypeDateText];
}


- (void)prepareArrowImageView:(UIImageView *)imageView
                    imageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.image = image;
    imageView.tintColor = self.refreshArrowColor;
}


- (NSArray<NSArray<OTGChartProcessView *> *> *)createAllSectionProcessViewArray
{
    NSMutableArray<NSArray<OTGChartProcessView *> *> *allSectionProcessViewArray = [NSMutableArray array];
    
    NSInteger sectionCount = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInGanttChartView:)]) {
        sectionCount = [self.dataSource numberOfSectionsInGanttChartView:self];
    }
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        
        NSMutableArray<OTGChartProcessView *> *processViewArray = [NSMutableArray array];
        
        NSInteger processCount = 0;
        if ([self.dataSource respondsToSelector:@selector(ganttChartView:numberOfProcessViewsForSection:)]) {
            processCount = [self.dataSource ganttChartView:self numberOfProcessViewsForSection:section];
        }
        
        for (NSInteger processNo = 0; processNo < processCount; processNo++) {
            if ([self.dataSource respondsToSelector:@selector(ganttChartView:chartProcessViewAtSection:processNo:)]) {
                OTGChartProcessView *chartProcessView = [self.dataSource ganttChartView:self chartProcessViewAtSection:section processNo:processNo];
                
                if (![chartProcessView.dateArray count]) {
                    continue;
                }
                
                chartProcessView.dateArray = [OTGCommonClass createAdjustDateArray:chartProcessView.dateArray];
                chartProcessView.processNo = processNo;
                
                [processViewArray addObject:chartProcessView];
            }
        }
        
        [allSectionProcessViewArray addObject:processViewArray];
        
    }
    
    return allSectionProcessViewArray;
}


- (NSArray<NSArray<OTGChartPointView *> *> *)createAllSectionPointViewArray
{
    NSMutableArray<NSArray<OTGChartPointView *> *> *allSectionPointViewArray = [NSMutableArray array];
    
    NSInteger sectionCount = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInGanttChartView:)]) {
        sectionCount = [self.dataSource numberOfSectionsInGanttChartView:self];
    }
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSMutableArray<OTGChartPointView *> *pointViewArray = [NSMutableArray array];
        
        NSInteger pointCount = 0;
        if ([self.dataSource respondsToSelector:@selector(ganttChartView:numberOfPointViewsForSection:)]) {
            pointCount = [self.dataSource ganttChartView:self numberOfPointViewsForSection:section];
        }
        
        for (NSInteger pointNo = 0; pointNo < pointCount; pointNo++) {
            if ([self.dataSource respondsToSelector:@selector(ganttChartView:chartPointViewAtSection:pointNo:)]) {
                OTGChartPointView *pointView = [self.dataSource ganttChartView:self chartPointViewAtSection:section pointNo:pointNo];
                
                if (!pointView.date) {
                    continue;
                }
                
                [pointViewArray addObject:pointView];
            }
        }
        [allSectionPointViewArray addObject:pointViewArray];
    }
    
    return allSectionPointViewArray;
}


#pragma mark - CreateShowDateArray
/**
 引数で渡された開始日から引数で渡された終了日までのNSDateを格納したNSArrayを作成する
 
 @param startDate 開始日
 @param lastDate 終了日
 @return 期間分のNSArray
 */
- (NSArray<NSDate *> *)createShowDateArrayFromStartDate:(NSDate *)startDate
                                               lastDate:(NSDate *)lastDate;
{
    if (!startDate || !lastDate) {
        return [NSArray array];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSDate *addDate = startDate;
    while ([addDate compare:lastDate] != NSOrderedDescending) {
        [array addObject:addDate];
        addDate = [OTGCommonClass createDate:addDate differenceDays:1];
    }
    
    return array;
}


#pragma mark - CreateProcessViewArray
- (NSArray<NSArray<NSArray<OTGChartProcessView *> *> *> *)createAllRowProcessViewArray
{
    if (self.dataSource) {
        NSMutableArray<NSArray<NSArray<OTGChartProcessView *> *> *> *allProcessViewArray = [NSMutableArray array];
        
        NSInteger sectionCount = 1;
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInGanttChartView:)]) {
            sectionCount = [self.dataSource numberOfSectionsInGanttChartView:self];
        }
        
        for (NSInteger section = 0; section < sectionCount; section++) {
            
            NSArray<NSArray<OTGChartProcessView *> *> *sectionArray = [self createSectionProcessViewArray:section];
            
            [allProcessViewArray addObject:sectionArray];
        }
        
        return  allProcessViewArray;
    
    } else {
        
        [[NSException exceptionWithName:@"OTGanntChartNoImplementException"
                                 reason:@"You must implement OTGanttChartViewDataSourceMethod"
                               userInfo:nil] raise];
        return nil;
    
    }
}


- (NSArray<NSArray<OTGChartProcessView *> *> *)createSectionProcessViewArray:(NSInteger)section
{
    NSMutableArray *sectionArray = [NSMutableArray array];
    NSInteger rowCount = [self.dataSource ganttChartView:self numberOfRowsInSection:section];
    
    for (NSInteger row = 0; row < rowCount; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        NSArray<OTGChartProcessView *> *rowArray = [self createRowProcessViewArray:indexPath];
        [sectionArray addObject:rowArray];
    }
    
    return sectionArray;
}


- (NSArray<OTGChartProcessView *> *)createRowProcessViewArray:(NSIndexPath *)indexPath
{
    NSMutableArray<OTGChartProcessView *> *rowArray = [NSMutableArray array];
    
    NSInteger processCount = [self.dataSource ganttChartView:self numberOfProcessViewsForIndexPath:indexPath];
    
    for (NSInteger processNo = 0; processNo < processCount; processNo++) {
        
        OTGChartProcessView *chartProcessView = [self createChartProcessView:indexPath procesNo:processNo];
        
        if (!chartProcessView) {
            continue;
        }
        
        [rowArray addObject:chartProcessView];
    }
    
    rowArray = [[rowArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        OTGChartProcessView *process1 = obj1;
        OTGChartProcessView *process2 = obj2;
        return [[process1.dateArray firstObject] compare:[process2.dateArray firstObject]];
    }] mutableCopy];
    
    return rowArray;
}


- (OTGChartProcessView *)createChartProcessView:(NSIndexPath *)indexPath procesNo:(NSInteger)processNo
{
    OTGChartProcessView *chartProcessView = [self.dataSource ganttChartView:self
                                                chartProcessViewAtIndexPath:indexPath
                                                                  processNo:processNo];
    
    if (![chartProcessView.dateArray count]) {
        return nil;
    }
    
    chartProcessView.dateArray = [OTGCommonClass sortDateArray:chartProcessView.dateArray];
    chartProcessView.processNo = processNo;
    
    return chartProcessView;
}


#pragma mark - CreateAllPointViewArray
- (NSArray<NSArray<NSArray<OTGChartPointView *> *> *> *)createAllRowPointViewArray
{
    if (self.dataSource) {
        NSMutableArray<NSArray<NSArray<OTGChartPointView *> *> *> *allPointViewArray = [NSMutableArray array];
        
        NSInteger sectionCount = 1;
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInGanttChartView:)]) {
            sectionCount = [self.dataSource numberOfSectionsInGanttChartView:self];
        }
        
        for (NSInteger section = 0; section < sectionCount; section++) {
            
            NSArray<NSArray<OTGChartPointView *> *> *sectionArray = [self createSectionPointViewArray:section];
            
            [allPointViewArray addObject:sectionArray];
        }
        
        return allPointViewArray;
    } else {
        [[NSException exceptionWithName:@"OTGanntChartNoImplementException"
                                 reason:@"You must implement OTGanttChartViewDataSourceMethod"
                               userInfo:nil] raise];
        return nil;
    }
}


- (NSArray<NSArray<OTGChartPointView *> *> *)createSectionPointViewArray:(NSInteger)section
{
    NSMutableArray<NSArray<OTGChartPointView *> *> *sectionArray = [NSMutableArray array];
    
    NSInteger rowCount = [self.dataSource ganttChartView:self numberOfRowsInSection:section];
    
    for (NSInteger row = 0; row < rowCount; row++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        NSArray<OTGChartPointView *> *rowArray = [self createRowPointViewArray:indexPath];
        
        [sectionArray addObject:rowArray];
    }
    
    return sectionArray;
}


- (NSArray<OTGChartPointView *> *)createRowPointViewArray:(NSIndexPath *)indexPath
{
    NSMutableArray<OTGChartPointView *> *rowArray = [NSMutableArray array];
    
    NSInteger pointCount = 0;
    if ([self.dataSource respondsToSelector:@selector(ganttChartView:numberOfPointViewsForIndexPath:)]) {
        pointCount = [self.dataSource ganttChartView:self numberOfPointViewsForIndexPath:indexPath];
    }
    
    for (NSInteger pointNo = 0; pointNo < pointCount; pointNo++) {
        
        OTGChartPointView *chartPointView = [self createChartPointView:indexPath pointNo:pointNo];
        
        if (!chartPointView) {
            continue;
        }
        
        [rowArray addObject:chartPointView];
    }
    
    rowArray = [[rowArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        OTGChartPointView *point1 = obj1;
        OTGChartPointView *point2 = obj2;
        return [point1.date compare:point2.date];
    }] mutableCopy];
    
    return rowArray;
}


- (OTGChartPointView *)createChartPointView:(NSIndexPath *)indexPath pointNo:(NSInteger)pointNo
{
    if ([self.dataSource respondsToSelector:@selector(ganttChartView:chartPointViewAtIndexPath:pointNo:)]) {
        OTGChartPointView *chartPointView = [self.dataSource ganttChartView:self chartPointViewAtIndexPath:indexPath pointNo:pointNo];
        
        if (!chartPointView.date) {
            return  nil;
        }
        
        chartPointView.pointNo = pointNo;
        
        return chartPointView;
    } else {
        return nil;
    }
}


#pragma mark - CreateAllProcessHeightArray
- (NSArray<NSArray<NSNumber *> *> *)createAllRowProcessHeightArray
{
    NSMutableArray<NSArray<NSNumber *> *> *allRowProcessHeightArray = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [self.allRowProcessViewArray enumerateObjectsUsingBlock:^(NSArray<NSArray<OTGChartProcessView *> *> * _Nonnull sectionArray, NSUInteger section, BOOL * _Nonnull sectionStop) {
        
        NSArray<NSNumber *> *sectionHeightArray = [weakSelf createSectionProcessHeightArray:sectionArray minimumHeight:weakSelf.minimumRowProcessAreaHeight];
        
        [allRowProcessHeightArray addObject:sectionHeightArray];
    }];
    
    return allRowProcessHeightArray;
}


- (NSArray<NSNumber *> *)createSectionProcessHeightArray:(NSArray<NSArray<OTGChartProcessView *> *> *)sectionArray minimumHeight:(CGFloat)minimumHeight
{
    NSMutableArray<NSNumber *> *sectionHeightArray = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [sectionArray enumerateObjectsUsingBlock:^(NSArray<OTGChartProcessView *> * _Nonnull processviewArray, NSUInteger row, BOOL * _Nonnull rowStop) {
        
        NSNumber *processHeight = [weakSelf createProcessHeight:processviewArray minimumHeight:minimumHeight];
        
        [sectionHeightArray addObject:processHeight];
        
    }];
    
    return sectionHeightArray;
}


- (NSNumber *)createProcessHeight:(NSArray<OTGChartProcessView *> *)processViewArray minimumHeight:(CGFloat)minimumHeight
{
    if ([processViewArray count]) {
        
        NSMutableArray<NSArray<NSDate *> *> *rowProcessDateArray = [NSMutableArray array];
        
        [processViewArray enumerateObjectsUsingBlock:^(OTGChartProcessView * _Nonnull processView, NSUInteger processNo, BOOL * _Nonnull processStop) {
            [rowProcessDateArray addObject:processView.dateArray];
        }];
        
        return @([self calculateProcessAreaHeightFromProcessArray:rowProcessDateArray minimumHeight:minimumHeight]);
        
    } else {
        return @(minimumHeight);
    }
}


#pragma mark - CreateAllPointHeightArray
- (NSArray<NSArray<NSNumber *> *> *)createAllRowPointHeightArray
{
    NSMutableArray<NSArray<NSNumber *> *> *allPointHeightArray = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [self.allRowPointViewArray enumerateObjectsUsingBlock:^(NSArray<NSArray<OTGChartPointView *> *> * _Nonnull sectionArray, NSUInteger section, BOOL * _Nonnull sectionStop) {
        
        NSArray<NSNumber *> *sectionHeightArray = [weakSelf createSectionPointHeightArray:sectionArray minimumHeight:weakSelf.minimumRowPointAreaHeight];
        
        [allPointHeightArray addObject:sectionHeightArray];
    }];
    
    return allPointHeightArray;
}


- (NSArray<NSNumber *> *)createSectionPointHeightArray:(NSArray<NSArray<OTGChartPointView *> *> *)sectionArray minimumHeight:(CGFloat)minimumHeight
{
    NSMutableArray<NSNumber *> *sectionHeightArray = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [sectionArray enumerateObjectsUsingBlock:^(NSArray<OTGChartPointView *> * _Nonnull pointViewArray, NSUInteger row, BOOL * _Nonnull rowStop) {
        
        [sectionHeightArray addObject:[weakSelf createPointHeight:pointViewArray minimumHeight:minimumHeight]];
        
    }];
    
    return sectionHeightArray;
}


- (NSNumber *)createPointHeight:(NSArray<OTGChartPointView *> *)pointViewArray minimumHeight:(CGFloat)minimumHeight
{
    if ([pointViewArray count]) {
        
        NSMutableArray<NSDate *> *rowPointDateArray = [NSMutableArray array];
        
        [pointViewArray enumerateObjectsUsingBlock:^(OTGChartPointView * _Nonnull pointView, NSUInteger idx, BOOL * _Nonnull stop) {
            [rowPointDateArray addObject:pointView.date];
        }];
        
        return @([self calculatePointAreaHeightFromDateArray:rowPointDateArray minimumHeight:minimumHeight]);
        
    } else {
        return @(minimumHeight);
    }
}


#pragma mark - CalculateAreaHeight
- (CGFloat)calculateProcessAreaHeightFromProcessArray:(NSArray<NSArray<NSDate *> *> *)processArray minimumHeight:(CGFloat)minimumHeight
{
    NSArray *allProcessDateArray = [self createAllProcessDateArrayFromProcessArray:processArray];
    
    __block NSInteger duplicationCount = 1;
    __weak typeof(self) weakSelf = self;
    [processArray enumerateObjectsUsingBlock:^(NSArray<NSDate *> *_Nonnull processDateArray, NSUInteger idx, BOOL * _Nonnull stop) {
     
        processDateArray = [self createShowDateArrayFromStartDate:[processDateArray firstObject] lastDate:[processDateArray lastObject]];
        
        if (![OTGCommonClass isContainProcessStartDate:[processDateArray firstObject]
                                       processLastDate:[processDateArray lastObject]
                                         showStartDate:[weakSelf.showDateArray firstObject]
                                          showLastDate:[weakSelf.showDateArray lastObject]]) {
            //工程自体が表示範囲外の時は計算しない
            return;
        }
        
        [processDateArray enumerateObjectsUsingBlock:^(NSDate * _Nonnull date, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (![OTGCommonClass isContainDate:date
                                     startDate:[weakSelf.showDateArray firstObject]
                                      lastDate:[weakSelf.showDateArray lastObject]]) {
                //日付が表示範囲外の時は計算しない
                return;
            }
            
            NSInteger dateCount = [OTGCommonClass daysCountFromStartDate:[processDateArray firstObject]
                                                                lastDate:[processDateArray lastObject]
                                                        isCountStartDate:NO];
            
            if (dateCount < weakSelf.minimumProcessViewWidthDays) {
                //最少表示日数に工程の日数が足りない場合
                NSInteger arrayCount = 0;
                
                //表示用の日付重複数チェック
                for (NSInteger i = 0; i < weakSelf.minimumProcessViewWidthDays; i++) {
                    NSDate *showDate = [OTGCommonClass createDate:date differenceDays:i];
                    NSPredicate *showDatePredicate = [NSPredicate predicateWithFormat:@"SELF == %@",showDate];
                    NSArray *showDateArray = [allProcessDateArray filteredArrayUsingPredicate:showDatePredicate];
                    
                    NSInteger showDateArrayCount = [showDateArray count];
                    
                    if (i > dateCount) {
                        showDateArrayCount += 1;
                    }
                    
                    arrayCount = (arrayCount > showDateArrayCount)? arrayCount : showDateArrayCount;
                }
                
                if (arrayCount > duplicationCount) {
                    //重複数の最大を取る
                    duplicationCount = arrayCount;
                }
                
            } else {
                //複数日の場合は初日の重複数を調べる
                
                NSArray *predicateArray = @[date];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", predicateArray];
                NSArray *duplicateArray = [allProcessDateArray filteredArrayUsingPredicate:predicate];
                
                if ([duplicateArray count] > duplicationCount) {
                    //重複数の最大を取る
                    duplicationCount = [duplicateArray count];
                }
            }
        }];
    }];
    
    CGFloat calculateHeight = self.processViewHeight * duplicationCount + self.processAreaTopMargin + self.processAreaUnderMargin;
    return (calculateHeight > minimumHeight)? calculateHeight : minimumHeight;
}


/**
 工程ごとに分割されているNSDateのArrayを分解して一つのArrayにまとめる
 
 @param array 工程ごとのArray
 @return 一列に表示される工程の全ての日付が入ったArray(やらない日も含む)
 */
- (NSArray<NSDate *> *)createAllProcessDateArrayFromProcessArray:(NSArray<NSArray<NSDate *> *> *)array
{
    NSMutableArray *allDateArray = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSArray<NSDate *> * _Nonnull dateArray, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![dateArray count]) {
            return;
        }
        
        NSArray<NSDate *> *processDateArray = [OTGCommonClass createAdjustDateArray:dateArray];
        
        NSDate *startDate = [processDateArray firstObject];
        NSDate *lastDate = [processDateArray lastObject];
        
        NSDate *addDate = startDate;
        
        while ([addDate compare:lastDate] != NSOrderedDescending) {
            [allDateArray addObject:addDate];
            addDate = [OTGCommonClass createDate:addDate differenceDays:1];
        }
        
    }];
    
    return allDateArray;
}


/**
 セルの高さをPointごとに計算する

 @param dateArray 日付リスト
 @return 高さ
 */
- (CGFloat)calculatePointAreaHeightFromDateArray:(NSArray<NSDate *> *)dateArray minimumHeight:(CGFloat)minimumHeight
{
    __block NSInteger duplicationCount = 1;
    
    dateArray = [OTGCommonClass createAdjustDateArray:dateArray];
    
    __weak typeof(self) weakSelf = self;
    [dateArray enumerateObjectsUsingBlock:^(NSDate * _Nonnull firstDate, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![OTGCommonClass isContainDate:firstDate
                                 startDate:[weakSelf.showDateArray firstObject]
                                  lastDate:[weakSelf.showDateArray lastObject]]) {
            return;
        }
    
        NSMutableArray *predicateArray = [NSMutableArray array];
        for (NSInteger i = 0; i < weakSelf.minimumPointViewWidthDays; i++) {
            NSDate *showDate = [OTGCommonClass createDate:firstDate differenceDays:i];
            [predicateArray addObject:showDate];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", predicateArray];
        NSArray *duplicateArray = [dateArray filteredArrayUsingPredicate:predicate];
        
        if (duplicationCount < [duplicateArray count]) {
            duplicationCount = [duplicateArray count];
        }
    }];
    
    CGFloat calculateHeight = self.pointViewHeight * duplicationCount + self.pointAreaTopMargin + self.pointAreaUnderMargin;
    return (calculateHeight > minimumHeight)? calculateHeight: minimumHeight;
}


#pragma mark - Setter

#pragma mark Theme & Color
-(void)setThemeMode:(OTGThemeMode)themeMode
{
    _themeMode = themeMode;
    
    [self prepareThemeColor];
}


- (void)setDateSeparatorColor:(UIColor *)dateSeparatorColor
{
    _dateSeparatorColor = dateSeparatorColor;
    self.chartView.dateSeparatorColor = dateSeparatorColor;
}


- (void)setDotSeparatorColor:(UIColor *)dotSeparatorColor
{
    _dotSeparatorColor = dotSeparatorColor;
    self.chartView.dotSeparatorColor = dotSeparatorColor;
}


- (void)setChartBorderColor:(UIColor *)chartBorderColor
{
    _chartBorderColor = chartBorderColor;
    self.chartView.chartBorderColor = chartBorderColor;
}


- (void)setTodayHiligtedBackgroundColor:(UIColor *)todayHiligtedBackgroundColor
{
    _todayHiligtedBackgroundColor = todayHiligtedBackgroundColor;
    self.chartView.todayHiligtedBackgroundColor = todayHiligtedBackgroundColor;
}


- (void)setDateAreaBackgroundColor:(UIColor *)dateAreaBackgroundColor
{
    _dateAreaBackgroundColor = dateAreaBackgroundColor;
    self.chartView.dateAreaBackgroundColor = dateAreaBackgroundColor;
}


- (void)setProcessAreaBackgroundColor:(UIColor *)processAreaBackgroundColor
{
    _processAreaBackgroundColor = processAreaBackgroundColor;
    self.chartView.processAreaBackgroundColor = processAreaBackgroundColor;
}


- (void)setPointAreaBackgroundColor:(UIColor *)pointAreaBackgroundColor
{
    _pointAreaBackgroundColor = pointAreaBackgroundColor;
    self.chartView.pointAreaBackgroundColor = pointAreaBackgroundColor;
}


- (void)setScrollBackgroundColor:(UIColor *)scrollBackgroundColor
{
    _scrollBackgroundColor = scrollBackgroundColor;
    self.backgroundColor = scrollBackgroundColor;
}


- (void)setRowSeparatorColor:(UIColor *)rowSeparatorColor
{
    _rowSeparatorColor = rowSeparatorColor;
    self.chartView.rowSeparatorColor = rowSeparatorColor;
}


- (void)setRefreshArrowColor:(UIColor *)refreshArrowColor
{
    _refreshArrowColor = refreshArrowColor;
    [self prepareArrowImageView:self.leftArrowImageView
                      imageName:@"otg_icon_arrow_left"];
    
    [self prepareArrowImageView:self.rightArrowImageView
                      imageName:@"otg_icon_arrow_right"];
}


- (void)setDateTextColor:(UIColor *)dateTextColor
{
    _dateTextColor = dateTextColor;
    self.chartView.dateTextColor = dateTextColor;
}


- (void)setTodayHiligtedDateTextColor:(UIColor *)todayHiligtedDateTextColor
{
    _todayHiligtedDateTextColor = todayHiligtedDateTextColor;
    self.chartView.todayHiligtedDateTextColor = todayHiligtedDateTextColor;
}


- (void)setTodayLineColor:(UIColor *)todayLineColor
{
    _todayLineColor = todayLineColor;
    self.chartView.todayLineColor = todayLineColor;
}


#pragma mark Locale
- (void)setLocaleIdentifier:(NSString *)localeIdentifier
{
    _localeIdentifier = localeIdentifier;
    self.chartView.localeIdentifier = localeIdentifier;
}


#pragma mark Size
- (void)setShowDateAreaHeight:(CGFloat)showDateAreaHeight
{
    _showDateAreaHeight = showDateAreaHeight;
    self.chartView.showDateAreaHeight = showDateAreaHeight;
}


- (void)setDateWidth:(CGFloat)dateWidth
{
    _dateWidth = dateWidth;
    self.chartView.dateWidth = dateWidth;
}


- (void)setDateFontSize:(CGFloat)dateFontSize
{
    _dateFontSize = dateFontSize;
    self.chartView.dateFontSize = dateFontSize;
}


- (void)setDateSeparatorWidth:(CGFloat)dateSeparatorWidth
{
    _dateSeparatorWidth = dateSeparatorWidth;
    self.chartView.dateSeparatorWidth = dateSeparatorWidth;
}


- (void)setChartBorderWidth:(CGFloat)chartBorderWidth
{
    _chartBorderWidth = chartBorderWidth;
    self.chartView.chartBorderWidth = chartBorderWidth;
}


- (void)setDotSeparatorWidth:(CGFloat)dotSeparatorWidth
{
    _dotSeparatorWidth = dotSeparatorWidth;
    self.chartView.dotSeparatorWidth = dotSeparatorWidth;
}


- (void)setRowSeparatorWidth:(CGFloat)rowSeparatorWidth
{
    _rowSeparatorWidth = rowSeparatorWidth;
    self.chartView.rowSeparatorWidth = rowSeparatorWidth;
}


- (void)setTodayLineWidth:(CGFloat)todayLineWidth
{
    _todayLineWidth = todayLineWidth;
    self.chartView.todayLineWidth = todayLineWidth;
}


- (void)setTodayFigureSize:(CGFloat)todayFigureSize
{
    _todayFigureSize = todayFigureSize;
    self.chartView.todayFigureSize = todayFigureSize;
}


- (void)setProcessViewHeight:(CGFloat)processViewHeight
{
    _processViewHeight = processViewHeight;
    self.chartView.processViewHeight = processViewHeight;
}


- (void)setPointViewHeight:(CGFloat)pointViewHeight
{
    _pointViewHeight = pointViewHeight;
    self.chartView.pointViewHeight = pointViewHeight;
}


- (void)setProcessAreaTopMargin:(CGFloat)processAreaTopMargin
{
    _processAreaTopMargin = processAreaTopMargin;
    self.chartView.processAreaTopMargin = processAreaTopMargin;
}


- (void)setPointAreaTopMargin:(CGFloat)pointAreaTopMargin
{
    _pointAreaTopMargin = pointAreaTopMargin;
    self.chartView.pointAreaTopMargin = pointAreaTopMargin;
}


- (void)setMinimumProcessViewWidthDays:(NSInteger)minimumProcessViewWidthDays
{
    _minimumProcessViewWidthDays = minimumProcessViewWidthDays;
    self.chartView.minimumProcessViewWidthDays = minimumProcessViewWidthDays;
}


- (void)setMinimumPointViewWidthDays:(NSInteger)minimumPointViewWidthDays
{
    _minimumPointViewWidthDays = minimumPointViewWidthDays;
    self.chartView.minimumPointViewWidthDays = minimumPointViewWidthDays;
}


- (void)setTodayFigureType:(OTGFigureType)todayFigureType
{
    _todayFigureType = todayFigureType;
    self.chartView.todayFigureType = todayFigureType;
}


#pragma mark function
- (void)setTodayLineEnabled:(BOOL)todayLineEnabled
{
    _todayLineEnabled = todayLineEnabled;
    
    self.chartView.todayLineEnabled = todayLineEnabled;
}


#pragma mark Data
- (void)setShowDateArray:(NSArray<NSDate *> *)showDateArray
{
    _showDateArray = showDateArray;
    self.chartView.showDateArray = showDateArray;
}


- (void)setAllSectionProcessViewArray:(NSArray<NSArray<OTGChartProcessView *> *> *)allSectionProcessViewArray
{
    _allSectionProcessViewArray = allSectionProcessViewArray;
    self.chartView.allSectionProcessViewArray = allSectionProcessViewArray;
}


- (void)setAllSectionPointViewArray:(NSArray<NSArray<OTGChartPointView *> *> *)allSectionPointViewArray
{
    _allSectionPointViewArray = allSectionPointViewArray;
    self.chartView.allSectionPointViewArray = allSectionPointViewArray;
}


- (void)setAllSectionProcessHeightArray:(NSArray<NSNumber *> *)allSectionProcessHeightArray
{
    _allSectionProcessHeightArray = allSectionProcessHeightArray;
    self.chartView.allSectionProcessHeightArray = allSectionProcessHeightArray;
}


- (void)setAllSectionPointHeightArray:(NSArray<NSNumber *> *)allSectionPointHeightArray
{
    _allSectionPointHeightArray = allSectionPointHeightArray;
    self.chartView.allSectionPointHeightArray = allSectionPointHeightArray;
}


- (void)setAllRowProcessViewArray:(NSArray<NSArray<NSArray<OTGChartProcessView *> *> *> *)allRowProcessViewArray
{
    _allRowProcessViewArray = allRowProcessViewArray;
    self.chartView.allRowProcessViewArray = allRowProcessViewArray;
}


- (void)setAllRowPointViewArray:(NSArray<NSArray<NSArray<OTGChartPointView *> *> *> *)allRowPointViewArray
{
    _allRowPointViewArray = allRowPointViewArray;
    self.chartView.allRowPointViewArray = allRowPointViewArray;
}


- (void)setAllRowProcessHeightArray:(NSArray<NSArray<NSNumber *> *> *)allRowProcessHeightArray
{
    _allRowProcessHeightArray = allRowProcessHeightArray;
    self.chartView.allRowProcessHeightArray = allRowProcessHeightArray;
}


- (void)setAllRowPointHeightArray:(NSArray<NSArray<NSNumber *> *> *)allRowPointHeightArray
{
    _allRowPointHeightArray = allRowPointHeightArray;
    self.chartView.allRowPointHeightArray = allRowPointHeightArray;
}


#pragma mark - Public Method
- (void)reloadData
{
    [self prepareChartView];
    [self.chartView reloadData];
    [self.ganttScrollView setContentOffset:CGPointZero];
}


- (void)redrawData
{
    [self prepareChartView];
    [self.chartView reloadData];
}


- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self prepareChartView];
    [self.chartView reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)reloadSections:(NSIndexSet *)indexSet withRowAnimation:(UITableViewRowAnimation)animation
{
    [self prepareChartView];
    [self.chartView reloadSections:indexSet withRowAnimation:animation];
}


- (void)setHorizontalContentOffsetFromDate:(NSDate *)date
                                atPosition:(OTGHorizontalScrollPosition)position
                                  animated:(BOOL)animated
{
    if (!date) {
        [self.ganttScrollView setContentOffset:CGPointZero animated:animated];
        return;
    }
    
    NSInteger sameIndex = [OTGCommonClass foundSameDateIndexFromDateArray:self.showDateArray
                                                                     date:date];
    
    if (sameIndex == NSNotFound) {
        [self.ganttScrollView setContentOffset:CGPointZero animated:animated];
        return;
    }
    
    //指定された日付がチャートの中央に来るように位置を指定する
    CGFloat xPoint = 0;
    
    switch (position) {
        case OTGHorizontalScrollPositionLeft:
        {
            xPoint = sameIndex * self.dateWidth;
            break;
        }
        case OTGHorizontalScrollPositionCenter:
        {
            xPoint = sameIndex * self.dateWidth - self.ganttScrollView.frame.size.width/2 + self.dateWidth/2;
            break;
        }
        case OTGHorizontalScrollPositionRight:
        {
            xPoint = sameIndex * self.dateWidth - self.ganttScrollView.frame.size.width + self.dateWidth;
            break;
        }
        case OTGHorizontalScrollPositionAutomatic:
        {
            NSInteger leftIndex = [self getDateIndexFromXpoint:self.ganttScrollView.contentOffset.x];
            NSInteger centerIndex = [self getDateIndexFromXpoint:self.ganttScrollView.contentOffset.x + self.ganttScrollView.frame.size.width/2];
            NSInteger rightIndex = [self getDateIndexFromXpoint:self.ganttScrollView.contentOffset.x + self.ganttScrollView.frame.size.width];
            
            NSInteger leftDifference = labs(leftIndex - sameIndex);
            NSInteger centerDifference = labs(centerIndex - sameIndex);
            NSInteger rightDifference = labs(rightIndex - sameIndex);
            
            NSArray *numArray = @[@(leftDifference),@(centerDifference),@(rightDifference)];
            NSExpression *minExpression = [NSExpression expressionForFunction:@"min:" arguments:@[[NSExpression expressionForConstantValue:numArray]]];
            NSInteger minimumValue = [[minExpression expressionValueWithObject:nil context:nil] integerValue];
            
            if (minimumValue == leftDifference) {
                xPoint = sameIndex * self.dateWidth;
            } else if (minimumValue == centerDifference) {
                xPoint = sameIndex * self.dateWidth - self.ganttScrollView.frame.size.width/2 + self.dateWidth/2;
            } else if (minimumValue == rightDifference) {
                xPoint = sameIndex * self.dateWidth - self.ganttScrollView.frame.size.width + self.dateWidth;
            }
            
            break;
        }
        case OTGHorizontalScrollPositionNone:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    
    if (xPoint < 0) {
        xPoint = 0;
    }
    
    if (self.chartView.frame.size.width - xPoint < self.ganttScrollView.frame.size.width) {
        xPoint = self.ganttScrollView.contentSize.width - self.ganttScrollView.frame.size.width;
    }
    
    CGPoint scrollPoint = CGPointMake(xPoint, 0);
    [self.ganttScrollView setContentOffset:scrollPoint animated:animated];
}


- (void)setHorizontalContentOffset:(CGPoint)offset
{
    self.ganttScrollView.contentOffset = offset;
}


- (void)setVerticalContentOffset:(CGPoint)offset
{
    [self.chartView setVerticalContentOffset:offset];
}


- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    [self.chartView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}


- (NSDate *)getCurrentLeftDate
{
    CGFloat leftX = self.ganttScrollView.contentOffset.x;
    return [self getDateFromXpoint:leftX];
}


- (NSDate *)getCurrentCenterDate
{
    CGFloat centerX = self.ganttScrollView.contentOffset.x + self.ganttScrollView.frame.size.width/2 - self.dateWidth;
    return [self getDateFromXpoint:centerX];
}


- (NSDate *)getCurrentRightDate
{
    CGFloat rightX = self.ganttScrollView.contentOffset.x + self.ganttScrollView.frame.size.width;
    return [self getDateFromXpoint:rightX];
}


- (CGFloat)getSectionHeightAtSection:(NSInteger)section
{
    return [self.allSectionProcessHeightArray[section] floatValue] + [self.allSectionPointHeightArray[section] floatValue];
}


- (CGFloat)getRowHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.allRowProcessHeightArray[indexPath.section][indexPath.row] floatValue] + [self.allRowPointHeightArray[indexPath.section][indexPath.row] floatValue];
}


- (CGFloat)getProcessAreaHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.allRowProcessHeightArray[indexPath.section][indexPath.row] floatValue];
}

- (CGFloat)getPointAreaHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.allRowPointHeightArray[indexPath.section][indexPath.row] floatValue];
}


#pragma mark - Get date on GanttChart
- (NSInteger)getDateIndexFromXpoint:(CGFloat)x
{
    NSInteger index = ceil(x/self.dateWidth);
    
    if (index < self.showDateArray.count) {
        return index;
    }
    
    return NSNotFound;
}


- (NSDate *)getDateFromXpoint:(CGFloat)x
{
    NSInteger index = [self getDateIndexFromXpoint:x];
    
    if (index != NSNotFound) {
        NSDate *date = self.showDateArray[index];
        
        return date;
    }
    
    return nil;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.chartView.currentContentOffsetX = scrollView.contentOffset.x;
    [self trackingProcessViewLabel:scrollView.contentOffset.x];
    
    if ([self.delegate respondsToSelector:@selector(ganttChartView:didHorizontalScroll:)]) {
        [self.delegate ganttChartView:self didHorizontalScroll:scrollView];
    }
    
    if (self.leftRefreshControlEnabled) {
        if (scrollView.contentOffset.x < 0) {
            
            //LeftBounce
            if (scrollView.contentOffset.x < -OTGScrollReloadDistance) {
                
                scrollView.contentOffset = CGPointMake(-OTGScrollReloadDistance,0);
            }
        }
    } else {
        if (scrollView.contentOffset.x < 0) {
            scrollView.contentOffset = CGPointZero;
        }
    }
    
    if (self.rightRefreshControlEnabled) {
        if (scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width) {
            
            //RightBounce
            if (scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width + OTGScrollReloadDistance){
                
                scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width + OTGScrollReloadDistance, 0);
                
            }
        }
    } else {
        
        if (scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width) {
            
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width, 0);
            
        }
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.leftRefreshControlEnabled) {
        if (scrollView.contentOffset.x <= -OTGScrollReloadDistance ) {
            if ([self.delegate respondsToSelector:@selector(ganttChartView:scrolledPrevieous:)]) {
                [self.delegate ganttChartView:self scrolledPrevieous:scrollView];
            }
        }
    }
    
    if (self.rightRefreshControlEnabled) {
        if (scrollView.contentOffset.x + scrollView.frame.size.width >= scrollView.contentSize.width + OTGScrollReloadDistance) {
            if ([self.delegate respondsToSelector:@selector(ganttChartView:scrolledNext:)]) {
                [self.delegate ganttChartView:self scrolledNext:scrollView];
            }
        }
    }
}


- (void)trackingProcessViewLabel:(CGFloat)xPosition
{
    [self.allSectionProcessViewArray enumerateObjectsUsingBlock:^(NSArray<OTGChartProcessView *> * _Nonnull sectionArray, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionArray enumerateObjectsUsingBlock:^(OTGChartProcessView * _Nonnull processView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (processView.textTrackingEnabled) {
                [processView trackingHorizontalScrollWithCurrentXPosition:xPosition];
            }
        }];
    }];
    
    
    [self.allRowProcessViewArray enumerateObjectsUsingBlock:^(NSArray<NSArray<OTGChartProcessView *> *> * _Nonnull sectionArray, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionArray enumerateObjectsUsingBlock:^(NSArray<OTGChartProcessView *> * _Nonnull rowArray, NSUInteger idx, BOOL * _Nonnull stop) {
            [rowArray enumerateObjectsUsingBlock:^(OTGChartProcessView * _Nonnull processView, NSUInteger idx, BOOL * _Nonnull stop) {
                if (processView.textTrackingEnabled) {
                    [processView trackingHorizontalScrollWithCurrentXPosition:xPosition];
                }
            }];
        }];
    }];
}


#pragma mark - OTGChartViewDataSource
- (NSInteger)numberOfSectionInChartView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInGanttChartView:)]) {
        return [self.dataSource numberOfSectionsInGanttChartView:self];
    }
    
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource) {
        return [self.dataSource ganttChartView:self numberOfRowsInSection:section];
    }
    
    return 0;
}


#pragma mark - OTGChartViewDelegate
- (UIColor *)chartColorForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(ganttChartView:chartColorForIndexPath:)]) {
        return [self.delegate ganttChartView:self chartColorForIndexPath:indexPath];
    }
    
    return [UIColor greenColor];
}


- (UIColor *)chartColorForSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(ganttChartView:chartColorForSection:)]) {
        return [self.delegate ganttChartView:self chartColorForSection:section];
    }
    
    return [UIColor blueColor];
}


- (UIColor *)chartBackgroundColorForDate:(NSDate *)date
{
    if ([self.delegate respondsToSelector:@selector(ganttChartView:chartBackgroundColorForDate:)]) {
        return [self.delegate ganttChartView:self chartBackgroundColorForDate:date];
    }
    
    return [UIColor clearColor];
}


- (void)tappedSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(ganttChartView:tappedSection:)]) {
        return [self.delegate ganttChartView:self tappedSection:section];
    }
}


- (void)didVerticalScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(ganttChartView:didVerticalScroll:)]) {
        [self.delegate ganttChartView:self didVerticalScroll:scrollView];
    }
}


@end
