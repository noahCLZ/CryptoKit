# CryptoKit

[![Build Status](https://travis-ci.org/noahCLZ/CryptoKit.svg?branch=master)](https://travis-ci.org/noahCLZ/CryptoKit) 
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20tvOS%20%7C%20watchOS-informational.svg) 
![pod](https://img.shields.io/cocoapods/v/CryptoKit+.svg) 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

CryptoKit is a wrapper of Apple's CommonCrypto library including the most used functionalities only.

## Features
- SHA
- RSA
- AES
- Importing keys
- Exporting keys
- Keychain integration

## Requirements
- iOS 9.0+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 10.1+
- Swift 4.2+

## Installation

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate CryptoKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'CryptoKit+', '~> 1.0'
end
```

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate CryptoKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "noahCLZ/CryptoKit" ~> 1.0
```

## Usage
- SHA - [Message digest](https://github.com/noahCLZ/CryptoKit/blob/master/Docs/Usage.md#message-digest)
- RSA - [Key generation](https://github.com/noahCLZ/CryptoKit/blob/master/Docs/Usage.md#rsa---key-generation), [Encryption](https://github.com/noahCLZ/CryptoKit/blob/master/Docs/Usage.md#rsa---encryption), [Decryption](https://github.com/noahCLZ/CryptoKit/blob/master/Docs/Usage.md#rsa---decryption), [Signing](https://github.com/noahCLZ/CryptoKit/blob/master/Docs/Usage.md#rsa---signing), [Verifying](https://github.com/noahCLZ/CryptoKit/blob/master/Docs/Usage.md#rsa---verifying), [Importing key](https://github.com/noahCLZ/CryptoKit/blob/master/Docs/Usage.md#rsa---importing-key)
- AES - [Key generation](https://github.com/noahCLZ/CryptoKit/blob/master/Docs/Usage.md#aes---key-generation), [Encryption](https://github.com/noahCLZ/CryptoKit/blob/master/Docs/Usage.md#aes---encryption), [Decryption](https://github.com/noahCLZ/CryptoKit/blob/master/Docs/Usage.md#aes---decryption), [Importing key](https://github.com/noahCLZ/CryptoKit/blob/master/Docs/Usage.md#aes---importing-key)

## License

CryptoKit is licensed under the MIT license. [See LICENSE](https://github.com/noahCLZ/CryptoKit/blob/master/LICENSE) for details.
