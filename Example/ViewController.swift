//
//  ViewController.swift
//  Example
//
//  Created by noah.cl.zhuang on 2019/3/17.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import UIKit
import CryptoKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            var success = false
            let test = "I need to test sign"
            let testData = test.data(using: .utf8)!
            let (pub, priv) = try Rsa().generate(size: Rsa.KeySize.In2048Bits, storeTag: "testSignature")
            let sig = try priv.sign(testData, hash: .sha1)
            try pub.verify(signature: sig, with: testData, hash: .sha1, success: &success)
            print("first verification success")
            let sig2 = try priv.sign(testData, hash: .sha1)
            try pub.verify(signature: sig2, with: testData, hash: .sha256, success: &success)
        } catch {
            print("second verification falil with \(error.localizedDescription)")

        }
        
    }


}
