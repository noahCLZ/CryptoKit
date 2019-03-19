//
//  SymmetricKey.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/19.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

open class SymmetricKey<A>: Key<A> where A: AlgorithmIdentifiable {
    
    override public func invalidate() {
        _ = delete(storeTag: self.storeTag, service: ivLabel)
        _ = delete(storeTag: self.storeTag, service: keyLabel)
    }
    
    override init(_ algo: A, storeTag: String?) {
        super.init(algo, storeTag: storeTag)
        
        let storeParam = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        ]
        self.storeParam = storeParam
    }
    
    let ivLabel = "IV"
    
    var keyLabel: String {
        return self.algorithm.identifier.description
    }
}
