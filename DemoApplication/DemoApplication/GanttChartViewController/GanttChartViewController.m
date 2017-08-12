//
//  GanttChartViewController.m
//  DemoApplication
//
//  Created by Tomosuke Okada on 2017/08/01.
//  Copyright © 2017年 TomosukeOkada. All rights reserved.
//

#import "GanttChartViewController.h"

#import <OTGanttChartKit/OTGanttChartKit.h>

typedef NS_ENUM(NSInteger, GanttChartSectionType)
{
    GanttChartSectionTypeNoFigure,
    GanttChartSectionTypeCircle,
    GanttChartSectionTypeSquare,
    GanttChartSectionTypeDiamond,
    GanttChartSectionTypeTriangle,
    GanttChartSectionTypeRatio,
    GanttChartSectionTypeDotLine
};

@interface GanttChartViewController ()<UITableViewDataSource,UITableViewDelegate,OTGanttChartViewDataSource,OTGanttChartViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UIView *ganttChartBaseView;

@property (nonatomic) OTGanttChartView *ganttChartView;

@end

@implementation GanttChartViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self prepareGanttChartView];
    [self prepareTableView];
}


#pragma mark - Prepare
- (void)prepareGanttChartView
{
    self.ganttChartView = [[OTGanttChartView alloc]initWithFrame:self.ganttChartBaseView.bounds];
    self.ganttChartView.dataSource = self;
    self.ganttChartView.delegate = self;
    
    // If you want to make original gantt chart, you can customize here.
    
    [self.ganttChartBaseView addSubview:self.ganttChartView];
}

- (void)prepareTableView
{
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case GanttChartSectionTypeNoFigure:
        
            return 1;
        
        case GanttChartSectionTypeCircle:
        case GanttChartSectionTypeSquare:
        case GanttChartSectionTypeDiamond:
        case GanttChartSectionTypeTriangle:
            
            return 2;
        
        case GanttChartSectionTypeRatio:
            
            return 3;
        
        case GanttChartSectionTypeDotLine:
            
            return 2;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.backgroundColor = [OTGCommonClass colorFromThemeMode:OTGThemeModeDark partsType:OTGPartsTypePointAreaBackground];
    
    NSString *cellText;
    
    
    switch (indexPath.section) {
        case GanttChartSectionTypeNoFigure:
            
            cellText = @"";
            break;
            
        case GanttChartSectionTypeCircle:
        case GanttChartSectionTypeSquare:
        case GanttChartSectionTypeDiamond:
        case GanttChartSectionTypeTriangle:
            
            if (indexPath.row == 0) {
                cellText = @"isFill = NO";
            } else if (indexPath.row == 1) {
                cellText = @"isFill = YES";
            }
            break;
            
        case GanttChartSectionTypeRatio:
            
            if (indexPath.row == 0) {
                cellText = @"startRatio = 0.4";
            } else if (indexPath.row == 1) {
                cellText = @"finishRatio = 0.8";
            } else if (indexPath.row == 2) {
                cellText = @"startRatio = 0.2\nfinishRatio = 0.6";
            }
            
            break;
        
        case GanttChartSectionTypeDotLine:
            
            if (indexPath.row == 0) {
                cellText = @"isDotLine = NO";
            } else if (indexPath.row == 1) {
                cellText = @"isDotLine = YES";
            }
            
            break;
        default:
            break;
    }
    
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = cellText;
    
    return cell;
}


#pragma mark - UITableVIewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc]init];
    
    view.contentView.backgroundColor = [OTGCommonClass colorFromThemeMode:OTGThemeModeDark partsType:OTGPartsTypeProcessAreaBackground];
    
    NSString *headerText = @"";
    
    switch (section) {
        case GanttChartSectionTypeNoFigure:
            
            headerText = @"OTGFigureTypeNone";
            break;
            
        case GanttChartSectionTypeCircle:
            
            headerText = @"OTGFigureTypeCircle";
            break;
            
        case GanttChartSectionTypeSquare:
            
            headerText = @"OTGFigureTypeSquare";
            break;
            
        case GanttChartSectionTypeDiamond:
            
            headerText = @"OTGFigureTypeDiamond";
            break;
            
        case GanttChartSectionTypeTriangle:
            
            headerText = @"OTGFigureTypeTriangle";
            break;
            
        case GanttChartSectionTypeRatio:
            
            headerText = @"ProcessViewRatio";
            break;
        
        case GanttChartSectionTypeDotLine:
            
            headerText = @"ProcessViewDotLine";
            break;
            
        default:
            break;
    }
    
    view.textLabel.text = headerText;
    view.textLabel.backgroundColor = [UIColor whiteColor];
    view.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.ganttChartView getSectionHeightAtSection:section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.ganttChartView getRowHeightAtIndexPath:indexPath];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.ganttChartView setVerticalContentOffset:scrollView.contentOffset];
}


