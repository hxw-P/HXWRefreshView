
Pod::Spec.new do |s|


  s.name         = "HXWRefreshView"
  s.version      = "1.0.0"
  s.summary      = "swift 下拉刷新，上拉加载"
  s.homepage     = "https://github.com/hxw-P/HXWRefreshView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "华晓伟" => "1375166613@qq.com" } 
  s.source       = { :git => "https://github.com/hxw-P/HXWRefreshView.git", :tag => '1.0.0' }
  s.ios.deployment_target = '8.0'
  s.source_files  = "HXWRefreshSource/Classes/**/*"
  s.resources = "HXWRefreshSource/Assets/**/*"

end
