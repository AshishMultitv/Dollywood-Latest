//
//  PlayerViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 23/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import MXSegmentedPager
import AFNetworking
import AVKit
import AVFoundation
import M3U8Kit2
import Photos
import PhotosUI
import SwiftMessages
import Fuzi
import SAVASTParser
import SAJsonParser
import SAVideoPlayer
import SANetworking
import SAUtils
import SAModelSpace
import CoreTelephony
import GoogleInteractiveMediaAds







class PlayerViewController: UIViewController,MXSegmentedPagerDataSource,MXSegmentedPagerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate,IMAAdsLoaderDelegate, IMAAdsManagerDelegate,AVPictureInPictureControllerDelegate {
    
    @IBOutlet var scrollviewheighltcontrant: NSLayoutConstraint!
    @IBOutlet weak var myscroll: UIScrollView!
    @IBOutlet weak var myscroolview: UIView!
    @IBOutlet weak var titlenamelabel: UILabel!
    @IBOutlet weak var likelabel: UILabel!
    @IBOutlet weak var contantdiscriptionlabel: UILabel!
    @IBOutlet weak var expandbutton: UIButton!
    @IBOutlet weak var downloadbutton: UIButton!
    @IBOutlet weak var likebutton: UIButton!
    @IBOutlet weak var favraoutbutton: UIButton!
    @IBOutlet weak var sharebutton: UIButton!
    @IBOutlet weak var mytableview: UITableView!
    @IBOutlet weak var Resolutionbutton: UIButton!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var soundbutton: UIButton!
    @IBOutlet weak var forwardbutton: UIButton!
    @IBOutlet weak var backwordbutton: UIButton!
    @IBOutlet weak var backwordbuttonuppercnstraint: NSLayoutConstraint!
    @IBOutlet weak var discriptionlabeheightcontraint: NSLayoutConstraint!
    @IBOutlet weak var Bottomviewuppercnstraint: NSLayoutConstraint!
    @IBOutlet var Expendbuttonheightconstrnt: NSLayoutConstraint!
    
    
    var Video_url = String()
    var tilttext = String()
    var liketext = String()
    var likecount:Int = 0
    var descriptiontext = String()
    var cat_id = String()
    var catid = String()
    var cat_idarray = NSArray()
    var likeornot = String()
    var favornot = String()
    var mXSegmentedPager = MXSegmentedPager()
    var downloadVideo_url = String()
    var fromdownload = String()
    var Download_dic:NSMutableDictionary=NSMutableDictionary()


     var videoPlayer:AVPlayer!
    var lblEnd:UILabel = UILabel()
    var avLayer:AVPlayerLayer!
    var timer:Timer!
    var bEnlarge:Bool = Bool()
    var playbackSlider:UISlider!
    var lblLeft:UILabel = UILabel()
    var tempView:UIView!
    var expandBtn:UIButton = UIButton()
    var Skipbutton:UIButton = UIButton()
    var bFirstTime:Bool = Bool()
    var enlargeBtn:UIButton = UIButton()
    var enlargeBtnLayer:UIButton = UIButton()
    var activityIndicator:UIActivityIndicatorView=UIActivityIndicatorView()
    var bPlay:Bool = Bool()
    var bHideControl:Bool = Bool()
    var bSlideBar:Bool = Bool()
    var isshowmore:Bool = Bool()
    var moredataarray = NSArray()
    var recomdentdedataarray = NSArray()
    var ismore:Bool = Bool()
    var islike:Bool = Bool()
    var isfav:Bool = Bool()
    var videoresoulationtypearray:NSMutableArray=NSMutableArray()
    var videoresoulationurlarray:NSMutableArray=NSMutableArray()
    var dictionaryOtherDetail = NSDictionary()
    var devicedetailss =  NSDictionary()
    var shareurlnew = String()
    
    
    
    ////Download Video File////////
    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    
  ////sav parser
    
    var Event_dict:NSDictionary=NSDictionary()
    var isplayadd:Bool = Bool()
    var skiptimer = Timer()
    var skiptime:Int = 0
    var vastarray = NSArray()
    var ismidrolepresent:Bool = Bool()
    var midroletime = Float()
    var currentvideplayingtime = Float()
    var seletetedresoltionindex:Int = 0

    
    