#pragma mark - OTGanttChartView DataSource

#pragma mark Show Date
- (NSDate *)startDateInGanttChartView:(OTGanttChartView *)ganttChartView
{
    return [OTGCommonClass firstDateInMonthFromDate:[NSDate date]];
}


- (NSDate *)lastDateInGanttChartView:(OTGanttChartView *)ganttChartView
{
    return [OTGCommonClass lastDateInMonthFromDate:[OTGCommonClass createDate:ganttChartView.currentStartDate differenceMonths:2]];
}


#pragma mark - Section
- (NSInteger)numberOfSectionsInGanttChartView:(OTGanttChartView *)ganttChartView
{
    return 7;
}


#pragma mark ProcessView
- (NSInteger)ganttChartView:(OTGanttChartView *)ganttChartView numberOfProcessViewsForSection:(NSInteger)section
{
    return 1;
}


- (OTGChartProcessView *)ganttChartView:(OTGanttChartView *)ganttChartView chartProcessViewAtSection:(NSInteger)section processNo:(NSInteger)processNo
{
    OTGChartProcessView *processView = [[OTGChartProcessView alloc]init];
    
    NSMutableArray *dateArray = [NSMutableArray array];
    for (NSInteger i = processNo; i < processNo + 5; i++) {
        [dateArray addObject:[OTGCommonClass createDate:[NSDate date] differenceDays:i]];
    }
    processView.dateArray = dateArray;
    
    switch (section) {
        case GanttChartSectionTypeNoFigure:
            
            processView.figureType = OTGFigureTypeNone;
            break;
            
        case GanttChartSectionTypeCircle:
            
            processView.figureType = OTGFigureTypeCircle;
            break;
            
        case GanttChartSectionTypeSquare:
            
            processView.figureType = OTGFigureTypeSquare;
            break;
            
        case GanttChartSectionTypeDiamond:
            
            processView.figureType = OTGFigureTypeDiamond;
            break;
            
        case GanttChartSectionTypeTriangle:
            
            processView.figureType = OTGFigureTypeTriangle;
            break;
            
        case GanttChartSectionTypeRatio:
            
            processView.figureType = OTGFigureTypeNone;
            processView.startRatio = 0.2;
            processView.finishRatio = 0.4;
            break;
        
        case GanttChartSectionTypeDotLine:
            
            processView.figureType = OTGFigureTypeCircle;
            processView.dateArray = @[[dateArray firstObject],[dateArray lastObject]];
            processView.isDotLine = YES;
            break;
            
    }
    
    
    processView.isFill = YES;
    
    NSString *firstDateString = [OTGCommonClass stringFromDate:[dateArray firstObject] format:@"MM/dd"];
    NSString *lastDateString = [OTGCommonClass stringFromDate:[dateArray lastObject] format:@"MM/dd"];
    processView.title = [NSString stringWithFormat:@"sec:%@ pro:%@ %@ - %@",@(section).stringValue,@(processNo).stringValue,firstDateString,lastDateString];
    
    return processView;
}


#pragma mark PointView
- (NSInteger)ganttChartView:(OTGanttChartView *)ganttChartView numberOfPointViewsForSection:(NSInteger)section
{
    switch (section) {
        case GanttChartSectionTypeNoFigure:
        case GanttChartSectionTypeCircle:
        case GanttChartSectionTypeSquare:
        case GanttChartSectionTypeDiamond:
        case GanttChartSectionTypeTriangle:
            
            return 1;
            
        case GanttChartSectionTypeRatio:
        case GanttChartSectionTypeDotLine:
            
            return 0;
            
    }
    return 1;
}


- (OTGChartPointView *)ganttChartView:(OTGanttChartView *)ganttChartView chartPointViewAtSection:(NSInteger)section pointNo:(NSInteger)pointNo
{
    OTGChartPointView *pointView = [[OTGChartPointView alloc]init];
    pointView.date = [NSDate date];
    
    switch (section) {
        case GanttChartSectionTypeNoFigure:
            
            pointView.figureType = OTGFigureTypeNone;
            break;
            
        case GanttChartSectionTypeCircle:
            
            pointView.figureType = OTGFigureTypeCircle;
            break;
            
        case GanttChartSectionTypeSquare:
            
            pointView.figureType = OTGFigureTypeSquare;
            break;
            
        case GanttChartSectionTypeDiamond:
            
            pointView.figureType = OTGFigureTypeDiamond;
            break;
            
        case GanttChartSectionTypeTriangle:
            
            pointView.figureType = OTGFigureTypeTriangle;
            break;
        
        default:
            
            break;
    }
    
    pointView.isFill = NO;
    
    NSString *dateString = [OTGCommonClass stringFromDate:pointView.date format:@"MM/dd"];
    pointView.title = [NSString stringWithFormat:@"sec:%@ poi:%@ %@",@(section).stringValue,@(pointNo).stringValue,dateString];
    
    return pointView;
}


