//
//  PrivateKey+Rsa.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/18.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

public extension PrivateKey where A: Rsa {
    
    /**
     Support RSA-PKCS1 decryption in condition of without using hash,
     otherwise, it is RSA-OAEP decryption.
     
     - returns:
     Result of decryption.
     - parameters:
         - data: Cipher data.
         - hash: Hash function, of type Algorithm.Hash.
    */
    public func decrypt(_ data: Data, hash: Hash?) throws -> Data {
        
        // 0. locate private key
        
        let cryptor = self.algorithm.cryptor
        var keyData = Data()
        let osStatus = self.locateData(output: &keyData)
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
        guard keyType == 1 else {
            throw CCError.incorrectKeyType
        } // 0 = public key, 1 = private key
        
        // 3. decide padding
        
        let padding = hash == nil ? A.Padding.pkcs1.rawValue : A.Padding.oaep.rawValue
        
        // 4. Operation
        
        var bufferSize = Int(cryptor.getKeySize!(keyRef!))
        var buffer = Data(count: bufferSize)
        
        ccStatus = buffer.withUnsafeMutableBytes { (bufferBytes: UnsafeMutablePointer<UInt8>) -> CCCryptorStatus in
            let resultBytes = bufferBytes
            return cryptor.decrypt!(
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
    
    public func sign(_ data: Data, hash: Hash) throws -> Data {
        
        // 0. locate private key
        
        let cryptor = self.algorithm.cryptor
        var keyData = Data()
        let osStatus = self.locateData(output: &keyData)
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
        guard keyType == 1 else {
            throw CCError.incorrectKeyType
        } // 0 = public key, 1 = private key
        
        // 3. get key size
        
        let keySize = cryptor.getKeySize!(keyRef!)
        
        // 4. Operation
        
        var digest: Data = try hash.digest(data)
        
        var signedDataLength = Int(keySize)
        var signedData = Data(count: signedDataLength)
        let status = signedData.withUnsafeMutableBytes({
            (signedDataBytes: UnsafeMutablePointer<UInt8>) -> CCCryptorStatus in
            return cryptor.sign!(
                keyRef!,
                A.Padding.pkcs1.rawValue,
                (digest as NSData).bytes, digest.count,
                hash.rawValue,
                0 /*unused*/,
                signedDataBytes,
                &signedDataLength)
        })
        guard status == noErr else {
            throw CCError.code(status)
        }
        
        signedData.count = signedDataLength
        return signedData
    }
    
}
