//
//  OTGDateView.m
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

#import "OTGDateView.h"

#import "OTGCommonClass.h"
#import "OTGDrawingCommonClass.h"

@interface OTGDateView()



@end

@implementation OTGDateView


#pragma mark - Setter
- (void)setDateAreaBackgroundColor:(UIColor *)dateAreaBackgroundColor
{
    _dateAreaBackgroundColor = dateAreaBackgroundColor;
    self.backgroundColor = dateAreaBackgroundColor;
}


- (void)drawRect:(CGRect)rect
{
    [self drawDateString:rect];
    [self drawSeparator:rect];
    
    [OTGDrawingCommonClass drawDateSeparator:self
                                        rect:rect
                                   dateWidth:self.dateWidth
                                   lineWidth:self.dateSeparatorWidth
                                       color:self.dateSeparatorColor];
}


/**
 日付文字列を描画する

 @param rect 実際に表示されるOTGDateViewのサイズ
 */
- (void)drawDateString:(CGRect)rect
{
    __weak typeof(self) weakSelf = self;
    [self.showDateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *fontColor = self.dateTextColor;
        
        if (idx == self.todayIndex) {
            UIBezierPath *squarePath = [UIBezierPath bezierPathWithRect:CGRectMake(idx * weakSelf.dateWidth, 0, weakSelf.dateWidth, rect.size.height)];
            [weakSelf.todayHiligtedBackgroundColor setFill];
            [squarePath fill];
            fontColor = weakSelf.todayHiligtedDateTextColor;
        }
        
        NSDate *date = obj;
        
        //日付の描画
        NSString *dateString = [OTGCommonClass stringFromDate:date format:@"dd"];
        if([[dateString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]){
            //一文字目が0だったら省く
            dateString = [dateString substringFromIndex:1];
        };
        
        [OTGDrawingCommonClass drawString:dateString
                                     rect:CGRectMake(idx * weakSelf.dateWidth, rect.size.height/4 - weakSelf.dateFontSize/2, weakSelf.dateWidth, rect.size.height/2)
                                     font:[UIFont systemFontOfSize:weakSelf.dateFontSize]
                                fontColor:fontColor
                          backgroundColor:[UIColor clearColor]
                           textAllignment:NSTextAlignmentCenter
                            lineBreakMode:NSLineBreakByWordWrapping
                         isAdjustFontSize:YES];
        
        //曜日の描画
        NSString *weekString = [OTGCommonClass weekStringFromDate:date
                                                 localeIdentifier:weakSelf.localeIdentifier];
        
        [OTGDrawingCommonClass drawString:weekString
                                     rect:CGRectMake(idx * weakSelf.dateWidth, rect.size.height/4 * 3 - weakSelf.dateFontSize/2, weakSelf.dateWidth, rect.size.height/2)
                                     font:[UIFont systemFontOfSize:weakSelf.dateFontSize]
                                fontColor:fontColor
                          backgroundColor:[UIColor clearColor]
                           textAllignment:NSTextAlignmentCenter
                            lineBreakMode:NSLineBreakByWordWrapping
                         isAdjustFontSize:YES];
    }];
}


- (void)drawSeparator:(CGRect)rect
{
    CGFloat viewWidth = rect.size.width;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [self.dateSeparatorColor setStroke];
    linePath.lineWidth = self.dateSeparatorWidth;
    
    CGPoint centerStartPoint = CGPointMake(0, rect.size.height/2);
    [linePath moveToPoint:centerStartPoint];
    CGPoint centerEndPoint = CGPointMake(viewWidth, rect.size.height/2);
    [linePath addLineToPoint:centerEndPoint];
    [linePath stroke];
    
    linePath = [UIBezierPath bezierPath];
    [self.chartBorderColor setStroke];
    linePath.lineWidth = self.chartBorderWidth;
    //区切り線座標を指定
    CGPoint underStartPoint = CGPointMake(0, rect.size.height - self.chartBorderWidth/2);
    [linePath moveToPoint:underStartPoint];
    CGPoint underEndPoint = CGPointMake(viewWidth, rect.size.height - self.chartBorderWidth/2);
    [linePath addLineToPoint:underEndPoint];
    
    [linePath stroke];
    
}


@end
