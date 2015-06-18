//
//  LockboxDetailViewController.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-16.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit


protocol DetailViewControllerDelegate {
    func ldvcDidFinish(controller: LockboxDetailViewController,
        newImage : UIImage?,
        newName : String?,
        newAccount : String?,
        newPassword : String?,
        checkNew : Bool)
}

class LockboxDetailViewController: UIViewController {
    
    var delegate : DetailViewControllerDelegate? = nil
    
    var isNew = false
    
    @IBOutlet weak var accountInfo: UITextField!
    @IBOutlet weak var passwordInfo: UITextField!
    
    @IBAction func saveLockboxInfo(sender: UIBarButtonItem) {
        if (delegate != nil) {
            self.currentAccount = accountInfo.text
            self.currentPassword = passwordInfo.text
            delegate!.ldvcDidFinish(self, newImage: currentImage, newName: currentName, newAccount: currentAccount, newPassword: currentPassword, checkNew : isNew)
        }
    }
    var currentImage : UIImage?
    var currentName : String?
    var currentAccount : String?
    var currentPassword : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountInfo.text = currentAccount
        passwordInfo.text = currentPassword 
    }
    
}
