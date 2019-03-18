//
//  Rsa.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/16.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

/// RSA can perform RSA-PKCS1 encryption, RSA-OAEP encryption, and create RSA-PKCSv1.5 signature

open class Rsa: AlgorithmIdentifiable {
    public var identifier: Algorithm = .rsa
    
    /// RSA key size.
    public enum KeySize: Int {
        case In512Bits = 512
        case In1024Bits = 1024
        case In2048Bits = 2048
        case In4096Bits = 4096
    }
    
    /// RSA padding.
    public enum Padding: UInt32 {
        
        /// Raw RSA encryption. This mode should only be used to implement cryptographically sound padding modes in the application code. Encrypting user data directly with RSA is insecure.
        case no = 1000
        
        /// PKCS #1 v1.5 padding. This currently is the most widely used mode.
        case pkcs1
        
        /// EME-OAEP as defined in PKCS #1 v2.0 with SHA-1, MGF1 and an empty encoding parameter. This mode is recommended for all new applications.
        case oaep
   
        case pkcs1Raw = 1004
        
        case pss
    }
    
    public init() throws {
        cryptor = try RSACryptor()
    }
    
    let cryptor: RSACryptor
    
}

public extension Rsa {
    
    /// Generate RSA key pair.
    /// Thay will be stored in keychain with storeTag.
    /// - important:
    /// If the storeTag is not provied, each keys will be stored at a shared default place in keychain.
    func generate(size: KeySize, storeTag: String?) throws -> (PublicKey<Rsa>, PrivateKey<Rsa>) {
        var privateKeyRef: CCRSACryptorRef? = nil
        var publicKeyRef: CCRSACryptorRef? = nil
        var status = cryptor.generatePair!(
            size.rawValue,
            65537,
            &publicKeyRef,
            &privateKeyRef)
        guard status == noErr else {
            throw CCError.code(status)
        }
        
        defer {
            status = cryptor.release!(privateKeyRef!)
            status = cryptor.release!(publicKeyRef!)
        }
        
        // export public key
        
        var publicKeyLength = size.rawValue
        var publicKey = Data(count: publicKeyLength)
        
        status = publicKey.withUnsafeMutableBytes {
            (keyBytes: UnsafeMutablePointer<UInt8>) -> CCCryptorStatus in
            return cryptor.export!(publicKeyRef!, keyBytes, &publicKeyLength)
        }
        
        guard status == noErr else {
            throw CCError.code(status)
        }
        
        publicKey.count = publicKeyLength
        
        // export private key
        
        var privateKeyLength = size.rawValue
        var privateKey = Data(count: privateKeyLength)
        
        status = privateKey.withUnsafeMutableBytes {
            (keyBytes: UnsafeMutablePointer<UInt8>) -> CCCryptorStatus in
            return cryptor.export!(privateKeyRef!, keyBytes, &privateKeyLength)
        }
        
        guard status == noErr else {
            throw CCError.code(status)
        }
        
        privateKey.count = privateKeyLength
        
        let pub = PublicKey(self, storeTag: storeTag)
        let priv = PrivateKey(self, storeTag: storeTag)

        status = pub.storeData(publicKey, tag: pub.storeTag, parameters: pub.storeParam)
        guard status == noErr else {
            throw KeychainError.code(status)
        }
        status = priv.storeData(privateKey, tag: priv.storeTag, parameters: priv.storeParam)
        guard status == noErr else {
            throw KeychainError.code(status)
        }
        return (pub, priv)
    }
    
    /// Import RSA public Key and prepare a Publickey object.
    /// X.509 or PKCS1 format is recommended.
    /// It will be stored in keychain with storeTag.
    /// - important:
    /// If the storeTag is not provied, the key will be stored at a shared default place in keychain.
    func importPublicKey(DER data: Data, storeTag: String?) throws -> PublicKey<Rsa> {
        let PKCS1Data = try extractPKCS1Data(from: data)
        let p = PublicKey(self, storeTag: storeTag)
        let status = p.storeData(PKCS1Data, tag: p.storeTag, parameters: p.storeParam)
        guard status == noErr else {
            throw KeychainError.code(status)
        }
        return p
    }
    
    /// Import RSA private Key and prepare a PrivateKey object.
    /// X.509 or PKCS1 format is recommended.
    /// It will be stored in keychain with storeTag.
    /// - important:
    /// If the storeTag is not provied, the key will be stored at a shared default place in keychain.
    func importPrivateKey(DER data: Data, storeTag: String?) throws -> PrivateKey<Rsa> {
        let PKCS1Data = try extractPKCS1Data(from: data)
        let p = PrivateKey(self, storeTag: storeTag)
        let status = p.storeData(PKCS1Data, tag: p.storeTag, parameters: p.storeParam)
        guard status == noErr else {
            throw KeychainError.code(status)
        }
        return p
    }
    
    /// Locate a public key from keychain.
    func locatePublicKey(storeTag: String) throws -> PublicKey<Rsa> {
        let key = PublicKey(self, storeTag: storeTag)
        var keyData = Data()
        let osStatus = key.locateData(tag: key.storeTag, parameters: key.storeParam, output: &keyData)
        guard osStatus == noErr else {
            throw KeychainError.code(osStatus)
        }
        return key
    }
    
    /// Locate a private key from keychain.
    func locatePrivateKey(storeTag: String) throws -> PrivateKey<Rsa> {
        let key = PrivateKey(self, storeTag: storeTag)
        var keyData = Data()
        let osStatus = key.locateData(tag: key.storeTag, parameters: key.storeParam, output: &keyData)
        guard osStatus == noErr else {
            throw KeychainError.code(osStatus)
        }
        return key
    }
    
    //MARK: Privates
    private func isPKCS1Format(key: Data) -> Bool {
        var keyRef: CCRSACryptorRef? = nil
        var status = cryptor.`import`!(
            (key as NSData).bytes,
            key.count,
            &keyRef)
        defer {
            if let ref = keyRef {
                status = cryptor.release!(ref)
            }
        }
        return status == noErr
    }
    
    private func extractPKCS1Data(from data: Data) throws -> Data {
        guard let PKCS1Data = ASN1(type: 0x30, arbitraryData: data)?.last?.data else {
            throw CCError.nonPKCS1Format
        }
        guard isPKCS1Format(key: PKCS1Data) else {
            throw CCError.nonPKCS1Format
        }
        return PKCS1Data
    }
}
