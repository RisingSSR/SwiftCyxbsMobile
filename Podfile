source 'https://github.com/CocoaPods/specs'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

platform :ios,'11.0'
use_frameworks!

inhibit_all_warnings!

def share_pods
  pod 'Alamofire'
  pod 'SwiftyJSON'
end

target 'CyxbsMobile2019_iOS' do
  share_pods
  
	# pod 'TZImagePickerController'
	# pod 'YBImageBrowser'
  # pod 'IQKeyboardManager'
	pod 'SDWebImage'
  pod 'MBProgressHUD'
	pod 'MJRefresh'
  
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
  pod 'TagListView'
  
  pod 'AlicloudHTTPDNS'
  pod 'AlicloudUtils'
  
  pod 'RYTransitioningDelegateSwift'
  pod 'RYAngelWalker'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['VALID_ARCHS'] = 'x86_64'
#      config.build_settings['VALID_ARCHS'] = 'arm64 arm64e armv7 armv7s x86_64 i386'
#      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      config.build_settings['HEADER_SEARCH_PATHS'] = '$(PROJECT_DIR)/**'
      config.build_settings['IOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
