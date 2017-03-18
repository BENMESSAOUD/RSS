source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'News' do
   pod 'SwiftyXMLParser', :git => 'https://github.com/yahoojapan/SwiftyXMLParser.git'
   pod 'Kingfisher', :git => "https://github.com/onevcat/Kingfisher.git", :branch => 'master'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
