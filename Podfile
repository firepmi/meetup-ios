# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'meetup' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
pod 'Fabric'
pod 'Crashlytics'
#pod 'TPKeyboardAvoiding'
pod 'RangeSeekSlider'
pod 'IQKeyboardManager'
pod 'AETextFieldValidator'          #for textfield validations
pod 'SDWebImage'                    #for Web Images

#pod for verticalSwipe
pod 'VerticalCardSwiper', '1.0.0'

#facebook
#pod 'FacebookCore'
#pod 'FacebookLogin'
#pod 'FacebookShare'
  pod 'FBSDKLoginKit'
  
#Cosmo for Rating
pod 'Cosmos'

#For Chatting
pod 'MessageKit'
pod 'InputBarAccessoryView', '4.2.2'

#google Sign in
pod 'GoogleSignIn'

#API
pod 'Alamofire','4.8.2'
pod 'SwiftyJSON'

#GooglePlaces
#pod 'GooglePlaces'

#Inplace of GooglePlaces
pod 'LocationPickerViewController'

#Firebase for database
pod 'Firebase/Core'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'Firebase/Auth'

  # Pods for meetup
pod 'PinterestLayout'
pod 'FSPagerView'
pod 'KMPlaceholderTextView'
pod 'ImageSlideshow/SDWebImage'
pod 'AKImageCropperView'

end

DEFAULT_SWIFT_VERSION = '5.3'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = DEFAULT_SWIFT_VERSION
    end
  end
end
