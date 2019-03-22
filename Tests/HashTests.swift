//
//  HashTests.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/22.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import XCTest
@testable import CryptoKit

class HashTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testSHA1() {
        let text = "Test SHA1"
        let data = text.data(using: .utf8)!
        do {
            let digest = try Hash.sha1.digest(data)
            XCTAssert(digest.count == 20, "incorrect result")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSHA224() {
        let text = "Test SHA224"
        let data = text.data(using: .utf8)!
        do {
            let digest = try Hash.sha224.digest(data)
            XCTAssert(digest.count == 28, "incorrect result")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSHA256() {
        let text = "Test SHA256"
        let data = text.data(using: .utf8)!
        do {
            let digest = try Hash.sha256.digest(data)
            XCTAssert(digest.count == 32, "incorrect result")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSHA384() {
        let text = "Test SHA384"
        let data = text.data(using: .utf8)!
        do {
            let digest = try Hash.sha384.digest(data)
            XCTAssert(digest.count == 48, "incorrect result")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSHA512() {
        let text = "Test SHA512"
        let data = text.data(using: .utf8)!
        do {
            let digest = try Hash.sha512.digest(data)
            XCTAssert(digest.count == 64, "incorrect result")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
