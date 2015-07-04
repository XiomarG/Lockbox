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
    var cellPerRow = Int()
    
    let cellPerRowString = "Box/Row: "
    
    @IBOutlet weak var cellPerRowLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperChanged(sender: UIStepper) {
        cellPerRow = Int(sender.value)
        cellPerRowLabel.text = cellPerRowString + "\(cellPerRow)"
        NSUserDefaults.standardUserDefaults().setObject(cellPerRow, forKey: "cell per row")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //password = NSUserDefaults.standardUserDefaults().valueForKey("myPassword") as? [String]

        cellPerRow = NSUserDefaults.standardUserDefaults().objectForKey("cell per row") as? Int ?? 3
        stepper.value = Double(cellPerRow)
        cellPerRowLabel.text = cellPerRowString + "\(cellPerRow)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hasPassword = NSUserDefaults.standardUserDefaults().valueForKey("has password") as? Bool
        
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
