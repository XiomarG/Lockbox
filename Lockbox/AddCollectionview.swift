//
//  AddCollectionview.swift
//  Lockbox
//
//  Created by XunGong on 2015-07-08.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import Foundation

var lastContentOffsetX : CGFloat = CGFloat(FLT_MIN)
extension SettingViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return candidateImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = switchCollectionView!.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BackgroundSwitchCell
        cell.switchImage.image = self.candidateImages[indexPath.row]
        return cell
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //var lastContentOffsetX = globalLastContentOffsetX
        if ( CGFloat(FLT_MIN) == lastContentOffsetX ) {
            lastContentOffsetX = scrollView.contentOffset.x
            return
        }
        
        var currentOffsetX = scrollView.contentOffset.x
        var currentOffsetY = scrollView.contentOffset.y
        
        var pageWidth = scrollView.frame.size.width
        var offset = pageWidth * CGFloat( self.candidateImages.count - 2 )
        
        if currentOffsetX < pageWidth && lastContentOffsetX > currentOffsetX {
            lastContentOffsetX = currentOffsetX + offset
            scrollView.contentOffset = CGPoint(x: lastContentOffsetX, y: currentOffsetY)
        } else if currentOffsetX > offset && lastContentOffsetX < currentOffsetX {
            lastContentOffsetX = currentOffsetX - offset
            scrollView.contentOffset = CGPoint(x: lastContentOffsetX, y: currentOffsetY)
        } else {
            lastContentOffsetX = currentOffsetX
        }
        
        backgroundImageIndex = Int(currentOffsetX / pageWidth) - 1
    }
}