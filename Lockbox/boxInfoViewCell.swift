//
//  boxInfoViewCell.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-17.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit

class boxInfoViewCell: UITableViewCell {

    
    var detailInfo : Account?

    @IBOutlet weak var accountInfo: UITextField!
    @IBOutlet weak var passwordInfo: UITextField!
    
    override func awakeFromNib() {
        accountInfo.text = detailInfo?.name
        passwordInfo.text = detailInfo?.password
    }
    
    
}
