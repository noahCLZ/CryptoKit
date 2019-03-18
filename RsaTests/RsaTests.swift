//
//  RsaTests.swift
//  RsaTests
//
//  Created by noah.cl.zhuang on 2019/3/17.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import XCTest
@testable import CryptoKit

class RsaTests: XCTestCase {
    
    let base64_pkcs8_publicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAx3UtC3/P4NBqDvxJwgDBQRQSvKZAdA9cIjG22VwRSoh0xSZkpM7JozJ43iWPSDA0k/c3/uHeTvl49bKHnoxXw0TrCXXziVgrkv3nwcnIf4pHMk0QqURok6oZfrcryMEMKLdd0KN0lYpWS3+6PbYoKAbZueCGH6Yk230bxp6/o8aXYXQbmUIxdho5E3Bl3vm75nzhPstqfaoN6ZlqHtI7Seiq/8uS32nNayXCDgCrRyDK5K7wXKRGSolHLOo65/1QPlEOubh3BrUEhHCT3kh//MQtqYUH1habkJHDwPN7KuKhUliPijREmRKHnSGpTmqILtRBwCLrrYnAgGP3Qnr3LwIDAQAB"
    
    let base64_pkcs8_privateKey = "MIIEpAIBAAKCAQEAx3UtC3/P4NBqDvxJwgDBQRQSvKZAdA9cIjG22VwRSoh0xSZkpM7JozJ43iWPSDA0k/c3/uHeTvl49bKHnoxXw0TrCXXziVgrkv3nwcnIf4pHMk0QqURok6oZfrcryMEMKLdd0KN0lYpWS3+6PbYoKAbZueCGH6Yk230bxp6/o8aXYXQbmUIxdho5E3Bl3vm75nzhPstqfaoN6ZlqHtI7Seiq/8uS32nNayXCDgCrRyDK5K7wXKRGSolHLOo65/1QPlEOubh3BrUEhHCT3kh//MQtqYUH1habkJHDwPN7KuKhUliPijREmRKHnSGpTmqILtRBwCLrrYnAgGP3Qnr3LwIDAQABAoIBAQCl3Hji0RwqlOU9JOqo2zvZRDn4ij+aw5MYFEM7KOZwFl0T/MNAkXz3qub7xDwMCZoPWUtFNspI3geKOTWx0H7CsLLKoT0tfxZtG5r3eTazaGegGpm6SFq2QIMG7ocIYBAeY60t7F7sY6czDTnwS2PFNT0k5uJhuyV3J+hLGIPASdCSgAiCX5v7zT0iOEFzELUWg0Bdign+m62S7IQBAhMU1erHFUptTJ1TP4gA4JkmKKt8lz4YiqCOiBo0hdBzs9qAcBrem01skhYDmNzXXB1VJE8pzO/fHMUGnR9UpMP6Ecu1Whzenik9XYPRNuntVs2coqEvcj7PDNft0OCCp8qxAoGBAPqJlF1HTSFw9N8v/Rm05KvMOCszIdCpLEz2xvbbEOQGaK2HrpzlGi8j5rEjStzLKpSgQm/XBI/X72UYMCnTwcPwbOqgCiOPvVN5awxvLB7ZkgSxVMAZR1FaJnauMUaFG7RobW10DL5wUZc63phWSrU8rSul7YeFK8TFLCppJTvdAoGBAMvOfFdenI++54KIeT76KviQE/6nkWboLzF1U0vO/uxzD7Rt01Em5N8Ez7jRytA1lft37ETFlJ8iNNQqDZKnqhY4Ggh3fNV4msOz48V1LOk+eIkMzOc0kA/dNuWb52862Ja6v3Izyk8ixma3ws/cn0eCpOmK08JE5Di6moA3qsR7AoGAAtFDQt1HZ8XeaxgeD4jyPWBZjVrQ2Yjdf6wSxrnl8bqEuNbaxtbouXj84icUc3ExdGRs+tb/LSLvhUKFYCMKfcqZXvYXxxiZt3OZGZWyeFJYCwd3fYWLQMXzwsfos/NRQXEfMejpL8cRk9LMqAfoZStegywlhK2htV/GRF/UVF0CgYAdFTIZJZ8hxBQ1RFRI8FoBbk3sIO1WyfsyC5P/VWJ7S1AKZ0GoauxuBrm9nfJbE8p7P/mvNqKmsrLnM7kMHHDhCtBsNODTdYpgMuNl4fqurgN1SyZSN+X23ZJf4Yd9D+CoYa3AFjPgZw34ynA6STlRcwslaHIfXsVScw5pDYiI0QKBgQDOFdlIpXeQZ2en9hqlCP0+Lq++Lsup9OtMGd0/8pY9nURe1HIM4HfLjUnsxs2tPq1H7BACvM4P1VYlpQwFDbVg5yu2uTflAet9r+6cs61C0vG8mxGdMt/X/cKuwp+cAvcp1VBacna3+fwvfs9RNZLtM0R854FTt54xkrl88WiYBg=="

