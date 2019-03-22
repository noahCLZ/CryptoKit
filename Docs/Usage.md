## Usage
```swift
import CryptoKit
```

### SHA - Message digest
```swift
do {
    let text = "SHA family"
    let data = text.data(using: .utf8)!
    let sha1_digest = try Hash.sha1.digest(data)
    let sha224_digest = try Hash.sha224.digest(data)
    let sha256_digest = try Hash.sha256.digest(data)
    let sha384_digest = try Hash.sha384.digest(data)
    let sha512_digest = try Hash.sha512.digest(data)
} catch {
    // Handle error here. 
}
```

### RSA - Key generation
```swift
do {
    let (pub, priv) = try Rsa().generate(size: Rsa.KeySize.In2048Bits, storeTag: "RSA Key generation")
    
    // Return type of pub is PublicKey<Rsa>, and priv is PrivateKey<Rsa>.
    // Both keys are stored in the keychain and associated with the tag "RSA Key generation".
} catch {
    // Handle error here. 
}
```

### RSA - Encryption
```swift
do {
    // Suppose we have a pub of type PublicKey<Rsa> here.
    let plainText = "Hello, Cryptokit!"
    let plainData = plainText.data(using: .utf8)!
    let encrypted = try pub.encrypt(plainData, hash: Hash.sha256)
    
    // Return type of encrypted is Data.
    // The hash can be nil to perform RSA-PKCS1 encryption. Otherwise, RSA-OAEP encryption is performed.  
} catch {
    // Handle error here. 
}
```

### RSA - Decryption
```swift
do {
    // Suppose we have a priv of type PrivateKey<Rsa>, and an encrypted of type Data here.
    let decrypted = try priv.decrypt(encrypted, hash: Hash.sha256)
    
    // Return type of decrypted is Data.
    // The hash can be nil to perform RSA-PKCS1 decryption. Otherwise, RSA-OAEP decryption is performed.  
} catch {
    // Handle error here. 
}
```

### RSA - Signing
```swift
do {
    // Suppose we have a priv of type PrivateKey<Rsa> here.
    let message = "Cryptokit signing!"
    let messageData = message.data(using: .utf8)!
    let signature = try priv.sign(messageData, hash:  Hash.sha256)
    
    // Return type of signature is Data.
} catch {
    // Handle error here. 
}
```

### RSA - Verifying
```swift
do {
    // Suppose we have a pub of type PublicKey<Rsa>, and signature of type Data here.
    let message = "Cryptokit signing!"
    let messageData = message.data(using: .utf8)!
    var success = false
    try pub.verify(signature: signature, with: messageData, hash: .sha256, success: &success)
    
} catch {
    // Handle error here. 
}
```

### RSA - Importing key
#### *PKCS#1 format*
```swift
do {
    // Suppose we have base64_pkcs1_publicKey and base64_pkcs1_privateKey here.
    let base64_pkcs1_publicKey = "MIIBCgKCAQEAx3...rYnAgGP3Qnr3LwIDAQAB"
    let base64_pkcs1_privateKey = "MIIEpAIBAAKCAQEAx3...54xkrl88WiYBg=="
    let publicKey_DER = Data(base64Encoded: base64_pkcs1_publicKey)!
    let privateKey_DER = Data(base64Encoded: base64_pkcs1_privateKey)!
    
    let pub = try Rsa().importPublicKey(DER: publicKey_DER, storeTag: "public key import")
    let priv = try Rsa().importPrivateKey(DER: privateKey_DER, storeTag: "private key import")

    // One shot solution if we only care about the operation results.
    let plainText = "Hello, Cryptokit!"
    let plainData = plainText.data(using: .utf8)!
    
    let encrypted = try Rsa()
        .importPublicKey(DER: publicKey_DER, storeTag: "public key import")
        .encrypt(plainData, hash: nil)
    let decrypted = try Rsa()
        .importPrivateKey(DER: privateKey_DER, storeTag: "private key import")
        .decrypt(encrypted, hash: nil)

} catch {
    // Handle error here. 
}
```

#### *X.509 subject public key format*
```swift
do {
    // Suppose we have base64_x509_publicKey here.
    let base64_x509_publicKey = "MIIBIjANBgkqhkiG9w0B...AgGP3Qnr3LwIDAQAB"
    let publicKey_DER = Data(base64Encoded: base64_x509_publicKey)!
    
    let pub = try Rsa().importPublicKey(DER: publicKey_DER, storeTag: "public key import")

    // One shot solution if we only care about the operation results.
    let plainText = "Hello, Cryptokit!"
    let plainData = plainText.data(using: .utf8)!
    
    let encrypted = try Rsa()
        .importPublicKey(DER: publicKey_DER, storeTag: "public key import")
        .encrypt(plainData, hash: nil)

} catch {
    // Handle error here. 
}
```
#### *PKCS#8 private key format*
```swift
do {
    // Suppose we have base64_pkcs8_privateKey here.
    let base64_pkcs8_privateKey = "MIIEpAIBAAKCAQEAx3UtC...4FTt54xkrl88WiYBg=="
    let privateKey_DER = Data(base64Encoded: base64_pkcs8_privateKey)!
    
    let priv = try Rsa().importPrivateKey(DER: privateKey_DER, storeTag: "private key import")

    // One shot solution if we only care about the operation results.
    // Suppose we have encrypted of type Data here.
    
    let decrypted = try Rsa()
        .importPrivateKey(DER: privateKey_DER, storeTag: "private key import")
        .decrypt(encrypted, hash: nil)

} catch {
    // Handle error here. 
}
```
