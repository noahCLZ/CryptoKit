//
//  CCError.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/18.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

public enum CCError: Error, LocalizedError {
    case code(Int32)
    case dynamicLoadingFail(String)
    case nonPKCS1Format
    case incorrectKeyType
    
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .code(let value):
            return "Error code:\(value)"
        case .dynamicLoadingFail(let s):
            return s
        case .nonPKCS1Format:
            return "nonPKCS1Formatted"
        case .incorrectKeyType:
            return "incorrectKeyType"
        }
    }
    
    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        return errorDescription
    }
}
