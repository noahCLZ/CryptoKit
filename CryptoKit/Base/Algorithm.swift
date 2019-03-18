//
//  AlgorithmType.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/17.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

public enum Algorithm {
    case aes, rsa, ec
    
    public enum Hash: UInt32 {
        case sha1 = 8
        case sha224 = 9, sha256 = 10, sha384 = 11, sha512 = 12
        
        func digest(_ data: Data) throws -> Data {
            let d = try Digest()
            let outputSize = d.getOutputSize!(self.rawValue)
            var output = Data(count: outputSize)
            let status = output.withUnsafeMutableBytes { (outputBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
                return d.digest!(self.rawValue,
                            (data as NSData).bytes,
                            data.count,
                            outputBytes)
            }
            if status != 0 {
                throw CCError.code(status)
            }
            return output
        }
    }
}

public protocol AlgorithmIdentifiable {
    var identifier: Algorithm { get }
}

extension Algorithm: CustomStringConvertible {
    public var description: String {
        switch self {
        case .aes: return "Advanced Encryption Standard"
        case .rsa: return kSecAttrKeyTypeRSA as String
        case .ec: return kSecAttrKeyTypeEC as String
        }
    }
    
    
}
