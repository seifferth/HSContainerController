#
# Be sure to run `pod lib lint TestLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HSContainerController'
  s.version          = File.read('VERSION')
  s.summary          = 'Lightweight Swift Framework for iOS which let you replace UIViewController in UIContainerViews based on UIStoryboardSegues!'
  s.homepage         = 'https://github.com/tschob/HSContainerController.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hans Seiffert' => 'hans.seiffert@gmail.com' }

  s.source           = { :git => 'https://github.com/tschob/HSContainerController.git', :tag => s.version.to_s }

  s.platform              = :ios
  s.ios.deployment_target = '8.0'

  s.source_files = 'HSContainerController/**/*.{swift,h}'
  s.public_header_files = 'HSContainerController/**/*.h'
  
  s.frameworks = 'UIKit'
end
