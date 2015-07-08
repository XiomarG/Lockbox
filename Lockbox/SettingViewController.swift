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
    var hasPassword : Bool?
    var boxPerRow = Int()
    
    let cellPerRowString = "Box/Row: "
    
    @IBOutlet weak var boxPerRowLabel: UILabel!
    @IBOutlet weak var boxPerRowNumber: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperChanged(sender: UIStepper) {
        boxPerRow = Int(sender.value)
        boxPerRowLabel.text = "\(boxPerRow)"
        NSUserDefaults.standardUserDefaults().setObject(boxPerRow, forKey: "box per row")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        boxPerRowLabel.textColor = systemTextColor
        boxPerRowNumber.textColor = systemTextColor
        boxPerRow = NSUserDefaults.standardUserDefaults().objectForKey("box per row") as? Int ?? 3
        stepper.value = Double(boxPerRow)
        boxPerRowNumber.text = "\(boxPerRow)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hasPassword = NSUserDefaults.standardUserDefaults().valueForKey("has password") as? Bool
        setPassword.toCustomize()
        if hasPassword != nil {
            setPassword.setTitle("Change Password", forState: UIControlState.Normal)
        } else {
            setPassword.setTitle("Set Password", forState: UIControlState.Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setPW" {
            if let pwController = segue.destinationViewController as? PasswordViewController
            {
                if hasPassword == nil {
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
