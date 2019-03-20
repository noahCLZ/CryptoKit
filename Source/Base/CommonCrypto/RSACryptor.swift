//
//  RSACryptor.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/18.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation


//MARK: Typealias
typealias CCRSACryptorRef = UnsafeRawPointer
typealias CCRSAKeyType = UInt32
typealias CCAsymmetricPadding = UInt32

class RSACryptor: CommonCrypto {
    
    /**
     Generate an RSA public and private key.
     - returns:
     Possible error returns are kCCParamError and kCCMemoryFailure.
     - parameters:
         - keysize:     The Key size in bits. RSA keys smaller than 2048 bits are insecure and should not be used.
         - e:           The "e" value (public key). Must be odd; 65537 or larger
         - publicKey:    A (required) pointer for the returned public CCRSACryptorRef.
         - privateKey:    A (required) pointer for the returned private CCRSACryptorRef.
     */
    typealias CCRSACryptorGeneratePair = @convention(c)(
        _ keysize: Int,
        _ e: UInt32,
        _ publicKey: UnsafeMutablePointer<CCRSACryptorRef?>,
        _ privateKey: UnsafeMutablePointer<CCRSACryptorRef?>) -> CCCryptorStatus
    
    /**
     Create an RSA public key from a full private key.
     - returns:
     returns either a valid public key CCRSACryptorRef or NULL.
     - parameters:
        - privateKey:    A (required) pointer for the returned private CCRSACryptorRef.
     */
    typealias CCRSACryptorGetPublicKeyFromPrivateKey = @convention(c)(
        _ privateKey: CCRSACryptorRef) -> CCRSACryptorRef
    
    /**
     Import an RSA key from data. This imports public or private
     keys in PKCS#1 format.
     
     - returns:
     Possible error returns are kCCParamError and kCCMemoryFailure.
     
     - parameters:
         - keyPackage:     The data package containing the encoded key.
         - keyPackageLen:  The length of the encoded key package.
         - key:    A CCRSACryptorRef of the decoded key.
     */
    typealias CCRSACryptorImport = @convention(c)(
        _ keyPackage: UnsafeRawPointer,
        _ keyPackageLen: Int,
        _ key: UnsafeMutablePointer<CCRSACryptorRef?>) -> CCCryptorStatus
    
    /**
     Import an RSA key from data. This exports public or private
     keys in PKCS#1 format.
     
     - returns:
     Possible error returns are kCCParamError and kCCMemoryFailure.
     
     - parameters:
         - key:     The CCRSACryptorRef of the key to encode.
         - out:  The data package in which to put the encoded key.
         - outLen:    A pointer to the length of the encoded key package.  This is an in/out parameter.
     */
    typealias CCRSACryptorExport = @convention(c)(
        _ key: CCRSACryptorRef,
        _ out: UnsafeMutableRawPointer,
        _ outLen: UnsafeMutablePointer<Int>) -> CCCryptorStatus
    
    /**
     Determine whether a CCRSACryptorRef is public or private.
     
     - returns:
     Return values are ccRSAKeyPublic, ccRSAKeyPrivate, or ccRSABadKey.
     
     - parameters:
        - key:     The CCRSACryptorRef.
     */
    typealias CCRSAGetKeyType = @convention(c)(
        _ key: CCRSACryptorRef) -> CCRSAKeyType
    
    /**
     Return the key size.
     
     - returns:
     Returns the keysize in bits or kCCParamError.
     
     - parameters:
        - key:     The CCRSACryptorRef.
     */
    typealias CCRSAGetKeySize = @convention(c)(
        _ key: CCRSACryptorRef) -> Int32
    
    /**
     Clear and release a CCRSACryptorRef.
     
     - parameters:
        - key:     The CCRSACryptorRef of the key to release.
     */
    typealias CCRSACryptorRelease = @convention(c)(
        _ key: CCRSACryptorRef) -> Int32
    
    /**
     Compute a signature for data with an RSA private key.
     
     - returns:
     Possible error returns are kCCParamError and kCCMemoryFailure.
     
     - parameters:
         - privateKey:        A pointer to a private CCRSACryptorRef.
     
         - padding:            A selector for the padding to be used.
     
         - hashToSign:        A pointer to the bytes of the value to be signed.
     
         - hashSignLen:        Length of data to be signed.
     
         - digestType:        The digest algorithm to use (See CommonDigestSPI.h).
     
         - saltLen:            Length of salt to use for the signature.
     
         - signedData:        The signature bytes.
     
         - signedDataLen:    A pointer to the length of signature material.
         This is an in/out parameter value.
     */
    typealias CCRSACryptorSign = @convention(c)(
        _ privateKey: CCRSACryptorRef,
        _ padding: CCAsymmetricPadding,
        _ hashToSign: UnsafeRawPointer,
        _ hashSignLen: Int,
        _ digestType: CCDigestAlgorithm,
        _ saltLen: Int,
        _ signedData: UnsafeMutableRawPointer,
        _ signedDataLen: UnsafeMutablePointer<Int>) -> CCCryptorStatus
    
