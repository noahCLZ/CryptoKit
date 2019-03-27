//
//  ASN1.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/18.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

struct ASN1 {
    let type: UInt8
    let length: Int
    let data: Data
    
    init?(type: UInt8, arbitraryData data: Data) {
        guard data.count > 4 else {
            return nil
        }
        
        var result = data
        
        let byteArray = [UInt8](result)
        
        for (_, v) in byteArray.enumerated() {
            if v == type { // ASN1 SEQUENCE Type
                break
            }
            result = Data(result.dropFirst())
        }
        guard result.count > 4 else {
            return nil
        }
        guard
            let first = result.advanced(by: 0).first, // advanced start from 7.0
            let second = result.advanced(by: 1).first,
            let third = result.advanced(by: 2).first,
            let fourth = result.advanced(by: 3).first
            else {
                return nil
        }
        
        var length = 0
        switch second {
        case 0x82:
            length = ((Int(third) << 8) | Int(fourth)) + 4
            break
        case 0x81:
            length = Int(third) + 3
            break
        default:
            length = Int(second) + 2
            break
        }
        
        guard result.startIndex + length <= result.endIndex else { // startIndex, endIndex start from 7.0
            return nil
        }
        result = result[result.startIndex..<result.startIndex + length]
        self.data = result
        self.length = length
        self.type = first
    }
    
    var last: ASN1? {
        get {
            var result: Data?
            var dataToFetch = self.data
            while let fetched = ASN1(type: self.type, arbitraryData: dataToFetch) {
                
                if let range = data.range(of: fetched.data) {
                    if range.upperBound == data.count {
                        result = fetched.data
                        dataToFetch = Data(fetched.data.dropFirst())
                    } else {
                        dataToFetch = Data(data.dropFirst(range.upperBound))
                    }
                } else {
                    break
                }
            }
            
            return ASN1(type: type, arbitraryData: result!)
        }
    }
    
    static func wrap(type: UInt8, followingData: Data) -> Data {
        var adjustedFollowingData = followingData
        if type == 0x03 {
            adjustedFollowingData = Data([0]) + followingData // add prefix 0
        }
        let lengthOfAdjustedFollowingData = adjustedFollowingData.count
        let first: UInt8 = type
        var bytes = [UInt8]()
        if lengthOfAdjustedFollowingData <= 0x80 {
            let second: UInt8 = UInt8(lengthOfAdjustedFollowingData)
            bytes = [first, second]
        } else if lengthOfAdjustedFollowingData > 0x80 && lengthOfAdjustedFollowingData <= 0xFF {
            let second: UInt8 = UInt8(0x81)
            let third: UInt8 = UInt8(lengthOfAdjustedFollowingData)
            bytes = [first, second, third]
        } else {
            let second: UInt8 = UInt8(0x82)
            let third: UInt8 = UInt8(lengthOfAdjustedFollowingData >> 8)
            let fourth: UInt8 = UInt8(lengthOfAdjustedFollowingData & 0xFF)
            bytes = [first, second, third, fourth]
        }
        return Data(bytes) + adjustedFollowingData
    }
    
    static func rsaOID() -> Data {
        var bytes = [UInt8]()
        bytes = [0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x01, 0x05, 0x00]
        return Data(bytes)
    }
}
