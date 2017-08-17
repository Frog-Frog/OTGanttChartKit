#
#  Be sure to run `pod spec lint OTGanttChartKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "OTGanttChartKit"
  s.version      = "1.2"
  s.summary      = "OTGanttChartKit is gantt chart framework for iOS. This framework use easily like UITableView."
  s.homepage     = "https://github.com/PKPK-Carnage/OTGanttChartKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Tomosuke Okada" => "pkpkcarnage@gmail.com" }
  s.social_media_url   = "https://github.com/PKPK-Carnage"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/PKPK-Carnage/OTGanttChartKit.git", :tag => s.version  }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.resource_bundles = {
    'OTGanttChartKit' => ['Classes/*.xcassets','Classes/**/*.xib']
  }
  s.requires_arc = true

end
