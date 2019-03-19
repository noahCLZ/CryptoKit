//
//  CommonCrypto.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/18.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

//MARK: Typealias
typealias CCCryptorStatus = Int32
typealias CCDigestAlgorithm = UInt32

class CommonCrypto {

    public init() throws {
        if dylib == nil {
            throw CCError.dynamicLoadingFail(String(cString: dlerror()))
        }
    }
    
    deinit {
        dlclose(dylib)
    }
    
    func getFunc<T>(_ f: String) throws -> T {
        guard let dylib = self.dylib else {
            throw CCError.dynamicLoadingFail(String(cString: dlerror()))
        }
        let sym = dlsym(dylib, f)
        guard sym != nil else {
            throw CCError.dynamicLoadingFail(String(cString: dlerror()))
        }
        return unsafeBitCast(sym, to: T.self)
    }
    
    let dylib = dlopen("/usr/lib/system/libcommonCrypto.dylib", RTLD_LAZY)
}
