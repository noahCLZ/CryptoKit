
Pod::Spec.new do |spec|

  spec.name         = "CryptoKit+"
  spec.version      = "1.0.3"
  spec.summary      = "A pragmatic crypto framework for iOS, watchOS, and tvOS."
  spec.description  = <<-DESC
CryptoKit is a wrapper of Apple's CommonCrypto library including the most used functionalities only.
                   DESC
  spec.homepage     = "https://github.com/noahCLZ/CryptoKit.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "noahCLZ" => "noah.cl.zhuang@gmail.com" }
  spec.ios.deployment_target = "9.0"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"
  spec.source       = { :git => "https://github.com/noahCLZ/CryptoKit.git", :tag => "#{spec.version}" }
  spec.source_files  = "Source/**/*.{swift,h,m}"
  spec.frameworks = "Foundation"
  spec.swift_version = "4.2"
end
