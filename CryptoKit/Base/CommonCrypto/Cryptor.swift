//
//  Cryptor.swift
//  CryptoKit
//
//  Created by noah.cl.zhuang on 2019/3/19.
//  Copyright © 2019 noah.cl.zhuang. All rights reserved.
//

import Foundation

//MARK: Typealias
typealias CCCryptorRef = UnsafeRawPointer
typealias CCOperation = UInt32
typealias CCMode = UInt32
typealias CCAlgorithm = UInt32
typealias CCPadding = UInt32
typealias CCModeOptions = UInt32

class Cryptor: CommonCrypto {
    
    /**
     Create a cryptographic context.
     - parameters:
         - op:         Defines the basic operation: kCCEncrypt or kCCDecrypt.
         - mode:        Specifies the cipher mode to use for operations.
         - alg:        Defines the algorithm.
         - padding:        Specifies the padding to use.
         - iv:         Initialization vector, optional. Used by block ciphers with the following modes:
     
             Cipher Block Chaining (CBC)
             Cipher Feedback (CFB and CFB8)
             Output Feedback (OFB)
             Counter (CTR)
     
             If present, must be the same length as the selected
             algorithm's block size.  If no IV is present, a NULL
             (all zeroes) IV will be used. For sound encryption,
             always initialize iv with random data.
     
             This parameter is ignored if ECB mode is used or
             if a stream cipher algorithm is selected.
     
         - key:         Raw key material, length keyLength bytes.
     
         - keyLength:   Length of key material. Must be appropriate
         for the selected operation and algorithm. Some
         algorithms  provide for varying key lengths.
     
         - tweak:      Raw key material, length keyLength bytes. Used for the
         tweak key in XEX-based Tweaked CodeBook (XTS) mode.
     
         - tweakLength:   Length of tweak key material. Must be appropriate
         for the selected operation and algorithm. Some
         algorithms  provide for varying key lengths.  For XTS
         this is the same length as the encryption key.
     
         - numRounds:    The number of rounds of the cipher to use.  0 uses the default.
     
         - options:    A word of flags defining options. See discussion
         for the CCModeOptions type.
     
         - cryptorRef:  A (required) pointer to the returned CCCryptorRef.
     */
    
    typealias CCCryptorCreateWithMode = @convention(c)(
        _ op: CCOperation,
        _ mode: CCMode,
        _ alg: CCAlgorithm,
        _ padding: CCPadding,
        _ iv: UnsafeRawPointer?,
        _ key: UnsafeRawPointer,
        _ keyLength: Int,
        _ tweak: UnsafeRawPointer?,
        _ tweakLength: Int,
        _ numRounds: Int32,
        _ options: CCModeOptions,
        _ cryptorRef: UnsafeMutablePointer<CCCryptorRef?>) -> CCCryptorStatus
    
    /**
     Determine output buffer size required to process a given input size.
     
     - Note:
     Some general rules apply that allow clients of this module to
     know a priori how much output buffer space will be required
     in a given situation. For stream ciphers, the output size is
     always equal to the input size, and CCCryptorFinal() never
     produces any data. For block ciphers, the output size will
     always be less than or equal to the input size plus the size
     of one block. For block ciphers, if the input size provided
     to each call to CCCryptorUpdate() is is an integral multiple
     of the block size, then the output size for each call to
     CCCryptorUpdate() is less than or equal to the input size
     for that call to CCCryptorUpdate(). CCCryptorFinal() only
     produces output when using a block cipher with padding enabled.
     
     - parameters:
         - cryptorRef:  A CCCryptorRef created via CCCryptorCreate() or
         CCCryptorCreateFromData().
         -  inputLength: The length of data which will be provided to
         CCCryptorUpdate().
         - final:       If false, the returned value will indicate the
         output buffer space needed when 'inputLength'
         bytes are provided to CCCryptorUpdate(). When
         'final' is true, the returned value will indicate
         the total combined buffer space needed when
         'inputLength' bytes are provided to
         CCCryptorUpdate() and then CCCryptorFinal() is
         called.
     */
    typealias CCCryptorGetOutputLength = @convention(c)(
        _ cryptorRef: CCCryptorRef,
        _ inputLength: Int,
        _ final: Bool) -> Int
    
