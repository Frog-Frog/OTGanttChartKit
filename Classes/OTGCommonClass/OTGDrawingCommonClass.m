//
//  OTGDrawingCommonClass.m
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

#import "OTGDrawingCommonClass.h"

@implementation OTGDrawingCommonClass

#pragma mark - Draw Line
+ (void)drawDateSeparator:(UIView *)view
                     rect:(CGRect)rect
                dateWidth:(CGFloat)dateWidth
                lineWidth:(CGFloat)lineWidth
                    color:(UIColor *)color
{
    CGFloat viewWidth = rect.size.width;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    [color setStroke];
    linePath.lineWidth = lineWidth;
    
    for (CGFloat x = 0.0f ; x < viewWidth; x += dateWidth) {
        
        CGPoint startPoint = CGPointMake(x, view.frame.origin.y);
        [linePath moveToPoint:startPoint];
        CGPoint endPoint = CGPointMake(x, view.frame.origin.y + view.frame.size.height);
        [linePath addLineToPoint:endPoint];
        
    }
    
    [linePath stroke];
}


+ (void)drawCellSeparator:(CGRect)rect
                    width:(CGFloat)width
                    color:(UIColor *)color
{
    CGFloat viewWidth = rect.size.width;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [color setStroke];
    linePath.lineWidth = width;
    
    CGPoint topStartPoint = CGPointMake(rect.origin.x, rect.origin.y);
    [linePath moveToPoint:topStartPoint];
    CGPoint topEndPoint = CGPointMake(rect.origin.x + viewWidth, rect.origin.y);
    [linePath addLineToPoint:topEndPoint];
    
    CGPoint underStartPoint = CGPointMake(rect.origin.x, rect.size.height);
    [linePath moveToPoint:underStartPoint];
    CGPoint underEndPoint = CGPointMake(rect.origin.x + viewWidth, rect.size.height);
    [linePath addLineToPoint:underEndPoint];
    
    [linePath stroke];
}


+ (void)drawCenterDotLine:(CGRect)rect
        processAreaHeight:(CGFloat)processAreaHeight
                lineWidth:(CGFloat)lineWidth
                    color:(UIColor *)color
{
    CGFloat viewWidth = rect.size.width;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [color setStroke];
    linePath.lineWidth = lineWidth;
    CGFloat dashPattern[] = {1.0f,2.0f};
    [linePath setLineDash:dashPattern count:2 phase:0];
    
    
    CGPoint centerStartPoint = CGPointMake(rect.origin.x, processAreaHeight);
    [linePath moveToPoint:centerStartPoint];
    CGPoint centerEndPoint = CGPointMake(rect.origin.x + viewWidth, processAreaHeight);
    [linePath addLineToPoint:centerEndPoint];
    [linePath stroke];
}


#pragma mark - Draw Background
+ (void)drawBackground:(CGRect)rect
                 color:(UIColor *)color
{
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRect:rect];
    [color setFill];
    [squarePath fill];
}


#pragma mark - Draw String
+ (void)drawString:(NSString *)string
              rect:(CGRect)rect
              font:(UIFont *)font
         fontColor:(UIColor *)fontColor
   backgroundColor:(UIColor *)backgroundColor
    textAllignment:(NSTextAlignment)alligment
     lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = lineBreakMode;
    style.alignment = alligment;
    
    CGSize stringSize = [string sizeWithAttributes:@{NSFontAttributeName : font}];
    while(stringSize.width > rect.size.width || stringSize.height > rect.size.height){
        font = [UIFont systemFontOfSize:font.pointSize -1];
        stringSize = [string sizeWithAttributes:@{NSFontAttributeName : font}];
    }
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : fontColor,
                                 NSBackgroundColorAttributeName : backgroundColor,
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : style,
                                 };
    
    [string drawInRect:rect withAttributes:attributes];
}


#pragma mark - Draw Figure
+(void)drawCircle:(CGRect)circleRect
        lineWidth:(CGFloat)lineWidth
      strokeColor:(UIColor *)strokeColor
        fillColor:(UIColor *)fillColor
{
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    circlePath.lineWidth = lineWidth;
    [strokeColor setStroke];
    [fillColor setFill];
    [circlePath fill];
    [circlePath stroke];
}


+(void)drawTriangle:(CGRect)triangleRect
          lineWidth:(CGFloat)lineWidth
        strokeColor:(UIColor *)strokeColor
          fillColor:(UIColor *)fillColor
{
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    
    [trianglePath moveToPoint:CGPointMake(triangleRect.origin.x + triangleRect.size.width/2, triangleRect.origin.y)];
    [trianglePath addLineToPoint:CGPointMake(triangleRect.origin.x, triangleRect.origin.y + triangleRect.size.height)];
    [trianglePath addLineToPoint:CGPointMake(triangleRect.origin.x + triangleRect.size.width,triangleRect.origin.y + triangleRect.size.height)];
    [trianglePath closePath];
    
    trianglePath.lineWidth = lineWidth;
    [strokeColor setStroke];
    [fillColor setFill];
    [trianglePath fill];
    [trianglePath stroke];
    
}


+(void)drawDiamond:(CGRect)diamondRect
         lineWidth:(CGFloat)lineWidth
       strokeColor:(UIColor *)strokeColor
         fillColor:(UIColor *)fillColor
{
    UIBezierPath *diamondPath = [UIBezierPath bezierPath];
    
    [diamondPath moveToPoint:CGPointMake(diamondRect.origin.x + diamondRect.size.width/2, diamondRect.origin.y)];
    [diamondPath addLineToPoint:CGPointMake(diamondRect.origin.x, diamondRect.origin.y + diamondRect.size.height/2)];
    [diamondPath addLineToPoint:CGPointMake(diamondRect.origin.x + diamondRect.size.width/2,diamondRect.origin.y + diamondRect.size.height)];
    [diamondPath addLineToPoint:CGPointMake(diamondRect.origin.x + diamondRect.size.width, diamondRect.origin.y + diamondRect.size.height/2)];
    [diamondPath closePath];
    
    diamondPath.lineWidth = lineWidth;
    [strokeColor setStroke];
    [fillColor setFill];
    [diamondPath fill];
    [diamondPath stroke];
}


+(void)drawSquare:(CGRect)squareRect
        lineWidth:(CGFloat)lineWidth
      strokeColor:(UIColor *)strokeColor
        fillColor:(UIColor *)fillColor
{
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRect:squareRect];
    squarePath.lineWidth = lineWidth;
    [strokeColor setStroke];
    [fillColor setFill];
    [squarePath fill];
    [squarePath stroke];
}

@end
