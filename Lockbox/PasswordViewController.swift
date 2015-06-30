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
    
    var thePassword = ["1","2","3","4"]
    
    var textFields = [UITextField]()
    var controllerType : pwControllerType?
    
    enum pwControllerType {
        case setPW
        case confirmPW
        case checkPW
    }
    
    private func setNotificationLabel() {
        switch self.controllerType! {
        case .setPW:
            self.notificationLabel.text = "Please Set Password"
            self.notificationLabel.textColor = UIColor.blueColor()
        case .confirmPW:
            self.notificationLabel.text = "Please Confirm Password"
            self.notificationLabel.textColor = UIColor.blueColor()
        case .checkPW:
            self.notificationLabel.text = "Please Input Password"
            self.notificationLabel.textColor = UIColor.blueColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFields = [input1, input2, input3, input4]
        // Do any additional setup after loading the view.
        for index in 0 ... 3 {
            textFields[index].delegate = self
            textFields[index].secureTextEntry = true
            //textFields[index].tag = Int(index)
            textFields[index].keyboardType = UIKeyboardType.Default
            observePasswordInputs(textFields[index], index: index, textFields: textFields)
        }
        self.controllerType = .checkPW
        self.setNotificationLabel()
        input1.becomeFirstResponder()
        
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
                        self.notificationLabel.text = ""
                    }
                case 3:
                    if self.checkPassword() == true {
                        theTextfield.resignFirstResponder()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.notificationLabel.text = "Password Incorrect"
                        for aTextField in self.textFields {
                            aTextField.text = ""
                        }
                        textFields[0].becomeFirstResponder()
                    }
                default:
                    break
                }
        }
    }
    
    func checkPassword() -> Bool{
        for index in 0 ... 3 {
            if textFields[index].text != thePassword[index]
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
