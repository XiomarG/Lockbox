//
//  boxInfoViewCell.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-17.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit

class boxInfoViewCell: UITableViewCell, UITextFieldDelegate {

    
    var detailInfo : Account?

    @IBOutlet weak var accountInfo: UITextField!
    @IBOutlet weak var passwordInfo: UITextField!
    
    override func awakeFromNib() {
        accountInfo.text = detailInfo?.name
        passwordInfo.text = detailInfo?.password
        accountInfo.delegate = self
        passwordInfo.delegate = self
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
