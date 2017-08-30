![OTGanttChartKitLogo.png](https://qiita-image-store.s3.amazonaws.com/0/152335/6c29f494-1cf4-8928-cd35-9ea0387b484d.png "OTGanttChartKitLogo.png")

## Description
OTGanttChartKit is gantt chart framework for iOS. This framework use easily like UITableView.

OTGanttChartKit has color and size adjust functions.

You can show your original gantt chart.

## Demo
![OTGanttChartView](https://qiita-image-store.s3.amazonaws.com/0/152335/a5068008-bc00-fe8a-7859-15adc8bf4080.gif "OTGanttChartViewDemo.gif")

## Usage
```objectivec:Objective-C

#import <OTGanttChartKit/OTGanttChartKit.h>

OTGanttChartView *ganttChartView = [[OTGanttChartView alloc]initWithFrame:self.yourView.bounds];

ganttChartView.dataSource = self;
ganttChartView.delegate = self;

// If you want to make original gantt chart, you can customize here.

[self.yourView addSubView:ganttChartView];

```

## Install

**CocoaPods**  
Add this to your Podfile.

```PodFile
pod 'OTGanttChartKit'
```

**Carthage**  
Add this to your Cartfile.

```Cartfile
github "PKPK-Carnage/OTGanttChartKit"
```

## Licence

[MIT](https://github.com/PKPK-Carnage/OTGanttChartKit/blob/master/LICENSE)

## Author

[PKPK-Carnage](https://github.com/PKPK-Carnage)
