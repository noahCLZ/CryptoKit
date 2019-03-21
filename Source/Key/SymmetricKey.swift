//
//  SymmetricKey.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/19.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

open class SymmetricKey<A>: Key where A: AlgorithmIdentifiable {
    
    override var keychainQuery: [NSString : AnyObject] {
        return  [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: self.storeTag as AnyObject,
            kSecAttrService: self.algorithm.identifier.description as AnyObject,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        ]
    }
    
    public init(algorithm: A, userStoreTag: String?) {
        self.algorithm = algorithm
        super.init(userStoreTag: userStoreTag)
    }
    var algorithm: A
}
