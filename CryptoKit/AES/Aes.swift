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
        let k = SymmetricKey(self, storeTag: storeTag)
        
        let param = k.storeParam
        
        var status = k.storeData(key, tag: k.storeTag, service: k.keyLabel, parameters: param)
        guard status == noErr else {
            throw KeychainError.code(status)
        }
        
        status = k.storeData(iv, tag: k.storeTag, service: k.ivLabel, parameters: param)
        guard status == noErr else {
            throw KeychainError.code(status)
        }
        return k
    }
}
