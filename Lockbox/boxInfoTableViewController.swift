//
//  boxInfoTableViewController.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-17.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit
import MobileCoreServices

// this protocol is used to transfer data from this table view to main collectionview
protocol BoxInfoTableViewControllerDelegate {
    func detailDidFinish(controller: boxInfoTableViewController,
        newAccounts : [Account],
        newAppName: String?,
        newAppIcon: UIImage?,
        checkNew : Bool)
}


class boxInfoTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var delegate : BoxInfoTableViewControllerDelegate? = nil
    
    var myName : String?
    var myImage : UIImage?
    var accounts = [Account]()
    var isNew = false
    
    enum textFieldType {
        case appName
        case accountName
        case password
    }
    
    static let appNameFontSize = CGFloat(20)
    
    
    @IBOutlet weak var appName: UITextField!
    
    // MARK: - Set App Image
    
    @IBOutlet weak var setImageButton: UIButton!
    @IBAction func setImage() {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            let optionMenu = UIAlertController(title: "Choose Image From", message: "", preferredStyle: .ActionSheet)
            let fromCamera = UIAlertAction(title: "Camera", style: .Default)
            {   _ -> Void in
                self.takePhoto()
            }
            let fromLibrary = UIAlertAction(title: "Library", style: .Default)
            {   _ -> Void in
                self.choosePhotoFromLibrary()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
            {    _ -> Void in
                println("Cancelled")
            }
            
            optionMenu.addAction(fromCamera)
            optionMenu.addAction(fromLibrary)
            optionMenu.addAction(cancelAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    private func takePhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.mediaTypes = [kUTTypeImage]
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    private func choosePhotoFromLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        myImage = info[UIImagePickerControllerEditedImage] as? UIImage
        if myImage == nil {
            myImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        setImageButton.setImage(myImage, forState: UIControlState.Normal)
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
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
            self.delegate?.detailDidFinish(self, newAccounts: accounts, newAppName: myName, newAppIcon: myImage, checkNew: isNew)
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
        if myImage != nil {
            setImageButton.setImage(myImage, forState: UIControlState.Normal)
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
