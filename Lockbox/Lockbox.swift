//
//  lockbox.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-16.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import Foundation
import UIKit

class  Account : NSObject, NSCoding {
    var name : String = ""
    var password : String = ""
    init (name : String, password : String) {
        self.name = name
        self.password = password
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "NAME_KEY")
        aCoder.encodeObject(password, forKey: "PASSWORD_KEY")
        
        
    }
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("NAME_KEY") as! String
        password = aDecoder.decodeObjectForKey("PASSWORD_KEY") as! String
    }
    
}


class Lockbox : NSObject, NSCoding  {
    
    var icon : UIImage?
    var appName : String?
    
    private struct Constants {
        static let LBIcon = "LBIcon"
        static let LBName = "LBName"
        static let LBAccounts = "LBAccounts"
    }
    
    
    var accounts = [Account]()
        
    init ( accountName: String, password : String ){
        self.accounts.append(Account(name: accountName,password: password))
    }
    
    init ( newAccounts : [Account], newAppName: String?) {
        self.accounts = newAccounts
        self.appName = newAppName
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(icon, forKey: Constants.LBIcon)
        aCoder.encodeObject(appName, forKey: Constants.LBName)
        aCoder.encodeObject(accounts, forKey: Constants.LBAccounts)
    }
    
    required init(coder aDecoder: NSCoder) {
        icon = aDecoder.decodeObjectForKey(Constants.LBIcon) as? UIImage
        appName = aDecoder.decodeObjectForKey(Constants.LBName) as?     String
        accounts = aDecoder.decodeObjectForKey(Constants.LBAccounts) as! [Account]
    }
}
