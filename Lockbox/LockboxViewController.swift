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
    
    var boxes = [Lockbox]()
    var selectedBoxIndex : Int = 0
    
    private let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    private let reuseIdentifier = "lockboxCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTestData()
        addEmptyBox()
    }
    
    private func addEmptyBox() {
        boxes.append(Lockbox(accountName: "", password: ""))
    }
    
    private func initializeTestData() {
        boxes.append(Lockbox(accountName: "111", password: "bbb"))
        boxes.append(Lockbox(accountName: "222", password: "bbb"))
        boxes.append(Lockbox(accountName: "333", password: "bbb"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
        boxes.last?.accounts.append(Account(name: "sadds", password: "djsaf"))
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show detail" {
            if let sdvc = segue.destinationViewController as? boxInfoTableViewController {
                sdvc.delegate = self

                sdvc.accounts = boxes[selectedBoxIndex].accounts
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
        
        if indexPath.row < boxes.count - 1 {
        cell.backgroundColor = UIColor.blackColor()
        } else {
            cell.backgroundColor = UIColor.redColor()
        }
        return cell
    }
}

extension LockboxViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

extension LockboxViewController : BoxInfoTableViewControllerDelegate {
    func detailDidFinish(controller: boxInfoTableViewController, newAccounts: [Account], checkNew: Bool) {
        if checkNew == false {
            boxes[selectedBoxIndex].accounts = newAccounts
        } else
        {
            boxes.insert(Lockbox(newAccounts: newAccounts), atIndex: boxes.count-1)
            //addEmptyBox()
            collectionView?.reloadData()
        }
        controller.navigationController?.popViewControllerAnimated(true)
    }
}
