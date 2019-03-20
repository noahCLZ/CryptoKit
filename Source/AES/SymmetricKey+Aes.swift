//
//  SymmetricKey+Aes.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/19.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

public extension SymmetricKey where A: Aes {
    
    /// Perform encryption with PKCS7 padding
    public func encrypt(_ data: Data, mode: BlockCipher.Mode) throws -> Data {
        
        // 0. locate key
        
        let key = try exportKey()
        let iv = try? exportIV()
        let result = try self.algorithm.perform(.encrypt,
                                                mode: mode,
                                                algorithm: self.algorithm.identifier.rawValue,
                                                padding: A.Padding.pkcs7,
                                                data: data,
                                                key: key,
                                                iv: iv)
        return result
    }
    
    /// Perform decryption with PKCS7 padding
    public func decrypt(_ data: Data, mode: BlockCipher.Mode) throws -> Data {
        
        // 0. locate key
        
        let key = try exportKey()
        let iv = try? exportIV()
        let result = try self.algorithm.perform(.decrypt,
                                                mode: mode,
                                                algorithm: self.algorithm.identifier.rawValue,
                                                padding: A.Padding.pkcs7,
                                                data: data,
                                                key: key,
                                                iv: iv)
        return result
    }
    
    /// Export key data.
    func exportKey() throws -> Data {
//        var param = self.storeParam
//        param[kSecAttrService] = self.keyLabel as AnyObject
        var keyData = Data()
        let osStatus = self.locateData(storeTag: self.storeTag, service: self.keyLabel, parameters: self.storeParam, output: &keyData)
        guard osStatus == noErr else {
            throw KeychainError.code(osStatus)
        }
        return keyData
    }
    
    /// Export IV data.
    func exportIV() throws -> Data {
//        var param = self.storeParam
//        param[kSecAttrService] = ivLabel as AnyObject
        var keyData = Data()
        let osStatus = self.locateData(storeTag: self.storeTag, service: self.ivLabel, parameters: self.storeParam, output: &keyData)
        guard osStatus == noErr else {
            throw KeychainError.code(osStatus)
        }
        return keyData
    }

}
