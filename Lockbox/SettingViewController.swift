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
    
    var switchCollectionView : UICollectionView?
    let reuseIdentifier = "Switch Cell"
    var candidateImages = [UIImage?]()
    
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
        loadCandidates()
        boxPerRowLabel.textColor = systemTextColor
        boxPerRowNumber.textColor = systemTextColor
        boxPerRow = NSUserDefaults.standardUserDefaults().objectForKey("box per row") as? Int ?? 3
        stepper.value = Double(boxPerRow)
        boxPerRowNumber.text = "\(boxPerRow)"
        addCollectionView()
    }
    func loadCandidates() {
        var firstItem = backgroundImages.first
        var lastItem = backgroundImages.last
        
        candidateImages = backgroundImages
        
        candidateImages.insert(lastItem!, atIndex: 0)
        candidateImages.append(firstItem!)
    }
    
    
    func addCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = self.view.bounds.size
        layout.minimumInteritemSpacing = CGFloat(0)
        layout.minimumLineSpacing = CGFloat(0)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.automaticallyAdjustsScrollViewInsets = false
        switchCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        switchCollectionView!.dataSource = self
        switchCollectionView!.delegate = self
        switchCollectionView?.registerNib(UINib(nibName: "BackgroundSwitchCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        switchCollectionView?.pagingEnabled = true
        switchCollectionView?.backgroundColor = UIColor.whiteColor()
        switchCollectionView?.showsHorizontalScrollIndicator = false
        self.view.addSubview(switchCollectionView!)
        self.view.sendSubviewToBack(switchCollectionView!)
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
        switchCollectionView!.scrollToItemAtIndexPath(NSIndexPath(forItem: backgroundImageIndex + 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSUserDefaults.standardUserDefaults().setInteger(backgroundImageIndex, forKey: "Background Image Index")
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
}
