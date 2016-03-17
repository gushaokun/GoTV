//
//  RootTabBarController.swift
//  GoTV
//
//  Created by Gavin on 16/3/3.
//  Copyright © 2016年 Gavin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class RootTabBarController: UITabBarController {

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
    func showAlert(msg:String?){
        let alert = UIAlertController(title: "发生错误！", message: msg!, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        let retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
            self.loadRequest()
            alert.dismissViewControllerAnimated(true, completion: nil)

        })
        alert.addAction(defaultAction)
        alert.addAction(retryAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRequest()
        // Do any additional setup after loading the view.
    }
    
    func loadRequest(){
        self.activityView()?.startAnimating()
        Alamofire.request(.GET, "http://open.mb.hd.sohu.com/v4/category/pgc.jso?api_key=5b0af1a8986b3acd80da84a7dda5da6c").responseJSON { (data:Response<AnyObject, NSError>) -> Void in
            self.activityView().stopAnimating()
            if data.result.isSuccess {
                let json = JSON(data.result.value!)
                if json["status"] == 200 {
                    let channels = json["data"]
                    var controls:[UINavigationController] = []
                    for channel in channels {
                        let album_control = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("AlbumSpliteController") as! AlbumSpliteController
                        let nav = UINavigationController(rootViewController: album_control)
                        nav.navigationBar.hidden = true
                        let obj = channel.1.dictionaryValue
                        let cate_code = (obj["cate_code"])?.stringValue
                        let cate_id = (obj["cate_id"])?.stringValue
                        let cate_name =  (obj["cate_name"])?.stringValue
                        
                        album_control.cate_code = cate_code
                        album_control.cate_id = cate_id
                        album_control.cate_name = cate_name
                        album_control.title = album_control.cate_name
                        controls.append(nav)
                        if controls.count == 6{
                            break
                        }
                    }
                    self.viewControllers = controls
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
