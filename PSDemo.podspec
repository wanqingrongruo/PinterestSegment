Pod::Spec.new do |s|
  s.name         = "PSDemo"
  s.version      = "0.0.1"
  s.summary      = "Have a try about pod support."

  s.homepage     = "http://www.baidu.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "roni" => "https://github.com/wanqingrongruo" }
  s.source       = { :git => "https://github.com/wanqingrongruo/PinterestSegment"}

  # 最低支持版本
  s.ios.deployment_target = '10.0'

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