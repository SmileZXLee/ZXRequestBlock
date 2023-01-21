Pod::Spec.new do |s|
s.name         = 'ZXRequestBlock'
s.version      = '1.0.3'
s.summary      = '一句话实现iOS应用底层所有网络请求拦截，包含http-dns解决方法，有效防止DNS劫持，用于分析http，https请求，禁用/允许代理，防抓包，重定向等'
s.homepage     = 'https://github.com/SmileZXLee/ZXRequestBlock'
s.license      = 'MIT'
s.authors      = {'李兆祥' => '393727164@qq.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/SmileZXLee/ZXRequestBlock.git', :tag => s.version}
s.source_files = 'ZXRequestBlockDemo/ZXRequestBlockDemo/ZXRequestBlock/**/*'
s.requires_arc = true
end