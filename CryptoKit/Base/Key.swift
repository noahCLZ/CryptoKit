//
//  Key.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/18.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

open class Key<A>: SecureItem where A: AlgorithmIdentifiable {
    
    override var defaultStoreTag: String {
        return String(describing: self) + "." + self.algorithm.identifier.description
    }
    
    init(_ algo: A, storeTag: String?) {
        self.algorithm = algo
        
        super.init(storeTag: storeTag)
        
        let storeParam = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: String(describing: self)  as AnyObject,
            kSecAttrService: self.algorithm.identifier.description as AnyObject,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        ]
        self.storeParam = storeParam
    }
    
    let algorithm: A
    
}
