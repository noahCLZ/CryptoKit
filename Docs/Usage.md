## Usage
```swift
import CryptoKit
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
    let encrypted = try pub.encrypt(plainData, hash: Algorithm.Hash.sha256)
    
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
    let decrypted = try priv.decrypt(encrypted, hash: Algorithm.Hash.sha256)
    
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
    let signature = try priv.sign(messageData, hash:  Algorithm.Hash.sha256)
    
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
