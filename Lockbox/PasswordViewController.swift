//
//  PasswordViewController.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-26.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit
import KeychainAccess


class PasswordViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var input1: UITextField!
    @IBOutlet weak var input2: myTextField!
    @IBOutlet weak var input3: myTextField!
    @IBOutlet weak var input4: myTextField!
    @IBOutlet weak var logoImage: UIImageView!

    @IBOutlet weak var notificationLabel: UILabel!

    @IBOutlet weak var minorNotificationLabel: UILabel!

    @IBOutlet weak var inputBackgroundView: UIView!

    var backImageView = UIImageView()

    var thePassword : String?

    var tempPassword = ""

    var textFields = [UITextField]()
    var controllerType : pwControllerType?

    var keyboardHeight : CGFloat?
    var viewHeightConstraint : NSLayoutConstraint?
    var defaultBackViewConstraint : NSLayoutConstraint?


    let keychain = Keychain()


    enum pwControllerType {
        case changePW
        case setPW
        case confirmPW
        case checkPW
        case removePW
    }
        
    private func setNotificationLabel() {
        if self.controllerType != nil {
            switch self.controllerType! {
            case .changePW, .removePW:
                self.notificationLabel.text = "Please Input Current Password"
            case .setPW:
                self.notificationLabel.text = "Please Set Password"
            case .confirmPW:
                self.notificationLabel.text = "Please Confirm Password"
            case .checkPW:
                self.notificationLabel.text = "Please Input Password"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initBackImageView(backImageView)
        self.loadBackImageView(backImageView)
        setView()
        if self.controllerType == .checkPW {
            isPasswordView = true
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "detectDeleteBackward", name: "DeleteNotification", object: nil)
    }



    private func updateViewForKeyboard() {
        viewHeightConstraint = NSLayoutConstraint(item: self.inputBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: keyboardHeight!+100)
        inputBackgroundView.removeConstraint(defaultBackViewConstraint!)
        inputBackgroundView.addConstraint(viewHeightConstraint!)
        self.logoImage.layer.cornerRadius = self.logoImage.layer.bounds.width / CGFloat(8.0)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "keyboardShown:", object: nil)
        NSUserDefaults.standardUserDefaults().setObject(keyboardHeight, forKey: "saved keyboard height")
    }


    private func setView() {
        keyboardHeight = NSUserDefaults.standardUserDefaults().objectForKey("saved keyboard height") as? CGFloat
        if keyboardHeight != nil {
            defaultBackViewConstraint = NSLayoutConstraint(item: self.inputBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: keyboardHeight!+100)
            inputBackgroundView.addConstraint(defaultBackViewConstraint!)
        } else {
            defaultBackViewConstraint = NSLayoutConstraint(item: self.inputBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 316)
            inputBackgroundView.addConstraint(defaultBackViewConstraint!)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShown:", name: UIKeyboardDidShowNotification, object: nil)
        }
        
        input1.becomeFirstResponder()
        
        self.thePassword = self.keychain[string: Constants.APP_PASSWORD]
        self.notificationLabel.text = ""
        self.textFields = [input1, input2, input3, input4]
        for index in 0 ... 3 {
            textFields[index].delegate = self
            textFields[index].secureTextEntry = true
            textFields[index].keyboardType = UIKeyboardType.Default
            observePasswordInputs(textFields[index], index: index, textFields: textFields)
        }
        self.notificationLabel.textColor = systemTextColor
        self.minorNotificationLabel.textColor = UIColor.redColor()
        self.setNotificationLabel()
        self.minorNotificationLabel.text = ""
        self.logoImage.layer.masksToBounds = true
        self.logoImage.layer.cornerRadius = CGFloat(10.0)
    }

    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!

        let rawFrame = value.CGRectValue()
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        keyboardHeight = keyboardFrame.height
        updateViewForKeyboard()
    }

    // MARK: Text Filed Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.length + range.location > count(textField.text)
        {    return false   }
        let newLength = count(textField.text) + count(string) - range.length
        if newLength > 1  { return false }
        return newLength  <= 1
    }


    func observePasswordInputs(theTextfield : UITextField!, index : Int, textFields: [UITextField!]) {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        center.addObserverForName(UITextFieldTextDidChangeNotification,
            object: theTextfield,
            queue: queue) { _ in
                switch index {
                case 0,1,2 :
                    if count(textFields[index].text) == 1 {
                        textFields[index+1].becomeFirstResponder()
                        self.minorNotificationLabel.text = ""
                        self.setNotificationLabel()
                    }
                case 3:
                        // check password
                    if self.controllerType == .checkPW {
                        if self.comparePassword(self.thePassword!) == true {
                            theTextfield.resignFirstResponder()
                            self.dismissViewControllerAnimated(true, completion: nil)
                            isPasswordView = false
                        } else {
                            self.notificationLabel.text = "Password Incorrect"
                            self.minorNotificationLabel.text = "Please Input Again"
                            for aTextField in self.textFields {
                                aTextField.text = ""
                            }
                            textFields[0].becomeFirstResponder()
                        }
                    }
                        // change password
                    else if self.controllerType == .changePW {
                        if self.comparePassword(self.thePassword!) == true {
                            self.controllerType = .setPW
                            for aTextField in self.textFields {
                                aTextField.text = ""
                            }
                            textFields[0].becomeFirstResponder()
                            self.setNotificationLabel()
                        } else {
                            self.notificationLabel.text = "Password Incorrect"
                            self.minorNotificationLabel.text = "Please Input Again"
                            for aTextField in self.textFields {
                                aTextField.text = ""
                            }
                            textFields[0].becomeFirstResponder()
                        }
                    }
                    else if self.controllerType == .removePW {
                        if self.comparePassword(self.thePassword!) == true {
                            NSUserDefaults.standardUserDefaults().removeObjectForKey("has password")
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            self.notificationLabel.text = "Password Incorrect"
                            self.minorNotificationLabel.text = "Please Input Again"
                            for aTextField in self.textFields {
                                aTextField.text = ""
                            }
                            textFields[0].becomeFirstResponder()
                        }
                    }
                        // set password
                    else if self.controllerType == .setPW {
                        self.tempPassword = ""
                        for index in 0 ... 3 {
                            self.tempPassword += textFields[index].text
                            textFields[index].text = ""  // set finished. clear for confirmation
                        }
                        self.controllerType = .confirmPW
                        self.setNotificationLabel()
                        textFields[0].becomeFirstResponder()
                    }
                        // confirm password
                    else if self.controllerType == .confirmPW {
                        var isSame = self.comparePassword(self.tempPassword)
                        if isSame {
                            self.thePassword = self.tempPassword
                            self.keychain[string: Constants.APP_PASSWORD] = self.thePassword
                            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "has password")
                            self.navigationController?.popViewControllerAnimated(true)
                            
                        }  else {
                            for aTextField in self.textFields {
                                aTextField.text = ""
                            }
                            textFields[0].becomeFirstResponder()
                            self.controllerType = .setPW
                            self.setNotificationLabel()
                            self.minorNotificationLabel.text = "Confimation Failed"
                        }
                    }
                    
                    
                default:
                    break
                }
        }
    }

    func comparePassword(password : String ) -> Bool {
        var inputPassword = ""
        for index in 0 ... 3 {
            inputPassword = inputPassword + textFields[index].text
        }
        
        if inputPassword != password  { return false }
        return true
    }
    func detectDeleteBackward() {
        for index in 1...3 {
            if textFields[index].isFirstResponder() {
                textFields[index-1].text = ""
                textFields[index-1].becomeFirstResponder()
                break
            }
        }
    }
}

class myTextField : UITextField {
    var vc : UIViewController?
    override func deleteBackward() {
        super.deleteBackward()
//        globalDeleteBackward = !globalDeleteBackward
        NSNotificationCenter.defaultCenter().postNotificationName("DeleteNotification", object: nil)
    }
}
