# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!
install! 'cocoapods', :deterministic_uuids => false

source 'git@github.com:CocoaPods/Specs.git'
source 'git@github.com:applicaster/CocoaPods-Private.git'
source 'git@github.com:applicaster/CocoaPods.git'

pre_install do |installer|
    # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end

def shared_pods
  pod 'ZappPlugins'
  #pod 'ZappGeneralPluginsSDK'
  #pod 'ZappRootPluginsSDK'
#  pod 'ApplicasterSDK', :path => 'Submodules/ApplicasterSDK/ApplicasterSDK-Dev.podspec'
 # pod 'google-cast-sdk', '= 4.3.3'
end

target 'KanCentralizedViewsPlugin' do
  shared_pods
  target 'KanCentralizedViewsPluginTests' do
    # Pods for testing
  end
end
