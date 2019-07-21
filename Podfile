# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Robotak' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  platform :ios, '11.0'

  pod 'PromiseKit', '~> 6.8'
  pod 'RxSwift', '~> 4'
  pod 'RxCocoa', '~> 4'
  pod 'RxViewController'
  pod 'SwiftLint'
  
  target 'RobotakTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