    let base64_pkcs1_publicKey = "MIIBCgKCAQEAx3UtC3/P4NBqDvxJwgDBQRQSvKZAdA9cIjG22VwRSoh0xSZkpM7JozJ43iWPSDA0k/c3/uHeTvl49bKHnoxXw0TrCXXziVgrkv3nwcnIf4pHMk0QqURok6oZfrcryMEMKLdd0KN0lYpWS3+6PbYoKAbZueCGH6Yk230bxp6/o8aXYXQbmUIxdho5E3Bl3vm75nzhPstqfaoN6ZlqHtI7Seiq/8uS32nNayXCDgCrRyDK5K7wXKRGSolHLOo65/1QPlEOubh3BrUEhHCT3kh//MQtqYUH1habkJHDwPN7KuKhUliPijREmRKHnSGpTmqILtRBwCLrrYnAgGP3Qnr3LwIDAQAB"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImportPublicKey() {
        do {
            let _ = try Rsa().importPublicKey(DER: Data(base64Encoded: base64_pkcs1_publicKey)!, storeTag: "test")
            let _ = try Rsa().importPublicKey(DER: Data(base64Encoded: base64_pkcs8_publicKey)!, storeTag: "test2")
        } catch {
            XCTFail(error.localizedDescription)
        }

    }
    
    func testEncryption() {
        do {
            let test = "aaeefdcosmfgnbs"
            let (pub, priv) = try Rsa().generate(size: Rsa.KeySize.In2048Bits, storeTag: "testEncryption")
            let enc = try pub.encrypt(test.data(using: .utf8)!, hash: .sha256)
            let dec = try priv.decrypt(enc, hash: .sha256)
            XCTAssert(String(data: dec, encoding: .utf8) == test, "result different")
            
            let enc2 = try pub.encrypt(test.data(using: .utf8)!, hash: .sha256)
            let dec2 = try? priv.decrypt(enc2, hash: .sha1)
            XCTAssert(dec2 == nil, "result should be different from test")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSignature() {
        do {
            var success = false
            let test = "I need to test sign"
            let testData = test.data(using: .utf8)!
            let (pub, priv) = try Rsa().generate(size: Rsa.KeySize.In2048Bits, storeTag: "testSignature")
            let sig = try priv.sign(testData, hash: .sha1)
            try pub.verify(signature: sig, with: testData, hash: .sha1, success: &success)
            XCTAssert(success == true, "verify fail")
            
            let sig2 = try priv.sign(testData, hash: .sha1)
            try? pub.verify(signature: sig2, with: testData, hash: .sha256, success: &success)
            XCTAssert(success == false, "verify should not success")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testExportPEM() {
        do {
            let pub = try Rsa().importPublicKey(DER: Data(base64Encoded: base64_pkcs1_publicKey)!, storeTag: "testExportPEM")
            let pem = try pub.pkcs1PEM()
            XCTAssert(pem.contains("-----BEGIN RSA PUBLIC KEY-----"), "RSA prefix needed")
            XCTAssert(pem.contains("-----END RSA PUBLIC KEY-----"), "RSA sufix needed")
            
            let pem2 = try pub.x509PEM()
            XCTAssert(pem2.contains("-----BEGIN PUBLIC KEY-----"), "RSA prefix needed")
            XCTAssert(pem2.contains("-----END PUBLIC KEY-----"), "RSA sufix needed")
            
            let derBase64 = try pub.pkcs1DER().base64EncodedString()
            XCTAssert(derBase64 == base64_pkcs1_publicKey, "import and export public key should be the same")
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
