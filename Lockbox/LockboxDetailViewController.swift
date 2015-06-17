//
//  LockboxDetailViewController.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-16.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit

class LockboxDetailViewController: UIViewController {
    

    @IBOutlet weak var accountInfo: UITextField!
    @IBOutlet weak var passwordInfo: UITextField!
    
    var currentAccount : String?
    var currentPassword : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountInfo.text = currentAccount
        passwordInfo.text = currentPassword 
    }
    
}
