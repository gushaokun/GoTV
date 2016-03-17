//
//  SubCategoryController.swift
//  GoTV
//
//  Created by Gavin on 16/3/3.
//  Copyright © 2016年 Gavin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SubCategoryController: UITableViewController {

    var cate_id:String?
    var cate_code:String?
    var cate_name:String?
    var actView:UIActivityIndicatorView?
    var subChannels:JSON?
    
    func activityView()->UIActivityIndicatorView!{
        
        if let actView = actView {
            return actView
        }
        actView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        actView!.hidesWhenStopped = true
        actView!.center = self.view.center
        return actView
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.window!.addSubview(actView!)
    }
    func albumspliteControl()->AlbumSpliteController?{
        
        return self.splitViewController as? AlbumSpliteController
        
    }
    
    func showAlert(msg:String?){
        
        let alert = UIAlertController(title: "发生错误！", message: msg!, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        let retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
            self.loadSubCategories()
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        })
        alert.addAction(defaultAction)
        alert.addAction(retryAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
 
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.intilizedData()
        self.loadSubCategories()
        
    }
    
    func intilizedData(){
        
        self.title = self.albumspliteControl()?.title
        self.cate_code = self.albumspliteControl()?.cate_code
        self.cate_id = self.albumspliteControl()?.cate_id
        self.cate_name = self.albumspliteControl()?.cate_name
        
    }
    
    func loadSubCategories(){
        
        self.activityView().startAnimating()
        Alamofire.request(.GET, "http://open.mb.hd.sohu.com/v4/category/catecode/"+self.cate_id!+".json?api_key=5b0af1a8986b3acd80da84a7dda5da6c").responseJSON { (data:Response<AnyObject, NSError>) -> Void in
            self.subChannels = []
            self.activityView().stopAnimating()
            if data.result.isSuccess {
                let json = JSON(data.result.value!)
                if json["status"] == 200 {
                    self.subChannels = json["data"]
                    self.tableView.reloadData()
                    if self.subChannels?.count > 0 {
                        let indexPath = NSIndexPath.init(forRow: 0, inSection: 0)
                        self.tableView(self.tableView, didSelectRowAtIndexPath:indexPath)
                    }
                }else{
                    self.showAlert(json["statusText"].stringValue)
                }
            }else{
                self.showAlert(String(data.result.error?.code))
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let subChannels = subChannels {
            return subChannels.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SubChannel")
        // Configure the cell...
        let channel = subChannels!.arrayObject![indexPath.row] as? Dictionary<String,String>
        cell?.textLabel?.text = channel!["second_cate_name"]
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let detailControl = self.albumspliteControl()?.viewControllers.last as? AlbumListController
        let channel = subChannels?.arrayObject![indexPath.row] as? Dictionary<String,String>
        detailControl?.first_cate_code = channel!["first_cate_code"]!
        detailControl?.first_cate_name = channel!["first_cate_name"]!
        detailControl?.second_cate_code = channel!["second_cate_code"]!
        detailControl?.second_cate_name = channel!["second_cate_name"]!
        detailControl?.loadDataForPage()
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
