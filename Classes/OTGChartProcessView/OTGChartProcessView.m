//
//  OTGChartProcessView.m
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

#import "OTGChartProcessView.h"

#import "OTGCommonClass.h"
#import "OTGDrawingCommonClass.h"

@interface OTGChartProcessView()

@property (nonatomic) UILabel *processTitleLabel;

@end

@implementation OTGChartProcessView

#pragma mark - Initialize
// OverRide(コードから生成時に呼ばれる)
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        
    }
    return self;
}


- (void)initialize
{
    //そのままだと背景が黒くなるので透明にする
    self.backgroundColor = [UIColor clearColor];
    
    self.fillColor = [UIColor whiteColor];
    
    self.isFill = YES;
    
    self.lineWidth = OTGProcessLineWidth;
    
    self.isDotLine = NO;
    
    self.dotLineWidth = OTGProcessDotLineWidth;
    
    self.dotBlankWidth = OTGProcessDotBlankWidth;
    
    self.dotSolidLineWidth = OTGProcessDotSolidLineWidth;
    
    self.figureLineWidth = OTGFigurePeripheryWidth;
    
    self.figureLeftMargin = OTGFigureSideMargin;
    
    self.figureRightMargin = OTGFigureSideMargin;
    
    self.figureSize = OTGFigureSize;
    
    self.figureType = OTGFigureTypeNone;
    
    self.textTrackingEnabled = NO;
    
    self.fontSize = OTGChartFontSize;

    self.adjustFontSizeEnabled = NO;
    
    self.fontColor = [UIColor whiteColor];
    
    self.textBackgroundColor = [UIColor clearColor];
    
    self.startRatio = 0.0;
    
    self.finishRatio = 1.0f;
    
    [self prepareGesture];
}


- (void)prepareGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedChartProcessView:)];
    [self addGestureRecognizer:tapGesture];
}


#pragma mark - LifeCycle
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (self.textTrackingEnabled && [self.title length] && !self.processTitleLabel) {
        [self putTitleLabel];
    }
}


- (void)putTitleLabel
{
    CGFloat startTextX = [self calculateTextStartX];
    CGFloat startTextY = self.frame.size.height/2 + self.lineWidth/2;
    
    CGSize stringSize = [self.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.fontSize]}];
    
    BOOL isContainFirstDate =[OTGCommonClass isContainDate:[self.dateArray firstObject] startDate:[self.showDateArray firstObject] lastDate:[self.showDateArray lastObject]];
    NSDate *firstDate = (isContainFirstDate)? [self.dateArray firstObject]:[self.showDateArray firstObject];
    
    NSInteger daysCount = [OTGCommonClass daysCountFromStartDate:firstDate lastDate:[self.dateArray lastObject] isCountStartDate:YES];
    daysCount = (self.minimumProcessViewWidthDays > daysCount)? self.minimumProcessViewWidthDays : daysCount;
    
    CGFloat maxStringWidth = daysCount * self.dateWidth - startTextX;
    
    CGFloat textWidth  = (stringSize.width > maxStringWidth)? maxStringWidth : stringSize.width;
    
    self.processTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(startTextX, startTextY, textWidth, stringSize.height)];
    self.processTitleLabel.text = self.title;
    self.processTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.processTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.processTitleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    self.processTitleLabel.textColor = self.fontColor;
    self.processTitleLabel.backgroundColor = self.textBackgroundColor;
    self.processTitleLabel.minimumScaleFactor = (self.adjustFontSizeEnabled)? 0.5:1;
    
    [self addSubview:self.processTitleLabel];
}


#pragma mark - Setter
- (void)setStartRatio:(CGFloat)startRatio
{
    if (startRatio < 0.0f || startRatio >= 1.0f) {
        startRatio = 0.0f;
    }
    
    _startRatio = startRatio;
}


- (void)setFinishRatio:(CGFloat)finishRatio
{
    if (finishRatio <= 0.0f || finishRatio > 1.0f) {
        finishRatio = 1.0f;
    }
    
    _finishRatio = finishRatio;
}


#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    [self drawProcess:rect];
    
    if (!self.textTrackingEnabled) {
        [self drawText:rect];
    }
}


/**
 工程部分の描画を行う

 @param rect 表示サイズ
 */
