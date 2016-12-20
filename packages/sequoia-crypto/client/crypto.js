
Sequoia.crypto = {
    genSymKey(passphrase) {
        if (typeof passphrase === 'undefined' ) {
           passphrase = niceware.generatePassphrase(8).join(' ')
        }
        var salt = "NaCl"
        var key = Sequoia.scrypt(passphrase, salt, 16384, 8, 1, 64).toString('hex')
        return [key, passphrase]
    },
    genKeyPair() {
        crypt = new JSEncrypt({ default_key_size: 2048 })
        crypt.getKey()
        return [crypt.getPrivateKey().toString('hex'), crypt.getPublicKey().toString('hex')]
    },

    encrypt(text, key) {
        return CryptoJS.AES.encrypt(text, key)
    },

    decrypt(encrypted, key) {
        return CryptoJS.AES.decrypt(encrypted, key)
    },
}
