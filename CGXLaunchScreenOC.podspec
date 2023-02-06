Pod::Spec.new do |s|
s.name        = "CGXLaunchScreenOC"  
s.version     = "0.1"     
s.summary     = "CGXLaunchScreenOC是集成开屏广告库" 
s.description = "CGXLaunchScreenOC封装的热门开屏广告"  
s.homepage    = "https://github.com/974794055/CGXLaunchScreenOC"   
s.license     = {:type => "MIT", :file => "LICENSE"}  
s.author      = {"974794055" => "974794055@qq.com"} 
s.platform    = :ios, "9.0"               
s.source      = {:git => "https://github.com/974794055/CGXLaunchScreenOC.git", :tag => s.version}         
s.frameworks  = 'UIKit'
s.requires_arc = true 

s.source_files = 'CGXLaunchScreenOC/CGXLaunchScreenOC.h'

s.public_header_files = 'CGXLaunchScreenOC/CGXLaunchScreenOC.h'

s.dependency 'SDWebImage'

s.subspec 'AnimatedImage' do |ss|
    ss.source_files = 'CGXLaunchScreenOC/AnimatedImage/**/*.{h,m}'
end
s.subspec 'BaseView' do |ss|
    ss.source_files = 'CGXLaunchScreenOC/BaseView/**/*.{h,m}'
end


s.subspec 'LaunchScreen' do |ss|
    ss.source_files = 'CGXLaunchScreenOC/LaunchScreen/**/*.{h,m}'
    ss.dependency 'CGXLaunchScreenOC/BaseView'
    ss.dependency 'CGXLaunchScreenOC/AnimatedImage'
end

end




