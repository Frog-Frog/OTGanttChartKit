# OTGanttChartKit

OTGanttChartKit is gantt chart framework for iOS. This framework use easily like UITableView.

## Description

OTGanttChartKit has color and size adjust functions.
You can show your original gantt chart.

## Demo
To be prepared.
Coming soon...

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
To be prepared.
Coming soon...

## Licence

[MIT](https://github.com/PKPK-Carnage/OTGanttChartKit/blob/master/LICENSE)

## Author

[PKPK-Carnage](https://github.com/PKPK-Carnage)