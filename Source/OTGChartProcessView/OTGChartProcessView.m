//
//  OTGChartProcessView.m
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

#import "OTGChartProcessView.h"

#import "OTGCommonClass.h"
#import "OTGDrawingCommonClass.h"

@interface OTGChartProcessView()

@property (weak, nonatomic) IBOutlet UILabel *processTitleLabel;

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
    
    self.dotLineWidth = OTGProcessDotLineWidth;
    
    self.dotBlankWidth = OTGProcessDotBlankWidth;
    
    self.dotSolidLineWidth = OTGProcessDotSolidLineWidth;
    
    self.figureLineWidth = OTGFigurePeripheryWidth;
    
    self.figureLeftMargin = OTGFigureSideMargin;
    
    self.figureRightMargin = OTGFigureSideMargin;
    
    self.figureSize = OTGFigureSize;
    
    self.figureType = OTGFigureTypeNone;
    
    self.fontSize = OTGChartFontSize;
    
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
    [self drawText:rect];
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
        
        if (placeCount == 0) {
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
                        lineBreakMode:NSLineBreakByTruncatingMiddle];
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
    if (self.figureType != OTGFigureTypeNone) {
        return self.figureLeftMargin + self.figureSize + self.figureRightMargin;
    } else {
        BOOL isNotFound;
        [self searchFirstDateIndex:&isNotFound];
        return [self calculateProcessStartXFromPlaceCount:0 isNotFound:isNotFound];
    }
}



- (CGFloat)calculateProcessStartXFromPlaceCount:(NSInteger)placeCount
                                     isNotFound:(BOOL)isNotFound
{
    CGFloat startX = self.dateWidth * placeCount;
    
    if (placeCount == 0) {
        if (self.figureType != OTGFigureTypeNone) {
            //図形の描画がある場合は工程のスタートは図形の真ん中からにする
            startX = self.figureLeftMargin + self.figureSize/2;
        } else {
            if (!isNotFound) {
                startX = (self.startRatio == 0.0)? startX : self.startRatio * self.dateWidth;
            }
        }
    }
    
    return startX;
}


- (CGFloat)calculateProcessFinishXFromPlaceCount:(NSInteger)placeCount
                                       roopCount:(NSInteger)roopCount
                                   lastDateIndex:(NSInteger)lastDateIndex
                                      isNotFound:(BOOL)isNotFound
{
    CGFloat finishX = self.dateWidth * placeCount + self.dateWidth;
    
    if (self.figureType != OTGFigureTypeNone) {
        return finishX;
    }
    
    if (roopCount == lastDateIndex) {
        if (!isNotFound) {
            finishX = (self.finishRatio == 1.0)? finishX : self.dateWidth * placeCount + self.finishRatio * self.dateWidth;
        }
        
    }
    
    return finishX;
}


#pragma mark - TapGesture
- (void)tappedChartProcessView:(UITapGestureRecognizer *)sender
{
    [self.delegate tappedChartProcessView:self];
}

@end
