//
//  lockbox.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-16.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import Foundation
import UIKit

class lockbox {
    
    var icon : UIImage?
    var name : String?
    var account : String
    var password : String
    
    init ( name: String, account: String, password : String ){
        self.name = name
        self.account = account
        self.password = password
    }
    
    func updateInfoWith (image : UIImage?, newName name : String?, newAccount account : String, newPassword password : String) {
        self.icon = image
        self.name = name
        self.account = account
        self.password = password
    }
}