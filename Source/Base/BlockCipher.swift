//
//  BlockCipher.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/19.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

open class BlockCipher {
    
    public enum Operation: Int {
        case encrypt, decrypt
    }
    
    /// Block cipher modes for symmetric-key encryption algorithms require plain text input that is a multiple of the block size, so messages may have to be padded to bring them to this length.
    public enum Mode: UInt32, Codable {
        case ecb = 1, cbc, cfb, ctr, ofb = 7, cfb8 = 10
    }
    
    /// PKCS5 padding is identical to PKCS7 padding, except that it has only been defined for block ciphers that use a 64-bit (8-byte) block size. In practice the two can be used interchangeably.
    public enum Padding: UInt32 {
        case none, pkcs7
    }
    
    //MARK: Services
    
    func perform(_ op: Operation,
                 mode: Mode,
                 algorithm: Algorithm.Symmetric.RawValue,
                 padding: Padding,
                 data: Data,
                 key: Data,
                 iv: Data?) throws -> Data {
        
        var ref: CCCryptorRef? = nil
        var status = cryptor.createWithMode!(
            CCOperation(op.rawValue),
            mode.rawValue,
            algorithm,
            padding.rawValue,
            iv == nil ? nil : (iv! as NSData).bytes,
            (key as NSData).bytes,
            key.count,
            nil,
            0,
            0,
            1,
            &ref)
        
        guard status == noErr else {
            throw CCError.code(status)
        }
        defer { _ = cryptor.release!(ref!) }
        
        let needed = cryptor.getOutputLength!(ref!, data.count, true)
        var result = Data(count: needed)
        var resultCount = result.count
        var updateLen: size_t = 0
        status = result.withUnsafeMutableBytes({ (resultBytes: UnsafeMutablePointer<UInt8>) -> CCCryptorStatus in
            return cryptor.update!(
                ref!,
                (data as NSData).bytes, data.count,
                resultBytes, resultCount,
                &updateLen)
        })
        
        guard status == noErr else {
            throw CCError.code(status)
        }
        
        resultCount = result.count
        var finalLen: size_t = 0
        status = result.withUnsafeMutableBytes({ (resultBytes: UnsafeMutablePointer<UInt8>) -> CCCryptorStatus in
            return cryptor.final!(
                ref!,
                resultBytes + updateLen,
                resultCount - updateLen,
                &finalLen)
        })
        
        guard status == noErr else {
            throw CCError.code(status)
        }
        
        result.count = updateLen + finalLen
        return result
    }
    
    func secureRandom(_ count: UInt) throws -> Data {
        
        var data: Data = Data(count: Int(count))
        
        let status = data.withUnsafeMutableBytes { (resultBytes: UnsafeMutablePointer<UInt8>) -> CCRNGStatus in
            let result = resultBytes
            return random.generateBytes!(result, Int(count))
        }
        guard status == noErr else {
            throw CCError.code(status)
        }
        return data
    }
    
    //MARK: Init
    
    public init() throws {
        cryptor = try Cryptor()
        random = try Random()
    }
    
    //MARK: Properties
    
    let cryptor: Cryptor
    
    let random: Random
    
    open var blockSize: Int {
        return 8
    }
}
