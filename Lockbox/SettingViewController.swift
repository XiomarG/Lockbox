//
//  SettingViewController.swift
//  Lockbox
//
//  Created by XunGong on 2015-07-02.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var setPassword: UIButton!
    var password : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password = NSUserDefaults.standardUserDefaults().valueForKey("myPassword") as? [String]
        
        if password != nil {
            setPassword.setTitle("Change Password", forState: UIControlState.Normal)
        } else {
            setPassword.setTitle("Set Password", forState: UIControlState.Normal)
        }

    }
    
//    override func viewDidAppear(animated: Bool) {
//        a
//        // Do any additional setup after loading the view.
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setPW" {
            if let pwController = segue.destinationViewController as? PasswordViewController
            {
                if password == nil {
                    pwController.controllerType = .setPW
                } else {
                    pwController.controllerType = .changePW
                }
            }
            self.navigationController?.navigationBar.topItem?.title = "Cancel"
        }
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
