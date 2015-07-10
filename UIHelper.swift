//
//  UIHelper.swift
//  Lockbox
//
//  Created by XunGong on 2015-07-07.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import Foundation

let systemTextColor = UIColor(red: 0, green: 122.0/255.0, blue: 1, alpha: 1)
var backgroundImageIndex = 0
//var backgroundImages = [UIImage(named: "background0"), UIImage(named: "background1"),UIImage(named: "background2"), UIImage(named: "background3"), UIImage(named: "background4"),nil]
var backgroundImages = [UIImage?]()



extension UIButton {
    
    func toCustomize() {
        self.setTitleColor(systemTextColor, forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 30.0)
    }
}

extension UILabel {
    func toCustomize() {
        self.textColor = systemTextColor
        self.font = UIFont(name: "Ubuntu", size: 30.0)
    }
}

extension UIViewController {
    func initBackImageView(backImageView : UIImageView) {
        backImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backImageView.backgroundColor = UIColor.whiteColor()
        backImageView.frame = self.view.frame
    }
    func loadBackImageView(backImageView : UIImageView) {
        
        backImageView.image = backgroundImages[backgroundImageIndex]
        self.view.addSubview(backImageView)
        self.view.sendSubviewToBack(backImageView)
    }
}