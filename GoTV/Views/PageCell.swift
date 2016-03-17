//
//  PageCell.swift
//  GoTV
//
//  Created by Gavin on 16/3/4.
//  Copyright © 2016年 Gavin. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    @IBOutlet weak var pageTitle: UILabel!
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 35
        self.contentView.clipsToBounds = true
        self.contentView.layer.borderColor = UIColor.whiteColor().CGColor
        self.contentView.layer.borderWidth = 1
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.pageTitle.transform = CGAffineTransformMakeScale(1.4, 1.4)
                self.pageTitle.textColor = UIColor.lightGrayColor()
                self.contentView.backgroundColor = UIColor(white: 1, alpha: 0.5)
                }, completion: nil)
        }else{
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.pageTitle.transform = CGAffineTransformMakeScale(1, 1)
                self.contentView.backgroundColor = UIColor(white: 1, alpha: 0)
                self.pageTitle.textColor = UIColor.whiteColor()
                }, completion: nil)
            
        }
    }

    
}