#pragma mark - Row
- (NSInteger)ganttChartView:(OTGanttChartView *)ganttChartView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
            case GanttChartSectionTypeNoFigure:
            
            return 1;
            
            case GanttChartSectionTypeCircle:
            case GanttChartSectionTypeSquare:
            case GanttChartSectionTypeDiamond:
            case GanttChartSectionTypeTriangle:
            
            return 2;
            
            case GanttChartSectionTypeRatio:
            
            return 3;
            
            case GanttChartSectionTypeDotLine:
            
            return 2;
    }
    return 0;
}


#pragma mark ProcessView
- (NSInteger)ganttChartView:(OTGanttChartView *)ganttChartView numberOfProcessViewsForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            case GanttChartSectionTypeNoFigure:
            
            return 1;
            
            case GanttChartSectionTypeCircle:
            case GanttChartSectionTypeSquare:
            case GanttChartSectionTypeDiamond:
            case GanttChartSectionTypeTriangle:
            
            return 2;
            
            case GanttChartSectionTypeRatio:
            case GanttChartSectionTypeDotLine:
            
            return 1;
        
    }
    return 0;
}


- (OTGChartProcessView *)ganttChartView:(OTGanttChartView *)ganttChartView chartProcessViewAtIndexPath:(NSIndexPath *)indexPath processNo:(NSInteger)processNo
{
    OTGChartProcessView *processView = [[OTGChartProcessView alloc]init];
    
    NSMutableArray *dateArray = [NSMutableArray array];
    for (NSInteger i = processNo; i < processNo + 5; i++) {
        [dateArray addObject:[OTGCommonClass createDate:[NSDate date] differenceDays:i]];
    }
    processView.dateArray = dateArray;
    
    switch (indexPath.section) {
        case GanttChartSectionTypeNoFigure:
            
            processView.figureType = OTGFigureTypeNone;
            break;
            
        case GanttChartSectionTypeCircle:
            
            processView.figureType = OTGFigureTypeCircle;
            processView.isFill = (indexPath.row == 0)? NO:YES;
            break;
            
        case GanttChartSectionTypeSquare:
            
            processView.figureType = OTGFigureTypeSquare;
            processView.isFill = (indexPath.row == 0)? NO:YES;
            break;
            
        case GanttChartSectionTypeDiamond:
            
            processView.figureType = OTGFigureTypeDiamond;
            processView.isFill = (indexPath.row == 0)? NO:YES;
            break;
            
        case GanttChartSectionTypeTriangle:
            
            processView.figureType = OTGFigureTypeTriangle;
            processView.isFill = (indexPath.row == 0)? NO:YES;
            break;
        
        case GanttChartSectionTypeRatio:
            
            processView.figureType = OTGFigureTypeNone;
            if (indexPath.row == 0) {
                
                processView.startRatio = 0.4;
                
            } else if (indexPath.row == 1) {
                
                processView.finishRatio = 0.8;
            
            } else if (indexPath.row == 2) {
                
                processView.startRatio = 0.2;
                processView.finishRatio = 0.6;
            
            }
            break;
        
        case GanttChartSectionTypeDotLine:
            
            processView.figureType = OTGFigureTypeCircle;
            processView.dateArray = @[[dateArray firstObject],[dateArray lastObject]];
            if (indexPath.row == 0) {
                processView.isDotLine = NO;
            } else if (indexPath.row == 1) {
                processView.isDotLine = YES;
            }
            
        default:
            break;
    }
    
    
    
    NSString *firstDateString = [OTGCommonClass stringFromDate:[dateArray firstObject] format:@"MM/dd"];
    NSString *lastDateString = [OTGCommonClass stringFromDate:[dateArray lastObject] format:@"MM/dd"];
    processView.title = [NSString stringWithFormat:@"sec:%@ row:%@ pro:%@ %@ - %@",@(indexPath.section).stringValue,@(indexPath.row).stringValue,@(processNo).stringValue,firstDateString,lastDateString];
    
    return processView;
}


