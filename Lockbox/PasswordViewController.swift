//
//  PasswordViewController.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-26.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var input1: UITextField!
    @IBOutlet weak var input2: UITextField!
    @IBOutlet weak var input3: UITextField!
    @IBOutlet weak var input4: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var textFields = [input1, input2, input3, input4]
        // Do any additional setup after loading the view.
        for index in 0 ... 3 {
            textFields[index].keyboardType = UIKeyboardType.NumberPad
        }
        
        
        input1.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
