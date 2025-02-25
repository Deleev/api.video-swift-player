Pod::Spec.new do |s|
  s.name             = 'ApiVideoPlayer'
  s.version          = '1.0.10'
  s.summary          = 'The official Swift player for api.video'

  s.homepage         = 'https://github.com/Deleev/api.video-swift-player'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Ecosystem' => 'ecosystem@api.video' }
  s.source           = { :git => 'https://github.com/Deleev/api.video-swift-player.git', :tag => "v" + s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/**/*.{swift, plist}'
  s.resources = 'Sources/**/*.{storyboard,xib,xcassets,json,png}'

  s.dependency "ApiVideoPlayerAnalytics", "2.0.0"
end
