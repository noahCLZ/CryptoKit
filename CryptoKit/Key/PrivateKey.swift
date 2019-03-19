//
//  PrivateKey.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/18.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

open class PrivateKey<A>: Key<A> where A: AlgorithmIdentifiable {
    
    override init(_ algo: A, storeTag: String?) {
        super.init(algo, storeTag: storeTag)

        let storeParam = [
            kSecClass: kSecClassKey,
            kSecAttrKeyClass: kSecAttrKeyClassPrivate,
            kSecAttrIsPermanent: true as AnyObject,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            kSecAttrKeyType: self.algorithm.identifier.description as AnyObject
        ]
        self.storeParam = storeParam
    }
}

