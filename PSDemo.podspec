Pod::Spec.new do |s|
  s.name         = "PSDemo"
  s.version      = "0.0.1"
  s.summary      = "PinterestSegment"

  s.homepage     = "https://github.com/wanqingrongruo"
  s.license      = { :type => 'MIT'}
  s.author       = { "roni" => "https://github.com/wanqingrongruo" }
  s.source       = { :git => "https://github.com/TBXark/PinterestSegment.git"}
  s.desription   = "PinterestSegment"

  # 最低支持版本
  s.platform     = :ios, "10.0"

  # 源文件
  s.source_files = 'PinterestSegment/*.{swift}'

  # bundle资源文件
  # s.resources = 'Assets'

  # public头文件
  s.public_header_files = 'PinterestSegment'

  # 是否开启ARC模式
  s.requires_arc = true

  # 系统依赖框架
  s.frameworks = 'Foundation', 'UIKit'

  # 第三方依赖库
  #s.dependency 'AFNetworking', '~> 2.6'

  # 静态库.a或.framework
  # s.vendored_libraries = 'lib/Mipush.a'

  # xcconfig配置
  #s.xcconfig     = {'OTHER_LDFLAGS' => '-ObjC'}
end