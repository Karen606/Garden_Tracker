# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

target 'Garden_Tracker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Garden_Tracker
  pod 'DropDown'
  pod 'FirebaseAnalytics'
  pod 'Firebase/RemoteConfig'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
end