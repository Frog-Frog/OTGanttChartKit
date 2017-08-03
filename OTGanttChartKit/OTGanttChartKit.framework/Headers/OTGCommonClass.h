//
//  OTGCommonClass.h
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

#import <Foundation/Foundation.h>

#import "OTGanttChartConstant.h"

@interface OTGCommonClass : NSObject

#pragma mark - Color

+ (UIColor *)hexToUIColor:(NSString *)hex alpha:(CGFloat)alpha;


+ (UIColor *)colorFromThemeMode:(OTGThemeMode)themeMode
                      partsType:(OTGPartsType)partsType;


#pragma mark - List

#pragma mark Create
+ (NSArray<NSDate *>*)createAdjustDateArray:(NSArray<NSDate *>*)dateArray;


#pragma mark Convert
+ (NSArray<NSDate *> *)createDateArrayFromStringArray:(NSArray<NSString *> *)stringArray
                                           dateFormat:(NSString *)dateFormat;


#pragma mark Sort
+ (NSArray<NSDate *> *)sortDateArray:(NSArray<NSDate *> *)dateArray;


#pragma mark Found Index
+ (NSInteger)foundSameDateIndexFromDateArray:(NSArray<NSDate *> *)dateArray
                                        date:(NSDate *)date;

#pragma mark - Date

#pragma mark Contain Check
+ (BOOL)isContainProcessStartDate:(NSDate *)processStartDate
                  processLastDate:(NSDate *)processLastDate
                    showStartDate:(NSDate *)showStartDate
                     showLastDate:(NSDate *)showLastDate;


+ (BOOL)isContainDate:(NSDate *)date
            startDate:(NSDate *)startDate
             lastDate:(NSDate *)lastDate;


#pragma mark Date In Month
+ (NSDate *)firstDateInMonthFromDate:(NSDate *)date;


+ (NSDate *)lastDateInMonthFromDate:(NSDate *)date;


#pragma mark Create Date
/**
 Create New NSDate from argument date. That is argument days before(-) or after(+).
 
 @param date original date
 @param days nagative value -> before, positive value -> after
 @return created NSDate
 */
+ (NSDate *)createDate:(NSDate *)date differenceDays:(NSInteger)days;


/**
 Create New NSDate from argument date. That is argument months before(-) or after(+).
 
 @param date original date
 @param months nagative value -> before, positive value -> after
 @return created NSDate
 */
+ (NSDate *)createDate:(NSDate *)date differenceMonths:(NSInteger)months;


#pragma mark Adjust Clock
/**
 Argument date's time information change into 12AM.
 
 @param date original date
 @return 12AM date
 */
+ (NSDate *)adjustZeroClock:(NSDate *)date;


#pragma mark Days Count
/**
 日数を取得する
 
 @param startDate 開始日
 @param lastDate 終了日
 @param isCountStartDate 初日を日数に含めるか
 @return 日数差
 */
+ (NSInteger)daysCountFromStartDate:(NSDate *)startDate
                           lastDate:(NSDate *)lastDate
                   isCountStartDate:(BOOL)isCountStartDate;





#pragma mark Equal
+ (BOOL)isEqualToDay1:(NSDate *)date1
                 day2:(NSDate *)date2;


#pragma mark Convert
/**
 Create NSDate from NSString.
 
 @param string Date text
 @param format Date text's format
 
 @return 変換後の日付型
 */
+ (NSDate *)dateFormatWithString:(NSString *)string
                          format:(NSString *)format;


/**
 Create NSString from NSDate.
 
 @param format Return date text's format
 
 @return 変換後の文字列
 */
+ (NSString *)stringFromDate:(NSDate *)date
                      format:(NSString *)format;


/**
 Create week text NSString From NSDate.
 
 @param date original date
 @return week text
 */
+ (NSString *)weekStringFromDate:(NSDate *)date
                localeIdentifier:(NSString *)localeIdentifier;





@end