    //////////////Google Ima Object////////
    var pictureInPictureController: AVPictureInPictureController?
    var pictureInPictureProxy: IMAPictureInPictureProxy?
    // IMA SDK handles.
    var contentPlayhead: IMAAVPlayerContentPlayhead?
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager?
    var companionSlot: IMACompanionAdSlot?
    var isplaydfturl:Bool = Bool()
    var Dfp_url = String()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(stopdownloadprogress), name: NSNotification.Name(rawValue: "CancelDownloading"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationDidBecomeActive, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.audioRouteChangeListener), name: .AVAudioSessionRouteChange, object: nil)


         let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        self.setmenu()
         print(catid)
        LoginCredentials.Videoid = cat_id
        DispatchQueue.global().async {

        self.getmorevideo()
        self.getuserrelatedvideo()
        }
        if(Common.Islogin())
        {
        Chekvideoisdownloading()
        }
    
        // Do any additional setup after loading the view.
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
    
        isshowmore = false
        AppUtility.lockOrientation([.portrait,.landscapeRight,.landscapeLeft])
        self.setvideodescription(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)

        if(Common.isInternetAvailable())
        {
        //GetVasthurl()
            getplayerurl()
        }
        else
        {
        self.setvideodata(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
         }
         if(!Common.isInternetAvailable())
        {
         if(self.fromdownload == "yes")
         {
         self.playvideo(url: "")
        }
        }
        ismore = true
    }
    
    
    
    func willResignActive(_ notification: Notification) {
       
        print(notification.object)
        
        
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            self.expandBtn.isHidden = true
             self.videoPlayer.play()
         }
        // code to execute
    }
    
    
    func audioRouteChangeListener(notification: Notification) {
        
        guard let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as? Int else { return }
        
        switch audioRouteChangeReason {
            
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.hashValue:
            //plugged out
            
            if(self.videoPlayer == nil)
            {
                
            }
            else
            {
                self.expandBtn.isHidden = true
                self.videoPlayer.play()
                
            }
            break
            
        default:
            break
            
        }
        
    }

    
    
    
    func getplayerurl()
    {
        Common.startloder(view: self.view)
        UIApplication.shared.endIgnoringInteractionEvents();

        //Common.startloderonplayer(view: self.view)
        var parameters = [String : Any]()
        var url = String()
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        LoginCredentials.VideoPlayingtime = 0

        
        if(Common.Islogin())
        {
            parameters = [ "content_id":cat_id,
                           "device":"ios",
                           "owner_info":"1",
                           "user_id": (dict.value(forKey: "id") as! NSNumber).stringValue
            ]
            
            
            
           // url = String(format: "%@%@/device/ios/content_id/%@/owner_info/1/user_id/%@/secure/1", LoginCredentials.Detailapi,Apptoken,cat_id,(dict.value(forKey: "id") as! NSNumber).stringValue)
            
              url = String(format: "%@%@/device/ios/content_id/%@/user_id/%@", LoginCredentials.Detailapi,Apptoken,cat_id,(dict.value(forKey: "id") as! NSNumber).stringValue)
            url = url.trimmingCharacters(in: .whitespaces)

        }
        else
        {
            parameters = [ "content_id":cat_id,
                           "device":"ios",
                           "owner_info":"1",
                           "user_id": ""]
           // url = String(format: "%@%@/content_id/%@/device/ios/owner_info/1/user_id", LoginCredentials.Detailapi,Apptoken,cat_id)
            
           
            url = String(format: "%@%@/device/ios/content_id/%@", LoginCredentials.Detailapi,Apptoken,cat_id)
            
            url = url.trimmingCharacters(in: .whitespaces)


        }
        
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        
        print(parameters)
        
         let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                Common.stoploder(view: self.view)
                LoginCredentials.Videoid = self.cat_id
                let dict = responseObject as! NSDictionary
                if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
                {
                    
                    return
                }
                 let detaildict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                print(detaildict)
                let downloadexpiry = ((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "download_expiry") as! NSString).integerValue
                self.Download_dic = (detaildict.value(forKey: "content") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                self.liketext = "\((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "likes_count") as! String)"
                self.descriptiontext = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "des") as! String
                self.likecount = Int(self.liketext)!
                 self.shareurlnew = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "share_url") as! String
             
                 if(Common.isNotNull(object: (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "url") as AnyObject?))
                {
                    self.Video_url = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "url") as! String
                    
                }
                else
                {
                    return
                }
              
                
                if((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "likes") as! String == "0")
                {
                    
                    self.likebutton.setImage(UIImage.init(named: "like"), for: .normal)
                    self.islike = false
                    
                }
                else
                {
                    self.likebutton.setImage(UIImage.init(named: "like1"), for: .normal)
                    self.islike = true
                    
                    
                }
                
                
                
                
                
                if((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "favorite") as! String == "0")
                {
                    
                    self.favraoutbutton.setImage(UIImage.init(named: "favriout"), for: .normal)
                    self.isfav = false
                    
                }
                else
                {
                    self.favraoutbutton.setImage(UIImage.init(named: "favriout1"), for: .normal)
                    self.isfav = true
                    
                    
                }

                
                
                
                
                
                
                
                
                
                
                
                self.setvideoinwatchlist()
           
                
                if Common.isNotNull(object: (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
                    
                    if(downloadexpiry > 0)
                    {
                    
                    self.downloadVideo_url = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "download_path") as! String
                    }
                    else
                    {
                        self.downloadVideo_url = ""

                    }
                    
                    
                }
                else
                {
                    self.downloadVideo_url = ""
                }
                
                
                if(Common.Islogin())
                {
                    
                    
                   
                
                    
                    if(self.fromdownload == "yes" || self.downloadVideo_url == "")
                    {
                        self.downloadbutton.isHidden = true
                        self.downloadbutton.isUserInteractionEnabled = true
                    }
                    else
                    {
                        self.downloadbutton.isHidden = false
                        self.downloadbutton.setImage(UIImage.init(named: "download"), for: .normal)
                        self.downloadbutton.isUserInteractionEnabled = true
                        
                        
                    }
                }
                
                if(Common.Islogin())
                {
                    self.Chekvideoisdownloading()
                }
                
                Common.startloder(view: self.view)
                UIApplication.shared.endIgnoringInteractionEvents();
                DispatchQueue.global().async {
                    self.GetVasthurl()
                }
                
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
        
        
    }

    
    
    
    func getcntantuserbehavior()
    {
        
        if(Common.Islogin())
        {
            var parameters = [String : Any]()
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            parameters = [ "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                           "content_id":cat_id,
                           "device":"ios"
            ]
            
            Common.startloder(view: self.view)
            UIApplication.shared.endIgnoringInteractionEvents();
            var url = String(format: "%@%@", LoginCredentials.Userbehaviorapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)
            url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!


            let manager = AFHTTPSessionManager()
            manager.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    
                    Common.stoploder(view: self.view)
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    let number = dict.value(forKey: "code") as! NSNumber
                    
                    if(number == 0)
                    {
                    }
                    else
                    {
                        let dict = Common.decodedresponsedata(msg: dict.value(forKey: "result") as! String)
                        print(dict)
                        
                        
                        
                        if(Common.Islogin())
                        {
                            
                            
                       
                            if((dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "likes") as! String == "0")
                            {
                                
                                self.likebutton.setImage(UIImage.init(named: "likedisable"), for: .normal)
                                self.islike = false
                                
                            }
                            else
                            {
                                self.likebutton.setImage(UIImage.init(named: "like"), for: .normal)
                                self.islike = true
                                
                                
                            }
                            
                            
                            
                            
                            
                            if((dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "favorite") as! String == "0")
                            {
                                
                                self.favraoutbutton.setImage(UIImage.init(named: "favriout"), for: .normal)
                                self.isfav = false
                                
                            }
                            else
                            {
                                self.favraoutbutton.setImage(UIImage.init(named: "favriout1"), for: .normal)
                                self.isfav = true
                                
                                
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }
            }
                )
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
                
            }
            
            
        }
        
        
    }
    
    
    
   
    
    //MARK:- //Create Player Session Api
    
    func CallplayerUsersesion()
    {
        
        
        let netInfo:CTTelephonyNetworkInfo=CTTelephonyNetworkInfo()
        let carrier = netInfo.subscriberCellularProvider
        let strResolution=String(format: "%.f*%.f", self.view.frame.size.width, self.view.frame.size.height)
        let systemVersion=UIDevice.current.systemVersion
        let appversion=Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        var networkname =  String()
        
        if(!Common.isNotNull(object: carrier?.carrierName as AnyObject?))
        {
            networkname = ""
        }
        else
        {
            networkname =  (carrier?.carrierName)! as String
        }
        
        dictionaryOtherDetail = [
            "os_version" : systemVersion,
            "network_type" : Common.getnetworktype(),
            "network_provider" : networkname,
            "app_version" : appversion!
        ]
        devicedetailss = [
            "make_model" : Common.getModelname(),
            "os" : "ios",
            "screen_resolution" : strResolution,
            "device_type" : "app",
            "platform" : "IOS",
            "device_unique_id" : uuid as String,//token! as! String,
            "push_device_token" :  LoginCredentials.DiviceToken
        ]
        print(dictionaryOtherDetail)
        print(devicedetailss)
        
        var json = [String:String]()
        if(Common.Islogin())
        {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            
            json=["od":Common.convertdictinyijasondata(data: dictionaryOtherDetail),"dd":Common.convertdictinyijasondata(data: devicedetailss),"id": cat_id,"type":"2","device":"ios","lat":"","long":"","user_id":(dict.value(forKey: "id") as! NSNumber).stringValue]
            
        }
        else
            
        {
            json=["od":Common.convertdictinyijasondata(data: dictionaryOtherDetail),"dd":Common.convertdictinyijasondata(data: devicedetailss),"id": cat_id,"type":"2","device":"ios","lat":"","long":""]
        }
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        
        // let parameters = ["device":"ios","customer_device":UserDefaults.standard.value(forKey: "UUID") as! String,"lat":"0" as String,"long":"0" as String,"ip":"0" as String,"token":Apptoken as String,"customer_id":dict.value(forKey: "id") as! String] as [String : Any]
        
        var url = String(format: "%@%@", LoginCredentials.Analyticsappapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!


        let manager = AFHTTPSessionManager()
        print(url)
        print(json)
        manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    
                }
                else
                {
                    LoginCredentials.Video_sid = ((dict.value(forKey: "result") as! NSDictionary).value(forKey: "app_session_id") as! NSNumber).stringValue
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "heartBeatapi"), object: nil)
                    
                    if(!Common.Islogin())
                    {
                        
                        Common.startheartbeat()
                    }
                }
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
        
        
    }
    

    
    
    
    
    func Chekvideoisdownloading()
    {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let array = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
        
        if(array.contains(cat_id))
        {
            animatedownloadbutton()
        }
        else
        {
         stopanimatedownliadbutton()
        }
    }
   
    
    
  func Chekvideoisfavornot()
  {
    if(Common.Islogin())
    {
    let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
    let favearray = dataBase.getfavrioutlvideoid(userid: dict.value(forKey: "id") as! String)
    
    if(favearray.contains(cat_id))
    {
        isfav = true
        self.favraoutbutton.setImage(UIImage.init(named: "favriout1"), for: .normal)

    }
    else
    {
        isfav = false
        self.favraoutbutton.setImage(UIImage.init(named: "favriout"), for: .normal)
 
    }
    
    }
    }
    
    
    
    func animatedownloadbutton()
    {
        let image1:UIImage = UIImage(named: "1")!
        let image2:UIImage = UIImage(named: "2")!
        let image3:UIImage = UIImage(named: "3")!
        let image4:UIImage = UIImage(named: "4")!
        let image5:UIImage = UIImage(named: "5")!
        let image6:UIImage = UIImage(named: "6")!
        let image7:UIImage = UIImage(named: "7")!
        downloadbutton.imageView?.animationImages = [image1,image2,image3,image4,image5,image6,image7]
        downloadbutton.imageView?.animationDuration = 1.0
        downloadbutton.imageView!.startAnimating()
        
    }
    func stopanimatedownliadbutton()
    {
        downloadbutton.imageView!.stopAnimating()
        downloadbutton.imageView?.cancelImageDownloadTask()
        downloadbutton.imageView?.stopAnimating()
        downloadbutton.setImage(UIImage.init(named: "download"), for: .normal)
 
    }
    
    
  //MARK:- Get parse data with url
    
    func GetVasthurl()
    {
         //self.CallplayerUsersesion()
       //  self.Chekvideoisfavornot()
         self.setvideodescription(titile: tilttext, like: liketext, des: descriptiontext, url: Video_url)
         Common.startloder(view: self.view)
        UIApplication.shared.endIgnoringInteractionEvents();

         Skipbutton.isHidden = true
        
       //   var url = String(format: "%@%@/device/ios/cid/%@/secure/1", LoginCredentials.Addetailapi,Apptoken,cat_id)
        
         var url = String(format: "%@%@/device/ios/secure/1/cid/%@", LoginCredentials.Addetailapi,Apptoken,cat_id)
       // http://staging.multitvsolution.com:9001/automatorapi/v6/ads/adDetail_enc/token/device/ios/secure/1/cid/70396/token/58eb522164a49
        
        url = url.trimmingCharacters(in: .whitespaces)
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

          let manager = AFHTTPSessionManager()
              manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                
                
                
                
                
               if(Common.isNotNull(object: dict.value(forKey: "result") as AnyObject?))
               {
                
                
                
                var decodedata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptAddetailapi)
                {
                    decodedata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    
                    decodedata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    
                }

                print(decodedata_dict)

                
                if(Common.isNotNull(object: decodedata_dict.value(forKey: "url") as AnyObject?))
                {
                   // self.Video_url = (decodedata_dict.value(forKey: "url") as! NSDictionary).value(forKey: "abr") as! String
                    //self.Video_url = "http://d3k3fsmaqsjau9.cloudfront.net/storage/dollywood/chunks/144_599aed608874e/144_599aed608874e_master.m3u8"
                    if(Common.isNotNull(object: decodedata_dict.value(forKey: "url") as AnyObject?))
                    {
                        if(Common.isNotNull(object: ((decodedata_dict.value(forKey: "url") as! NSDictionary).value(forKey: "dfp_url") as AnyObject?)))
                        {
                            self.Dfp_url = (decodedata_dict.value(forKey: "url") as! NSDictionary).value(forKey: "dfp_url") as! String
                            self.isplaydfturl = true
                        }
                        else
                        {
                            
                            self.isplaydfturl = false
                            
                        }
                    }
                    else
                        
                    {
                        self.isplaydfturl = false
                    }
                    
                    
                    self.setvideodata(titile: self.tilttext, like: self.liketext, des: self.descriptiontext, url:self.Video_url)
                    self.setvideodescription(titile: self.tilttext, like: self.liketext, des: self.descriptiontext, url:self.Video_url)
                    Common.stoploder(view: self.view)

             
             
                }
                else
               {
                let alert = UIAlertController(title: "", message: "Something went wrong please try again.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                }
              }
                }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
   
    }
    
    
    
    
    
    func calladdeventurl(url:String)
    {
        
     
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
        
    }
    
    
    
    
    
    func convertToDictionary(text: String) -> NSDictionary {
        let asd = NSDictionary()
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return asd
    }
    
  
    
    
    
    
    
    //MARK:- Start Download Method
    
    
   func stopdownloadprogress()
   {
    
    if downloadTask != nil{
        downloadTask.cancel()
    }
     }
    
    
    func downloadwithurl(urlstr:String)
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
         let url = URL(string: urlstr)!
        downloadTask = backgroundSession.downloadTask(with: url)
        downloadTask.resume()
        dataBase.savedownloadvideoid(id: cat_id, userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
   
    }
    
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        
        
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
        else
        {
            
            //  urlData.write(toFile: filePath, atomically: true)
  
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL)
    {
        
       let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
      let fileManager = FileManager.default
      let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
       let array = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
        print(array)
        let videoid = array.object(at: 0) as! String
           let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/\((dict.value(forKey: "id") as! NSNumber).stringValue)\(videoid).mp4"))
        do
        {
       try fileManager.moveItem(at: location, to: destinationURLForFile)
        self.Showpopupmsg(msg: "video downloading completed")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Downloadingvideo"), object: nil, userInfo: nil)
        dataBase.deletedownloadvideoid(videoid: videoid)
        self.stopanimatedownliadbutton()
         }
        catch
        {
           print("Getting issue in downloading")
        }
        

     }
    
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
     
          print(downloadTask.taskIdentifier)
          print(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
        
      //  progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    //MARK: URLSessionTaskDelegate
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?){
        downloadTask = nil
         if (error != nil) {
            print(error!.localizedDescription)
        }else{
            print("The task finished transferring data successfully")
        }
    }
    
    //MARK: UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }

    
    //MARK:- End Download Method
    func chekUserislogin()
    {
        
        if !Common.Islogin()
        {
            downloadbutton.isUserInteractionEnabled = false
            likebutton.isUserInteractionEnabled = false
            favraoutbutton.isUserInteractionEnabled = false
        }
        else
        {
            
            downloadbutton.isUserInteractionEnabled = true
            likebutton.isUserInteractionEnabled = true
            favraoutbutton.isUserInteractionEnabled = true
        }
        
        
        
    }
    
    @IBAction func TAptoExpenddiscriptiontext(_ sender: UIButton)
    {
 
        if !isshowmore
        {
            isshowmore = true
            let height =  self.calculateContentHeight(str: descriptiontext)
            print(height)
            self.discriptionlabeheightcontraint.constant = height
            expandbutton.setImage(UIImage.init(named: "uparraow"), for: .normal)
            scrollviewheighltcontrant.constant =  scrollviewheighltcontrant.constant + height
            Expendbuttonheightconstrnt.constant =  scrollviewheighltcontrant.constant + height
            self.perform(#selector(changeUI), with: self, afterDelay: 0.01)
            
        }
        else
        {
            self.discriptionlabeheightcontraint.constant = 40.0
            scrollviewheighltcontrant.constant =  482
            isshowmore = false
            expandbutton.setImage(UIImage.init(named: "downarrow"), for: .normal)
            self.perform(#selector(changeUI), with: self, afterDelay: 0.01)
             Expendbuttonheightconstrnt.constant = 40.0
            
        }
        
        
        
        
    }
    
    
    
    func changeUI() {
        
        mXSegmentedPager.frame.origin.y = expandbutton.frame.origin.y+18
        
    }
    
    func forcefullyrotateinlancescape()
    {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
    func calculateContentHeight(str:String) -> CGFloat{
        
        print(str)
         let maxLabelSize: CGSize = CGSize.init(width: self.view.frame.size.width - 26, height: 9999)
        let contentNSString = str as NSString
        let expectedLabelSize = contentNSString.boundingRect(with: maxLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "Ubuntu", size: CGFloat(14))! as UIFont], context: nil)
        print("\(expectedLabelSize)")
        return expectedLabelSize.size.height
        
    }
    
 
    
   
    
    func setvideodescription(titile:String,like:String,des:String,url:String)
    {
     
        
        if(fromdownload == "yes")
        {
            Resolutionbutton.isHidden = true
        }
        else
        {
            Resolutionbutton.isHidden = false
            
        }
        
          self.titlenamelabel.text = titile
        self.likelabel.text = "likes:\(like)"
        
        var discriptiontext = des
        discriptiontext = discriptiontext.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
         self.contantdiscriptionlabel.text = discriptiontext
        
    }
    
    
    func setvideodata(titile:String,like:String,des:String,url:String)
    {
 
        if(Common.isInternetAvailable())
        {
        getallresolutionview(url: url)
        }
        
      if(self.fromdownload == "yes")
      {
        
       }
        else
      {
        if(!Common.isInternetAvailable()) {
        
            return
        }
        }
        
        self.playvideo(url: url)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    
    func getallresolutionview(url:String)
    {
        
        
         DispatchQueue.global(qos: .background).async {
   
                self.parseallsteme(url: url)
            
        }
        
        
    }
    
    func playvideo(url:String)
    {
        print(url)
        var videoURL = URL(string:url)
        
        
        DispatchQueue.main.async { () -> Void in
            let rect = CGRect(origin: CGPoint(x: 0,y :-10), size: CGSize(width: self.view.frame.size.width, height: 200))
            
         
            
           if !self.isplayadd
           {
            if(self.fromdownload == "yes")
            {
             let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
                
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let url = NSURL(fileURLWithPath: path)
                let videoDataPath = url.appendingPathComponent("\((dict.value(forKey: "id") as! NSNumber).stringValue)\(self.cat_id).mp4")?.path
                 videoURL = URL(fileURLWithPath: videoDataPath!)
                print(videoURL)
                    
                
           }
                
            }
            
            let playerItem:AVPlayerItem = AVPlayerItem(url: videoURL!)
            
            
            if self.avLayer != nil
            {
                self.avLayer.removeFromSuperlayer()
                self.avLayer = nil
            }
            if self.videoPlayer != nil && (self.videoPlayer.currentItem != nil)
            {
                self.videoPlayer = nil
            }
            self.videoPlayer = AVPlayer(playerItem: playerItem)
            //            if #available(iOS 10.0, *) {
            //                self.videoPlayer.automaticallyWaitsToMinimizeStalling = false
            //            } else {
            //                // Fallback on earlier versions
            //            }
            self.avLayer = AVPlayerLayer(player:self.videoPlayer)
            self.avLayer.frame = rect
            self.avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            do
            {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            catch {
                // report for an error
            }
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(self.startplayingnotification), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: self.videoPlayer.currentItem)
            
            self.view.layer.addSublayer(self.avLayer)
            if(!self.isplaydfturl)
            {
                self.videoPlayer.play()
            }
            if (self.tempView != nil)
            {
                self.tempView.removeFromSuperview()
                self.tempView = nil
            }
            self.tempView = UIView(frame:CGRect(x:0, y:-10, width:self.view.frame.size.width+10, height:200))
            self.tempView.backgroundColor=UIColor.clear
            self.view.addSubview(self.tempView)
            
            
            
            if(self.isplaydfturl)
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
                    self.loadadssetting()
                    self.creategoogeima()
                    self.setUpIMA()
                    self.requestAdsWithTag(self.Dfp_url)
                })
                
            }
            
            
            if self.playbackSlider != nil
            {
                self.playbackSlider.removeFromSuperview()
            }
            self.playbackSlider = UISlider(frame:CGRect(x:39, y:157, width:self.view.frame.size.width-100, height:25))
            let leftTrackImage = UIImage(named: "sliderThumb")
            let minImage = UIImage(named: "lineRed")
            let maxImage = UIImage(named: "lineGray")
            self.playbackSlider.setThumbImage(leftTrackImage, for: .normal)
            self.playbackSlider.minimumValue = 0
            // playbackSlider.maximumValue = 100
            self.playbackSlider.setValue(0, animated: true)
            self.playbackSlider.setMaximumTrackImage(maxImage, for: .normal)
            self.playbackSlider.setMinimumTrackImage(minImage, for: .normal)
            let duration : CMTime = playerItem.asset.duration
            print(duration)
            let seconds : Float64 = CMTimeGetSeconds(duration)
            //playerViewController.player = player
            let endInterval = NSDate(timeIntervalSince1970:seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.ReferenceType.local
            dateFormatter.dateFormat = "HH:mm:ss"
            let dateTimeFromPublishedString = dateFormatter.string(from: endInterval as Date)
            if seconds != seconds
            {
                self.playbackSlider.maximumValue = Float(0.0)
            }
            else
            {
                self.playbackSlider.maximumValue = Float(seconds)
            }
            
            self.playbackSlider.isContinuous = true
            self.playbackSlider.tintColor = UIColor.green
            
            if (self.timer != nil)
            {
                self.timer.invalidate()
                self.timer = nil
            }
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
            //Swift 2.2 selector syntax
            self.playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
            self.view.addSubview(self.playbackSlider)
            
            self.view.bringSubview(toFront: self.tempView)
            self.view.bringSubview(toFront: self.playbackSlider)
            //duration
            let rectLeft = CGRect(origin: CGPoint(x: 2,y :175), size: CGSize(width: 35, height: 10))
            if self.lblLeft != nil
            {
                self.lblLeft.removeFromSuperview()
            }
            self.lblLeft.backgroundColor = UIColor.clear
            self.lblLeft.font = UIFont.systemFont(ofSize: 8)
            self.lblLeft.textColor = UIColor.white
            self.lblLeft.text = "00:00"
            self.lblLeft.frame = rectLeft
            self.tempView.addSubview(self.lblLeft)
            let timeDuration = Float(seconds)
            //singleTapped
            
            
            let singletap = UITapGestureRecognizer(target: self, action: #selector(self.singleTapped))
            singletap.numberOfTapsRequired = 1
             if !self.isplayadd
             {
            self.tempView.addGestureRecognizer(singletap)
            }
            
            let (hr,  minf) = modf (timeDuration / 3600)
            let (min, secf) = modf (60 * minf)
            let second:Float =  60 * secf
            let hoursString = String(hr)
            let minutesString = String(min)
            let secondString = String(second)
            let timeEnd = String(format: "%.0f:%.0f:%.0f", hr,min, second)
            
            let rectRight = CGRect(origin: CGPoint(x: self.tempView.frame.size.width-65,y :175), size: CGSize(width: 35, height: 10))
            if self.lblEnd != nil
            {
                self.lblEnd.removeFromSuperview()
            }
            self.lblEnd.backgroundColor = UIColor.clear
            self.lblEnd.font = UIFont.systemFont(ofSize: 8)
            
            if(timeEnd  == "nan:nan:nan")
            {
                self.lblEnd.text = ""
                
            }
            else
            {
                self.lblEnd.text = timeEnd as String
            }
            
            //self.lblEnd.text = timeEnd as String
            self.lblEnd.frame = rectRight
            self.lblEnd.textColor = UIColor.white
            self.tempView.addSubview(self.lblEnd)
            
            if self.expandBtn != nil
            {
                self.expandBtn.removeFromSuperview()
            }
            let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :97), size: CGSize(width: 40, height: 40))
            self.expandBtn.frame = rectMore
            self.expandBtn.addTarget(self, action: #selector(self.expandBtnAction), for: .touchUpInside)
            let image = UIImage(named:"pause")
            self.expandBtn.setImage(image, for: .normal)
            self.expandBtn.isHidden = true
            if self.enlargeBtn != nil
            {
                self.enlargeBtn.removeFromSuperview()
            }
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-20,y :173), size: CGSize(width: 10, height: 10))
            //expandPlayer
            let expandImage = UIImage(named: "expandPlayer")
            self.enlargeBtn.setImage(expandImage, for: .normal)
            self.enlargeBtn.frame = rectEnlarge
            self.enlargeBtn.addTarget(self, action: #selector(self.enlargeBtnAction), for: .touchUpInside)
            
            
            ///Skipbutton
            let skipEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-105,y :160), size: CGSize(width: 95, height: 30))
            self.Skipbutton.setTitle("SKIP", for: .normal)
            self.Skipbutton.setTitleColor(UIColor.white, for: .normal)
            self.Skipbutton.frame = skipEnlarge
            self.Skipbutton.backgroundColor = UIColor.black
            self.Skipbutton.addTarget(self, action: #selector(self.taptoskip), for: .touchUpInside)
            self.Skipbutton.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(16))
            Common.setbuttonborderwidth(button: self.Skipbutton, borderwidth: 1.0)
             self.tempView.addSubview(self.Skipbutton)
              self.Skipbutton.isHidden = true
               self.tempView.addSubview(self.expandBtn)
            self.tempView.bringSubview(toFront: self.expandBtn)
            
            self.tempView.addSubview(self.enlargeBtn)
            self.tempView.bringSubview(toFront: self.enlargeBtn)
            
            if self.enlargeBtnLayer != nil
            {
                self.enlargeBtnLayer.removeFromSuperview()
            }
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-70,y :120), size: CGSize(width: 120, height: 90))
            //expandPlayer
            let expandLayerImage = UIImage(named: "")
            self.enlargeBtnLayer.setImage(expandLayerImage, for: .normal)
            self.enlargeBtnLayer.frame = rectEnlargeLayer
            self.enlargeBtnLayer.addTarget(self, action: #selector(self.enlargeBtnAction), for: .touchUpInside)
            
            self.tempView.addSubview(self.enlargeBtnLayer)
            self.tempView.bringSubview(toFront: self.enlargeBtnLayer)
            self.backwordbutton.isHidden = true
            self.forwardbutton.isHidden = true
            self.soundbutton.isHidden = true
            self.backwordbuttonuppercnstraint.constant = 70.0
            self.Resolutionbutton.isHidden = true
            self.view.bringSubview(toFront: self.forwardbutton)
            self.view.bringSubview(toFront: self.backwordbutton)
            self.view.bringSubview(toFront: self.soundbutton)
            self.view.bringSubview(toFront: self.backbutton)
            self.view.bringSubview(toFront: self.Resolutionbutton)
            self.view.bringSubview(toFront: self.Skipbutton)
            if(self.fromdownload == "yes")
            {
              //self.startloader()
            }
            else
            {
                self.startloader()
   
            }
            
          self.rotateddd()
//            if !self.isplayadd
//            {
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
//                    self.singleTapped()
//                })
//            }
//            else{
//                
//               
//                 self.bHideControl = false
//                self.singleTapped()
//                
//            }
        }
        

    }
    
    
    
    
    func loadadssetting()
    {
        if (adsLoader != nil) {
            adsLoader = nil
        }
        let settings = IMASettings()
        settings.enableBackgroundPlayback = true;
        adsLoader = IMAAdsLoader(settings: settings)
        
    }
    
    func creategoogeima()
    {
        // Create content playhead
        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: self.videoPlayer)
        // Set ourselves up for PiP.
        pictureInPictureProxy = IMAPictureInPictureProxy(avPictureInPictureControllerDelegate: self);
        pictureInPictureController = AVPictureInPictureController(playerLayer: avLayer!);
        if (pictureInPictureController != nil) {
            pictureInPictureController!.delegate = pictureInPictureProxy;
        }
    }
    
    
    
    // MARK: IMA SDK methods
    
    // Initialize ad display container.
    func createAdDisplayContainer() -> IMAAdDisplayContainer
    {
        // Create our AdDisplayContainer. Initialize it with our videoView as the container. This
        // will result in ads being displayed over our content video.
        return IMAAdDisplayContainer(adContainer: self.tempView, companionSlots: nil)
    }
    
    
    
    
    // Initialize AdsLoader.
    func setUpIMA()
    {
        
        if (adsManager != nil) {
            adsManager!.destroy()
        }
        adsLoader.contentComplete()
        adsLoader.delegate = self
        
    }
    
    
    // Request ads for provided tag.
    func requestAdsWithTag(_ adTagUrl: String!) {
        
        print(adTagUrl)
        // Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: adTagUrl,
            adDisplayContainer: createAdDisplayContainer(),
            avPlayerVideoDisplay: IMAAVPlayerVideoDisplay(avPlayer: self.videoPlayer),
            pictureInPictureProxy: pictureInPictureProxy,
            userContext: nil)
        print(request)
        adsLoader.requestAds(with: request)
    }
    
    
    // Notify IMA SDK when content is done for post-rolls.
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        // Make sure we don't call contentComplete as a result of an ad completing.
        if ((notification.object as? AVPlayerItem) == self.videoPlayer!.currentItem) {
            adsLoader.contentComplete()
        }
    }
    
    
    // MARK: AdsLoader Delegates
    
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
        adsManager = adsLoadedData.adsManager
        adsManager!.delegate = self
        // Create ads rendering settings to tell the SDK to use the in-app browser.
        let adsRenderingSettings = IMAAdsRenderingSettings()
        adsRenderingSettings.webOpenerPresentingController = self
        // Initialize the ads manager.
        adsManager!.initialize(with: adsRenderingSettings)
    }
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        // Something went wrong loading ads. Log the error and play the content.
        print(adErrorData.adError.message)
        //isAdPlayback = false
        isplayadd = true

        if(self.videoPlayer != nil)
        {
            self.videoPlayer.play()
        }
        else
        {
            
        }
        
        removeLoaderAfter()
    }
    
    
    // MARK: AdsManager Delegates
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        print(event.typeString!)
        
        
        if(event.typeString! == "Started")
        {
            isplayadd = true
            removeLoaderAfter()
            self.bHideControl = false
            self.singleTapped()
        }
        
        switch (event.type) {
        case IMAAdEventType.LOADED:
            if (pictureInPictureController == nil ||
                !pictureInPictureController!.isPictureInPictureActive) {
                adsManager.start()
            }
            break
        case IMAAdEventType.PAUSE:
            print("PAUSE")
            break
        case IMAAdEventType.RESUME:
            print("RESUME")
            break
        case IMAAdEventType.TAPPED:
            print("TAPPED")
            break
        default:
            break
        }
    }
    
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        // Something went wrong with the ads manager after ads were loaded. Log the error and play the
        // content.
        print(error.message)
        //  isAdPlayback = false
        isplayadd = false
        if(self.videoPlayer != nil)
        {
            self.videoPlayer.play()
        }
        removeLoaderAfter()
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        // The SDK is going to play ads, so pause the content.
        isplayadd = false
        if(self.videoPlayer != nil)
        {
            self.videoPlayer.pause()
        }
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        // The SDK is done playing ads (at least for now), so resume the content.
        isplayadd = false
        if(self.videoPlayer != nil)
        {
            self.videoPlayer.play()
        }
        removeLoaderAfter()
    }
    
    
    
    
    
    
   
   func makeskipbuttonenalbel()
   {

     skiptime = skiptime + 1
    if(skiptime<6)
    {
        Skipbutton.isUserInteractionEnabled = false
    self.Skipbutton.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(12))
    Skipbutton.setTitle("Skip After \(skiptime) Sec", for: .normal)
    }
    else
    {
      Skipbutton.isUserInteractionEnabled = true
     self.Skipbutton.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(16))
       Skipbutton.setTitle("SKIP", for: .normal)
    }
    
    
    
    }
    
    
    func stopTimer() {
        skiptimer.invalidate()
        //timerDispatchSourceTimer?.suspend() // if you want to suspend timer
     }
    
    
  func taptoskip()
  {
    isplayadd = false
    Skipbutton.isHidden = true
    self.avLayer.removeFromSuperlayer()
    self.avLayer = nil
    self.videoPlayer = nil
    self.setvideodata(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
    
    if(ismidrolepresent)
    {
        playseektime(seektime: midroletime)
        ismidrolepresent = false
    }
    }
    
    func update()
    {
        if self.videoPlayer != nil && (self.videoPlayer.currentItem != nil)
        {
            
           
            
            let currentItem:AVPlayerItem = videoPlayer.currentItem!
            let duration:CMTime = currentItem.duration
            let videoDUration:Float = Float(CMTimeGetSeconds(duration))
            let currentTime:Float = Float(CMTimeGetSeconds(videoPlayer.currentTime()))
            
            
            
            
            
            
            if(Common.isInternetAvailable())
            {
                
                if(!isplayadd)
                {
                      let currentplayertimeint = Int(self.playbackSlider.value)
                    let currentplayertime = String(currentplayertimeint)
                     print("/////////////////////////////")
                     print("video current playing time -> \(currentplayertime)")
                    
                    LoginCredentials.VideoPlayingtime = currentplayertimeint
                }
                else
                {
                   self.bHideControl = false
                   self.singleTapped()
                }
            
            }
            
            if self.bSlideBar == true
            {
                let time = Int(currentTime)
                let timePlay = Int(self.playbackSlider.value)
                print("currentTime ",time)
                print("self.playbackSlider.value >>",timePlay)
                if time == timePlay {
                    self.bSlideBar = false
                }
            }
            else
            {
                self.playbackSlider.value = currentTime
            }
            
             currentvideplayingtime = self.playbackSlider.value
             
              let (hr,  minf) = modf (currentTime / 3600)
            let (min, secf) = modf (60 * minf)
            let second:Float =  60 * secf
            
            let time = String(format: "%.0f:%.0f:%.0f", hr,min, second)
            self.lblLeft.text = time
            
            // playerTime = Int(currentTime)
        }
    }
    //MARK:- Player Delegate
    
    
    func removeLoaderAfter()
    {
        self.stoploader()
    }
    func stoploader()
    {
        activityIndicator.removeFromSuperview()
    }
    func startplayingnotification(note: NSNotification)
    {
        print("note >>>",note.object)
        if(!self.isplaydfturl)
        {
       Common.stoploder(view: self.view)
       self.perform(#selector(removeLoaderAfter), with: nil, afterDelay: 1.0)
        }

        
    }
    
    
    
    
    func playerDidFinishPlaying(note: NSNotification)
    {
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }
      let myIP = IndexPath(row: 0, section: 0)
      playmorevideourl(indexPath: myIP)
    self.forcefullyrotateinlancescape()
        
    }
    
    
    
    
    
    
    func rotateddd()
    {
        if(self.avLayer != nil)
        {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            bEnlarge = true
            Bottomviewuppercnstraint.constant = 300.0
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
            self.avLayer.frame = rect
            backbutton.isHidden = true
            backwordbuttonuppercnstraint.constant = rect.size.height/2-20
            let rectPlay = CGRect(x:39, y:self.view.frame.size.height-34, width:self.view.frame.size.width-120, height:25)
            self.playbackSlider.frame = rectPlay
            let rectLeft = CGRect(origin: CGPoint(x: 2,y :self.view.frame.size.height-23), size: CGSize(width: 35, height: 10))
            lblLeft.frame = rectLeft
            let rectRight = CGRect(origin: CGPoint(x: self.view.frame.size.width-65,y :self.view.frame.size.height-23), size: CGSize(width: 35, height: 10))
            lblEnd.frame = rectRight
            expandBtn.isHidden = true
            let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :self.view.frame.size.height/2 - 35.0), size: CGSize(width: 40, height: 40))
            self.expandBtn.frame = rectMore
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-40,y :self.view.frame.size.height-34), size: CGSize(width: 30, height: 30))
            enlargeBtn.frame = rectEnlarge
            
            
             let skipEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-105,y :self.view.frame.size.height-35), size: CGSize(width: 95, height: 30))
            Skipbutton.frame = skipEnlarge
            
            
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-60,y :self.view.frame.size.height-64), size: CGSize(width: 90, height: 90))
            enlargeBtnLayer.frame = rectEnlargeLayer
            
            self.tempView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
            activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
            backwordbutton.isHidden = true
            forwardbutton.isHidden = true
            soundbutton.isHidden = true
            Resolutionbutton.isHidden = true
            self.view.bringSubview(toFront: enlargeBtn)
            self.view.bringSubview(toFront: enlargeBtnLayer)
            self.view.bringSubview(toFront: forwardbutton)
            self.view.bringSubview(toFront: backwordbutton)
            self.view.bringSubview(toFront: soundbutton)
            self.view.bringSubview(toFront: Resolutionbutton)
            
            bHideControl = true
            self.playbackSlider.isHidden = true
            self.lblLeft.isHidden = true
            self.lblEnd.isHidden = true
            self.enlargeBtn.isHidden = true
            self.enlargeBtnLayer.isHidden = true
            
            
            
            self.expandBtn.isHidden = true
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        {
            bEnlarge = false
            Bottomviewuppercnstraint.constant = 170.0
            
            print("Portrait")
            self.tempView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 200))
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 200))
            self.avLayer.frame = rect
            backbutton.isHidden = false
            let rectPlay = CGRect(x:39, y:157, width:self.view.frame.size.width-100, height:25)
            self.playbackSlider.frame = rectPlay
            expandBtn.isHidden = false
            let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :75), size: CGSize(width: 40, height: 40))
            self.expandBtn.frame = rectMore
            backwordbuttonuppercnstraint.constant = 60.0
            let rectLeft = CGRect(origin: CGPoint(x: 2,y :165), size: CGSize(width: 35, height: 10))
            lblLeft.frame = rectLeft
            let rectRight = CGRect(origin: CGPoint(x:self.view.frame.size.width-65,y :165), size: CGSize(width: 35, height: 10))
            lblEnd.frame = rectRight
            
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-30,y :165), size: CGSize(width: 10, height: 10))
            enlargeBtn.frame = rectEnlarge
            
            let skipEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-105,y :160), size: CGSize(width: 95, height: 30))
             Skipbutton.frame = skipEnlarge
            
            
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-70,y :120), size: CGSize(width: 120, height: 90))
            enlargeBtnLayer.frame = rectEnlargeLayer
            activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
        }
        }
    }
    
     func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        self.videoPlayer!.seek(to: targetTime)
        self.playbackSlider.value = Float(CGFloat(seconds))
        self.bSlideBar = true
        self.PlayPauseAction()
        
