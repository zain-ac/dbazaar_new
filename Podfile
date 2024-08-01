# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Bazaar Ghar' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Bazaar Ghar

pod 'SwiftLog'
    pod 'SwiftHSVColorPicker'
    pod 'Intercom', '10.4.0'
    pod 'DropDown', '2.3.13'
   # pod 'SDWebImage', '5.0'
#    pod 'CircleColorPicker', '~> 1.0.0'
    pod 'IQKeyboardManagerSwift', '6.5.0'
    pod 'Moya', '~> 13.0'
    pod 'JGProgressHUD'
    pod 'R.swift'
    # For gif images
    pod 'SwiftyGif'
    # For drop down menu
#    pod 'DropDown'
    pod 'GoogleMaps', '5.2.0'
    pod 'TagListView', '~> 1.0'
    pod 'Presentr'
    pod 'GooglePlaces', '7.1.0'
    pod 'Cosmos'
    pod 'FirebaseCore'
    pod 'FirebaseFirestore'
    pod 'GoogleSignIn'
    pod 'Toast-Swift'
    pod 'Socket.IO-Client-Swift'
    pod 'Starscream', '4.0.4'
pod 'WCCircularFloatingActionMenu'
    pod 'FirebaseAuth'
#    pod 'SignalRSwift', '~> 2.0.2'
    pod 'SwiftyJSON'
    pod 'SwiftSignalRClient', '0.9.0'
    pod 'Charts', '4.1.0'
pod 'Alamofire'
pod 'AZTabBar'
pod 'Kingfisher', '~> 7.0'
pod 'OTPFieldView'
pod 'SwiftFlags'
pod 'UBottomSheet'
pod 'TwilioVideo'
pod 'Firebase/Messaging'
  pod 'FSPagerView'
  pod 'RangeSeekSlider'
 
  pod 'SideMenu'
pod 'lottie-ios'
pod 'Frames', '4.3.6'




  target 'Bazaar GharTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Bazaar GharUITests' do
    # Pods for testing
  end


end
post_install do |pi|
 pi.pods_project.targets.each do |t|
  t.build_configurations.each do |config|
   config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
  end
 end
end
