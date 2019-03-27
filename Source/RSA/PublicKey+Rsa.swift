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
    func encrypt(_ data: Data, hash: Hash?) throws -> Data {
        
        // 0. locate public key
        
        let cryptor = self.algorithm.cryptor
        var keyData = try pkcs1DER()
        
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
    
    
    func verify(signature: Data, with data: Data, hash: Hash, success: inout Bool) throws {
        
        success = false
        
        // 0. locate public key
        
        let cryptor = self.algorithm.cryptor
        var keyData = try pkcs1DER()
        
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
    
    /// Export PKCS1 DER format public key.
    func pkcs1DER() throws -> Data {
        var keyData = Data()
        let osStatus = self.locateData(output: &keyData)
        guard osStatus == noErr else {
            throw KeychainError.code(osStatus)
        }
        return keyData
    }
    
    /// Export PKCS1 PEM format public key.
    func pkcs1PEM() throws -> String {
        let keyData = try pkcs1DER()
        let rsaPrefix = "-----BEGIN RSA PUBLIC KEY-----\n"
        let rsaSuffix = "\n-----END RSA PUBLIC KEY-----"
        return rsaPrefix + keyData.base64EncodedString() + rsaSuffix
    }
    
    /// Export X509(subject public key) DER format public key.
    func x509DER() throws -> Data {
        let keyData = try pkcs1DER()
        let bitstringSequence = ASN1.wrap(type: 0x03, followingData: keyData)
        let oidData = ASN1.rsaOID()
        let oidSequence = ASN1.wrap(type: 0x30, followingData: oidData)
        let X509Sequence = ASN1.wrap(type: 0x30, followingData: oidSequence + bitstringSequence)
        return X509Sequence
    }
    
    /// Export X509(subject public key) PEM format public key.
    func x509PEM() throws -> String {
        let keyData = try x509DER()
        let publicKeyPrefix = "-----BEGIN PUBLIC KEY-----\n"
        let publicKeySuffix = "\n-----END PUBLIC KEY-----"
        return publicKeyPrefix + keyData.base64EncodedString() + publicKeySuffix
    }
}
