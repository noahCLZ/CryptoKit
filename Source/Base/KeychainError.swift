//
//  KeychainError.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/17.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

public enum KeychainError: Error, LocalizedError {
    
    /// Codes correspond to the value of the OSStatus
    case code(OSStatus)
    
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .code(let value):
            if #available(iOS 11.3, tvOS 11.3, watchOS 4.3, *)  {
                    return (SecCopyErrorMessageString(value, nil) as String?) ?? ""
            } else {
                // Fallback on earlier versions
                let nsError = NSError(domain: NSOSStatusErrorDomain, code: Int(value), userInfo: nil)
                return nsError.localizedFailureReason ?? nsError.localizedDescription
            }
        }

    }
    
    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        return errorDescription
    }
}
