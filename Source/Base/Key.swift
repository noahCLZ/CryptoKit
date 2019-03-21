//
//  Key.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/18.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

open class Key {
    
    //MARK: Services
    
    /// Remove self from keychain
    public func invalidate() {
        _ = delete()
    }
    
    //MARK: Internal
    
    func locateData(output: inout Data) -> OSStatus {
        
        var parameters: [NSString : AnyObject] = self.keychainQuery
        parameters[kSecReturnData] = true as AnyObject
        
        var data: CFTypeRef?
        let status = SecItemCopyMatching(parameters as CFDictionary, &data)
        if data != nil {
            output = data as! Data
        }
        return status
    }
    
    func delete() -> OSStatus {
        return SecItemDelete(self.keychainQuery as CFDictionary)
    }
    
    func storeData(_ data: Data) -> OSStatus {
        var parameters = self.keychainQuery
        parameters[kSecValueData] = data as AnyObject
        var status = SecItemAdd(parameters as CFDictionary, nil)
        if status == errSecDuplicateItem {
            status = delete()
            status = SecItemAdd(parameters as CFDictionary, nil)
        }
        return status
    }
    
    //MARK: Init

    public init(userStoreTag: String?) {
        self.userStoreTag = userStoreTag
    }
    
    //MARK: Properties
    
    public var storeTag: String {
        if let userStoreTag = userStoreTag {
            return defaultStoreTag + userStoreTag
        } else {
            return defaultStoreTag
        }
    }
    
    var keychainQuery: [NSString: AnyObject] {
        return [:]
    }
    
    var userStoreTag: String?
    
    var defaultStoreTag: String {
        return String(describing: self)
    }
    
}
