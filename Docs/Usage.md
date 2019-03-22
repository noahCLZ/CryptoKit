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
