# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!
install! 'cocoapods', :deterministic_uuids => false

source 'git@github.com:applicaster/CocoaPods-Private.git'
source 'git@github.com:applicaster/CocoaPods.git'
source 'https://cdn.cocoapods.org/'

pre_install do |installer|
    # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end
 
def shared_pods
  pod 'ZappPlugins'
  pod 'google-cast-sdk-no-bluetooth', '= 4.5.0'
  pod 'ZappGeneralPluginsSDK'
end
 
target 'KanCentralizedViewsPlugin' do
  shared_pods
  target 'KanCentralizedViewsPluginTests' do
    # Pods for testing
  end
end
