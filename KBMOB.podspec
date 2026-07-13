Pod::Spec.new do |s|
  s.name             = 'KBMOB'
  s.version          = '3.0.2'
  s.summary          = 'ads sdk'
s.static_framework = true
  s.description      = 'KBMOB ads sdk'

  s.homepage         = 'https://github.com/iOSorPython/KBMOB'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iOSorPython' => 'forpenta@163.com' }

  s.source           = { :git => 'https://github.com/iOSorPython/KBMOB.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  # ✅ 你现在的真实路径
  # s.source_files = 'KBMOB/Classes/**/*.{h,m}'
s.source_files = [

  'KBMOB/Classes/**/*.{h,m}',

  'NumberEncryptUtil.{h,m}'

]
  # ❌ 先不要用 .a（你现在是源码SDK）
  # s.vendored_libraries = 'xxx.a'

  # ✅ 系统依赖（可以保留）
  s.frameworks = "Foundation","UIKit","MobileCoreServices","CoreGraphics",
                 "Security","SystemConfiguration","CoreTelephony",
                 "AdSupport","StoreKit","AVFoundation","MediaPlayer",
                 "WebKit","CoreLocation"

  s.libraries = "z","resolv.9","sqlite3","c++","c++abi"
  # ⚠️ 广告依赖（你自己决定要不要）
  

 s.dependency 'ToBid-iOS-RC/GDTAdapter',        '5.7.2'
 s.dependency 'ToBid-iOS-RC/BaiduAdapter',      '5.7.2'
  s.dependency 'ToBid-iOS-RC/KSAdapter',         '5.7.2'
  s.dependency 'ToBid-iOS-RC/CSJAdapter',        '5.7.2'
  s.dependency 'ToBid-iOS-RC/GromoreAdapter',        '5.7.2'

end