- (void)drawProcess:(CGRect)rect
{
    BOOL firstIsNotFound;
    NSInteger firstDateIndex = [self searchFirstDateIndex:&firstIsNotFound];
    
    BOOL lastIsNotFound;
    NSInteger lastDateIndex = [self searchLastDateIndex:&lastIsNotFound];
    
    NSInteger placeCount = 0;
    
    for (NSInteger i = firstDateIndex; i <= lastDateIndex; i++) {
        NSInteger sameIndex = [OTGCommonClass foundSameDateIndexFromDateArrayByCompare:self.dateArray
                                                                                  date:self.showDateArray[i]];
        
        //一日ごとのバー描画の開始と終了地点
        //初回は図形を描いてからなので、図形の中心からバーをスタートする
        CGFloat startX = [self calculateProcessStartXFromPlaceCount:placeCount
                                                         isNotFound:firstIsNotFound];
        
        CGFloat finishX = [self calculateProcessFinishXFromPlaceCount:placeCount
                                                            roopCount:i
                                                        lastDateIndex:lastDateIndex
                                                           isNotFound:lastIsNotFound];
        
        
        if (sameIndex == NSNotFound && self.isDotLine) {
            //datelistにない日付かつ、isDotLineにYESが設定されている場合の点線の描画
            UIBezierPath *dotLinePath = [UIBezierPath bezierPath];
            dotLinePath.lineWidth = self.dotLineWidth;
            [self.strokeColor setStroke];
            
            //上部の点線
            CGFloat lineTopY = rect.size.height/2 - self.lineWidth/2 + self.dotLineWidth/2;
            [dotLinePath moveToPoint:CGPointMake(startX, lineTopY)];
            [dotLinePath addLineToPoint:CGPointMake(finishX, lineTopY)];
            
            //下部の点線
            CGFloat lineBottomY = rect.size.height/2 + self.lineWidth/ 2 - self.dotLineWidth/2;
            [dotLinePath moveToPoint:CGPointMake(startX, lineBottomY)];
            [dotLinePath addLineToPoint:CGPointMake(finishX, lineBottomY)];
            
            CGFloat dashPattern[] = {self.dotSolidLineWidth,self.dotBlankWidth};
            [dotLinePath setLineDash:dashPattern count:2 phase:0];
            
            [dotLinePath stroke];
        } else {
            //通常の実線の描画
            UIBezierPath *linePath = [UIBezierPath bezierPath];
            linePath.lineWidth = self.lineWidth;
            [self.strokeColor setStroke];
    
            [linePath moveToPoint:CGPointMake(startX, rect.size.height/2)];
            [linePath addLineToPoint:CGPointMake(finishX, rect.size.height/2)];
            
            [linePath stroke];
            
        }
        
        if (placeCount == 0 && firstIsNotFound == NO) {
            if (self.figureType != OTGFigureTypeNone) {
                //初日が表示中の日付のリストに存在している場合、初回は図形の描画
                //塗りつぶし色が違う場合があるので、最後に描画する
                [self drawFisrtFigure:rect];
            }
            
        }
        
        placeCount++;
    }
}


- (void)drawFisrtFigure:(CGRect)rect
{
    CGRect figureRect = CGRectMake(OTGFigureSideMargin, (rect.size.height - OTGFigureSize)/2, OTGFigureSize, OTGFigureSize);
    
    switch (self.figureType) {
        case OTGFigureTypeCircle:
        {
            [OTGDrawingCommonClass drawCircle:figureRect
                                    lineWidth:self.figureLineWidth
                                  strokeColor:self.strokeColor
                                    fillColor:self.fillColor];
            break;
        }
        case OTGFigureTypeTriangle:
        {
            [OTGDrawingCommonClass drawTriangle:figureRect
                                      lineWidth:self.figureLineWidth
                                    strokeColor:self.strokeColor
                                      fillColor:self.fillColor];
            break;
        }
        case OTGFigureTypeSquare:
        {
            [OTGDrawingCommonClass drawSquare:figureRect
                                    lineWidth:self.figureLineWidth
                                  strokeColor:self.strokeColor
                                    fillColor:self.fillColor];
            break;
        }
        case OTGFigureTypeDiamond:
        {
            [OTGDrawingCommonClass drawDiamond:figureRect
                                     lineWidth:self.figureLineWidth
                                   strokeColor:self.strokeColor
                                     fillColor:self.fillColor];
            break;
        }
        default:
        {
            break;
        }
            
    }
}


- (void)drawText:(CGRect)rect
{
    CGFloat startTextX = [self calculateTextStartX];
    CGFloat startTextY = rect.size.height/2 + self.lineWidth/2;
    CGFloat textWidth  = rect.size.width - startTextX;
    CGFloat textHeight = rect.size.height - startTextY;
    
    NSMutableArray *array = [NSMutableArray array];
    [self.title enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        [array addObject:line];
    }];
    self.title = [array componentsJoinedByString:@""];
    
    [OTGDrawingCommonClass drawString:self.title
                                 rect:CGRectMake(startTextX, startTextY , textWidth, textHeight)
                                 font:[UIFont systemFontOfSize:self.fontSize]
                            fontColor:self.fontColor
                      backgroundColor:self.textBackgroundColor
                       textAllignment:NSTextAlignmentLeft
                        lineBreakMode:NSLineBreakByTruncatingMiddle
                     isAdjustFontSize:self.adjustFontSizeEnabled];
}


#pragma mark - searchDateInde
- (NSInteger)searchFirstDateIndex:(BOOL *)isNotFound
{
    //初日
    NSDate *firstDate = [self.dateArray firstObject];
    NSInteger firstDateIndex = [OTGCommonClass foundSameDateIndexFromDateArray:self.showDateArray
                                                                          date:firstDate];
    //初日が表示日付リストの中に見つからない場合 = 表示範囲外の日付が初日の場合は、
    //表示範囲内最初の日付から線を伸ばし、最初の図形の描画は無しにする。
    if (firstDateIndex == NSNotFound) {
        *isNotFound = YES;
        return 0;
    } else {
        *isNotFound = NO;
        return firstDateIndex;
    }
}


