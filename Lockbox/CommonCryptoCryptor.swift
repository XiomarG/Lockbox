//
//  CommonCryptoCryptor.swift
//  Lockbox
//
//  Created by XunGong on 2015-07-04.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import Foundation

struct CCCParameter {
    static let keyString = "!Use a data key!"
    static let keyData = (keyString as NSString).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
    static let ivString = "Use a random iv!"
    static let ivData = (ivString as NSString).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
}

func testCrypt(data: NSData, keyData: NSData, ivData: NSData, operation: CCOperation) -> NSData? {
    let keyBytes = UnsafePointer<Void>(keyData.bytes)
    //println("keyLength   = \(keyData.length), keyData   = \(keyData)")
    
    let ivBytes = UnsafePointer<Void>(ivData.bytes)
    //println("ivLength    = \(ivData.length), ivData    = \(ivData)")
    
    let dataLength = data.length
    let dataBytes = UnsafePointer<Void>(data.bytes)
    //println("dataLength  = \(dataLength), data      = \(data)")
    
    let cryptData: NSMutableData! = NSMutableData(length: Int(dataLength) + kCCBlockSizeAES128)
    var cryptPointer = UnsafeMutablePointer<Void>(cryptData.mutableBytes)
    let cryptLength = cryptData.length
    
    let keyLength              = Int(kCCKeySizeAES128)
    let algorithm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
    let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding)
    
    var numBytesEncrypted : Int = 0
    
    var cryptStatus = CCCrypt(operation, algorithm, options, keyBytes, keyLength, ivBytes, dataBytes, dataLength, cryptPointer, cryptLength, &numBytesEncrypted)
    
    if UInt32(cryptStatus) == UInt32(kCCSuccess) {
        let x : Int = numBytesEncrypted
        cryptData.length = Int(numBytesEncrypted)
        //println("cryptLength = \(numBytesEncrypted), cryptData = \(cryptData)")
        
    } else {
        println("Error: \(cryptStatus)")
    }
    
    return cryptData;
}

extension String {
    func encrypted() -> NSData {
        let data = (self as NSString).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        let encryptedData = testCrypt(data, CCCParameter.keyData, CCCParameter.ivData, UInt32(kCCEncrypt))
        return encryptedData!
    }
}

extension NSData {
    func decrypted() -> String {
        let decryptedData = testCrypt(self, CCCParameter.keyData, CCCParameter.ivData, UInt32(kCCDecrypt)) as NSData!
        return NSString(data: decryptedData, encoding: NSUTF8StringEncoding) as! String
    }
}


//func encodeObjectEncrypted(thisCode: NSCoder, string: String, forKey: String) {
//    let data = (string as NSString).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
//    let encryptedData = testCrypt(data, CCCParameter.keyData, CCCParameter.ivData, UInt32(kCCEncrypt))
//    thisCoder.encodeObject(encryptedData, forKey: forKey)
//}