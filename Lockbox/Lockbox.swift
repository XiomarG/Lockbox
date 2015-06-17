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
        self.icon = nil
        self.name = name
        self.account = account
        self.password = password
    }
    
}