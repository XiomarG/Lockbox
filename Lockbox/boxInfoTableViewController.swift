//
//  boxInfoTableViewController.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-17.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit

// this protocol is used to transfer data from this table view to main collectionview
protocol BoxInfoTableViewControllerDelegate {
    func detailDidFinish(controller: boxInfoTableViewController,
        newAccounts : [Account],
        newAppName: String?,
        checkNew : Bool)
}


class boxInfoTableViewController: UITableViewController, UITextFieldDelegate {

    var delegate : BoxInfoTableViewControllerDelegate? = nil
    
    var myName : String?
    var accounts = [Account]()
    var isNew = false
    
    enum textFieldType {
        case appName
        case accountName
        case password
    }
    
    static let appNameFontSize = CGFloat(20)
    
    
    @IBOutlet weak var appName: UITextField!
    
    
    // MARK: - add new account
    
    @IBAction func addAccount(sender: UIButton) {
        accounts.append(Account(name:"", password: ""))
        tableView.reloadData()
    }
    // MARK: - send data back
    
    @IBAction func saveChange(sender: UIBarButtonItem) {
        
        let isValid = checkAccounts()
        
        if !isValid {
            let alertController = UIAlertController(title: "Invalid Information", message: "Cannot leave account name or password blank!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        else if delegate != nil {
            self.delegate?.detailDidFinish(self, newAccounts: accounts, newAppName: myName, checkNew: isNew)
        }
        
    }
    
    private func checkAccounts() -> Bool {
        // used to rearrange accounts incase certain cell is empty
        // if any cell has empty name or empty password return false
        //var emptyCellIndex = [Int]()
        var accountSize = accounts.count
        for (var index = 0; index < accountSize; index++){
            if accounts[index].name == "" && accounts[index].password == "" {
                accounts.removeAtIndex(index)
                accountSize = accounts.count
                index--
            }
        }
        
        for index in 0 ..< accounts.count {
            if accounts[index].name == "" || accounts[index].password == "" {
                return false
            }
        }
        
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        appName.text = myName
        appName.sizeToFit()
        if myName != nil {
            appName.borderStyle = UITextBorderStyle.None
            appName.font = appName.font.fontWithSize(20)
            appName.textColor = UIColor.blueColor()
        } else {
            appName.borderStyle = UITextBorderStyle.RoundedRect
        }
        observeTextFields(appName, theIndexPath: nil, type: textFieldType.appName)
    }
    
    func observeTextFields(theTextfield : UITextField, theIndexPath : NSIndexPath?, type : textFieldType) {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        center.addObserverForName(UITextFieldTextDidChangeNotification,
            object: theTextfield,
            queue: queue) { _ in
                switch type {
                case .appName: self.myName = theTextfield.text
                case .accountName: self.accounts[theIndexPath!.row].name = theTextfield.text
                case .password: self.accounts[theIndexPath!.row].password = theTextfield.text
                }
                
        }
        
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return accounts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detail cell", forIndexPath: indexPath) as! boxInfoViewCell
        // Configure the cell...        
        cell.detailInfo = accounts[indexPath.row]
        cell.accountInfo.text = cell.detailInfo?.name
        cell.passwordInfo.text = cell.detailInfo?.password
        observeTextFields(cell.accountInfo, theIndexPath: indexPath, type: textFieldType.accountName)
        observeTextFields(cell.passwordInfo, theIndexPath: indexPath, type: textFieldType.password)

        return cell
    }
    
}
