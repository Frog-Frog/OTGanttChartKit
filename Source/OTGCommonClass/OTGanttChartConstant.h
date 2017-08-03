//
//  OTGanttChartConstant.h
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

#import <UIKit/UIKit.h>

#ifndef OTGanttChartConstant_h
#define OTGanttChartConstant_h

/**
 チャート表示用の定数
 変更してもいい
 */
#pragma mark - ChartScroll
static const CGFloat OTGScrollReloadDistance = 100.0f;

#pragma mark - ChartLineWidth
/// チャート部分と日付表示部分の境界線の太さ
static const CGFloat OTGChartBorderWidth = 2.0f;

/// チャート全体の区切り線の太さ
static const CGFloat OTGChartSeparatorWidth = 1.0f;

/// 一日あたりの幅
static const CGFloat OTGDateWidth = 66.0f;

/// 高さの最小
static const CGFloat OTGMinimumSectionProcessAreaHeight = 0.0f;
static const CGFloat OTGMinimumSectionPointAreaHeight = 0.0f;
static const CGFloat OTGMinimumRowProcessAreaHeight = 50.0f;
static const CGFloat OTGMinimumRowPointAreaHeight = 50.0f;

static const CGFloat OTGProcessViewMargin = 5.0f;

static const CGFloat OTGProcessAreaTopMargin = 0.0f;
static const CGFloat OTGProcessAreaUnderMargin = 0.0f;
static const CGFloat OTGPointAreaTopMargin = 0.0f;
static const CGFloat OTGPointAreaUnderMargin = 0.0f;

static const CGFloat OTGTodayLineWidth = 2.0f;

static const CGFloat OTGTodayFigureSize = 8.0f;

#pragma mark - OTGDateView
static const CGFloat OTGDateViewHeight = 60.0f;

/// 日付表示のフォントサイズ
static const CGFloat OTGDateViewFontSize = 14.0f;

#pragma mark - ChartPartsSize
/// チャート内の文字列のフォントサイズ
static const CGFloat OTGChartFontSize = 12.0f;

#pragma mark - OTGChartProcessViewSize
/// OTGChartProcessView(複数日にまたがるデータ表示に使うView)の高さ
static const CGFloat OTGProcessHeight = 40.0f;

static const NSInteger OTGProcessViewMinimumWidthDays = 2;

/// OTGChartProcessViewの日数表示の線の太さ
static const CGFloat OTGProcessLineWidth = 4.0f;

/// OTGChartProcessVIewの非実行日点線の太さ
static const CGFloat OTGProcessDotLineWidth = 1.0f;

static const CGFloat OTGProcessDotBlankWidth = 5.0f;

static const CGFloat OTGProcessDotSolidLineWidth = 7.0f;

#pragma mark - OTGChartPointViewSize
/// OTGChartPointView(一日だけのデータ表示に使うView)のサイズ
static const CGFloat OTGPointHeight = 40.0f;

static const NSInteger OTGPointViewMinimumWidthDays = 2;

#pragma mark - Figure
/// 項目ごとの図形の大きさ
static const CGFloat OTGFigureSize = 12.0f;

/// 図形の外周の太さ
static const CGFloat OTGFigurePeripheryWidth = 2.0;

/// 図形の左右のマージン
static const CGFloat OTGFigureSideMargin = 4.0f;


/**
 内部で使用している定数なので変更しないこと
 */
#pragma mark - Don't Change!!!!
/**
 カラーテーマ

 - OTGThemeModeDark: ダークモード
 - OTGThemeModeBright: ブライトモード
 - OTGThemeModeCustom: カスタムモード
 */
typedef NS_ENUM(NSInteger, OTGThemeMode)
{
    OTGThemeModeDark,
    OTGThemeModeBright
};


/**
 パーツ区分

 - OTGPartsTypeSeparator: セパレーターと文字
 - OTGPartsTypeChartBackGround: チャート内背景
 - OTGPartsTypeCategoryBackGround: チャート外背景
 */
typedef NS_ENUM(NSInteger, OTGPartsType)
{
    OTGPartsTypeDateSeparator,
    OTGPartsTypeDotSeparator,
    OTGPartsTypeRowSeparator,
    OTGPartsTypeChartBorder,
    OTGPartsTypeDateAreaBackground,
    OTGPartsTypeProcessAreaBackground,
    OTGPartsTypePointAreaBackground,
    OTGPartsTypeScrollBackground,
    OTGPartsTypeTodayHighlitedBackground,
    OTGPartsTypeDateText,
    OTGPartsTypeTodayHighlitedDateText,
    OTGPartsTypeRefleshArrowImage,
    OTGPartsTypeTodayLineColor
};


typedef NS_ENUM(NSInteger, OTGFigureType)
{
    OTGFigureTypeNone,
    OTGFigureTypeCircle,
    OTGFigureTypeTriangle,
    OTGFigureTypeDiamond,
    OTGFigureTypeSquare,
};

#endif /* OTGanttChartConstant_h */
