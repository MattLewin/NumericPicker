#
# Be sure to run `pod lib lint NumericPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NumericPicker'
  s.version          = '0.1.0'
  s.summary          = 'iOS picker for easily selecting numbers by digit. (Swift 3)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
        NumericPicker is a drop-in iOS picker control written in Swift 3. It makes simplifies the creation of pickers that allow
        your users to specify numbers by digit. It automatically uses the proper grouping and decimal separator for the
        current (or specified) locale. You can easily dictate the number of integer and decimal places in the controller.
                       DESC

s.homepage         = 'https://bitbucket.org/MLewin72/numericpicker'
#  s.homepage         = 'https://github.com/MattLewin/NumericPicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Matt Lewin' => 'matt@mogroups.com' }
s.source           = { :git => 'https://MLewin72@bitbucket.org/MLewin72/numericpicker.git', :tag => s.version.to_s }
#  s.source           = { :git => 'https://github.com/MattLewin/NumericPicker.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mlewin72'

  s.ios.deployment_target = '9.3'

  s.source_files = 'NumericPicker/Classes/**/*'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
  s.frameworks = 'UIKit'
end
