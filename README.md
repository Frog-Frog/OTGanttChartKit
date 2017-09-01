![Logo](https://user-images.githubusercontent.com/20692907/29910168-cec649e6-8e63-11e7-85bb-c197bb1dc3c1.png)

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

### CocoaPods  
Add this to your Podfile.

```PodFile
pod 'OTGanttChartKit'
```

### Carthage  
Add this to your Cartfile.

```Cartfile
github "PKPK-Carnage/OTGanttChartKit"
```

## Help

If you want to support this framework, you can do these things.

* Please let us know if you have any requests for me.

	I will do my best to live up to your expectations.

* You can make contribute code, issues and pull requests.
	
	I promise to confirm them.

## Licence

[MIT](https://github.com/PKPK-Carnage/OTGanttChartKit/blob/master/LICENSE)

## Author

[PKPK-Carnage🦎](https://github.com/PKPK-Carnage)
