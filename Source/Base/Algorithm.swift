//
//  AlgorithmType.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/17.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

public enum Algorithm {
    case symmetric(Symmetric), asymmetric(Asymmetric)
    
    var rawValue: UInt32 {
        switch self {
        case .symmetric(let sym): return sym.rawValue
        case .asymmetric(let asym): return asym.rawValue
        }
    }
    
    /// Symmetric-key algorithm
    public enum Symmetric: UInt32, Codable {
        case aes = 0, des, tripleDES, cast, rc2 = 5, blowfish
        var blockSizeInBytes: Int {
            switch self {
            case .aes: return 16
            default: return 8
            }
        }
    }
    
    /// Asymmetric public-private key cryptosystem
    public enum Asymmetric: UInt32, Codable {
        case rsa, ec
    }
}

public protocol AlgorithmIdentifiable {
    var identifier: Algorithm { get }
}

extension Algorithm: CustomStringConvertible {
    public var description: String {
        switch self {
        case .asymmetric(let asym):
            switch asym {
            case .rsa: return kSecAttrKeyTypeRSA as String
            case .ec: return kSecAttrKeyTypeEC as String
            }
        case .symmetric(let sym):
            switch sym {
            case .aes:  return "Advanced Encryption Standard"
            case .blowfish: return "Blowfish"
            case .cast: return "CAST"
            case .rc2: return "RC2"
            case .des: return "Data Encryption Standard"
            case .tripleDES: return "Triple Data Encryption Algorithm"
            }
        }
    }
    
    
}
