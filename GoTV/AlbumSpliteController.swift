//
//  DocumentaryController.swift
//  GoTV
//
//  Created by Gavin on 16/3/1.
//  Copyright © 2016年 Gavin. All rights reserved.
//

import UIKit

class AlbumSpliteController: SourceTableController {
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.maximumPrimaryColumnWidth = 400
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let mediaInfo = segue.destinationViewController as? MediaInfoController
//    }
}