//        if self.videoPlayer!.rate == 0
//        {
//            self.videoPlayer?.play()
//        }
    }
    
  
    
    
    func PlayPauseAction()
    {
        if bPlay == true
        {
            bPlay = false
        }
        else
        {
            bPlay = true
            
        }
        
        self.expandBtnAction()
    }
    
    
    
    func playseektime(seektime:Float)
    {
         self.playvideo(url: Video_url)
        self.perform(#selector(playeseektime), with: nil, afterDelay: 3.0)
        
        
        
   }
    
  func playeseektime()
  {
   
    let seconds : Int64 = Int64(midroletime+10)
    let targetTime:CMTime = CMTimeMake(seconds, 1)
    self.videoPlayer!.seek(to: targetTime)
    self.playbackSlider.value = Float(CGFloat(seconds))
    self.bSlideBar = true
    if self.videoPlayer!.rate == 0
    {
        self.videoPlayer?.play()
    }

    }
    
    func singleTapped() {
        
    
        if bHideControl == true
        {
            
            // self.perform(#selector(self.removecontroleronvideofter3sec), with: self, afterDelay: 4)
            //            let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
            //            DispatchQueue.main.asyncAfter(deadline: when) {
            //
            //                self.removecontroleronvideofter3sec()
            //            }
            bHideControl = false
            self.playbackSlider.isHidden = false
            self.lblLeft.isHidden = false
            self.lblEnd.isHidden = false
            self.enlargeBtn.isHidden = false
            self.enlargeBtnLayer.isHidden = false
            backwordbutton.isHidden = false
            forwardbutton.isHidden = false
            soundbutton.isHidden = false
            Resolutionbutton.isHidden = false
            self.expandBtn.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                self.singleTapped()
                
            })
            
            
        }
        else
        {
            //  NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.removecontroleronvideofter3sec), object: nil)
            bHideControl = true
            self.playbackSlider.isHidden = true
            self.lblLeft.isHidden = true
            self.lblEnd.isHidden = true
            self.enlargeBtn.isHidden = true
            self.enlargeBtnLayer.isHidden = true
            backwordbutton.isHidden = true
            forwardbutton.isHidden = true
            soundbutton.isHidden = true
            Resolutionbutton.isHidden = true
            self.expandBtn.isHidden = true
        }
        
    }
    
    
    
    
    
    
    
    
    func enlargeBtnAction()
    {
        if bEnlarge == true {
            bEnlarge = false
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        else
        {
            bEnlarge = true
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
    }
    func expandBtnAction()
    {
        if(Common.isInternetAvailable())
        {
        
        if bPlay == true
        {
            self.videoPlayer.play()
            bPlay = false
            let image = UIImage(named:"pause")
            self.expandBtn.setImage(image, for: .normal)
            
        }
        else
        {
            self.videoPlayer.pause()
            bPlay = true
            let image = UIImage(named:"play")
            self.expandBtn.setImage(image, for: .normal)
            
        }
        }
    }
    
    func startloader()
    {
        
        
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.color = UIColor.red
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
        activityIndicator.startAnimating()
        self.tempView.addSubview(activityIndicator)
    }
    
    
    
    func setvideodescription()
    {
        
    }
    
    
    
    
    func getmorevideo()
    {
        let parameters = [
            "device": "ios",
            "cat_id": catid,
            "content_id":cat_id
            ] as [String : Any]
        print(parameters)
       // var url = String(format: "%@%@/device/ios/cat_id/%@/content_id/%@", LoginCredentials.Listapi,Apptoken,catid,cat_id)
        
        
         var url = String(format: "%@%@/device/ios/current_offset/0/max_counter/100/cat_id/%@", LoginCredentials.Listapi,Apptoken,catid)
         url = url.trimmingCharacters(in: .whitespaces)
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

         let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                var Catdata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptListapi)
                {
                    Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    
                }
                print(Catdata_dict)
                self.moredataarray = Catdata_dict.value(forKey: "content") as! NSArray
                self.mytableview.reloadData()
                Common.stoploder(view: self.view)
                
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
    }
    
    
    func getuserrelatedvideo()
    {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        var parameters = [String:String]()
         var url = String()
        if (dict.count>0)
        {
              url = String(format: "%@%@/device/ios/current_offset/0/max_counter/50/user_id/%@", LoginCredentials.Recomendedapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue)
        }
        else
        {
            parameters = [
                "device": "ios",
                "user_id": ""
            ]
           url = String(format: "%@%@/device/ios/current_offset/0/max_counter/50", LoginCredentials.Recomendedapi,Apptoken)
            
        }
          print(parameters)
        
        
        
      //  var url = String(format: "%@%@/device/ios", LoginCredentials.Recomendedapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!


        let manager = AFHTTPSessionManager()
        
        
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                var Catdata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptRecomendedapi)
                {
                    Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                print(Catdata_dict)
                self.recomdentdedataarray = Catdata_dict.value(forKey: "content") as! NSArray
                
                Common.stoploder(view: self.view)
                self.mytableview.reloadData()
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
    }
    
    

   
    @IBAction func Taptodownload(_ sender: UIButton)
    {
        if(Common.isInternetAvailable())
        {
       
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            
            if(downloadVideo_url == "")
            {
                EZAlertController.alert(title: "Can't Download This Video")
                return
                
            }
            
             let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let destinationURLForFile = URL(fileURLWithPath: path.appendingFormat("/\((dict.value(forKey: "id") as! NSNumber).stringValue)\(self.cat_id).mp4"))
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: destinationURLForFile.path) {
                print("FILE AVAILABLE")
                EZAlertController.alert(title: "This Video already exists in your download section")
                return

            } else
            {
                
                
                 let array = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
                 if(array.contains(cat_id))
                {
                 print("id is match")
                Showpopupmsg(msg: "\(tilttext) video already in downloading")
                }
                else
                {
                    self.saveDownloaddataincoredata()
                    Showpopupmsg(msg: "\(tilttext) video start downloading")
                    self.downloadwithurl(urlstr: self.downloadVideo_url)
                    self.animatedownloadbutton()
                }
    
            
                
//              DispatchQueue.global(qos: .background).async {
//                if let url = URL(string: self.downloadVideo_url),
//                    let urlData = NSData(contentsOf: url)
//                  {
//                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
//                    let filePath="\(documentsPath)/\(dict.value(forKey: "id") as! String)\(self.cat_id).mp4";
//                    DispatchQueue.main.async {
//                    urlData.write(toFile: filePath, atomically: true)
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Downloadingvideo"), object: nil, userInfo: nil)
//                    self.Showpopupmsg(msg: "\(self.tilttext) video complete downloading")
//                        
//                    }
//                }
//            }
            
        }
        }
        else
        {
            let alert = UIAlertController(title: "Dollywood Play", message: "Please login to watch videos on this app", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.destructive, handler: { action in
                self.gotologinpage()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        }
        else
        {
            EZAlertController.alert(title: "Please Check internet connection.")
        }
    }
    
    
    
    
    func gotologinpage()
    {
        
        
        
        if(Common.Islogin())
        {
            LoginCredentials.Video_sid = ""
            
        }
        else
        {
            Common.stopHeartbeat()
        }
        Common.callappanalytics()
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.afterbackaction()
        })
        
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    func Showpopupmsg(msg:String)
    {
        let view = MessageView.viewFromNib(layout:.MessageView)
        view.configureTheme(.info)
        view.configureDropShadow()
         view.configureContent(title: "Dollywood Play", body: msg, iconText:"")
        SwiftMessages.show(view: view)
    }
    
    
    func setvideoinwatchlist()
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            
            let asset = AVURLAsset(url: URL(string: Video_url)!)
            let duration: CMTime = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            print(durationTime)
            
            var parameters = [String:Any]()
                 parameters = [
                    "device": "ios",
                    "content_id":cat_id,
                    "c_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                     "total_duration":durationTime,
                     "duration":"0"
                    
                ]
         print(parameters)
            var url = String(format: "%@%@", LoginCredentials.watchdurationapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)
            url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!


            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    // let Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    // print(Catdata_dict)
               
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
            }
            
        }
        else
        {
            
        }
    }
    
    func saveDownloaddataincoredata()
    {
         DispatchQueue.global().async {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        print(self.Download_dic)
            var videoimage = NSData()
          if(Common.isNotNull(object: self.Download_dic.value(forKey: "thumb_url") as AnyObject))
          {
         let url = "\((self.Download_dic.value(forKey: "thumb_url") as! NSDictionary).value(forKey: "base_path") as! String)\((self.Download_dic.value(forKey: "thumb_url") as! NSDictionary).value(forKey: "thumb_path") as! String)"
         videoimage = try! NSData.init(contentsOf: URL(string: url)!)
        }
            else
          {
            videoimage = UIImagePNGRepresentation(#imageLiteral(resourceName: "Placehoder"))! as NSData
            }
        dataBase.SaveDownloadvideo(Userid: (dict.value(forKey: "id") as! NSNumber).stringValue, Videoid: self.cat_id, data: self.Download_dic, image:videoimage)
        }
        
    }
    
    @IBAction func Taptoshare(_ sender: UIButton) {
      if(Common.isInternetAvailable())
      {
     if(Common.isNotNull(object: Download_dic.value(forKey: "share_url") as AnyObject?))
     {
        let text = "I am watching this awesome video \(Download_dic.value(forKey: "share_url") as! String) on Dollywood Play. \n Visit Dollywood app on App Store"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.mail,UIActivityType.message,UIActivityType.copyToPasteboard,UIActivityType.assignToContact]
        self.present(activityViewController, animated: true, completion: nil)
        }
        }
        else
      {
        EZAlertController.alert(title: "Something went wrong please check your internet connection")

        }
    }
    
    
    
    
    
    
    
    @IBAction func Taptofav(_ sender: UIButton) {
        
        if(Common.isInternetAvailable())
        {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            
            var parameters = [String:String]()
            if(!isfav)
            {
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "favorite":"1",
                    "content_type":"video",
                ]
            }
            else
            {
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "favorite":"0",
                    "content_type":"video",
                ]
                
            }
            
            
            let logindict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            
            if(self.isfav)
            {
                //dataBase.deletefavvideoid(userid: logindict.value(forKey: "id") as! String, videoid: self.cat_id)
                 self.favraoutbutton.setImage(UIImage.init(named: "favriout"), for: .normal)
                self.isfav = false
            }
            else
            {
               // dataBase.savefavrioutvideoid(id: self.cat_id, userid: logindict.value(forKey: "id") as! String)
                self.favraoutbutton.setImage(UIImage.init(named: "favriout1"), for: .normal)
                 self.isfav = true
            }

            
            
            var url = String(format: "%@%@", LoginCredentials.Favrioutapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)
            url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!


            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    // let Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    // print(Catdata_dict)
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
            }
            
        }
        else
        {
            let alert = UIAlertController(title: "Dollywood Play", message: "Please login to watch videos on this app", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.destructive, handler: { action in
                self.gotologinpage()
            }))
            self.present(alert, animated: true, completion: nil)
  
        }
        }
        else
        {
            EZAlertController.alert(title: "Something went wrong please check your internet connection")
  
        }
    }
    
    @IBAction func Taptolike(_ sender: UIButton) {
        
        
        if(Common.isInternetAvailable())
        {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            var parameters = [String:String]()
            if(!islike)
            {
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "like":"1",
                    "content_type":"video",
                ]
            }
            else
            {
                
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "like":"0",
                    "content_type":"video",
                ]
            }
            
            
              if(self.islike)
            {
                self.likebutton.setImage(UIImage.init(named: "like"), for: .normal)
                islike = false
                
                
                if(self.likecount>0)
                {
                self.likelabel.text =   "likes:\(self.likecount - 1)"
                self.likecount = self.likecount-1
                }
             }
            else
            {
                self.likebutton.setImage(UIImage.init(named: "like1"), for: .normal)
                islike = true
                self.likelabel.text = "likes:\(self.likecount + 1)"
                self.likecount = self.likecount+1
 
            }
            
            
            var url = String(format: "%@%@", LoginCredentials.Likeapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)
            url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!


            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    // let Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    // print(Catdata_dict)
                    
                    
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
            }
            
        }
        else
        {
            let alert = UIAlertController(title: "Dollywood Play", message: "Please login to watch videos on this app", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.destructive, handler: { action in
                self.gotologinpage()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        }
        else
        {
            EZAlertController.alert(title: "Something went wrong please check your internet connection")
        }
        
    }
    @IBAction func Taptoback(_ sender: UIButton) {
        
        if(Common.Islogin())
        {
            LoginCredentials.Video_sid = ""
            
        }
        else
        {
            Common.stopHeartbeat()
        }
         Common.callappanalytics()
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }
        
       
        
        
        adsLoader = nil
        if (adsManager != nil)
        {
            adsManager!.destroy()
            adsManager = nil
        }
        

        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.afterbackaction()
         })
        
        
        
        do {
        
        let sucees =  try? (self.navigationController?.popViewController(animated: true))
         print(sucees)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func afterbackaction()
    {
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            self.avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }
  
    }
    
    
    
    
    func setmenu()
    {
        mXSegmentedPager = MXSegmentedPager.init(frame: CGRect.init(x: 0, y: expandbutton.frame.origin.y+18, width: self.view.frame.size.width, height: 41))
        mXSegmentedPager.segmentedControl.selectionIndicatorLocation = .down
        mXSegmentedPager.segmentedControl.backgroundColor = UIColor(red: CGFloat(58.0 / 255.0), green: CGFloat(58.0 / 255.0), blue: CGFloat(58.0 / 255.0), alpha: CGFloat(1))
        mXSegmentedPager.segmentedControl.selectionIndicatorColor = UIColor.red
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Ubuntu", size: 14.0) as Any]
        mXSegmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        //mXSegmentedPager.segmentedControlPosition = .bottom
        mXSegmentedPager.dataSource = self
        mXSegmentedPager.delegate = self
        self.myscroolview.addSubview(mXSegmentedPager)
        
    }
    
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int
    {
        return 2
    }
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String
    {
        switch index {
        case 0:
            return "More Videos"
        case 1:
            return "Related Videos"
        default:
            break
        }
        return ""
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView
    {
        let label = UILabel()
        return label
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWith index: Int)
    {
        switch index {
        case 0:
            ismore = true
            mytableview.reloadData()
            print(index)
            
        case 1:
            ismore = false
            mytableview.reloadData()
            print(index)
            
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        if ismore {
            return self.moredataarray.count
        }
        else
        {
            return self.recomdentdedataarray.count
            
        }
        
    }
    
    // cell height
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[0] as! Custometablecell
        cell.selectionStyle = .none
        Common.getRounduiview(view: cell.cellouterview, radius: 1.0)
        cell.cellouterview.backgroundColor = UIColor(red: CGFloat(58.0 / 255.0), green: CGFloat(58.0 / 255.0), blue: CGFloat(58.0 / 255.0), alpha: CGFloat(1))
        cell.cellouterview.layer.borderColor = UIColor.white.cgColor
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        Common.getRoundLabel(label:  cell.timelabel, borderwidth: 5.0)
        Common.getRounduiview(view: cell.timerview, radius: 5.0)

        Common.setlebelborderwidth(label: cell.timelabel, borderwidth: 1.0)
        cell.timelabel.layer.borderColor = UIColor.white.cgColor
        
        
        if ismore
        {
            
            cell.titlelabel.text = (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            
            
            if Common.isNotNull(object: (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "genre") as AnyObject)
            {
                cell.titletypwlabel.text = (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "genre") as? String
            }
            else
            {
                cell.titletypwlabel.text = ""
            }
            
            
            var discriptiontext = (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
            discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell.desciptionlabel.text = discriptiontext
            
            
            
            let arra = ((self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs")) as! NSArray
            
            
            
            if(arra.count>0)
            {
                if(((arra.object(at: 0) as! NSDictionary).value(forKey: "name") as! String) == "rectangle")
                {
                    
                    let dict = arra.object(at: 0) as! NSDictionary
                  let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                   let urlImg = URL(string:str)
                  cell.imageview?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
                    
                }
                else
                {
                    
                    let dict = arra.object(at: 1) as! NSDictionary
                   let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                     let urlImg = URL(string:str)
                   cell.imageview?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
                    
                }
            }
            
            
            
            
            
//            for i in 0..<arra.count
//            {
//                let dict = arra.object(at: i) as! NSDictionary
//                let name  = dict.value(forKey: "name") as! String
//                if(name == "rectangle")
//                {
//
//                    let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
//                cell.imageview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
//
//                }
//                else
//                {
//
//                }
//
//
//
//            }
          
            
            
            let videotime = (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
            let time = dateFormatter.date(from: videotime!)
            dateFormatter.dateFormat = "HH:mm:ss"
            var coverttime = dateFormatter.string(from: time!)
            print(coverttime)
            let fullNameArr = coverttime.components(separatedBy: ":")
            if((fullNameArr[0] as String) == "00")
            {
                if((fullNameArr[1] as String) == "00")
                {
                    coverttime = "\(fullNameArr[1]):\(fullNameArr[2]) sec"
                }
                else
                {
                    
                    coverttime = "\(fullNameArr[1]):\(fullNameArr[2]) min"
                }
            }
            else
            {
                coverttime = "\(fullNameArr[0]):\(fullNameArr[1]) hr"
            }
            
            cell.timelabel.text = coverttime
            
        }
        else
        {
            
            cell.titlelabel.text = (self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            
            
            if Common.isNotNull(object: (self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "genre") as AnyObject)
            {
                cell.titletypwlabel.text = (self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "genre") as? String
            }
            else
            {
                cell.titletypwlabel.text = ""
            }
            
            var discriptiontext = (self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
            discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell.desciptionlabel.text = discriptiontext
            
            let arra = ((self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs")) as! NSArray
            
            
            
            
            
            
            if(arra.count>0)
            {
                if(((arra.object(at: 0) as! NSDictionary).value(forKey: "name") as! String) == "rectangle")
                {
                    
                    let dict = arra.object(at: 0) as! NSDictionary
                    let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                    let urlImg = URL(string:str)
                    cell.imageview?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
                    
                }
                else
                {
                    
                    let dict = arra.object(at: 1) as! NSDictionary
                    let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                    let urlImg = URL(string:str)
                    cell.imageview?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
                    
                }
            }
            
            
            
            
//            for i in 0..<arra.count
//            {
//                let dict = arra.object(at: i) as! NSDictionary
//                let name  = dict.value(forKey: "name") as! String
//                if(name == "rectangle")
//                {
//                    
//                    let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
//                    cell.imageview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
//                }
//                else
//                {
//                    
//                }
//            }
   
            let videotime = (self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
            let time = dateFormatter.date(from: videotime!)
            dateFormatter.dateFormat = "HH:mm:ss"
            var coverttime = dateFormatter.string(from: time!)
            print(coverttime)
            let fullNameArr = coverttime.components(separatedBy: ":")
            if((fullNameArr[0] as String) == "00")
            {
                if((fullNameArr[1] as String) == "00")
                {
                    coverttime = "\(fullNameArr[1]):\(fullNameArr[2]) sec"
                }
                else
                {
                    
                    coverttime = "\(fullNameArr[1]):\(fullNameArr[2]) min"
                }
            }
            else
            {
                coverttime = "\(fullNameArr[0]):\(fullNameArr[1]) hr"
            }
            
            cell.timelabel.text = coverttime
            
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
   
        if Common.Islogin()
        {
             Common.callappanalytics()
            seletetedresoltionindex = 0

            
            if(self.videoPlayer == nil)
            {
                
            }
            else
            {
                avLayer.removeFromSuperlayer()
                self.videoPlayer.pause()
                
                self.videoPlayer = nil
            }
            midroletime = 0.0
            skiptime = 0
            self.bHideControl = false
            self.singleTapped()
            Download_dic.removeAllObjects()
            fromdownload = "no"
            if ismore
            {
               
                
                
                
                if(Common.isNotNull(object: (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "mature_content") as AnyObject?))
                {
                    
                    if((self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "mature_content") as! String == "1")
                    {
                        
                        
                        
                        let alert = UIAlertController(title: "Dollywood Play", message: "This video is rated adult by CBFC, India. Please confirm that you have read the Terms of Use of this service and you confirm that you are an adult", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                            self.playmorevideourl(indexPath: indexPath)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        self.playmorevideourl(indexPath: indexPath)
                    }
                }
                else
                {
                    self.playmorevideourl(indexPath: indexPath)
                }
                

                
                
                
                
            }
            else
            {
                
                
                
                
                if(Common.isNotNull(object: (self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "mature_content") as AnyObject?))
                {
                    
                    if((self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "mature_content") as! String == "1")
                    {
                        
                        
                        
                        let alert = UIAlertController(title: "Dollywood Play", message: "This video is rated adult by CBFC, India. Please confirm that you have read the Terms of Use of this service and you confirm that you are an adult", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                            self.playuserrelatedvideo(indexPath: indexPath)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        self.playuserrelatedvideo(indexPath: indexPath)
                    }
                }
                else
                {
                    self.playuserrelatedvideo(indexPath: indexPath)
                }
                

                
                
                
                
             }
        }
        else
        {
            let alert = UIAlertController(title: "Dollywood Play", message: "Please login to watch videos on this app", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.destructive, handler: { action in
                self.gotologinpage()
            }))
            self.present(alert, animated: true, completion: nil)
            
            
         }
        
        
    }
    
    
    
    func playmorevideourl(indexPath:IndexPath)
    {
        
     
        
       if(moredataarray.count>0)
       {
         self.cat_id = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        tilttext = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        descriptiontext = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
      
           
            let catdataarray = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
            
            if(catdataarray.count == 0)
            {
                catid = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
            }
            else
            {
                
                var ids = String()
                for i in 0..<catdataarray.count
                {
                    
                    let str = ((moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                    ids = ids + str + ","
                    
                }
                ids = ids.substring(to: ids.index(before: ids.endIndex))
                catid = ids
            }
  
        self.setvideodescription(titile: tilttext, like: "", des: descriptiontext, url:"")
        getplayerurl()
        self.getuserrelatedvideo()
        self.getmorevideo()
    
        }
    }
    
    
    
    func playuserrelatedvideo(indexPath:IndexPath)
    {
        
     
  
        self.cat_id = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        tilttext = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
         descriptiontext = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
         let catdataarray = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        
        if(catdataarray.count == 0)
        {
            catid = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
        }
            
        else
            
        {
            var ids = String()
            for i in 0..<catdataarray.count
            {
                
                let str = ((recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            catid = ids
            
        }
        

        
        self.setvideodescription(titile: tilttext, like: liketext, des: descriptiontext, url:"")
        getplayerurl()
        self.getuserrelatedvideo()
        self.getmorevideo()


        
        
  
    }
    
    @IBAction func Taptofarword5sec(_ sender: UIButton) {
        
        
        if(Common.isInternetAvailable())
        {
        let seconds : Int64 = Int64(playbackSlider.value + 5.0)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        print("seconds >>>",seconds)
        self.videoPlayer!.seek(to: targetTime)
        self.playbackSlider.value = Float(CGFloat(seconds))
        self.bSlideBar = true
        if self.videoPlayer!.rate == 0
        {
            self.PlayPauseAction()
            //self.videoPlayer?.play()
        }
        }
        
    }
    
    
    func seektovideoafterchagingresolution()
    {
        let seconds : Int64 = Int64(currentvideplayingtime + 5.0)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        print("seconds >>>",seconds)
        self.videoPlayer!.seek(to: targetTime)
        self.playbackSlider.value = Float(CGFloat(seconds))
        self.bSlideBar = true
        self.PlayPauseAction()
        
//        if self.videoPlayer!.rate == 0
//        {
//            self.videoPlayer?.play()
//        }
 
    }
    
    @IBAction func Taptobackword5sec(_ sender: UIButton)
    {
        if(Common.isInternetAvailable()) {
        
        if(playbackSlider.value < 5.0)
        {
            
        }
        else
        {
            let seconds : Int64 = Int64(playbackSlider.value - 5.0)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            self.videoPlayer!.seek(to: targetTime)
            self.playbackSlider.value = Float(CGFloat(seconds))
            self.bSlideBar = true
            if self.videoPlayer!.rate == 0
            {
                self.PlayPauseAction()
               // self.videoPlayer?.play()
            }
        }
        }
    }
    func parseallsteme(url:String)
    {
      
        if(!(Common.isNotNull(object: url as AnyObject?)) || (url == "") )
        {
            return
        }
        print(url)
        videoresoulationtypearray.removeAllObjects()
        videoresoulationurlarray.removeAllObjects()
        let typenadresolutionarray = NSMutableDictionary()

         let xStreamList = try! M3U8PlaylistModel.init(url:url).masterPlaylist.xStreamList
        let count1 = try! M3U8PlaylistModel.init(url:url).masterPlaylist.xStreamList.count
        for i in 0..<count1 {
            
            let str = (xStreamList?.xStreamInf(at: i).resolution.height)! as Float
            let str1 = "\(str.cleanValue)\("P")"
            typenadresolutionarray.setValue((xStreamList?.xStreamInf(at: i).m3u8URL())!, forKey: str1)
            
        }
        
         let reverser = typenadresolutionarray.sorted(by: { (a, b) in (a.value as! String) < (b.value as! String) })
        
        for i in 0..<reverser.count {
            videoresoulationtypearray.add(reverser[i].key)
            videoresoulationurlarray.add(reverser[i].value)
        }
        
        videoresoulationtypearray.insert("Auto", at: 0)
        videoresoulationurlarray.insert(url, at: 0)
    
    }
    
    func downloadSheet()
    {
        
        let orderedSet = NSOrderedSet(object: videoresoulationtypearray)
        print(orderedSet.array)
        
        let set = NSSet(array: [videoresoulationtypearray.mutableCopy()])
        videoresoulationtypearray.removeAllObjects()
        let array1:NSMutableArray=NSMutableArray()
        array1.add(set.allObjects)
        videoresoulationtypearray = (((array1.object(at: 0) as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray)
        
        
        let set1 = NSSet(array: [videoresoulationurlarray.mutableCopy()])
        videoresoulationurlarray.removeAllObjects()
        let array2:NSMutableArray=NSMutableArray()
        array2.add(set1.allObjects)
        videoresoulationurlarray = (((array2.object(at: 0) as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray)
        
        
        
        
        
        let actionSheet = UIActionSheet(title: "Video Quality", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        
        for i in 0..<videoresoulationtypearray.count {
            
            
            if(i == seletetedresoltionindex)
            {
                actionSheet.addButton(withTitle: "\(videoresoulationtypearray.object(at: i) as! String)\(" ✓")")
            }
            else
            {
                actionSheet.addButton(withTitle: videoresoulationtypearray.object(at: i) as? String)
            }
         }
        actionSheet.show(in: view)
        
        
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        print(buttonIndex)
        if buttonIndex>0 {
            
            if(self.videoPlayer == nil)
            {
                
            }
            else
            {
                avLayer.removeFromSuperlayer()
                self.videoPlayer.pause()
                self.videoPlayer = nil
            }
            self.isplaydfturl = false
             seletetedresoltionindex = buttonIndex-1
            self.playvideo(url: videoresoulationurlarray.object(at: buttonIndex-1) as! String)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                self.seektovideoafterchagingresolution()
                
            })
        }
    }
    
    @IBAction func Taptosound(_ sender: UIButton) {
        
        
        
        if (sender.currentImage?.isEqual(UIImage(named: "Unmute")))! {
            //do something here
            self.videoPlayer.isMuted = true
            sender.setImage(UIImage.init(named: "Mute"), for: .normal)
        }
        else
        {
            self.videoPlayer.isMuted = false
            sender.setImage(UIImage.init(named: "Unmute"), for: .normal)
        }
        
        
    }
    @IBAction func TaptoResolution(_ sender: UIButton) {
        
        self.downloadSheet()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
