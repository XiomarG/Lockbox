//
//  lockbox.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-16.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import Foundation
import UIKit

struct Account {
    var name : String
    var password : String
}

class Lockbox {
    
    var icon : UIImage?
    var name : String?
    
    
    var accounts = [Account]()
    
    init ( accountName: String, password : String ){
        self.accounts.append(Account(name: accountName,password: password))
    }
    
    init ( newAccounts : [Account]) {
        self.accounts = newAccounts
    }
    /*
    func updateInfoWith (image : UIImage?, newName name : String?, newAccount account : String, newPassword password : String) {
        self.icon = image
        self.name = name
        self.accounts = 
    }*/
}