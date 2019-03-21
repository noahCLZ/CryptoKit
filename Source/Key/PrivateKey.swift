//
//  PrivateKey.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/18.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

open class PrivateKey<A>: Key where A: AlgorithmIdentifiable {
    
    override var keychainQuery: [NSString : AnyObject] {
        return [
            kSecClass: kSecClassKey,
            kSecAttrKeyClass: kSecAttrKeyClassPrivate,
            kSecAttrIsPermanent: true as AnyObject,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            kSecAttrKeyType: self.algorithm.identifier.description as AnyObject,
            kSecAttrApplicationTag: self.storeTag as AnyObject
        ]
    }
    
    public init(algorithm: A, userStoreTag: String?) {
        self.algorithm = algorithm
        super.init(userStoreTag: userStoreTag)
    }
    var algorithm: A
}

