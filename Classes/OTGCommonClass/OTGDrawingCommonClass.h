//
//  OTGDrawingCommonClass.h
//  DemoApplication
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OTGDrawingCommonClass : NSObject

#pragma mark - Drawing
+ (void)drawDateSeparator:(UIView *)view
                     rect:(CGRect)rect
                dateWidth:(CGFloat)dateWidth
                lineWidth:(CGFloat)lineWidth
                    color:(UIColor *)color;


+ (void)drawCellSeparator:(CGRect)rect
                    width:(CGFloat)width
                    color:(UIColor *)color;


+ (void)drawCenterDotLine:(CGRect)rect
        processAreaHeight:(CGFloat)processAreaHeight
                lineWidth:(CGFloat)lineWidth
                    color:(UIColor *)color;


+ (void)drawBackground:(CGRect)rect
                 color:(UIColor *)color;


+ (void)drawString:(NSString *)string
              rect:(CGRect)rect
              font:(UIFont *)font
         fontColor:(UIColor *)fontColor
   backgroundColor:(UIColor *)backgroundColor
    textAllignment:(NSTextAlignment)alligment
     lineBreakMode:(NSLineBreakMode)lineBreakMode
  isAdjustFontSize:(BOOL)isAdjustFontSize;


+(void)drawCircle:(CGRect)circleRect
        lineWidth:(CGFloat)lineWidth
      strokeColor:(UIColor *)strokeColor
        fillColor:(UIColor *)fillColor;


+(void)drawTriangle:(CGRect)triangleRect
          lineWidth:(CGFloat)lineWidth
        strokeColor:(UIColor *)strokeColor
          fillColor:(UIColor *)fillColor;


+(void)drawDiamond:(CGRect)diamondRect
         lineWidth:(CGFloat)lineWidth
       strokeColor:(UIColor *)strokeColor
         fillColor:(UIColor *)fillColor;


+(void)drawSquare:(CGRect)squareRect
        lineWidth:(CGFloat)lineWidth
      strokeColor:(UIColor *)strokeColor
        fillColor:(UIColor *)fillColor;


@end