    /**
     Process (encrypt, decrypt) some data. The result, if any,
     is written to a caller-provided buffer.
     
     - Note:
     This routine can be called multiple times. The caller does
     not need to align input data lengths to block sizes; input is
     bufferred as necessary for block ciphers.
     
     When performing symmetric encryption with block ciphers,
     and padding is enabled via kCCOptionPKCS7Padding, the total
     number of bytes provided by all the calls to this function
     when encrypting can be arbitrary (i.e., the total number
     of bytes does not have to be block aligned). However if
     padding is disabled, or when decrypting, the total number
     of bytes does have to be aligned to the block size; otherwise
     CCCryptFinal() will return kCCAlignmentError.
     
     A general rule for the size of the output buffer which must be
     provided by the caller is that for block ciphers, the output
     length is never larger than the input length plus the block size.
     For stream ciphers, the output length is always exactly the same
     as the input length. See the discussion for
     CCCryptorGetOutputLength() for more information on this topic.
     
     Generally, when all data has been processed, call
     CCCryptorFinal().
     
     In the following cases, the CCCryptorFinal() is superfluous as
     it will not yield any data nor return an error:
     1. Encrypting or decrypting with a block cipher with padding
     disabled, when the total amount of data provided to
     CCCryptorUpdate() is an integral multiple of the block size.
     2. Encrypting or decrypting with a stream cipher.
     
     - returns:
     kCCBufferTooSmall indicates insufficent space in the dataOut
     buffer. The caller can use
     CCCryptorGetOutputLength() to determine the
     required output buffer size in this case. The
     operation can be retried; no state is lost
     when this is returned.
     - parameters:
         - cryptorRef:  A CCCryptorRef created via CCCryptorCreate() or
         CCCryptorCreateFromData().
         -  dataIn:          Data to process, length dataInLength bytes.
         -  dataInLength:    Length of data to process.
         -  dataOut:         Result is written here. Allocated by caller.
         Encryption and decryption can be performed
         "in-place", with the same buffer used for
         input and output. The in-place operation is not
         suported for ciphers modes that work with blocks
         of data such as CBC and ECB.
     
         -  dataOutAvailable: The size of the dataOut buffer in bytes.
         -  dataOutMoved:    On successful return, the number of bytes
         written to dataOut.
     */
    
    typealias CCCryptorUpdate = @convention(c)(
        _ cryptorRef: CCCryptorRef,
        _ dataIn: UnsafeRawPointer,
        _ dataInLength: Int,
        _ dataOut: UnsafeMutableRawPointer,
        _ dataOutAvailable: Int,
        _ dataOutMoved: UnsafeMutablePointer<Int>) -> CCCryptorStatus
    
    /**
     Finish an encrypt or decrypt operation, and obtain the (possible)
     final data output.
     
     - Note:
     Except when kCCBufferTooSmall is returned, the CCCryptorRef
     can no longer be used for subsequent operations unless
     CCCryptorReset() is called on it.
     
     It is not necessary to call CCCryptorFinal() when performing
     symmetric encryption or decryption if padding is disabled, or
     when using a stream cipher.
     
     It is not necessary to call CCCryptorFinal() prior to
     CCCryptorRelease() when aborting an operation.
     
     - returns:
     - kCCBufferTooSmall indicates insufficent space in the dataOut
     buffer. The caller can use
     CCCryptorGetOutputLength() to determine the
     required output buffer size in this case. The
     operation can be retried; no state is lost
     when this is returned.
     - kCCAlignmentError When decrypting, or when encrypting with a
     block cipher with padding disabled,
     kCCAlignmentError will be returned if the total
     number of bytes provided to CCCryptUpdate() is
     not an integral multiple of the current
     algorithm's block size.
     - kCCDecodeError  Indicates garbled ciphertext or the
     wrong key during decryption. This can only
     be returned while decrypting with padding enabled.
     
     - parameters:
         - cryptorRef:      A CCCryptorRef created via CCCryptorCreate() or
         CCCryptorCreateFromData().
         - dataOut:         Result is written here. Allocated by caller.
         - dataOutAvailable: The size of the dataOut buffer in bytes.
         - dataOutMoved:    On successful return, the number of bytes
         written to dataOut.
     */
    typealias CCCryptorFinal = @convention(c)(
        _ cryptorRef: CCCryptorRef,
        _ dataOut: UnsafeMutableRawPointer,
        _ dataOutAvailable: Int,
        _ dataOutMoved: UnsafeMutablePointer<Int>) -> CCCryptorStatus
    
    /**
     Free a context created by CCCryptorCreate or
     CCCryptorCreateFromData().
     
     - returns:
     The only possible error return is kCCParamError resulting
     from passing in a null CCCryptorRef.
     
     - parameters:
        - cryptorRef:  The CCCryptorRef to release.
     */
    typealias CCCryptorRelease = @convention(c)
        (_ cryptorRef: CCCryptorRef) -> CCCryptorStatus
    
    //MARK: Init
    override init() throws {
        try super.init()
        createWithMode = try self.getFunc("CCCryptorCreateWithMode")
        getOutputLength = try self.getFunc("CCCryptorGetOutputLength")
        update = try self.getFunc("CCCryptorUpdate")
        final = try self.getFunc("CCCryptorFinal")
        release = try self.getFunc("CCCryptorRelease")
    }
    
    //MARK: Properties
    
    var createWithMode: CCCryptorCreateWithMode?
    var getOutputLength: CCCryptorGetOutputLength?
    var update: CCCryptorUpdate?
    var final: CCCryptorFinal?
    var release: CCCryptorRelease?
}
