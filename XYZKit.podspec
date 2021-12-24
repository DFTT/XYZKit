#
# Be sure to run `pod lib lint XYZKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XYZKit'
  s.version          = '0.2.0'
  s.summary          = 'A short description of XYZKit.'

  s.description      = <<-DESC
                      TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/DFTT'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'XYZ' => 'lidong@021.com' }
  s.source           = { :git => 'https://github.com/DFTT/XYZKit.git', :tag => s.version.to_s }


  s.ios.deployment_target = '9.0'
  s.swift_versions = ['5.0']
  s.frameworks     = 'Foundation', 'UIKit'

  # s.user_target_xcconfig =  {'OTHER_LDFLAGS' => ['-lObjC']}
  # s.pod_target_xcconfig  =  {'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}

  s.requires_arc = true
  s.default_subspecs = 'Core'



  #Core
  s.subspec 'Core' do |ss|
    ss.source_files = 'XYZKit/Classes/Core/**/*.swift'
  end

  #XYZEmptyBoard
  s.subspec 'XYZEmptyBoard' do |ss|
    ss.dependency 'XYZKit/Core'
    ss.source_files = 'XYZKit/Classes/XYZEmptyBoard/**/*.swift'
  end


  #XYZFloatDragView
  s.subspec 'XYZFloatDragView' do |ss|
    ss.dependency 'XYZKit/Core'
    ss.source_files = 'XYZKit/Classes/XYZFloatDragView/**/*.swift'
  end


  #XYZSMSCodeInputView
  s.subspec 'XYZSMSCodeInputView' do |ss|
    ss.dependency 'XYZKit/Core'
    ss.source_files = 'XYZKit/Classes/XYZSMSCodeInputView/**/*.swift'
  end


  #XYZBadgeView
  s.subspec 'XYZBadgeView' do |ss|
    ss.dependency 'XYZKit/Core'
    ss.source_files = 'XYZKit/Classes/XYZBadgeView/**/*.swift'
  end














  
  # s.resource_bundles = {
  #   'XYZKit' => ['XYZKit/Assets/*.png']
  # }
end