- (NSInteger)searchLastDateIndex:(BOOL *)isNotFound
{
    //最終日
    NSDate * lastDate = [self.dateArray lastObject];
    NSInteger lastDateIndex = [OTGCommonClass foundSameDateIndexFromDateArray:self.showDateArray
                                                                         date:lastDate];
    //最終日が表示日付リストの中に見つからない場合 = 表示範囲外の日付が終了日の場合は、
    //表示範囲の最後の日まで線が伸びるようにshowDateArrayの最後を指定する
    if (lastDateIndex == NSNotFound) {
        *isNotFound = YES;
        return self.showDateArray.count - 1;
    } else {
        *isNotFound = NO;
        return lastDateIndex;
    }
}


#pragma mark - Calculate
- (CGFloat)calculateTextStartX
{
    BOOL isNotFound;
    [self searchFirstDateIndex:&isNotFound];
    
    if (self.figureType != OTGFigureTypeNone) {
        if (isNotFound == YES) {
            return [self calculateProcessStartXFromPlaceCount:0 isNotFound:isNotFound];
        }
        return self.figureLeftMargin + self.figureSize + self.figureRightMargin;
    } else {
        return [self calculateProcessStartXFromPlaceCount:0 isNotFound:isNotFound];
    }
}



- (CGFloat)calculateProcessStartXFromPlaceCount:(NSInteger)placeCount
                                     isNotFound:(BOOL)isNotFound
{
    if (placeCount == 0) {
        if (isNotFound) {
            
            return 0;
        
        } else {
            if (self.figureType == OTGFigureTypeNone) {
                
                return self.startRatio * self.dateWidth;
                
            } else {
            
                return self.figureLeftMargin + self.figureSize/2;
            
            }
        }
    }
    
    return self.dateWidth * placeCount;
}


- (CGFloat)calculateProcessFinishXFromPlaceCount:(NSInteger)placeCount
                                       roopCount:(NSInteger)roopCount
                                   lastDateIndex:(NSInteger)lastDateIndex
                                      isNotFound:(BOOL)isNotFound
{
    if (roopCount == lastDateIndex) {
        if (!isNotFound) {
            return  self.dateWidth * placeCount + self.finishRatio * self.dateWidth;
        }
    }
    
    return self.dateWidth * placeCount + self.dateWidth;
}


#pragma mark - TapGesture
- (void)tappedChartProcessView:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(tappedChartProcessView:)]) {
        [self.delegate tappedChartProcessView:self];
    }
}


#pragma mark - Tracking Horizontal Scroll
- (void)trackingHorizontalScrollWithCurrentXPosition:(CGFloat)xPosition
{
    if (!self.textTrackingEnabled || !self.processTitleLabel) {
        return;
    }
   
    CGFloat textStartX = self.frame.origin.x + [self calculateTextStartX];
    
    BOOL isContainFirstDate =[OTGCommonClass isContainDate:[self.dateArray firstObject] startDate:[self.showDateArray firstObject] lastDate:[self.showDateArray lastObject]];
    NSDate *firstDate = (isContainFirstDate)? [self.dateArray firstObject]:[self.showDateArray firstObject];
    
    CGFloat lineWidth = [OTGCommonClass daysCountFromStartDate:firstDate lastDate:[self.dateArray lastObject] isCountStartDate:YES] * self.dateWidth;
    CGFloat lineEndPoint = self.frame.origin.x + lineWidth;
    
    if (textStartX < xPosition && xPosition < lineEndPoint) {
        
        if (self.processTitleLabel.frame.size.width > lineWidth) {
            return;
        }
        
        CGFloat newX = xPosition - self.frame.origin.x;
        
        newX = (newX + self.processTitleLabel.frame.size.width > lineWidth)? lineWidth - self.processTitleLabel.frame.size.width:newX;
        
        self.processTitleLabel.frame = CGRectMake(newX,
                                                  self.processTitleLabel.frame.origin.y,
                                                  self.processTitleLabel.frame.size.width,
                                                  self.processTitleLabel.frame.size.height);
    } else if (textStartX > xPosition) {
        
        self.processTitleLabel.frame = CGRectMake([self calculateTextStartX],
                                                  self.processTitleLabel.frame.origin.y,
                                                  self.processTitleLabel.frame.size.width,
                                                  self.processTitleLabel.frame.size.height);
        
    } else if (lineEndPoint < xPosition) {
        
        if (self.processTitleLabel.frame.size.width > lineWidth) {
            return;
        }
        
        self.processTitleLabel.frame = CGRectMake(lineWidth - self.processTitleLabel.frame.size.width,
                                                  self.processTitleLabel.frame.origin.y,
                                                  self.processTitleLabel.frame.size.width,
                                                  self.processTitleLabel.frame.size.height);
    }
    
    
    
}

@end
