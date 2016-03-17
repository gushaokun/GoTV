//
//  AlbumCardCell.swift
//  GoTV
//
//  Created by Gavin on 16/3/3.
//  Copyright © 2016年 Gavin. All rights reserved.
//

import UIKit

class AlbumCardCell: UICollectionViewCell {
    
    @IBOutlet weak var albumPicView: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        var y = albumTitle.frame.origin.y
        if context.nextFocusedView == self {
            y += 20
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.albumTitle.transform = CGAffineTransformMakeScale(1.2, 1.2)
                self.albumTitle.frame = CGRectMake(self.albumTitle.frame.origin.x, y, self.albumTitle.frame.size.width, self.albumTitle.frame.size.height)

                }, completion: nil)
        }else{
            y -= 20
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.albumTitle.transform = CGAffineTransformMakeScale(1, 1)
                self.albumTitle.frame = CGRectMake(self.albumTitle.frame.origin.x, y, self.albumTitle.frame.size.width, self.albumTitle.frame.size.height)

                }, completion: nil)

        }
    }
    
}
