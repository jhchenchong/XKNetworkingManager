Pod::Spec.new do |s|
s.name = 'XKNetworkingManager'
s.version = '1.0.1'
s.license = 'MIT'
s.summary = '基于RAC AFNetworking YYCache封装的自带缓存的网络请求'
s.homepage = 'https://github.com/jhchenchong/XKNetworkingManager.git'
s.authors = { '浪漫恋星空' => '727378500@qq.com' }
s.source = { :git => 'https://github.com/jhchenchong/XKNetworkingManager.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'XKNetworkingManager/XKNetworkingManager/*.{h,m}'
s.dependency "AFNetworking"
s.dependency "YYCache"
s.dependency "ReactiveObjC"
end
