//
//  VideoPlayerController.swift
//  GoTV
//
//  Created by Gavin on 16/3/4.
//  Copyright © 2016年 Gavin. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import SwiftyJSON

class VideoPlayerController: AVPlayerViewController ,AVPlayerViewControllerDelegate{
    
    var actView:UIActivityIndicatorView?
    var albumContents:JSON?
    var curPlayIndex:Int = 0
    var curPlayData:AnyObject?
    var curPlayType:String? = "nor"
    var backgroundImageView:UIImageView?
    var progressView:UIProgressView?
    var queuePlayer:AVQueuePlayer?
    var items:[AVPlayerItem] = []
    
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
//        let retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
//            alert.dismissViewControllerAnimated(true, completion: nil)
//            
//        })
        alert.addAction(defaultAction)
//        alert.addAction(retryAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for obj in albumContents! {
            let video = obj.1.dictionaryObject
            if let video = video {
                var url:String?
                if curPlayType! == "nor" {
                    let nurl = video["url_nor"] as? String
                    url = nurl
                }else if curPlayType! == "hig" {
                    let hurl = video["url_high"] as? String
                    url = hurl
                    
                }else if curPlayType! == "sup" {
                    let surl = video["url_super"] as? String
                    url = surl
                    
                }else if curPlayType! == "blue"{
                    let burl = video["url_blue"] as? String
                    url = burl
                }
                let item = AVPlayerItem(URL: NSURL(string: url!)!)
                items.append(item)
            }
        }
        self.loadProgressView()
    }
    
    func loadProgressView(){
//        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
//        progressView?.backgroundColor = UIColor.clearColor()
//        progressView?.tintColor = UIColor.clearColor()
//        progressView?.trackTintColor = UIColor.whiteColor()
//        self.requiresLinearPlayback = true
//        self.requiresFullSubtitles = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.playVideoWithData(self.curPlayIndex)
    }
    
    func playNextItem(){
        
        if self.albumContents?.count > self.curPlayIndex + 1 {
            self.curPlayIndex += 1
            self.playVideoWithData(self.curPlayIndex)
        }
    }
    
    func playPreItem(){
        
        if self.curPlayIndex - 1 >= 0 {
            self.curPlayIndex -= 1
            self.playVideoWithData(self.curPlayIndex)
        }
    }
    
    func playVideoWithData(index:Int){
        
        self.items.removeRange(Range(start: 0, end: index))
        self.player = AVQueuePlayer(items:items)
        self.player?.play()

    }
    
}
