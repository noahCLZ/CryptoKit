//
//  SecureStorage.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/17.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

open class SecureItem {
    
    //MARK: Internal
    
    func locateData(tag: String, parameters p: [NSString : AnyObject], output: inout Data) -> OSStatus {
        var parameters = p
        parameters[kSecAttrApplicationTag] = tag as AnyObject
        parameters[kSecReturnData] = true as AnyObject
        
        var data: CFTypeRef?
        let status = SecItemCopyMatching(parameters as CFDictionary, &data)
        if data != nil {
            output = data as! Data
        }
        return status
    }
    
    func store(tag: String, parameters p: [NSString : AnyObject]) -> OSStatus {
        var parameters = p
        parameters[kSecAttrApplicationTag] = tag as AnyObject

        var status = SecItemAdd(parameters as CFDictionary, nil)
        if status == errSecDuplicateItem {
            status = delete(storeTag: tag)
            status = SecItemAdd(parameters as CFDictionary, nil)
        }
        return status
    }
    
    func storeData(_ data: Data, tag: String, parameters p: [NSString : AnyObject]) -> OSStatus {
        var parameters = p
        parameters[kSecValueData] = data as AnyObject
        return store(tag: tag, parameters: parameters)
    }
    
    func delete(storeTag tag: String) -> OSStatus {
        let theQuery: [NSString : AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag : tag as AnyObject,
            ]
        return SecItemDelete(theQuery as CFDictionary)
    }
    
    public init(storeTag: String?) {
        self.userStoreTag = storeTag
        self.storeParam = [:]
    }
    var storeParam: [NSString: AnyObject] = [:]
    
    var defaultStoreTag: String {
        return String(describing: self)
    }
    var userStoreTag: String?
    
    var storeTag: String {
        return userStoreTag ?? "" + defaultStoreTag
    }
}
