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
        checkNew : Bool)
}


class boxInfoTableViewController: UITableViewController, UITextFieldDelegate {

    var delegate : BoxInfoTableViewControllerDelegate? = nil
    
    var accounts = [Account]()
    var isNew = false
    
    enum textFieldType {
        case name
        case password
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
            self.delegate?.detailDidFinish(self, newAccounts: accounts, checkNew: isNew)
        }
        
    }
    
    private func checkAccounts() -> Bool {
        // used to rearrange accounts incase certain cell is empty
        // if any cell has empty name or empty password return false
        //var emptyCellIndex = [Int]()
        var accountSize = accounts.count
        for (var index = 0; index < accountSize; index++ ){
            if accounts[index].name == "" && accounts[index].password == "" {
                accounts.removeAtIndex(index)
                accountSize = accounts.count
            }
        }
        
        for index in 0 ..< accounts.count {
            if accounts[index].name == "" || accounts[index].password == "" {
                return false
            }
        }
        
        return true
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)    }
    
    func observeTextFields(theTextfield : UITextField, theIndexPath : NSIndexPath, type : textFieldType) {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        center.addObserverForName(UITextFieldTextDidChangeNotification,
            object: theTextfield,
            queue: queue) { _ in
                switch type {
                case .name: self.accounts[theIndexPath.row].name = theTextfield.text
                case .password: self.accounts[theIndexPath.row].password = theTextfield.text
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
        observeTextFields(cell.accountInfo, theIndexPath: indexPath, type: textFieldType.name)
        observeTextFields(cell.passwordInfo, theIndexPath: indexPath, type: textFieldType.password)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
