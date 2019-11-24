Pod::Spec.new do |s|
  s.name             = "KanCentralizedViewsPlugin"
  s.version          = '2.0.0'
  s.summary          = "KanCentralizedViewsPlugin"
  s.description      = <<-DESC
                        KanCentralizedViewsPlugin container.
                       DESC
  s.homepage         = "https://github.com/applicaster-plugins/ZappGeneralPluginChromecast-iOS"
  s.license          = 'CMPS'
	s.author           = "Applicaster LTD."
  s.source           = { :git => "git@github.com:applicaster-plugins/KanCentralizedViewsPlugin-iOS.git", :tag => s.version.to_s }
  s.platform         = :ios, '10.0'
  s.requires_arc = true
  s.static_framework = true

  s.public_header_files = 'KanCentralizedViewsPlugin/**/*.h'
  s.source_files = 'KanCentralizedViewsPlugin/**/*.{h,m,swift}'

  s.resources = [
                "KanCentralizedViewsPlugin/**/*.xcassets",
                "KanCentralizedViewsPlugin/**/*.storyboard",
                "KanCentralizedViewsPlugin/**/*.xib",
                "KanCentralizedViewsPlugin/**/*.png"]

  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                  'ENABLE_BITCODE' => 'YES',
                  'SWIFT_VERSION' => '5.0'
                }

  s.dependency 'ZappPlugins'
  s.dependency 'ZappGeneralPluginsSDK'
  s.dependency 'google-cast-sdk-no-bluetooth', '= 4.4.4'
end
