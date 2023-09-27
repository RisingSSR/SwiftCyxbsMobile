source 'https://github.com/CocoaPods/specs'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

platform :ios, '13.0'
use_frameworks!

inhibit_all_warnings!

pod 'Alamofire'
pod 'SwiftyJSON'

target 'CyxbsMobile2019_iOS' do
  
	# pod 'TZImagePickerController'
	# pod 'YBImageBrowser'
  # pod 'IQKeyboardManager'
	pod 'SDWebImage'
  pod 'ProgressHUD'
	pod 'MJRefresh'
  pod 'MarkdownKit'
  pod 'TagListView'
  
  pod 'UMCommon'
  pod 'UMDevice'
  pod 'UMVerify'
  pod 'UMCCommonLog',           :configurations => ['Debug']
  pod 'UMShare/Social/WeChat'
  pod 'UMShare/Social/QQ'
  
  pod 'JXBanner'
  pod 'JXSegmentedView'
  pod 'JXPagingView'
  pod 'JXPageControl'
  
  # pod 'SwifterSwift/SwiftStdlib'
  # pod 'SwifterSwift/Foundation'
  # pod 'SwifterSwift/UIKit'
  
	pod 'Bugly'
	pod 'LookinServer',           :configurations => ['Debug']
  
  pod 'AlicloudHTTPDNS'
  pod 'AlicloudUtils'
  
  pod 'RYTransitioningDelegateSwift'
  pod 'RYAngelWalker'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "target #{target}"
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['HEADER_SEARCH_PATHS'] = '$(PROJECT_DIR)/**'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      
      if target == 'Pods-CyxbsMobile2019_iOS'
        config.build_settings['VALID_ARCHS'] = 'x86_64'
      end
    end
  end
end
