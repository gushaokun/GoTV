//
//  SourceTableController.swift
//  GoTV
//
//  Created by Gavin on 16/3/2.
//  Copyright © 2016年 Gavin. All rights reserved.
//

import UIKit

class SourceTableController: UISplitViewController {

    var cate_id:String?
    var cate_code:String?
    var cate_name:String?
    var actView:UIActivityIndicatorView?
    
    func activityView()->UIActivityIndicatorView!{
        
        if let actView = actView {
            return actView
        }
        actView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        actView!.hidesWhenStopped = true
        actView!.center = self.view.center
        self.view.addSubview(actView!)
        return actView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
