//
//  PasswordViewController.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-26.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var input1: UITextField!
    @IBOutlet weak var input2: UITextField!
    @IBOutlet weak var input3: UITextField!
    @IBOutlet weak var input4: UITextField!
    
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBOutlet weak var minorNotificationLabel: UILabel!
    
    @IBOutlet weak var inputBackgroundView: UIView!
    var thePassword = NSUserDefaults.standardUserDefaults().objectForKey("myPassword") as? [String]
    var tempPassword = ["","","",""]
    
    var textFields = [UITextField]()
    var controllerType : pwControllerType?
    
    var keyboardHeight : CGFloat?

    
    enum pwControllerType {
        case changePW
        case setPW
        case confirmPW
        case checkPW
    }
    
    private func setNotificationLabel() {
        if self.controllerType != nil {
            switch self.controllerType! {
            case .changePW:
                self.notificationLabel.text = "Please Input Old Password"
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
        self.notificationLabel.text = ""
        self.textFields = [input1, input2, input3, input4]
        // Do any additional setup after loading the view.
        for index in 0 ... 3 {
            textFields[index].delegate = self
            textFields[index].secureTextEntry = true
            //textFields[index].tag = Int(index)
            textFields[index].keyboardType = UIKeyboardType.Default
            observePasswordInputs(textFields[index], index: index, textFields: textFields)
        }
        //self.controllerType = .checkPW
        //self.controllerType = .setPW
        self.notificationLabel.textColor = UIColor.blueColor()
        self.minorNotificationLabel.textColor = UIColor.redColor()
        self.setNotificationLabel()
        self.minorNotificationLabel.text = ""
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardShown:", name: UIKeyboardDidShowNotification, object: nil)
        input1.becomeFirstResponder()
        //setView()
        
    }
    override func viewDidAppear(animated: Bool) {
        setView()
    }
    
    private func setView() {
        let viewHeightConstraint = NSLayoutConstraint(item: self.inputBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: keyboardHeight!+100)
        inputBackgroundView.addConstraint(viewHeightConstraint)

    }
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue()
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        keyboardHeight = keyboardFrame.height
        println("keyboardHeight: \(keyboardHeight)")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                        if self.checkPassword() == true {
                            theTextfield.resignFirstResponder()
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            self.notificationLabel.text = "Password Incorrect"
                            self.minorNotificationLabel.text = "Please Input Again"
                            for aTextField in self.textFields {
                                aTextField.text = ""
                            }
                            textFields[0].becomeFirstResponder()
                        }
                    }
                    else if self.controllerType == .changePW {
                        if self.checkPassword() == true {
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
                        // set password
                    else if self.controllerType == .setPW {
                        for index in 0 ... 3 {
                            self.tempPassword[index] = textFields[index].text
                            textFields[index].text = ""  // set finished. clear for confirmation
                        }
                        self.controllerType = .confirmPW
                        self.setNotificationLabel()
                        textFields[0].becomeFirstResponder()
                    }
                        // confirm password
                    else if self.controllerType == .confirmPW {
                        var isSame = true
                        for index in 0 ... 3 {
                            if self.tempPassword[index] != textFields[index].text { isSame = false }
                        }
                        if isSame {
                            self.thePassword = self.tempPassword
                            NSUserDefaults.standardUserDefaults().setObject(self.thePassword, forKey: "myPassword")
                            //theTextfield.resignFirstResponder()
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
    
    func checkPassword() -> Bool{
        for index in 0 ... 3 {
            if textFields[index].text != thePassword![index]
            { return false }
        }
        //self.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