    /**
     Verify a signature for data with an RSA private key.
     
     - returns:
     returns kCCSuccess if successful, kCCDecodeError if verification fails and kCCParamError if input parameters are incorrect.
     
     - parameters:
         - publicKey:        A pointer to a public CCRSACryptorRef.
     
         - padding:            A selector for the padding to be used.
     
         - hash:            A pointer to the bytes of the hash of the data.
     
         - hashLen:            Length of hash.
     
         - digestType:        The digest algorithm to use (See CommonDigestSPI.h).
     
         - saltLen:            Length of salt to use for the signature.
     
         - signedData:        The bytes of the signature to be verified.
     
         - signedDataLen:    Length of data associated with the signature.
         This is an in/out parameter value.
     */
    typealias CCRSACryptorVerify = @convention(c)(
        _ publicKey: CCRSACryptorRef,
        _ padding: CCAsymmetricPadding,
        _ hash: UnsafeRawPointer,
        _ hashLen: Int,
        _ digestType: CCDigestAlgorithm,
        _ saltLen: Int,
        _ signedData: UnsafeRawPointer,
        _ signedDataLen: Int) -> CCCryptorStatus
    
    /**
     Encrypt data with an RSA public key.
     
     - returns:
     Possible error returns are kCCParamError.
     
     - parameters:
        - publicKey:        A pointer to a public CCRSACryptorRef.
     
        - padding:            A selector for the padding to be used.
     
        - plainText:            A pointer to the data to be encrypted.
     
        - plainTextLen:            Length of data to be encrypted.
     
        - cipherText:        The encrypted byte result.
     
        - cipherTextLen:            Length of encrypted bytes.
     
        - tagData:         tag to be included in the encryption.
     
        - tagDataLen:    Length of tag bytes.
     
        - digestType:        The digest algorithm to use (See CommonDigestSPI.h).
     */
    typealias CCRSACryptorEncrypt = @convention(c) (
        _ publicKey: CCRSACryptorRef,
        _ padding: CCAsymmetricPadding,
        _ plainText: UnsafeRawPointer,
        _ plainTextLen: Int,
        _ cipherText: UnsafeMutableRawPointer,
        _ cipherTextLen: UnsafeMutablePointer<Int>,
        _ tagData: UnsafeRawPointer,
        _ tagDataLen: Int,
        _ digestType: CCDigestAlgorithm) -> CCCryptorStatus
    
    /**
     Decrypt data with an RSA private key.
     
     - returns:
     Possible error returns are kCCParamError.
     
     - parameters:
     - privateKey:        A pointer to a private CCRSACryptorRef.
     
     - padding:            A selector for the padding to be used.
     
     - cipherText:        The encrypted byte result.
     
     - cipherTextLen:            Length of encrypted bytes.
     
     - plainText:            A pointer to the data to be encrypted.
     
     - plainTextLen:            Length of data to be encrypted. This is an in/out parameter.
     
     - tagData:         tag to be included in the encryption.
     
     - tagDataLen:    Length of tag bytes.
     
     - digestType:        The digest algorithm to use (See CommonDigestSPI.h).
     */
    typealias CCRSACryptorDecrypt = @convention (c) (
        _ privateKey: CCRSACryptorRef,
        _ padding: CCAsymmetricPadding,
        _ cipherText: UnsafeRawPointer,
        _ cipherTextLen: Int,
        _ plainText: UnsafeMutableRawPointer,
        _ plainTextLen: UnsafeMutablePointer<Int>,
        _ tagData: UnsafeRawPointer,
        _ tagDataLen: Int,
        _ digestType: CCDigestAlgorithm) -> CCCryptorStatus

    //MARK: Padding
    enum Padding: CCAsymmetricPadding {
        case none = 1000, pkcs1, oaep, pkcs1Raw = 1004, pss
    }
    
    //MARK: Init
    override init() throws {
        try super.init()
        generatePair = try getFunc("CCRSACryptorGeneratePair")
        getPublicKeyFromPrivateKey = try getFunc("CCRSACryptorGetPublicKeyFromPrivateKey")
        `import` = try getFunc("CCRSACryptorImport")
        export = try getFunc("CCRSACryptorExport")
        getKeyType = try getFunc("CCRSAGetKeyType")
        getKeySize = try getFunc("CCRSAGetKeySize")
        release = try getFunc("CCRSACryptorRelease")
        sign = try getFunc("CCRSACryptorSign")
        verify = try getFunc("CCRSACryptorVerify")
        encrypt = try getFunc("CCRSACryptorEncrypt")
        decrypt = try getFunc("CCRSACryptorDecrypt")
    }
    
    //MARK: Properties
    
    var generatePair: CCRSACryptorGeneratePair?
    var getPublicKeyFromPrivateKey: CCRSACryptorGetPublicKeyFromPrivateKey?
    var `import`: CCRSACryptorImport?
    var export: CCRSACryptorExport?
    var getKeyType: CCRSAGetKeyType?
    var getKeySize: CCRSAGetKeySize?
    var release: CCRSACryptorRelease?
    var sign: CCRSACryptorSign?
    var verify: CCRSACryptorVerify?
    var encrypt: CCRSACryptorEncrypt?
    var decrypt: CCRSACryptorDecrypt?
}

