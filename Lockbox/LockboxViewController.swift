//
//  LockboxViewController.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-16.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class LockboxViewController: UICollectionViewController {
    
    var boxes = [lockbox]()
    var selectedBoxIndex : Int = 0
    
    private let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    private let reuseIdentifier = "lockboxCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTestData()
        addEmptyBox()
    }
    
    private func addEmptyBox() {
        boxes.append(lockbox(name: "", account: "", password: ""))
    }
    
    private func initializeTestData() {
        boxes.append(lockbox(name: "fb", account: "111", password: "bbb"))
        boxes.append(lockbox(name: "fb", account: "222", password: "bbb"))
        boxes.append(lockbox(name: "fb", account: "333", password: "bbb"))
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show detail" {
            if let sdvc = segue.destinationViewController as? LockboxDetailViewController {
                sdvc.delegate = self
                sdvc.currentAccount = boxes[selectedBoxIndex].account
                sdvc.currentPassword = boxes[selectedBoxIndex].password
                if selectedBoxIndex == boxes.count {
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
        
        if indexPath.row < boxes.count - 1 {
        cell.backgroundColor = UIColor.blackColor()
        } else {
            cell.backgroundColor = UIColor.redColor()
        }
        print(indexPath.row)
    
        // Configure the cell
        print(boxes.count)
        
    
        return cell
    }
}

extension LockboxViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

extension LockboxViewController : DetailViewControllerDelegate {
    func ldvcDidFinish(controller: LockboxDetailViewController, newImage: UIImage?, newName: String?, newAccount: String?, newPassword: String?, checkNew : Bool) {
        if checkNew {
            boxes.append(lockbox(name: newName!, account: newAccount!, password: newPassword!))
        } else {
            boxes[selectedBoxIndex].updateInfoWith(nil, newName: newName, newAccount: newAccount!, newPassword: newPassword!)
            addEmptyBox()
            collectionView?.reloadData()
        }
        controller.navigationController?.popViewControllerAnimated(true)
    }
}
