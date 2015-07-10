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
    var backImageView = UIImageView()

    var myName : String?
    var myImage : UIImage?
    var accounts = [Account]()
    var isNew = false
    
    
    @IBOutlet weak var addAcountButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var appName: UITextField!
    
    
    private var isNewAccountTrigger = false
    
    enum textFieldType {
        case appName
        case accountName
        case password
    }
    
    static let appNameFontSize = CGFloat(20)
    
    // MARK: UI Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        tableView.backgroundView = UIImageView(image: backgroundImages[backgroundImageIndex])
        //self.initBackImageView(backImageView)

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.loadBackImageView(backImageView)
    }
    
    func setView() {
        appName.text = myName
        appName.sizeToFit()
        appName.textColor = systemTextColor
        if myName != nil && myName != ""    {
            appName.borderStyle = UITextBorderStyle.None
            appName.font = UIFont(name: "Ubuntu", size: 28.0)
            appName.minimumFontSize = 5.0
        } else {
            appName.borderStyle = UITextBorderStyle.RoundedRect
            appName.font = UIFont(name: "Ubuntu", size: 20.0)
        }
        appName.autocorrectionType = UITextAutocorrectionType.No
        appName.delegate = self
        // set button to round corner
        self.setImageButton.layer.masksToBounds = true
        self.setImageButton.layer.cornerRadius = self.setImageButton.bounds.width / CGFloat(8.0)
        if myImage == nil {
            setImageButton.setImage(UIImage(named: "defaultKeyImage") , forState: UIControlState.Normal)
        } else {
            setImageButton.setImage(myImage, forState: UIControlState.Normal)
        }
        observeTextFields(appName, theIndexPath: nil, type: textFieldType.appName)
        
        addAcountButton.toCustomize()
        //deleteButton.toCustomize()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        myImage = info[UIImagePickerControllerEditedImage] as? UIImage

        if myImage == nil {
            myImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        setImageButton.setImage(myImage, forState: UIControlState.Normal)
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    // MARK: - User Interaction
    
    @IBAction func addAccount(sender: UIButton) {
        self.resignFirstResponder()
        accounts.append(Account(name:"", password: ""))
        tableView.reloadData()
        isNewAccountTrigger = true
    }

    @IBAction func deleteApp(sender: AnyObject) {
        var alert = UIAlertController(title: "Ready to delete this app?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Destructive, handler: {
            _ in
            self.accounts.removeAll(keepCapacity: false)
            self.delegate?.detailDidFinish(self, newAccounts: self.accounts, newAppName: self.myName, newAppIcon: self.myImage, checkNew: self.isNew)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
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
        cell.accountInfo.autocorrectionType = UITextAutocorrectionType.No
        cell.passwordInfo.autocorrectionType = UITextAutocorrectionType.No
        observeTextFields(cell.accountInfo, theIndexPath: indexPath, type: textFieldType.accountName)
        observeTextFields(cell.passwordInfo, theIndexPath: indexPath, type: textFieldType.password)
        if self.isNew {
            cell.accountInfo.becomeFirstResponder()
            self.isNew = false
        }
        if isNewAccountTrigger && indexPath.row == accounts.count-1 {
            cell.accountInfo.becomeFirstResponder()
            isNewAccountTrigger = false
        }
        return cell
    }
    
}
