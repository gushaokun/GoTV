//
//  AlbumListController.swift
//  GoTV
//
//  Created by Gavin on 16/3/3.
//  Copyright © 2016年 Gavin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class AlbumListController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageToolBar: UIView!
    @IBOutlet weak var pageCollectionView: UICollectionView!
    @IBOutlet weak var pageCollectionWidth: NSLayoutConstraint!
    
    let pageSize = 20
    var curPage = 1
    var first_cate_code:String = ""
    var first_cate_name:String = ""
    var second_cate_code:String = ""
    var second_cate_name:String = ""
    var totalCount:Int = 0
    var albums:JSON?
    
    var actView:UIActivityIndicatorView?
    func showAlert(msg:String?){
        
        let alert = UIAlertController(title: "发生错误！", message: msg!, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        let retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
            self.loadDataForPage()
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        })
        alert.addAction(defaultAction)
        alert.addAction(retryAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    func activityView()->UIActivityIndicatorView!{
        
        if let actView = actView {
            return actView
        }
        actView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        actView!.center = CGPointMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds))
        actView!.hidesWhenStopped = true
        self.view.addSubview(actView!)
        return actView
    }
    
    func albumspliteControl()->AlbumSpliteController?{
        return self.splitViewController as? AlbumSpliteController
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.splitViewController?.title
        self.collectionView.contentInset = UIEdgeInsetsMake(80, 80, 0, 80)

        self.collectionView.remembersLastFocusedIndexPath = true
        // Do any additional setup after loading the view.
    }
    
    func loadDataForPage(){
        
        self.activityView().startAnimating()
        let params = ["api_key":"5b0af1a8986b3acd80da84a7dda5da6c","page_size":String(pageSize),"page":String(curPage),"cat":self.second_cate_code]
        
        Alamofire.request(.GET, "http://open.mb.hd.sohu.com/v4/category/channel/"+self.first_cate_code+".json", parameters:params , encoding: .URLEncodedInURL, headers: nil).responseJSON { (data:
            Response<AnyObject, NSError>) -> Void in
            
            self.activityView().stopAnimating()
            if data.result.isSuccess {
                let json = JSON(data.result.value!)
                if json["status"] == 200 {
                    self.albums = json["data"]["videos"]
                    self.totalCount = json["data"]["count"].intValue
                    self.collectionView.reloadData()
                    self.pageCollectionView.reloadData()
                    dispatch_after(1, dispatch_get_main_queue(), { () -> Void in
                        self.pageCollectionWidth.constant = (self.pageCollectionView.contentSize.width > self.view.frame.size.width - 100) ? (self.view.frame.size.width - 100) : (self.pageCollectionView.contentSize.width)
                        print("\(self.pageCollectionWidth.constant)")
                        self.view.layoutIfNeeded()

                    })
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let albums = albums {
            if collectionView == self.pageCollectionView {
                let page = (self.totalCount % pageSize == 0 ? self.totalCount/pageSize : self.totalCount/pageSize + 1)
                
                return page == 1 ? 0 : page
            }
            return albums.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == self.pageCollectionView {
            return CGSizeMake(70, 70)
        }

        return CGSizeMake(240, 330)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if collectionView == self.pageCollectionView {
            return 10
        }
        return 100
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if collectionView == self.pageCollectionView {
            return 0
        }
        return 20
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == self.pageCollectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Page", forIndexPath: indexPath)
            let pageLabel = cell.contentView.viewWithTag(110) as? UILabel
            pageLabel?.text = String(indexPath.row + 1)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Album", forIndexPath: indexPath) as! AlbumCardCell
        let album = self.albums?.arrayObject![indexPath.row]
        let pic = album!["ver_high_pic"] as? String
        let name = album!["album_name"] as? String
        cell.albumPicView.af_setImageWithURL(NSURL(string:pic!)!)
        cell.albumTitle.text = name
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.pageCollectionView {
            if curPage != (indexPath.row+1) {
                curPage = indexPath.row + 1
                self.loadDataForPage()
            }
            return
        }
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        let album = self.albums?.arrayObject![indexPath.row]
        let meidaInfo = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MediaInfoController") as? MediaInfoController
        meidaInfo?.mediaData = album
        self.splitViewController?.navigationController?.pushViewController(meidaInfo!, animated:true)
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {

        
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
