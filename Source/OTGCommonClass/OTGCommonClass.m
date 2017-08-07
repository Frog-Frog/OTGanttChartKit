//
//  OTGCommonClass.m
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

#import "OTGCommonClass.h"

static NSCalendar *calendar;
static NSDateFormatter *dateFormatter;

@implementation OTGCommonClass

#pragma mark - Color
+ (UIColor *)hexToUIColor:(NSString *)hex alpha:(CGFloat)alpha
{
    if ([hex length] == 0) {
        return [UIColor colorWithWhite:1.0 alpha:alpha];
    }
    
    NSString *firstStr = [hex substringToIndex:1];
    if ([firstStr isEqualToString:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    
    NSScanner *colorScanner = [NSScanner scannerWithString:hex];
    unsigned int color;
    [colorScanner scanHexInt:&color];
    CGFloat r = ((color & 0xFF0000) >> 16)/255.0f;
    CGFloat g = ((color & 0x00FF00) >> 8) /255.0f;
    CGFloat b =  (color & 0x0000FF) /255.0f;
    //NSLog(@"HEX to RGB >> r:%f g:%f b:%f a:%f\n",r,g,b,a);
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}


+ (UIColor *)colorFromThemeMode:(OTGThemeMode)themeMode
                      partsType:(OTGPartsType)partsType
{
    switch (themeMode) {
        case OTGThemeModeDark:
        {
            switch (partsType) {
                case OTGPartsTypeDateSeparator:
                {
                    return [self hexToUIColor:@"5d5d5d" alpha:1.0f];
                }
                case OTGPartsTypeDateAreaBackground:
                {
                    return [self hexToUIColor:@"3f3f3f" alpha:1.0f];
                }
                case OTGPartsTypePointAreaBackground:
                {
                    return [self hexToUIColor:@"3f3f3f" alpha:1.0f];
                }
                case OTGPartsTypeProcessAreaBackground:
                {
                    return [self hexToUIColor:@"383838" alpha:1.0f];
                }
                case OTGPartsTypeScrollBackground:
                {
                    return [self hexToUIColor:@"3f3f3f" alpha:1.0f];
                }
                case OTGPartsTypeTodayHighlitedBackground:
                {
                    return [self hexToUIColor:@"D07926" alpha:1.0f];
                }
                case OTGPartsTypeDotSeparator:
                {
                    return [self hexToUIColor:@"595959" alpha:1.0f];
                }
                case OTGPartsTypeChartBorder:
                {
                    return [self hexToUIColor:@"8b8b8b" alpha:1.0f];
                }
                case OTGPartsTypeDateText:
                {
                    return [UIColor whiteColor];
                }
                case OTGPartsTypeTodayHighlitedDateText:
                {
                    return [self hexToUIColor:@"3f3f3f" alpha:1.0f];
                }
                case OTGPartsTypeRowSeparator:
                {
                    return [self hexToUIColor:@"515151" alpha:1.0f];
                }
                case OTGPartsTypeRefleshArrowImage:
                {
                    return [self hexToUIColor:@"9c9c9c" alpha:1.0f];
                }
                case OTGPartsTypeTodayLineColor:
                {
                    return [self hexToUIColor:@"D07926" alpha:1.0f];
                }
            }
        }
        case OTGThemeModeBright:
        {
            switch (partsType) {
                case OTGPartsTypeDateSeparator:
                {
                    return [self hexToUIColor:@"E8E8E8" alpha:1.0f];
                }
                case OTGPartsTypeDateAreaBackground:
                {
                    return [self hexToUIColor:@"F4F7FC" alpha:1.0f];
                }
                case OTGPartsTypePointAreaBackground:
                {
                    return [UIColor whiteColor];
                }
                case OTGPartsTypeProcessAreaBackground:
                {
                    return [UIColor whiteColor];
                }
                case OTGPartsTypeScrollBackground:
                {
                    return [self hexToUIColor:@"F4F4F3" alpha:1.0f];
                }
                case OTGPartsTypeTodayHighlitedBackground:
                {
                    return [self hexToUIColor:@"F4F7FC" alpha:1.0f];
                }
                case OTGPartsTypeDotSeparator:
                {
                    return [UIColor clearColor];
                }
                case OTGPartsTypeChartBorder:
                {
                    return [self hexToUIColor:@"7C7C7C" alpha:1.0f];
                }
                case OTGPartsTypeDateText:
                {
                    return [self hexToUIColor:@"4f4f4f" alpha:1.0f];
                }
                case OTGPartsTypeTodayHighlitedDateText:
                {
                    return [self hexToUIColor:@"4f4f4f" alpha:1.0f];
                }
                case OTGPartsTypeRowSeparator:
                {
                    return [self hexToUIColor:@"C7C7C7" alpha:1.0f];
                }
                case OTGPartsTypeRefleshArrowImage:
                {
                    return [self hexToUIColor:@"9c9c9c" alpha:1.0f];
                }
                case OTGPartsTypeTodayLineColor:
                {
                    return [self hexToUIColor:@"fa9420" alpha:1.0f];
                }
            }
        }
        default:
        {
            return [UIColor blackColor];
        }
    }
}


#pragma mark - List
#pragma mark Create
/**
 時間がバラバラの可能性があるので、合わせてArrayを作り直す
 
 @param dateArray Array
 @return 時間を調整したArray
 */
+ (NSArray<NSDate *>*)createAdjustDateArray:(NSArray<NSDate *>*)dateArray
{
    NSMutableArray<NSDate *> *adjustDateArray = [NSMutableArray array];
    [dateArray enumerateObjectsUsingBlock:^(NSDate * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        NSDate *date = [self adjustZeroClock:obj];
        [adjustDateArray addObject:date];
    }];
    
    return [self sortDateArray:adjustDateArray];
}


#pragma mark Convert
/**
 NSStringの日付リストをNSDateの日付リストに変換する
 
 @param stringArray NSStringの日付リスト
 @param dateFormat 日付リストのフォーマット
 @return NSDateの日付リスト
 */
+ (NSArray<NSDate *> *)createDateArrayFromStringArray:(NSArray<NSString *> *)stringArray
                                           dateFormat:(NSString *)dateFormat
{
    if (stringArray.count == 0) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [stringArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [weakSelf dateFormatWithString:obj format:dateFormat];;
        [array addObject:date];
    }];
    
    return [self sortDateArray:array];
}


#pragma mark Sort
/**
 配列のNSDateを並び替えます。
 
 @param dateArray 並び替え対象の配列
 
 @return 並び替え後の配列
 */
+ (NSArray<NSDate *> *)sortDateArray:(NSArray<NSDate *> *)dateArray
{
    NSComparisonResult (^dateComapre)(NSDate *, NSDate *) = ^(NSDate *date1, NSDate *date2)
    {
        
        NSComparisonResult result = [date1 compare:date2];
        if (result == NSOrderedAscending) {
            
            return NSOrderedAscending;
        
        } else if (result == NSOrderedDescending) {
            
            return NSOrderedDescending;
            
        }
        return NSOrderedSame;
    };
    
    return [dateArray sortedArrayUsingComparator:dateComapre];
}


#pragma mark - Found Index
/**
 リストから引数の日付が存在している場合indexを返す
 
 @param dateArray 日付リスト
 @param date 日付
 @return インデックス
 */
+ (NSInteger)foundSameDateIndexFromDateArray:(NSArray<NSDate *> *)dateArray
                                        date:(NSDate *)date
{
    dateArray = [self sortDateArray:dateArray];
    BOOL isContain = [self isContainDate:date startDate:[dateArray firstObject] lastDate:[dateArray lastObject]];
    
    if (!isContain) {
        return NSNotFound;
    }
    
    return [OTGCommonClass daysCountFromStartDate:[dateArray firstObject] lastDate:date isCountStartDate:NO];
}


/**
 リストから引数の日付が存在している場合indexを返す
 
 @param dateArray 日付リスト
 @param date 日付
 @return インデックス
 */
+ (NSInteger)foundSameDateIndexFromDateArrayByCompare:(NSArray<NSDate *> *)dateArray
                                                 date:(NSDate *)date
{
    dateArray = [self sortDateArray:dateArray];
    
    __block NSInteger index = NSNotFound;
    [dateArray enumerateObjectsUsingBlock:^(NSDate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isEqualToDay1:date day2:obj] ) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}


#pragma mark - Date

#pragma mark Contain Check
/**
 引数で渡された工程の期間が表示する期間に含まれるか判定する
 
 @param processStartDate 工程開始日
 @param processLastDate 工程終了日
 @param showStartDate 表示開始日
 @param showLastDate 表示終了日
 @return YES = どちらかが含まれる、 NO = どちらも範囲外
 */
+ (BOOL)isContainProcessStartDate:(NSDate *)processStartDate
                  processLastDate:(NSDate *)processLastDate
                    showStartDate:(NSDate *)showStartDate
                     showLastDate:(NSDate *)showLastDate
{
    if ([processStartDate compare:showStartDate] == NSOrderedAscending && [processLastDate compare:showStartDate] == NSOrderedDescending) {
        //工程開始日が表示開始日より前かつ、工程終了日が表示終了日より後の場合
        return YES;
    }
    
    BOOL isContainProcessStartDate = [self isContainDate:processStartDate
                                             startDate:showStartDate
                                              lastDate:showLastDate];
    
    BOOL isContainProcessLastDate = [self isContainDate:processLastDate
                                           startDate:showStartDate
                                            lastDate:showLastDate];
    
    if (isContainProcessStartDate || isContainProcessLastDate) {
        return YES;
    }
    
    return NO;
}


/**
 引数で渡されたstartDateとlastDateの期間にdateが含まれるか判定する

 @param date 判定する日付
 @param startDate 開始日
 @param lastDate 終了日
 @return 判定
 */
+ (BOOL)isContainDate:(NSDate *)date
            startDate:(NSDate *)startDate
             lastDate:(NSDate *)lastDate
{
    date = [self adjustZeroClock:date];
    startDate = [self adjustZeroClock:startDate];
    lastDate = [self adjustZeroClock:lastDate];
    
    if ([date compare:startDate] == NSOrderedDescending && [date compare:lastDate] == NSOrderedAscending) {
        return YES;
    }
    
    if ([date compare:startDate] == NSOrderedSame || [date compare:lastDate] == NSOrderedSame) {
        return YES;
    }
    
    return NO;
}


#pragma mark Date In Month
/**
 引数で渡された日付の月初の日を取得する
 
 @param date 日付
 @return 月初の日付
 */
+ (NSDate *)firstDateInMonthFromDate:(NSDate *)date
{
    if (!calendar) {
        calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                                   fromDate:date];
    
    dateComponents.day = 1;
    
    return [calendar dateFromComponents:dateComponents];
}


+ (NSDate *)lastDateInMonthFromDate:(NSDate *)date
{
    if (!calendar) {
        calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                                   fromDate:date];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSInteger lastDay =  range.length;
    
    dateComponents.day = lastDay;
    
    return [calendar dateFromComponents:dateComponents];
}


#pragma mark Create Date
/**
 Create New NSDate from argument date. That is argument days before(-) or after(+).
 
 @param date original date
 @param days nagative value -> before, positive value -> after
 @return created NSDate
 */
+ (NSDate *)createDate:(NSDate *)date differenceDays:(NSInteger)days
{
    if (!calendar) {
        calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                                   fromDate:date];
    
    dateComponents.day += days;
    
    return [calendar dateFromComponents:dateComponents];
}


/**
 Create New NSDate from argument date. That is argument months before(-) or after(+).
 
 @param date original date
 @param months nagative value -> before, positive value -> after
 @return created NSDate
 */
+ (NSDate *)createDate:(NSDate *)date differenceMonths:(NSInteger)months
{
    if (!calendar) {
        calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                                   fromDate:date];
    
    dateComponents.month += months;
    
    return [calendar dateFromComponents:dateComponents];
}


#pragma mark Adjust Clock
/**
 Argument date's time information change into 12AM.
 
 @param date original date
 @return 12AM date
 */
+ (NSDate *)adjustZeroClock:(NSDate *)date
{
    if (!calendar) {
        calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:date];
    
    return [calendar dateFromComponents:components];
}


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
                   isCountStartDate:(BOOL)isCountStartDate
{
    if (!startDate || !lastDate) {
        return 0;
    }
    
    if (!calendar) {
        calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                               fromDate:startDate
                                                 toDate:lastDate
                                                options:0];
    NSInteger daysCount = components.day;
    return (isCountStartDate)?daysCount + 1 : daysCount;
}


#pragma mark Equal
/**
 指定した日付と同日かを判定します。
 
 @param date1 判定対象の日付
 @param date2 判定対象の日付
 
 @return 判定結果
 */
+ (BOOL)isEqualToDay1:(NSDate *)date1
                 day2:(NSDate *)date2
{
    if (!date1 && !date2) return NO;
    
    date1 = [self adjustZeroClock:date1];
    date2 = [self adjustZeroClock:date2];
    
    return ([date1 compare:date2] == NSOrderedSame)? YES : NO;
}




#pragma mark Convert
/**
 文字列から日付型へ変換して返します。
 
 @param string 変換前文字列
 @param format 変換フォーマット
 
 @return 変換後の日付型
 */
+ (NSDate *)dateFormatWithString:(NSString *)string
                          format:(NSString *)format
{
    if (!string || [string length] == 0) return nil;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    
    dateFormatter.dateFormat = format;
    
    return [dateFormatter dateFromString:string];
}


/**
 変換フォーマットの文字列に変換して返します。
 
 @param format 変換フォーマット
 
 @return 変換後の文字列
 */
+ (NSString *)stringFromDate:(NSDate *)date
                      format:(NSString *)format
{
    if (!date) return @"";
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:date];
}


/**
 曜日テキストをDateから取得する

 @param date Date
 @return 曜日テキスト
 */
+ (NSString *)weekStringFromDate:(NSDate *)date
                localeIdentifier:(NSString *)localeIdentifier;
{
    if (!calendar) {
        calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    NSDateComponents* components = [calendar components:NSCalendarUnitWeekday
                                          fromDate:date];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    
    return dateFormatter.shortWeekdaySymbols[components.weekday-1];
}




@end
