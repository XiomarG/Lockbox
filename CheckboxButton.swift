//
//  CheckboxButton.swift
//  Lockbox
//
//  Created by XunGong on 2015-07-05.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit

class CheckboxButton: UIButton {
    var isChecked = false
    func toggleImage() {
        isChecked = !isChecked
        let buttonImage = isChecked ? UIImage(named: "checkedButton") : UIImage(named: "uncheckedButton")
        self.setBackgroundImage(buttonImage, forState: .Normal)
    }
}
