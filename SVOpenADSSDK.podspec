Pod::Spec.new do |s|
  s.name             = 'SVOpenADSSDK'
  s.version          = '5.7.2'
  s.summary          = 'SV Open Ads SDK binary distribution.'
  s.description      = 'Precompiled SV Open Ads SDK. The implementation source is not distributed.'
  s.homepage         = 'https://github.com/iOSorPython/SVOpenADSSDK'
  s.license          = { :type => 'Proprietary', :text => 'Copyright (c) SVOpenADSSDK.' }
  s.author           = { 'iOSorPython' => 'forpenta@163.com' }
  s.source           = { :git => 'https://github.com/iOSorPython/SVOpenADSSDK.git', :tag => s.version.to_s }
  s.platform         = :ios, '13.0'
  s.static_framework = true
  s.vendored_frameworks = 'SVOpenADSSDK/Distribution/SVOpenADSSDK.xcframework'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 x86_64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 x86_64' }
  s.frameworks = 'Foundation', 'UIKit', 'MobileCoreServices', 'CoreGraphics', 'Security', 'SystemConfiguration', 'CoreTelephony', 'AdSupport', 'StoreKit', 'AVFoundation', 'MediaPlayer', 'WebKit', 'CoreLocation'
  s.libraries = 'z', 'resolv.9', 'sqlite3', 'c++', 'c++abi'
  s.dependency 'ToBid-iOS-RC/GDTAdapter', '5.7.2'
  s.dependency 'ToBid-iOS-RC/BaiduAdapter', '5.7.2'
  s.dependency 'ToBid-iOS-RC/KSAdapter', '5.7.2'
  s.dependency 'ToBid-iOS-RC/CSJAdapter', '5.7.2'
  s.dependency 'ToBid-iOS-RC/GromoreAdapter', '5.7.2'
end
