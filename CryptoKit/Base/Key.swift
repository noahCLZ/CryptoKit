//
//  Key.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/18.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

open class Key<A> where A: AlgorithmIdentifiable {
    
    //MARK: Services
    
    /// Remove self from keychain
    public func invalidate() {
        _ = delete(storeTag: self.storeTag, service: nil)
    }
    
    func locateData(storeTag tag: String, service: String?, parameters p: [NSString : AnyObject], output: inout Data) -> OSStatus {
        var parameters: [NSString : AnyObject]
        
        if let service = service {
            parameters = [
                kSecClass : kSecClassGenericPassword,
                kSecAttrAccount: tag as AnyObject,
                kSecAttrService: service as AnyObject,
                kSecReturnData : true as AnyObject
            ]
        } else {
            parameters = p
            parameters[kSecReturnData] = true as AnyObject
            parameters[kSecAttrApplicationTag] = tag as AnyObject
        }
        var data: CFTypeRef?
        let status = SecItemCopyMatching(parameters as CFDictionary, &data)
        if data != nil {
            output = data as! Data
        }
        return status
    }
    
    func storeData(_ data: Data, tag: String, service: String?, parameters p: [NSString : AnyObject]) -> OSStatus {
        var parameters = p
        parameters[kSecValueData] = data as AnyObject
        if let service = service {
            parameters[kSecAttrService] = service as AnyObject
            parameters[kSecAttrAccount] = tag as AnyObject
        } else {
            parameters[kSecAttrApplicationTag] = tag as AnyObject
        }
        var status = SecItemAdd(parameters as CFDictionary, nil)
        if status == errSecDuplicateItem {
            status = delete(storeTag: tag, service: service)
            status = SecItemAdd(parameters as CFDictionary, nil)
        }
        return status
    }
    
    func delete(storeTag tag: String, service: String?) -> OSStatus {
        let theQuery: [NSString : AnyObject]
        if let service = service {
            theQuery = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: tag as AnyObject,
                kSecAttrService: service as AnyObject
            ]
        } else {
            theQuery = [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag : tag as AnyObject,
            ]
        }
        return SecItemDelete(theQuery as CFDictionary)
    }
    
    //MARK: Init
    
    init(_ algo: A, storeTag: String?) {
        self.algorithm = algo
        self.userStoreTag = storeTag
    }
    
    //MARK: Properties
    
    var storeParam: [NSString: AnyObject] = [:]
    
    var defaultStoreTag: String {
        return String(describing: self) + "." + self.algorithm.identifier.description
    }
    
    var userStoreTag: String?
    
    var storeTag: String {
        return (userStoreTag ?? "") + defaultStoreTag
    }
    
    let algorithm: A
    
}
