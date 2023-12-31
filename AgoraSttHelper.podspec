#
# Be sure to run `pod lib lint AgoraSttHelper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AgoraSttHelper'
  s.version          = '0.1.2'
  s.summary          = 'AgoraSttHelper. For quick start using agora speech-to-text service.'
  s.swift_version         = '5.8'
  s.ios.deployment_target = '13.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Quick start lib for Agora speech to text service.
  
  Release Note
  ---
  * 0.1.2 (2023/07/31)
    - Addd **Query**
    - Other
  ---
  * 0.1.1 (2023/07/28)
    - First version
  DESC

  s.homepage         = 'https://github.com/DarkEggStudio/AgoraSttHelper_iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'darkzero' => 'darkzero_mk2@hotmail.com' }
  s.source           = { :git => 'https://github.com/DarkEggStudio/AgoraSttHelper_iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '13.0'

  s.source_files = 'AgoraSttHelper/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AgoraSttHelper' => ['AgoraSttHelper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Protobuf', '3.21.12'
  s.dependency 'PromiseKit'
  s.dependency 'Alamofire'
  s.dependency 'DarkEggKit', '~>1.0.0'
end
