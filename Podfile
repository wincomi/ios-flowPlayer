platform :ios, '10.0'

target 'flowPlayer' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'R.swift'

  pod 'InAppSettingsKit'
  pod 'DZNEmptyDataSet'
  pod 'StatusAlert'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
          end
      end
  end
end
