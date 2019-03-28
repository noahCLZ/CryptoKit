//
//  Aes.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/19.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

open class Aes: BlockCipher, AlgorithmIdentifiable {
    public var identifier: Algorithm = .symmetric(.aes)
    
    /// AES key size.
    public enum KeySize: Int {
        case In16Bytes = 16
        case In24Bytes = 24
        case In32Bytes = 32
    }
    
    override open var blockSize: Int {
        return 16
    }
    
}

public extension Aes {
    
    /// Generate key with specific size, and length of 16 bytes IV.
    /// Thay will be stored in keychain with storeTag.
    /// - important:
    /// If the storeTag is not provied, each keys will be stored at a shared default place in keychain.
    func generate(size: KeySize, storeTag: String?) throws -> SymmetricKey<Aes> {
        
        let key = try self.secureRandom(UInt(size.rawValue))
        let iv = try self.secureRandom(UInt(self.blockSize))
        
        return try self.import(key: key, iv: iv, storeTag: storeTag)
    }
    
    func `import`(key: Data, iv: Data, storeTag: String?) throws -> SymmetricKey<Aes> {
        let KEY = SymmetricKey(algorithm: self, userStoreTag: storeTag)
        let IV = SymmetricKey(algorithm: self, userStoreTag: (storeTag ?? "") + "IV")
        
        var status = KEY.storeData(key)
        guard status == noErr else {
            throw KeychainError.code(status)
        }
        
        status = IV.storeData(iv)
        guard status == noErr else {
            throw KeychainError.code(status)
        }
        return KEY
    }
    
    func locateKey(storeTag: String) throws -> SymmetricKey<Aes> {
        let KEY = SymmetricKey(algorithm: self, userStoreTag: storeTag)
        let IV = SymmetricKey(algorithm: self, userStoreTag: storeTag + "IV")
        
        var keyData: Data = Data()
        var ivData: Data = Data()
        var status = KEY.locateData(output: &keyData)
        guard status == noErr else {
            throw KeychainError.code(status)
        }
        
        status = IV.locateData(output: &ivData)
        guard status == noErr else {
            throw KeychainError.code(status)
        }
        
        return try Aes().import(key: keyData, iv: ivData, storeTag: storeTag)
    }
}
