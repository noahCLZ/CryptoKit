//
//  PublicKey+Rsa.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/16.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

public extension PublicKey where A: Rsa {
    
    /// Support RSA-PKCS1 encryption in condition of without using hash,
    /// otherwise, it is RSA-OAEP encryption.
    /**
     Support RSA-PKCS1 encryption in condition of without using hash,
     otherwise, it is RSA-OAEP encryption.
     
     - returns:
     Result of encryption.
     - parameters:
         - data: plain data.
         - hash: Hash function, of type Algorithm.Hash.
     */
    public func encrypt(_ data: Data, hash: Algorithm.Hash?) throws -> Data {
        
        // 0. locate public key
        
        let cryptor = self.algorithm.cryptor
        
        var keyData = Data()
        let osStatus = self.locateData(tag: self.storeTag, parameters: self.storeParam, output: &keyData)
        guard osStatus == noErr else {
            throw KeychainError.code(osStatus)
        }
        
        // 1. get CCRSACryptorRef
        
        var keyRef: CCRSACryptorRef? = nil
        var ccStatus = cryptor.`import`!(
            (keyData as NSData).bytes,
            keyData.count,
            &keyRef)
        guard ccStatus == noErr else {
            throw CCError.code(ccStatus)
        }
        
        // 2. Check key type
        
        let keyType = cryptor.getKeyType!(keyRef!)
        guard keyType == 0 else {
            throw CCError.incorrectKeyType
        } // 0 = public key, 1 = private key
        
        // 3. decide padding
        
        let padding = hash == nil ? A.Padding.pkcs1.rawValue : A.Padding.oaep.rawValue
        
        // 4. Operation
        
        var bufferSize = Int(cryptor.getKeySize!(keyRef!))
        var buffer = Data(count: bufferSize)

        ccStatus = buffer.withUnsafeMutableBytes { (bufferBytes: UnsafeMutablePointer<UInt8>) -> CCCryptorStatus in
            let resultBytes = bufferBytes
            return cryptor.encrypt!(
                keyRef!,
                padding,
                (data as NSData).bytes,
                data.count,
                resultBytes,
                &bufferSize,
                (Data() as NSData).bytes,
                0,
                hash?.rawValue ?? 0)
        }
        guard ccStatus == noErr else {
            throw CCError.code(ccStatus)
        }
        
        buffer.count = Int(bufferSize)
        return buffer
    }
    
    
    public func verify(signature: Data, with data: Data, hash: Algorithm.Hash, success: inout Bool) throws {
        
        success = false
        
        // 0. locate public key
        
        let cryptor = self.algorithm.cryptor
        var keyData = Data()
        let osStatus = self.locateData(tag: self.storeTag, parameters: self.storeParam, output: &keyData)
        guard osStatus == noErr else {
            throw KeychainError.code(osStatus)
        }
        
        // 1. get CCRSACryptorRef
        
        var keyRef: CCRSACryptorRef? = nil
        let ccStatus = cryptor.`import`!(
            (keyData as NSData).bytes,
            keyData.count,
            &keyRef)
        guard ccStatus == noErr else {
            throw CCError.code(ccStatus)
        }
        
        // 2. Check key type
        
        let keyType = cryptor.getKeyType!(keyRef!)
        guard keyType == 0 else {
            throw CCError.incorrectKeyType
        } // 0 = public key, 1 = private key
        
        // 3. Operation
        
        var digest: Data = try hash.digest(data)
        
        let status = cryptor.verify!(
            keyRef!,
            A.Padding.pkcs1.rawValue,
            (digest as NSData).bytes, digest.count,
            hash.rawValue,
            0 /*unused*/,
            (signature as NSData).bytes,
            signature.count)
        guard status == noErr else {
            throw CCError.code(status)
        }
        success = true
    }
}
