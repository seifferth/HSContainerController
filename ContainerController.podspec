#
# Be sure to run `pod lib lint TestLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ContainerController'
  s.version          = File.read('VERSION')
  s.summary          = 'Lightweight Swift Framework for iOS which let you replace UIViewController in UIContainerViews based on UIStoryboardSegues!'
  s.homepage         = 'https://github.com/tschob/ContainerController.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hans Seiffert' => 'tschob@posteo.de' }

  s.source           = { :git => 'https://github.com/tschob/ContainerController.git', :tag => s.version.to_s }

  s.platform              = :ios
  s.ios.deployment_target = '9.0'
  s.swift_version         = '5.3'

  s.source_files = 'ContainerController/**/*.{swift,h}'
  s.public_header_files = 'ContainerController/**/*.h'
  
  s.frameworks = 'UIKit'
end
