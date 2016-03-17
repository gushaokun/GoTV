//
//  MediaInfoController.swift
//  GoTV
//
//  Created by Gavin on 16/3/2.
//  Copyright © 2016年 Gavin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class MediaInfoController: UITableViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    
    var actView:UIActivityIndicatorView?
    var mediaData:AnyObject?
    var albumContents:JSON?
    var backImageView:UIImageView?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var time_length: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var main_actor: UILabel!
    @IBOutlet weak var album_name: UILabel!
    @IBOutlet weak var ver_high_pic: UIImageView!
    @IBOutlet weak var album_desc: UILabel!
    
    @IBOutlet weak var headerCell: UITableViewCell!
    @IBOutlet weak var contentCell: UITableViewCell!
    @IBOutlet weak var contentTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var contentTitle: UILabel!
    
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
            self.loadContentInfo()
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        })
        alert.addAction(defaultAction)
        alert.addAction(retryAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsetsMake(-90, 0, -90, 0)
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 60, 0, 60)
        self.collectionView.remembersLastFocusedIndexPath = true
        self.loadBackGroundImageView()
        self.loadHeaderView()
        self.loadContentInfo()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadBackGroundImageView(){
        let bgImgUrl = mediaData!["hor_w8_pic"] as? String
        backImageView = UIImageView(frame: self.view.bounds)
        backImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        Alamofire.request(.GET,bgImgUrl!)
            .responseImage { response in
                debugPrint(response)
                
                if let image = response.result.value {
                    let newImage = image.applyTintEffectWithColor(UIColor(white: 0.5, alpha: 0.02))
                    dispatch_async(dispatch_get_main_queue(), {
                        self.backImageView?.image = newImage
                    })
                }
        }
        self.tableView.backgroundView = backImageView

    }
    
    func loadHeaderView(){
        
        let yearText = mediaData?["year"] as? Int
        let arearText = mediaData?["area"] as? String
        let langText = mediaData?["language"] as? String
        let time = mediaData!["time_length"]!!.intValue
        let directorText = mediaData?["director"] as? String
        let main_actorText = mediaData?["main_actor"] as? String
        let title = mediaData?["album_name"] as? String
        let picUrl = mediaData?["ver_high_pic"] as? String
        
        year.text = "年代：--"
        if let yearText = yearText {
            year.text = "年代：" + String(yearText) + "年"
        }
        area.text = "地区：--"
        if let arearText = arearText {
            area.text = "地区：" + arearText
        }
        language.text = "语言：--"

        if let langText = langText {
            language.text = "语言：" + langText
        }
        time_length.text = "时长：--"

        if let time = time {
            time_length.text = "时长：" + String(time/60)
        }
        director.text = "导演：--"
        if let directorText = directorText {
            director.text = "导演：" + directorText
        }
        main_actor.text = "主演：--"
        if let main_actorText = main_actorText {
            main_actor.text = "主演：" + main_actorText
        }
        album_name.text = ""
        if let title = title {
            album_name.text = title
        }
        if let picUrl = picUrl {
            ver_high_pic.af_setImageWithURL(NSURL(string:picUrl)!)
        }
    }
    
    func loadContentInfo(){
        
        let aid = String(mediaData?["aid"] as! Int)
        self.activityView().startAnimating()
        let url = "http://s1.api.tv.itc.cn/v4/album/videos/"+aid+".json?page_size=50&api_key=695fe827ffeb7d74260a813025970bd5&plat=3&partner=1&sver=5.3&poid=1&page=1&with_fee_video=3&"
        
        Alamofire.request(.GET, url).responseJSON(completionHandler: { (data:Response<AnyObject, NSError>) -> Void in
            self.activityView().stopAnimating()
            if data.result.isSuccess {
                let json = JSON(data.result.value!)
                if json["status"] == 200 {
                    self.albumContents = json.dictionaryValue["data"]?["videos"]
                    self.collectionView.reloadData()
                    debugPrint(self.albumContents)
                }else{
                    self.showAlert(json["statusText"].stringValue)
                }
                
            }else{
                let code = data.result.error?.code
                self.showAlert(String(code!))
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return headerCell
        }
        return contentCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 1000
        }
        return 1080 + 90
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let albumContents = albumContents {
            return albumContents.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(240, 280)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 60
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Album", forIndexPath: indexPath) as! AlbumCardCell
        let album = self.albumContents?.arrayObject![indexPath.row]
        let pic = album?["ver_high_pic"] as? String
        let name = album?["video_name"] as? String
        cell.albumPicView.af_setImageWithURL(NSURL(string:pic!)!)
        cell.albumTitle.text = name
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        let album = self.albumContents?.arrayObject![indexPath.row]
        self.showSourceQualityList(album,index: indexPath)
    }
    
    func showSourceQualityList(data:AnyObject?,index:NSIndexPath?){
        
        
        let hig =  data?["url_high"]
        let nor =  data?["url_nor"]
        let sup =  data?["url_super"]
//        let blue = data?["url_blue"]

        let playerControl = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("VideoPlayerController") as? VideoPlayerController
        playerControl?.albumContents = self.albumContents
        playerControl?.curPlayIndex = index!.row

        let alert = UIAlertController(title: "选择清晰度", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        if let nor = nor {
            nor?.stringValue
            let norAct = UIAlertAction(title: "标清", style:UIAlertActionStyle.Default, handler: { (act:UIAlertAction) -> Void in
                playerControl?.curPlayType = "nor"

                    self.navigationController?.tabBarController?.presentViewController(playerControl!, animated: true, completion: nil)
                    

            })
            alert.addAction(norAct)
        }
        
        if let hig = hig {
            
            hig?.stringValue
            let higAct = UIAlertAction(title: "高清", style:UIAlertActionStyle.Default, handler: { (act:UIAlertAction) -> Void in
                playerControl?.curPlayType = "hig"

                self.navigationController?.tabBarController?.presentViewController(playerControl!, animated: true, completion: nil)
                    
            })
            alert.addAction(higAct)
        }
        
        if let sup = sup
        {
            sup?.stringValue
            let supAct = UIAlertAction(title: "超清", style:UIAlertActionStyle.Default, handler: { (act:UIAlertAction) -> Void in
                playerControl?.curPlayType = "sup"

                self.navigationController?.tabBarController?.presentViewController(playerControl!, animated: true, completion: nil)

            })
            alert.addAction(supAct)
        }
//        if let blue = blue{
//            blue?.stringValue
//            let blueAct = UIAlertAction(title: "蓝光", style:UIAlertActionStyle.Default, handler: { (act:UIAlertAction) -> Void in
//                playerControl?.curPlayType = "blue"
//                self.navigationController?.tabBarController?.presentViewController(playerControl!, animated: true, completion: nil)
//                    
//            })
//            alert.addAction(blueAct)
//        }
        let cancAct = UIAlertAction(title: "返回", style:UIAlertActionStyle.Cancel, handler: { (act:UIAlertAction) -> Void in
           })
        alert.addAction(cancAct)
        if alert.actions.count > 0 {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
            
    }
    

    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        let view = context.nextFocusedView
        let classA = NSClassFromString("UICollectionViewCell")
        if view?.superclass == classA {
            coordinator.addCoordinatedAnimations({ () -> Void in
                dispatch_after(1, dispatch_get_main_queue(), { () -> Void in
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated:true)
                })

                }, completion: nil)

            
        }
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
