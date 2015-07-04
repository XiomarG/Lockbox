//
//  LockboxViewController.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-16.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit

var imageSize : CGSize?
var tempImage : UIImage?
var tempAccount : Account?

class LockboxViewController: UICollectionViewController {
    
    

    
    var boxes = [Lockbox]()
    var selectedBoxIndex : Int = 0
    
    var dataFilePath : String?
    
    var cellRadius = CGFloat()
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let reuseIdentifier = "lockboxCell"
    private let minCellSpacing = CGFloat(0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.loadDataFromFile() == false
        {
            //initializeTestData()
            addEmptyBox()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadDataFromFile()
        self.collectionView?.reloadData()

    }
    
    private func addEmptyBox() {
        boxes.append(Lockbox(accountName: "", password: ""))
    }
    
    private func refreshBoxes() {
        var boxesSize = boxes.count
        for (var index = 0; index < boxesSize; index++){
            if boxes[index].accounts.isEmpty {
                boxes.removeAtIndex(index)
                boxesSize = boxes.count
                index--
            }
        }
    }
    
    private func loadDataFromFile() -> Bool {
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as! String
        dataFilePath = docsDir.stringByAppendingPathComponent("data.archive")
        
        if filemgr.fileExistsAtPath(dataFilePath!) {
            let dataArray = NSKeyedUnarchiver.unarchiveObjectWithFile(dataFilePath!) as! [Lockbox]
            boxes = dataArray
            return true
        }
        else { return false }

    }

    
    private func initializeTestData() {
        boxes.append(Lockbox(accountName: "111", password: "bbb"))
        boxes.append(Lockbox(accountName: "222", password: "bbb"))
        boxes.append(Lockbox(accountName: "333", password: "bbb"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show detail" {
            if let sdvc = segue.destinationViewController as? boxInfoTableViewController {
                sdvc.delegate = self

                sdvc.accounts = boxes[selectedBoxIndex].accounts
                tempAccount = boxes[selectedBoxIndex].accounts[0]
                tempAccount = sdvc.accounts[0]
                sdvc.myName = boxes[selectedBoxIndex].appName
                sdvc.myImage = boxes[selectedBoxIndex].icon
                if selectedBoxIndex == boxes.count - 1 {
                    sdvc.isNew = true
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return boxes.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedBoxIndex = indexPath.row
        performSegueWithIdentifier("show detail", sender: nil)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LockboxViewCell
        
        var cellsize = cell.frame.size
        //cell.boxImage.frame.size = cell.frame.size
        //cell.boxImage.layer.cornerRadius = 9
        tempImage = boxes[indexPath.row].icon
        if indexPath.row < boxes.count - 1 {
            if boxes[indexPath.row].icon != nil {
                cell.boxImage.image = boxes[indexPath.row].icon
                imageSize = boxes[indexPath.row].icon!.size
                imageSize = cell.boxImage.image!.size
                //cell.boxImage.
            } else {
                cell.boxImage.image = UIImage(named: "defaultKeyImage")
            }
            //cell.backgroundColor = UIColor.blackColor()
        } else {
            cell.boxImage.image = UIImage(named: "myAddIcon")
            //cell.backgroundColor = UIColor.redColor()
        }
        cell.boxImage.layer.masksToBounds = true
        cell.boxImage.layer.cornerRadius = self.cellRadius
        return cell
    }
}

extension LockboxViewController : LXReorderableCollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView!, itemAtIndexPath fromIndexPath: NSIndexPath!, willMoveToIndexPath toIndexPath: NSIndexPath!) {
        let pickedBox = boxes[fromIndexPath.row]
        boxes.removeAtIndex(fromIndexPath.row)
        boxes.insert(pickedBox, atIndex: toIndexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView!, itemAtIndexPath fromIndexPath: NSIndexPath!, canMoveToIndexPath toIndexPath: NSIndexPath!) -> Bool {
        if fromIndexPath.row == boxes.count-1 {  return false }
            
        if toIndexPath.row == boxes.count-1   {  return false }
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView!, canMoveItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        if indexPath.row == boxes.count-1 { return false }
        return true
    }
    
    
    
}

extension LockboxViewController : LXReorderableCollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = collectionView.frame.size
        //let cellPerRow =
        size.width = (size.width - sectionInsets.left - sectionInsets.right - minCellSpacing * 2) / CGFloat(NSUserDefaults.standardUserDefaults().objectForKey("cell per row") as? Int ?? 3)
        size.height = size.width
        self.cellRadius = size.width / CGFloat(8.0)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minCellSpacing
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, didEndDraggingItemAtIndexPath indexPath: NSIndexPath!) {
        println("did end drag")
        NSKeyedArchiver.archiveRootObject(boxes, toFile: dataFilePath!)
    }
/*
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, didBeginDraggingItemAtIndexPath indexPath: NSIndexPath!) {
        println("did begin drag")
    }
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, willBeginDraggingItemAtIndexPath indexPath: NSIndexPath!) {
        println("will begin drag")
    }
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, willEndDraggingItemAtIndexPath indexPath: NSIndexPath!) {
        println("did begin drag")
    }
    */
    
}

extension LockboxViewController : BoxInfoTableViewControllerDelegate {
    func detailDidFinish(controller: boxInfoTableViewController, newAccounts: [Account], newAppName: String?, newAppIcon: UIImage?, checkNew: Bool) {
        imageSize = newAppIcon?.size
        boxes[selectedBoxIndex].appName = newAppName
        boxes[selectedBoxIndex].icon = newAppIcon
        boxes[selectedBoxIndex].accounts = newAccounts
        tempImage = newAppIcon
        imageSize = boxes[selectedBoxIndex].icon?.size
        if checkNew == true {
            addEmptyBox()
        }
        refreshBoxes()
        collectionView?.reloadData()
        NSKeyedArchiver.archiveRootObject(boxes, toFile: dataFilePath!)
        controller.navigationController?.popViewControllerAnimated(true)
    }
}
