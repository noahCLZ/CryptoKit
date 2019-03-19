//
//  AesTests.swift
//  AesTests
//
//  Created by noah.cl.zhuang on 2019/3/19.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import XCTest
@testable import CryptoKit

class AesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGenerate() {
        do {
            let _ = try Aes().generate(size: .In16Bytes, storeTag: "testGenerate")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    
    func testEncrytionShortText() {
        do {
            let test = "Good day"
            let testData = test.data(using: .utf8)!
            let k = try Aes().generate(size: .In16Bytes, storeTag: "testGenerate")
            let enc = try k.encrypt(testData, mode: .cbc)
            let dec = try k.decrypt(enc, mode: .cbc)
            XCTAssert(dec == testData, "Wrong decryption result")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testEncrytionLongText() {
        do {
            let test = "Of course the Widow Stimson never tried to win Deacon Hawkins, nor any other man, for that matter. A widow doesn't have to try to win a man; she wins without trying. Still, the Widow Stimson sometimes wondered why the deacon was so blind as not to see how her fine farm adjoining his equally fine place on the outskirts of the town might not be brought under one management with mutual benefit to both parties at interest. Which one that management might become was a matter of future detail. The widow knew how to run a farm successfully, and a large farm is not much more difficult to run than one of half the size. She had also had one husband, and knew something more than running a farm successfully. Of all of which the deacon was perfectly well aware, and still he had not been moved by the merging spirit of the age to propose consolidation."
            let testData = test.data(using: .utf8)!
            let k = try Aes().generate(size: .In16Bytes, storeTag: "testGenerate")
            let enc = try k.encrypt(testData, mode: .cbc)
            let dec = try k.decrypt(enc, mode: .cbc)
            XCTAssert(dec == testData, "Wrong decryption result")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testEncrytionEmptyText() {
        do {
            let test = ""
            let testData = test.data(using: .utf8)!
            let k = try Aes().generate(size: .In16Bytes, storeTag: "testGenerate")
            let enc = try k.encrypt(testData, mode: .cbc)
            let dec = try k.decrypt(enc, mode: .cbc)
            XCTAssert(dec == testData, "Wrong decryption result")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testExport() {
        do {
            let k = try Aes().generate(size: .In16Bytes, storeTag: "testGenerate")
            let iv = try k.exportIV()
            let key = try k.exportKey()
            XCTAssert(!iv.isEmpty && !key.isEmpty, "Wrong decryption result")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testImport() {
        do {
            let keyText = "jkjkjkjkjkjkjkjk"
            let keyData = keyText.data(using: .utf8)!
            let ivData = Data(repeating: 1, count: 1)
            let k = try Aes().import(key: keyData, iv: ivData, storeTag: "testImport")
            let key = try k.exportKey()
            let iv = try k.exportIV()
            XCTAssert(keyData == key && iv == ivData, "Wrong result")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }


}
