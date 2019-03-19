//
//  Digest.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/18.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

class Digest: CommonCrypto {
    
    /**
     Provides the digest output size of the digest algorithm.
     - returns:
     returns 0 on failure or the digest output size on success.
     - parameters:
        - algorithm:         A digest algorithm selector.
     */
    typealias CCDigestGetOutputSize = @convention(c) (
        _ algorithm: CCDigestAlgorithm) -> size_t
    
    /**
     Stateless, one-shot Digest function.

     - returns:
     Output is written to caller-supplied buffer, as in CCDigestFinal().
     - parameters:
        - algorithm:   Digest algorithm to perform.
        - data:        The data to digest.
        - length:      The length of the data to digest.
        - output:      The digest bytes (space provided by the caller). 
     */
    typealias CCDigest = @convention(c) (
        _ algorithm: CCDigestAlgorithm,
        _ data: UnsafeRawPointer,
        _ dataLen: size_t,
        _ output: UnsafeMutableRawPointer) -> Int32
    
    //MARK: Init
    override init() throws {
        try super.init()
        getOutputSize = try getFunc("CCDigestGetOutputSize")
        digest = try getFunc("CCDigest")
    }

    var getOutputSize: CCDigestGetOutputSize?
    var digest: CCDigest?
}
