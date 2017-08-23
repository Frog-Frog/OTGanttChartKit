//
//  OTGChartPointView.m
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

#import "OTGChartPointView.h"

#import "OTGDrawingCommonClass.h"

@interface OTGChartPointView()


@end

@implementation OTGChartPointView

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
    
    self.figureLineWidth = OTGFigurePeripheryWidth;
    
    self.figureSize = OTGFigureSize;
    
    self.figureLeftMargin = OTGFigureSideMargin;
    
    self.figureRightMargin = OTGFigureSideMargin;
    
    self.fontSize = OTGChartFontSize;
    
    self.adjustFontSizeEnabled = NO;
    
    self.figureType = OTGFigureTypeCircle;
    
    self.fontColor = [UIColor whiteColor];
    
    self.textBackgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedChartPointView:)];
    [self addGestureRecognizer:tapGesture];
}


#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    [self drawFigure:rect];
    [self drawText:rect];
}


- (void)drawFigure:(CGRect)rect
{
    CGRect figureRect = CGRectMake(self.figureLeftMargin, (rect.size.height - self.figureSize)/2, self.figureSize, self.figureSize);
    
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
    CGFloat startTextX = (self.figureType == OTGFigureTypeNone)? 0:self.figureLeftMargin + OTGFigureSize + self.figureRightMargin;
    CGFloat textWidth  = rect.size.width - startTextX;
    CGFloat textHeight = [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}].height;
    CGFloat startTextY = self.frame.size.height/2 - textHeight/2;
    
    self.title = [self.title stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    [OTGDrawingCommonClass drawString:self.title
                                 rect:CGRectMake(startTextX, startTextY, textWidth, textHeight)
                                 font:[UIFont systemFontOfSize:self.fontSize]
                            fontColor:self.fontColor
                      backgroundColor:self.textBackgroundColor
                       textAllignment:NSTextAlignmentLeft
                        lineBreakMode:NSLineBreakByTruncatingMiddle
                     isAdjustFontSize:self.adjustFontSizeEnabled];
}


#pragma mark - TapGesture
- (void)tappedChartPointView:(UITapGestureRecognizer *)sender
{
    [self.delegate tappedChartPointView:self];
}


@end
