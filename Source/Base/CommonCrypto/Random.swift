//
//  Random.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/19.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

typealias CCRNGStatus = CCCryptorStatus

class Random: CommonCrypto {
    
    /**
     Return random bytes in a buffer allocated by the caller.
     
     - Important:
     The PRNG returns cryptographically strong random bits suitable for use as cryptographic keys, IVs, nonces etc.
     - returns:
     Return kCCSuccess on success.
     - parameters:
         - bytes   Pointer to the return buffer.
         - count   Number of random bytes to return.
     */
    typealias CCRandomGenerateBytes = @convention(c) (
        _ bytes: UnsafeMutableRawPointer,
        _ count: Int) -> CCRNGStatus


    
    //MARK: Init
    override init() throws {
        try super.init()
        generateBytes = try getFunc("CCRandomGenerateBytes")
    }

    var generateBytes: CCRandomGenerateBytes?
}
