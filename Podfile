source 'https://github.com/CocoaPods/specs'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

platform :ios,'11.0'
use_frameworks!

target 'CyxbsMobile2019_iOS' do
	pod 'TZImagePickerController'
	pod 'YBImageBrowser', :inhibit_warnings => true
	pod 'NudeIn'
	pod 'SDWebImage'
	pod 'ProgressHUD'
	pod 'MJRefresh'
  
  pod 'UMCommon'
  pod 'UMDevice'
  pod 'UMVerify'
  pod 'UMCCommonLog',  :configurations => ['Debug']
  pod 'UMShare/Social/WeChat'
  pod 'UMShare/Social/QQ'
  
  pod 'JXBanner'
  pod 'JXSegmentedView'
  pod 'JXPagingView'
  pod 'JXPageControl'
  
  pod 'SwifterSwift/SwiftStdlib'
  pod 'SwifterSwift/Foundation'
  pod 'SwifterSwift/UIKit'
  
	pod 'IQKeyboardManager'
	pod 'Bugly'
	pod 'LookinServer', :configurations => ['Debug']
  
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'FluentDarkModeKit'
  
  pod 'RYTransitioningDelegateSwift'
  pod 'RYAngelWalker'

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['VALID_ARCHS'] = 'arm64 arm64e armv7 armv7s x86_64 i386'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      config.build_settings['HEADER_SEARCH_PATHS'] = '$(PROJECT_DIR)/**'
    end
  end
  
end