#pragma mark PointView
- (NSInteger)ganttChartView:(OTGanttChartView *)ganttChartView numberOfPointViewsForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            case GanttChartSectionTypeNoFigure:
            case GanttChartSectionTypeCircle:
            case GanttChartSectionTypeSquare:
            case GanttChartSectionTypeDiamond:
            case GanttChartSectionTypeTriangle:
        
            return 2;
            
        default:
            return 0;
    }
}


- (OTGChartPointView *)ganttChartView:(OTGanttChartView *)ganttChartView chartPointViewAtIndexPath:(NSIndexPath *)indexPath pointNo:(NSInteger)pointNo
{
    OTGChartPointView *pointView = [[OTGChartPointView alloc]init];
    pointView.date = [OTGCommonClass createDate:[NSDate date] differenceDays:pointNo * 3];
    

    switch (indexPath.section) {
            case GanttChartSectionTypeNoFigure:
            
            pointView.figureType = OTGFigureTypeNone;
            pointView.isFill = (indexPath.row == 0)? NO:YES;
            break;
            
            case GanttChartSectionTypeCircle:
            
            pointView.figureType = OTGFigureTypeCircle;
            pointView.isFill = (indexPath.row == 0)? NO:YES;
            break;
            
            case GanttChartSectionTypeSquare:
            
            pointView.figureType = OTGFigureTypeSquare;
            pointView.isFill = (indexPath.row == 0)? NO:YES;
            break;
            
            case GanttChartSectionTypeDiamond:
            
            pointView.figureType = OTGFigureTypeDiamond;
            pointView.isFill = (indexPath.row == 0)? NO:YES;
            break;
            
            case GanttChartSectionTypeTriangle:
            
            pointView.figureType = OTGFigureTypeTriangle;
            pointView.isFill = (indexPath.row == 0)? NO:YES;
            break;
            
        default:
            break;
    }
    
    if (indexPath.row == 0) {
        pointView.isFill = NO;
    } else if (indexPath.row == 1) {
        pointView.isFill = YES;
    }
    
    NSString *dateString = [OTGCommonClass stringFromDate:pointView.date format:@"MM/dd"];
    pointView.title = [NSString stringWithFormat:@"sec:%@ row:%@ poi:%@ %@",@(indexPath.section).stringValue,@(indexPath.row).stringValue,@(pointNo).stringValue,dateString];
    
    return pointView;
}


#pragma mark - OTGanttChartViewDelegate
- (void)ganttChartView:(OTGanttChartView *)ganttChartView didVerticalScroll:(UIScrollView *)scrollView
{
    self.leftTableView.contentOffset = scrollView.contentOffset;
}


- (UIColor *)ganttChartView:(OTGanttChartView *)ganttChartView chartColorForSection:(NSInteger)section
{
    switch (section) {
            case GanttChartSectionTypeNoFigure:
            
            return [UIColor redColor];
            
            case GanttChartSectionTypeCircle:
            
            return [UIColor blackColor];
            
            case GanttChartSectionTypeSquare:
            
            return [UIColor greenColor];
            
            case GanttChartSectionTypeDiamond:
            
            return [UIColor blueColor];
            
            case GanttChartSectionTypeTriangle:
            
            return [UIColor orangeColor];
            
            case GanttChartSectionTypeRatio:
            
            return [UIColor brownColor];
            
            case GanttChartSectionTypeDotLine:
            
            return [UIColor cyanColor];
            
        default:
            break;
    }
    
    return [UIColor clearColor];
}


- (UIColor *)ganttChartView:(OTGanttChartView *)ganttChartView chartColorForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            case GanttChartSectionTypeNoFigure:
            
            return [UIColor redColor];
            
            case GanttChartSectionTypeCircle:
            
            return [UIColor blackColor];
            
            case GanttChartSectionTypeSquare:
            
            return [UIColor greenColor];
            
            case GanttChartSectionTypeDiamond:
            
            return [UIColor blueColor];
            
            case GanttChartSectionTypeTriangle:
            
            return [UIColor orangeColor];
            
            case GanttChartSectionTypeRatio:
            
            return [UIColor brownColor];
            
            case GanttChartSectionTypeDotLine:
            
            return [UIColor cyanColor];
            
        default:
            break;
    }
    
    return [UIColor clearColor];
}


- (UIColor *)ganttChartView:(OTGanttChartView *)ganttChartView chartBackgroundColorForDate:(NSDate *)date
{
    if ([OTGCommonClass isEqualToDay1:date day2:[NSDate date]]) {
        return [OTGCommonClass hexToUIColor:@"f56b3b" alpha:0.5];
    }
    
    return [UIColor clearColor];
}


@end
