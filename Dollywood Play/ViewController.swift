//
//  ViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 25/05/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import MXSegmentedPager
import AFNetworking
import MBProgressHUD
import Kingfisher
import SDWebImage


class ViewController: UIViewController,MXSegmentedPagerDataSource,MXSegmentedPagerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,ImageCarouselViewDelegate {
    
    @IBOutlet weak var srollviewviewhgtconstrant: NSLayoutConstraint!
    @IBOutlet weak var myscrollview: UIScrollView!
    @IBOutlet weak var imageCarouselView: ImageCarouselView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var scrollXpos: CGFloat = 0.0
    var images: [UIImage]!
    var cellView: UIView?
    var genreName: UILabel?
    var dummyLabel: UILabel?
    var cellImage: UIImageView?
    var button: UIButton?
    var morebutton: UIButton?
    var homebutton: UIButton?
    var dummyView: UIView?
    var timerview: UIView?
    var timelabel: UILabel?
    var playbutton: UIButton?
    var sectionValueBookIds = [Any]()
    var HomeData_dict:NSMutableDictionary = NSMutableDictionary()
    var sidemenudatadict:NSMutableDictionary = NSMutableDictionary()
    var Slidermenulist_dict:NSMutableDictionary = NSMutableDictionary()
    var Slidermenusegment_dict:NSMutableDictionary = NSMutableDictionary()
    var Catdata_dict:NSMutableDictionary = NSMutableDictionary()
    var mXSegmentedPager = MXSegmentedPager()
    var slidermenuarray = NSMutableArray()
    var slidermenu_ids = [String]()
    var collectionviewarray = NSArray()
    var Ishomedata = Bool()
    var Iscliptv = Bool()
    var Ismature_contant = Bool()
    var Ismoviepromo = Bool()
    var featurebanner = NSArray()
    var dummybutton: UIButton?
    
    
    //MARK:- View did Load
    
    
    override func viewDidLoad()
    {
        
        
        chekforceupgraorsoftupgrateapi()
        Common.startloder(view: self.view)
        super.viewDidLoad()
         AppUtility.lockOrientation(.portrait)
        self.setupcollectionview()
        Ishomedata = true
        Iscliptv = false
        Ismoviepromo = false
        self.getdatabaseresponse()
        NotificationCenter.default.addObserver(self, selector: #selector(clickcoresal), name: NSNotification.Name(rawValue: "clickoncoresal"), object: nil)
      }
    
 
    
    
    
    
    
    
    func chekforceupgraorsoftupgrateapi()
    {
        var url = String(format: "%@%@/device/ios", LoginCredentials.Versioncheckapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            let dict = responseObject as! NSDictionary
            print(dict)
            let resultCode = dict.object(forKey: "code") as! Int
            if resultCode == 1
            {
                
                let type = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "type") as! String
                let messege = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "message") as! String
                let apiversion = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "version") as! NSString
                
                
                let currentappvesrion = Bundle.main.releaseVersionNumber
                
                print(apiversion.floatValue)
                print(currentappvesrion!.floatValue)
                if(currentappvesrion!.floatValue<apiversion.floatValue)
                {
                    if(type == "soft")
                    {
                        self.softupdatealert(message: messege)
                    }
                    else if(type == "force")
                    {
                        self.forceupdatealert(message: messege)
                    }
                }
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            
        })
    }

    
    
    
    func softupdatealert(message:String)
    {
        let alert = UIAlertController(title: "Dollywood", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.goToappstore()
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    func forceupdatealert(message:String)
    {
        let alert = UIAlertController(title: "Dollywood", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (action) in
            self.goToappstore()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToappstore()
    {
        UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/in/app/dollywood-play/id1266574888?mt=8")! as URL)
    }
    
    
    
    
    func getdatabaseresponse()
    {
        self.sidemenudatadict = dataBase.getDatabaseresponseinentity(entityname: "Sidemenudata", key: "sidemenudatadict")
        self.HomeData_dict = dataBase.getDatabaseresponseinentity(entityname: "Homedata", key: "homedatadict")
        self.Slidermenulist_dict = dataBase.getDatabaseresponseinentity(entityname: "Slidermenu", key: "slidemenudict")
        if(self.sidemenudatadict.count>0)
        {
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Sidemenunotification"), object: self.sidemenudatadict)
        }
        else
        {
           self.getSidemenu()
        }
        
        if(self.HomeData_dict.count>0)
        {
            self.collectionviewarray =  (self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray
            self.featurebanner =  (self.HomeData_dict.value(forKey: "dashboard") as!  NSDictionary).value(forKey: "feature_banner") as! NSArray
            self.myCollectionView.reloadData()
            myscrollview.setContentOffset(CGPoint.zero, animated: true)
            let collectionheight = self.collectionviewarray.count*100
            srollviewviewhgtconstrant.constant = CGFloat(collectionheight) + 230.0
            self.setimageincarouseview()
            Common.stoploder(view: self.view)
        }
        else
        {
            self.callhomedatawebapi()
  
        }
        if(self.Slidermenulist_dict.count>0)
        {
            self.slidermenuarray.add("Home")
            for i in 0..<(self.Slidermenulist_dict.value(forKey: "vod")  as! NSArray).count {
                self.slidermenuarray.add((((self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "name") as! String))
                self.slidermenu_ids.append((((self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "id") as! String))
            }
            print(self.slidermenuarray)
            self.setmenu()
        }
        else
        {
           self.getslidermenudata()
        }
        
        
        
        
    }
    
    //MARK:- SetUp Collection view
    
    
    func setupcollectionview()
    {
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        myCollectionView.alwaysBounceVertical = true
        myCollectionView.backgroundColor = UIColor.init(colorLiteralRed: 61.0/255, green: 61.0/255, blue: 61.0/255, alpha: 1.0)
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "background_white")?.draw(in: view.bounds)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //view.backgroundColor = UIColor(patternImage: image!)
        navigationController?.navigationBar.barTintColor = UIColor.purple
        
    }
    
    
    
    //MARK:- Call Slidermenuapi
    
    func getslidermenudata()
    {
        let parameters = [
            "device": "ios",]
        
        var url = String(format: "%@%@/device/ios", LoginCredentials.catlistapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                if let _ = dict.value(forKey: "code")
                {
                    if(dict.value(forKey: "code") as! NSNumber == 0)
                    {
                        return
                    }
                }
                
                self.Slidermenulist_dict = ((dict.value(forKey: "result") as! NSDictionary).value(forKey: "cat") as! NSDictionary).mutableCopy()   as! NSMutableDictionary
                print(self.Slidermenulist_dict)
                dataBase.Savedatainentity(entityname: "Slidermenu", key: "slidemenudict", data: self.Slidermenulist_dict)
                
                self.slidermenuarray.add("Home")
                for i in 0..<(self.Slidermenulist_dict.value(forKey: "vod")  as! NSArray).count {
                    self.slidermenuarray.add((((self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "name") as! String))
                    self.slidermenu_ids.append((((self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "id") as! String))
                }
                print(self.slidermenuarray)
                self.setmenu()
                
                // self.mXSegmentedPager.reloadData()
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
        
    }
    
    //MARK:- Call Home Data Api
    
    func callhomedatawebapi()
    {
        
        let parameters = [
            "device": "ios",
            "content_count" : "9",
            "display_limit" : "6",
            "display_offset" : ""
        ]
    //var url = String(format: "%@%@/device/ios/content_count/5/display_limit/3/display_offset/", LoginCredentials.Homeapi,Apptoken)
        
     var url = String(format: "%@%@/device/ios/display_offset/0/display_limit/20/content_count/5", LoginCredentials.Homeapi,Apptoken)
        
        
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                
                
                if let _ = dict.value(forKey: "code")
                {
                    if(dict.value(forKey: "code") as! NSNumber == 0)
                    {
                        return
                    }
                }
                
                
                self.HomeData_dict.removeAllObjects()
                self.collectionviewarray = NSArray()
                
                 self.HomeData_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                 print(self.HomeData_dict)
                
                dataBase.Savedatainentity(entityname: "Homedata", key: "homedatadict", data: self.HomeData_dict)
                
                self.collectionviewarray =  (self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray
                let collectionheight = self.collectionviewarray.count*100
                self.srollviewviewhgtconstrant.constant = CGFloat(collectionheight) + 230.0
                
                 self.featurebanner =  (self.HomeData_dict.value(forKey: "dashboard") as!  NSDictionary).value(forKey: "feature_banner") as! NSArray
                 self.myscrollview.setContentOffset(CGPoint.zero, animated: true)
                self.myCollectionView.reloadData()
                 self.setimageincarouseview()
                Common.stoploder(view: self.view)
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    //MARK:- Get Side Menu
    
    func getSidemenu()
    {
        
        let parameters = [
            "device": "ios",
            ]
        var url = String(format: "%@%@/device/ios", LoginCredentials.MenuAPi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)

        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                if(LoginCredentials.IsencriptMenuAPi)
                {
                    self.sidemenudatadict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    self.sidemenudatadict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                
                
                 print(self.sidemenudatadict)
                 dataBase.Savedatainentity(entityname: "Sidemenudata", key: "sidemenudatadict", data: self.sidemenudatadict)
                 print(self.sidemenudatadict)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Sidemenunotification"), object: self.sidemenudatadict)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    
    //MARK:- Get catlistdata
    
    func Getcatlistdata(id:String)
    {
        
        
        
        let parameters = [
            "device": "ios",
            "cat_id": id,
            "content_count": "20",
            "display_limit" : "20"
            ] as [String : Any]
        
     

        
        var url = String(format: "%@%@/device/ios/current_offset/0/max_counter/100/cat_id/%@", LoginCredentials.Listapi,Apptoken,id)
        
        
        
        
        
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                
                
                if let _ = dict.value(forKey: "code")
                {
                    if(dict.value(forKey: "code") as! NSNumber == 0)
                    {
                        return
                    }
                }
                
     
                self.Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSDictionary as! NSMutableDictionary
                dataBase.Savecatlist(entityname: "Catlistdata", id: id, key: "catlistdatadict", data: self.Catdata_dict)
                 print(self.Catdata_dict)
                self.collectionviewarray = NSArray()
                self.featurebanner = NSArray()
                self.featurebanner = (self.Catdata_dict.value(forKey: "feature") as! NSArray)
                self.collectionviewarray = (self.Catdata_dict.value(forKey: "content") as! NSArray)
                self.setimageincarouseview()
                self.myCollectionView.reloadData()
                self.myscrollview.setContentOffset(CGPoint.zero, animated: true)
                 Common.stoploder(view: self.view)
                
                
                
                
                
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    //MARK:- Init Slider menu
    
    
    func setmenu()
    {
        
        
        mXSegmentedPager = MXSegmentedPager.init(frame: CGRect.init(x: 0, y: 65, width: self.view.frame.size.width, height: 41))
        mXSegmentedPager.segmentedControl.selectionIndicatorLocation = .down
        mXSegmentedPager.segmentedControl.backgroundColor = UIColor.init(colorLiteralRed: 61.0/255, green: 61.0/255, blue: 61.0/255, alpha: 1.0)
        mXSegmentedPager.segmentedControl.selectionIndicatorColor = UIColor.red
         
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        mXSegmentedPager.segmentedControl.segmentWidthStyle = .dynamic
          mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Ubuntu", size: 14.0) as Any]
        mXSegmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
         //mXSegmentedPager.segmentedControlPosition = .bottom
        mXSegmentedPager.dataSource = self
        mXSegmentedPager.delegate = self
        self.view.addSubview(mXSegmentedPager)
        
    }
   //MARK:-   Zonerbutton action 
    
    @IBAction func TaptoZoner(_ sender: UIButton) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let zonerViewController = storyboard.instantiateViewController(withIdentifier: "ZonerViewController") as! ZonerViewController
        self.navigationController?.pushViewController(zonerViewController, animated: true)
    }
    //MARK:-   Collection view delegate method
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if Ishomedata
        {
            return collectionviewarray.count
        }
        else
        {
            return (Slidermenusegment_dict.value(forKey: "children") as! NSArray).count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: HomeCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HomeCollectionViewCell)
        for viewObject: UIView in (cell?.contentView.subviews)! {
            if (viewObject is UILabel) {
                viewObject.removeFromSuperview()
            }
        }
        
        
       
        Ismature_contant = true
        if Ishomedata
        {
            
            dummyLabel = UILabel(frame: CGRect(x: CGFloat(0.15*CGFloat(view.frame.size.width)), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(30)))
            print(collectionviewarray.object(at: indexPath.section))
            dummyLabel?.text = ((collectionviewarray.object(at: indexPath.section)) as AnyObject).value(forKey: "cat_name") as? String
             dummyLabel?.textAlignment = .left
            dummyLabel?.textColor = UIColor.white
            dummyLabel?.numberOfLines = 0
            dummyLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(16))
            dummyLabel?.adjustsFontSizeToFitWidth = true
            dummybutton = UIButton(frame: CGRect(x: 0, y: 0.0, width: 0, height: 0))
            homebutton = UIButton.init()
            homebutton = UIButton(frame: CGRect(x: 0, y: 0.0, width: 0, height: 0))
            morebutton = UIButton(frame: CGRect(x: CGFloat(view.frame.size.width-25), y: 4.0, width: 50.0, height: 22.0))
           // Common.setbuttonborderwidth(button: morebutton!, borderwidth: 1.0)
            morebutton?.setTitle("More", for: .normal)
            morebutton?.titleLabel?.textAlignment = .center
            morebutton?.tag = indexPath.section
            morebutton?.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(12))
            morebutton?.setTitleColor(UIColor.white, for: .normal)
            morebutton?.backgroundColor = UIColor(red: CGFloat(28.0 / 255.0), green: CGFloat(27.0 / 255.0), blue: CGFloat(26.0 / 255.0), alpha: CGFloat(1))
             morebutton?.addTarget(self, action: #selector(taptomore), for: .touchUpInside)
            dummybutton?.tag = indexPath.section
            homebutton?.tag = indexPath.section
             cell?.contentView.addSubview(dummyLabel!)
            cell?.contentView.addSubview(morebutton!)
            cell?.contentView.addSubview(dummybutton!)
            
            
            
            
            
            cell?.collectionScroll.contentSize = CGSize(width: CGFloat((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).count * 100) + 170), height: CGFloat((cell?.frame.size.height)!))
            for viewObject: UIView in (cell?.collectionScroll.subviews)! {
                viewObject.removeFromSuperview()
            }
            scrollXpos = 0.13*CGFloat(view.frame.size.width)

            for i in 0..<((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).count
            {
                print(((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i))
                
        
                cellView = UIView(frame: CGRect(x: CGFloat(scrollXpos), y: CGFloat(0), width: CGFloat(120), height: CGFloat(180)))
                scrollXpos += 110
                cell?.collectionScroll.addSubview(cellView!)
                dummyView = UIImageView(frame: CGRect(x: CGFloat(5), y: CGFloat(30), width: CGFloat(100), height: CGFloat(140)))
                dummyView?.layer.borderColor = UIColor(red: CGFloat(99.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: CGFloat(1)).cgColor
                //dummyView?.layer.borderWidth = 1.0
              //  dummyView?.layer.cornerRadius = 6
               // dummyView?.clipsToBounds = true
                
                button = UIButton(type: .custom)
                button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
               // ((sectionValueBookIds[indexPath.section] as! [Any])[i] as! Int)
                button?.tag = i
                button?.setTitle("", for: .normal)
                button?.frame = CGRect(x: CGFloat(5), y: CGFloat(30), width: CGFloat(100), height: CGFloat(140))
                cellImage = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(30), width: CGFloat(100), height: CGFloat(140)))
                
                let arra = ((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumbs")) as! NSArray
                if(arra.count>0)
                {
                if(((arra.object(at: 0) as! NSDictionary).value(forKey: "name") as! String) == "verticle_rectangle")
                {
                  
                  let dict = arra.object(at: 0) as! NSDictionary
                 let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                  let urlImg = URL(string:str)
                 cellImage?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
                    
                }
                else
                {
                  
                    let dict = arra.object(at: 1) as! NSDictionary
                    let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                    let urlImg = URL(string:str)
                    cellImage?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
                    
                }
                }
                
//                for i in 0..<arra.count
//                {
//                   let dict = arra.object(at: i) as! NSDictionary
//                  let name  = dict.value(forKey: "name") as! String
//                    if(name == "verticle_rectangle")
//                    {
//
//                   let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
//                  //  cellImage?.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
//                   let urlImg = URL(string:str)
//                     cellImage?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
//
//
//
//                    }
//                    else
//                    {
//
//                    }
//
//                }
                
                
                
              //  let str  = (((((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumbs") as? NSArray)?.object(at: 1) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String)
              //  cellImage?.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
                
                
                //cellImage?.setImageWith(URL(string: str)!)
               // cellImage?.layer.cornerRadius = 6
                //cellImage?.clipsToBounds = true
                genreName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)! + 10), width: CGFloat(90), height: CGFloat(20)))
                genreName?.text = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "title") as? String
                genreName?.textColor = UIColor.white
                genreName?.numberOfLines = 0
                genreName?.font = UIFont(name: "Ubuntu", size: CGFloat(13))
                // genreName?.adjustsFontSizeToFitWidth = true
                
                
                timerview = UIView(frame: CGRect(x: (cellImage?.frame.size.width)!-60, y: (cellImage?.frame.size.height)!+5, width: 60, height: 20))
                timerview?.backgroundColor = UIColor.black
                timerview?.alpha = 0.50
                Common.getRounduiview(view: timerview!, radius: 5.0)
                Common.setuiviewdborderwidth(View: timerview!, borderwidth: 2.0)
                
                timelabel = UILabel(frame: CGRect(x: (timerview?.frame.origin.x)!, y: (timerview?.frame.origin.y)!, width: (timerview?.frame.size.width)!, height: (timerview?.frame.size.height)!))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
               let videotime = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "duration") as? String
                let time = dateFormatter.date(from: videotime!)
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
                
                timelabel?.text = coverttime

                
               // timelabel?.text = "04.20 min"
                timelabel?.font = UIFont(name: "Ubuntu", size: CGFloat(12))
                timelabel?.textAlignment = .center
                timelabel?.textColor = UIColor.white
                
              playbutton = UIButton(frame: CGRect(x: 5, y: (cellImage?.frame.size.height)!+5, width: 20, height: 20))
              playbutton?.setImage(UIImage.init(named: "playicon"), for: .normal)
                
                
                cellView?.addSubview(button!)
                cellView?.addSubview(cellImage!)
                cellView?.addSubview(genreName!)
                cellView?.addSubview(dummyView!)
                cellView?.addSubview(timerview!)
                cellView?.addSubview(timelabel!)
                cellView?.addSubview(playbutton!)
                cell?.contentView.addSubview(homebutton!)

            }
        }
        else
        {
           
            
            dummyLabel = UILabel(frame: CGRect(x: CGFloat(0.15*CGFloat(view.frame.size.width)), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(30)))
            
            print(collectionviewarray.object(at: indexPath.section))
            dummyLabel?.text = ((((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: indexPath.section) as! NSDictionary).value(forKey: "name")) as? String)
            dummyLabel?.textAlignment = .left
            dummyLabel?.textColor = UIColor.white
            dummyLabel?.numberOfLines = 0
            dummyLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(16))
            dummyLabel?.adjustsFontSizeToFitWidth = true
            
            morebutton = UIButton(frame: CGRect(x: CGFloat(view.frame.size.width-25), y: 4.0, width: 50.0, height: 22.0))
           
            //Common.setbuttonborderwidth(button: morebutton!, borderwidth: 1.0)
            morebutton?.setTitle("More", for: .normal)
            morebutton?.titleLabel?.textAlignment = .center
            morebutton?.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(12))
            morebutton?.setTitleColor(UIColor.white, for: .normal)
            morebutton?.backgroundColor = UIColor(red: CGFloat(28.0 / 255.0), green: CGFloat(27.0 / 255.0), blue: CGFloat(26.0 / 255.0), alpha: CGFloat(1))
            morebutton?.tag = indexPath.section
            morebutton?.addTarget(self, action: #selector(taptomore), for: .touchUpInside)
            dummybutton = UIButton(frame: CGRect(x: 0, y: 0.0, width: 0, height: 0))
            dummybutton?.tag = indexPath.section


            cell?.contentView.addSubview(dummyLabel!)
            cell?.contentView.addSubview(morebutton!)
            scrollXpos = 0.13*CGFloat(view.frame.size.width)
            
            let stt = (((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: indexPath.section) as! NSDictionary).value(forKey: "id") as! String)
            let dataarray = NSMutableArray()
            
            for i in 0..<collectionviewarray.count
            {
                let stt1 = ((((collectionviewarray.object(at: i) as! NSDictionary).value(forKey: "category_ids")) as! NSArray).object(at: 0) as! String)
                
                if(stt ==  stt1)
                {
                    
                    dataarray.add(collectionviewarray.object(at: i))
                    
                }
            }
             if Iscliptv
            {
                cell?.collectionScroll.contentSize = CGSize(width: CGFloat((dataarray.count * 135) + 170), height: CGFloat((cell?.frame.size.height)!))

            }
            else
            {
             cell?.collectionScroll.contentSize = CGSize(width: CGFloat((dataarray.count * 100) + 170), height: CGFloat((cell?.frame.size.height)!))
            }
            
            
            for viewObject: UIView in (cell?.collectionScroll.subviews)! {
                viewObject.removeFromSuperview()
            }
            
            
            print(collectionviewarray)
            
            
            for i in 0..<dataarray.count
            {
                
                if Iscliptv
                {
                    cellView = UIView(frame: CGRect(x: CGFloat(scrollXpos), y: CGFloat(0), width: CGFloat(220), height: CGFloat(150)))
                    scrollXpos += 150
                }
                else
                {
                    cellView = UIView(frame: CGRect(x: CGFloat(scrollXpos), y: CGFloat(0), width: CGFloat(120), height: CGFloat(180)))
                    scrollXpos += 110
                }
                
               
                cell?.collectionScroll.addSubview(cellView!)
                dummyView = UIImageView(frame: CGRect(x: CGFloat(5), y: CGFloat(30), width: CGFloat(100), height: CGFloat(140)))
                dummyView?.layer.borderColor = UIColor(red: CGFloat(99.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: CGFloat(1)).cgColor
               // dummyView?.layer.borderWidth = 1.0
                //dummyView?.layer.cornerRadius = 6
               // dummyView?.clipsToBounds = true
            
                button = UIButton(type: .custom)
                button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button?.tag = i
                button?.setTitle("", for: .normal)
                button?.frame = CGRect(x: CGFloat(5), y: CGFloat(30), width: CGFloat(100), height: CGFloat(140))
                 var str = String()
                if Iscliptv
                {
                 cellImage = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(30), width: CGFloat(140), height: CGFloat(100)))
                    
                    
                    let arra = ((dataarray.object(at: i) as! NSDictionary).value(forKey: "thumbs")) as! NSArray
                    
                
                    
                    if(arra.count>0)
                    {
                        if(((arra.object(at: 0) as! NSDictionary).value(forKey: "name") as! String) == "rectangle")
                        {
                            
                            let dict = arra.object(at: 0) as! NSDictionary
                          str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                         //   let urlImg = URL(string:str)
                      //      cellImage?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
                            
                        }
                        else
                        {
                            
                            let dict = arra.object(at: 1) as! NSDictionary
                              str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                            //let urlImg = URL(string:str)
                          //  cellImage?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
                            
                        }
                    }
                    
                    
                    
                    
                    
                    
//                    for i in 0..<arra.count
//                    {
//                        let dict = arra.object(at: i) as! NSDictionary
//                        let name  = dict.value(forKey: "name") as! String
//                        if(name == "rectangle")
//                        {
//
//                            str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
//                           // cellImage?.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
//                        }
//                        else
//                        {
//
//                        }
//
//                    }
    
              //  str  = ((((((dataarray.object(at: i) as! NSDictionary).value(forKey: "thumbs") as? NSArray)?.object(at: 1)) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String)
                }
                else
                {
                
                cellImage = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(30), width: CGFloat(100), height: CGFloat(140)))
                    
                    
                    let arra = ((dataarray.object(at: i) as! NSDictionary).value(forKey: "thumbs")) as! NSArray
                    
                    if(arra.count>0)
                    {
                        if(((arra.object(at: 0) as! NSDictionary).value(forKey: "name") as! String) == "verticle_rectangle")
                        {
                            
                            let dict = arra.object(at: 0) as! NSDictionary
                             str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                        //    let urlImg = URL(string:str)
                         //   cellImage?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
                            
                        }
                        else
                        {
                            
                            let dict = arra.object(at: 1) as! NSDictionary
                             str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                           // let urlImg = URL(string:str)
                          //  cellImage?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
                            
                        }
                    }
                    
                    
                    
                    
//                    for i in 0..<arra.count
//                    {
//                        let dict = arra.object(at: i) as! NSDictionary
//                        let name  = dict.value(forKey: "name") as! String
//                        if(name == "verticle_rectangle")
//                        {
//
//                            str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
//                           // cellImage?.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
//                        }
//
//                        if(str == "")
//                        {
//                            if(name == "rectangle")
//                            {
//
//                                str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
//                             }
//                        }
//
//
//                    }
                    
             //  str  = ((((((dataarray.object(at: i) as! NSDictionary).value(forKey: "thumbs") as? NSArray)?.object(at: 0)) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String)
                }
                
               
                
                
                
                print(str)
                if(!(Common.isNotNull(object: str as AnyObject)) || str == "")
                {
                    cellImage?.image = #imageLiteral(resourceName: "Placehoder")
                }
                else
                {
                    
                    let urlImg = URL(string:str)
                    cellImage?.sd_setImage(with: urlImg, placeholderImage: nil, options: .lowPriority, completed: nil)
               // cellImage?.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
                }
               // cellImage?.setImageWith(URL(string: str)!)
                //cellImage?.layer.cornerRadius = 6
                //cellImage?.clipsToBounds = true
                genreName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)! + 10), width: CGFloat(90), height: CGFloat(20)))
                genreName?.text = ((dataarray.object(at: i)  as! NSDictionary).value(forKey: "title") as? String)
                genreName?.textColor = UIColor.white
                genreName?.numberOfLines = 0
                genreName?.font = UIFont(name: "Ubuntu", size: CGFloat(13))
                // genreName?.adjustsFontSizeToFitWidth = true
                
                timerview = UIView(frame: CGRect(x: (cellImage?.frame.size.width)!-60, y: (cellImage?.frame.size.height)!+5, width: 60, height: 20))
                timerview?.backgroundColor = UIColor.black
                timerview?.alpha = 0.50
                Common.getRounduiview(view: timerview!, radius: 5.0)
                Common.setuiviewdborderwidth(View: timerview!, borderwidth: 2.0)
                
                timelabel = UILabel(frame: CGRect(x: (timerview?.frame.origin.x)!, y: (timerview?.frame.origin.y)!, width: (timerview?.frame.size.width)!, height: (timerview?.frame.size.height)!))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                let videotime = ((dataarray.object(at: i)  as! NSDictionary).value(forKey: "duration") as? String)
                let time = dateFormatter.date(from: videotime!)
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

                
                timelabel?.text = coverttime

                
                
                
               // timelabel?.text = "04.20 min"
                timelabel?.font = UIFont(name: "Ubuntu", size: CGFloat(12))
                timelabel?.textAlignment = .center
                timelabel?.textColor = UIColor.white
                
                playbutton = UIButton(frame: CGRect(x: 5, y: (cellImage?.frame.size.height)!+5, width: 20, height: 20))
                playbutton?.setImage(UIImage.init(named: "playicon"), for: .normal)
                
                
                cellView?.addSubview(button!)
                cellView?.addSubview(cellImage!)
                cellView?.addSubview(genreName!)
                cellView?.addSubview(dummyView!)
                cellView?.addSubview(timerview!)
                cellView?.addSubview(timelabel!)
                cellView?.addSubview(playbutton!)
            }
            
            
        }
        
        return cell!
    }
    
    
    
    @IBAction func Taptosearch(_ sender: UIButton) {
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
         self.navigationController?.pushViewController(searchViewController, animated: true)
     
        
        
        
    }
    func taptomore(sender: UIButton!)
    {
        if(Ishomedata)
        {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        print(((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "cat_id") as! String))
        moreViewController.id = ((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "cat_id") as! String)
        moreViewController.moreorzoner = "more"
        moreViewController.headertext = ((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "cat_name") as! String)
        self.navigationController?.pushViewController(moreViewController, animated: true)
        }
        else
        {
             print((sender?.tag)! as Int)
            print((morebutton?.tag)! as Int)
            print ((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary)
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            print((((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary).value(forKey: "id") as! String))
            moreViewController.id = (((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary).value(forKey: "id") as! String)
            moreViewController.moreorzoner = "more"
            moreViewController.headertext = (((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary).value(forKey: "name") as! String)
            self.navigationController?.pushViewController(moreViewController, animated: true)
 
        }

        
    }
    
    
    func buttonAction(sender: UIButton!) {
      
        
        
        if(Ismoviepromo)
        {
            
            let headerView: UIView = sender.superview!
            print(headerView.subviews)
            let label = headerView.subviews[2] as! UILabel
            let str = label.text
            
            for i in 0..<(collectionviewarray.count)
            {
                
                let dictnew  = collectionviewarray.object(at: i) as! NSDictionary
                print(dictnew)
                let titlenew  = dictnew.value(forKey: "title") as! String
                
                if(str == titlenew)
                {
                    
                    if(Common.isNotNull(object: dictnew.value(forKey: "mature_content") as AnyObject?))
                    {
                    if(dictnew.value(forKey: "mature_content") as! String == "1")
                    {
                        let alert = UIAlertController(title: "Dollywood Play", message: "This video is rated adult by CBFC, India. Please confirm that you have read the Terms of Use of this service and you confirm that you are an adult", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                            self.playmoviewpromo(dictnew: dictnew)
                            return
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                   self.playmoviewpromo(dictnew: dictnew)
                     return
                    }
                }
                    else
                    {
                        self.playmoviewpromo(dictnew: dictnew)
                        return
                    }
                }
            }
            
        }
        else
        {
        
         if(Common.Islogin())
         {
            
            if(Ishomedata)
            {
               
                let point : CGPoint = sender.convert(CGPoint.zero, to:myCollectionView)
                var indexPath = myCollectionView!.indexPathForItem(at: point)
                print((indexPath?.section)! as Int)
                
                
                print((homebutton?.tag)! as Int)
                print((morebutton?.tag)! as Int)
                let ds = (indexPath?.section)! as Int
                print(ds)
                print(((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at:ds) as AnyObject).object(at: sender.tag))
                let dic = ((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at:ds) as AnyObject).object(at: sender.tag) as! NSDictionary
                if(Common.isNotNull(object: dic.value(forKey: "mature_content") as AnyObject?))
                {
                
                if(dic.value(forKey: "mature_content") as! String == "1")
                {
                    
                    
                    
                    let alert = UIAlertController(title: "Dollywood Play", message: "This video is rated adult by CBFC, India. Please confirm that you have read the Terms of Use of this service and you confirm that you are an adult", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                       self.playHomedata(dic: dic)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else
                {
                   self.playHomedata(dic: dic)
                }

                }
                else
                {
                 self.playHomedata(dic: dic)
                }
                
               
         }
        else
        {
            
           
            //let buttonPosition = sender.convertPoint(CGPointZero, toView: self.mytabelview)
          //  let indexPath = self.mytabelview.indexPathForRowAtPoint(buttonPosition)
            
            let headerView: UIView = sender.superview!
            print(headerView.subviews)
            let label = headerView.subviews[2] as! UILabel
            let str = label.text
           
            for i in 0..<(collectionviewarray.count)
            {

            let dictnew  = collectionviewarray.object(at: i) as! NSDictionary
            let titlenew  = dictnew.value(forKey: "title") as! String
                if(str == titlenew)
                {
                    if(Common.isNotNull(object: dictnew.value(forKey: "mature_content") as AnyObject?))
                    {
                    
                    if(dictnew.value(forKey: "mature_content") as! String == "1")
                    {
                        
                        
                        
                        let alert = UIAlertController(title: "Dollywood Play", message: "This video is rated adult by CBFC, India. Please confirm that you have read the Terms of Use of this service and you confirm that you are an adult", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                            self.playanotherhomedata(dictnew: dictnew)
                            return
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        self.playanotherhomedata(dictnew: dictnew)
                        return
                    }
                    
                    }
                    else
                    {
                        self.playanotherhomedata(dictnew: dictnew)
                        return
                        
                    }
                }
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
    }
 
    
    
    func playmoviewpromo(dictnew:NSDictionary)
   {
   
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
    if(Common.isNotNull(object: dictnew.value(forKey: "des") as AnyObject?))
    {
    playerViewController.descriptiontext = dictnew.value(forKey: "des") as! String
    }
    playerViewController.liketext = ""
    
    if(Common.isNotNull(object: dictnew.value(forKey: "title") as AnyObject?))
    {
    playerViewController.tilttext = dictnew.value(forKey: "title") as! String
    }
    playerViewController.cat_id = dictnew.value(forKey: "id") as! String
    playerViewController.fromdownload = "no"
 
    
    var ids = String()
    let catdataarray = dictnew.value(forKey: "category_ids") as! NSArray
    
    if(catdataarray.count == 0)
    {
        ids = dictnew.value(forKey: "category_id") as! String
        playerViewController.catid = ids
    }
    else
    {
        
        var ids = String()
        for i in 0..<catdataarray.count
        {
            
            let str = (dictnew.value(forKey: "category_ids") as! NSArray).object(at: i) as! String
            ids = ids + str + ","
            
        }
        ids = ids.substring(to: ids.index(before: ids.endIndex))
        playerViewController.catid = ids
    }
    
 
    
    
    self.navigationController?.pushViewController(playerViewController, animated: true)
    
    }
    
    
    
    
    func playHomedata(dic:NSDictionary)
   {
    
    
 
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
    if(Common.isNotNull(object: dic.value(forKey: "des") as AnyObject?))
    {
     playerViewController.descriptiontext = dic.value(forKey: "des") as! String
    }
    playerViewController.liketext =  ""
    
    
    
    playerViewController.fromdownload = "no"
    if(Common.isNotNull(object: dic.value(forKey: "title") as AnyObject?))
    {
     playerViewController.tilttext = dic.value(forKey: "title") as! String
    }
    
    var ids = String()
     var catdataarray = NSArray()
    if let _ = dic.value(forKey: "category_ids")
      {
      catdataarray = dic.value(forKey: "category_ids") as! NSArray
    }
    
    if(catdataarray.count == 0)
    {
        
        ids = dic.value(forKey: "category_id") as! String
        playerViewController.catid = ids
        
     }
    else
    {
        
         for i in 0..<catdataarray.count
        {
            
            let str = (dic.value(forKey: "category_ids") as! NSArray).object(at: i) as! String
            ids = ids + str + ","
            
        }
        ids = ids.substring(to: ids.index(before: ids.endIndex))
        playerViewController.cat_id = dic.value(forKey: "id") as! String

    }
      playerViewController.cat_id = dic.value(forKey: "id") as! String
      self.navigationController?.pushViewController(playerViewController, animated: true)
    
    }
    
    func playanotherhomedata(dictnew:NSDictionary)
    
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        if(Common.isNotNull(object: dictnew.value(forKey: "des") as AnyObject?))
        {
         playerViewController.descriptiontext = dictnew.value(forKey: "des") as! String
        }
        playerViewController.liketext = ""
        if(Common.isNotNull(object: dictnew.value(forKey: "title") as AnyObject?))
        {
        playerViewController.tilttext = dictnew.value(forKey: "title") as! String
        }
        playerViewController.cat_id = dictnew.value(forKey: "id") as! String
        
        playerViewController.fromdownload = "no"
        
        if Common.isNotNull(object: dictnew.value(forKey: "download_path") as AnyObject?) {
            
            playerViewController.downloadVideo_url = dictnew.value(forKey: "download_path") as! String
            playerViewController.Download_dic = dictnew.mutableCopy() as! NSMutableDictionary
        }
        else
        {
            playerViewController.downloadVideo_url = ""
        }
        
         var ids = String()
        
        let catdataarray = dictnew.value(forKey: "category_ids") as! NSArray
        
        if(catdataarray.count == 0)
        {
            ids = dictnew.value(forKey: "category_id") as! String
            playerViewController.catid = ids
        }
        else
        {
            
        
            for i in 0..<catdataarray.count
            {
                
                let str = (dictnew.value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            print(ids)
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
         }

        
         self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    
    func gotologinpage()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if Iscliptv
        {
            
            let retval = CGSize(width: CGFloat(view.frame.size.width+70), height: CGFloat(170))
            return retval
        }
        else
        {
        let retval = CGSize(width: CGFloat(view.frame.size.width+70), height: CGFloat(200))
        return retval
        }
           }
    
    
    
    
    
    //MARK:-   Slidermenu delegate method
    
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return slidermenuarray.count
    }
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        
        return slidermenuarray.object(at: index) as! String
        
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        let label = UILabel()
        //label.text! = "Page #\(index)"
        // label.textAlignment = .Center
        //label.text = "Ashish"
        return label
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWith index: Int) {
        
        if(index == 0)
        {
            Ismoviepromo = false
            Ishomedata = true
            Iscliptv = false
            
            if(self.HomeData_dict.count>0)
            {
                self.collectionviewarray =  (self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray
                let collectionheight = self.collectionviewarray.count*100
                srollviewviewhgtconstrant.constant = CGFloat(collectionheight) + 230.0
                self.featurebanner =  (self.HomeData_dict.value(forKey: "dashboard") as!  NSDictionary).value(forKey: "feature_banner") as! NSArray
                  myscrollview.setContentOffset(CGPoint.zero, animated: true)
                self.myCollectionView.reloadData()
                  self.setimageincarouseview()
            }
            else
            {
            
            Common.startloder(view: self.view)
            self.callhomedatawebapi()
            }
        }
        else
        {
            
            
          print(((Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).value(forKey: "name") as! String)
            
         if((((Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).value(forKey: "name") as! String) == "Movie Promos")
         {
            Ismoviepromo = true
            
            }
            else
           {
            
            Ismoviepromo = false
            }
            
            
            if((((Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).value(forKey: "name") as! String) == "Clip TV"  || (((Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).value(forKey: "name") as! String) == "Music Videos" )
            {
             Iscliptv = true
            }
            else
            {
             Iscliptv = false
            }
                
            
            
//            if(index == 4)
//            {
//                Ismoviepromo = true
//            }
//            else
//            {
//                Ismoviepromo = false
//   
//            }
//            
//            if (index == 5 || index == 6)
//            {
//             Iscliptv = true
//            }
//            else
//            {
//             Iscliptv = false
//  
//            }
            
            Ishomedata = false
            
            
            var ids = String()
            for i in 0..<((((Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).value(forKey: "children") as! NSArray).count)
            {
                
                let dict = (((Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).value(forKey: "children") as! NSArray).object(at: i) as! NSDictionary
                let str = dict.value(forKey: "id") as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            print(ids)
            Slidermenusegment_dict = ((Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).mutableCopy() as! NSMutableDictionary
          
            if Iscliptv
            {
            let collectionheight = (Slidermenusegment_dict.value(forKey: "children") as! NSArray).count*80
              if((Slidermenusegment_dict.value(forKey: "children") as! NSArray).count == 1)
              {
                srollviewviewhgtconstrant.constant = self.view.frame.size.height-400
 
              }
                else
              {
                srollviewviewhgtconstrant.constant = CGFloat(collectionheight) + 100.0

                }
                
            }
            else
            {
                let collectionheight = (Slidermenusegment_dict.value(forKey: "children") as! NSArray).count*80
                
                if((Slidermenusegment_dict.value(forKey: "children") as! NSArray).count == 1)
                {
                    srollviewviewhgtconstrant.constant = self.view.frame.size.height-400
                    
                }
                else
                {

                srollviewviewhgtconstrant.constant = CGFloat(collectionheight) + 180.0
                }
            }
            
            
            
           self.Catdata_dict = dataBase.getcatlistdatabase(entityname: "Catlistdata", id: ids, key: "catlistdatadict")
            if(self.Catdata_dict.count>0)
            {
                print(self.Catdata_dict)
                self.collectionviewarray = NSArray()
                self.featurebanner = NSArray()
                self.featurebanner = (self.Catdata_dict.value(forKey: "feature") as! NSArray)
                self.collectionviewarray = (self.Catdata_dict.value(forKey: "content") as! NSArray)
                self.setimageincarouseview()
                 self.myCollectionView.reloadData()
                myscrollview.setContentOffset(CGPoint.zero, animated: true)


            }
            else
            {
                self.Getcatlistdata(id: ids)
                Common.startloder(view: self.view)
            }
            
            
           
            
        }
    }
    
    
    
    
    //MARK:- SetUp CarouselView
    
    
    func setimageincarouseview()
    {
        let arry = NSMutableArray()
        let arry1 = NSMutableArray()
        for i in 0..<featurebanner.count
        {
            
            
            let arra = (featurebanner.object(at: i) as! NSDictionary).value(forKey: "thumbs") as! NSArray
            for j in 0..<arra.count
            {
                let dict = arra.object(at: j) as! NSDictionary
                let name  = dict.value(forKey: "name") as! String
                if(name == "rectangle")
                {
                    
                    let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                    let url = URL(string: str)!
                    arry.add(url)
                    
                }
                else
                {
                    
                }
                
            }
            
            
            
            //let url = URL(string: (((featurebanner.object(at: i) as! NSDictionary).value(forKey: "thumbnail") as! NSDictionary).value(forKey: "medium") as! String))!
            
            let text = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "title")   as! String)
           // arry.add(url)
            
            arry1.add(text)
            
            
            
        }
        //imageCarouselView.textarray = NSMutableArray()
        // imageCarouselView.imageurlarry = NSMutableArray()
        imageCarouselView.imageurlarry.removeAllObjects()
        imageCarouselView.textarray.removeAllObjects()
        imageCarouselView.textarray = arry1
        imageCarouselView.imageurlarry = arry
        
    }
    
    //MARK:- coresal view delegate
    func scrolledToPage(_ page: Int)
    {
        
    }
    
    func clickonpage(_ page: Int)
    {
      print(page)
    }
    func clickcoresal(notification:NSNotification)
    {
        print(featurebanner)
       let index = notification.object as! Int
        
        if Ismoviepromo
        {
        
            
            if(Common.isNotNull(object: (featurebanner.object(at: index) as AnyObject).value(forKey: "mature_content") as AnyObject?))
            {
                
                if((featurebanner.object(at: index) as! NSDictionary).value(forKey: "mature_content") as! String == "1")
                {
                    
                    
                    
                    let alert = UIAlertController(title: "Dollywood Play", message: "This video is rated adult by CBFC, India. Please confirm that you have read the Terms of Use of this service and you confirm that you are an adult", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                      self.Clickoncoresalmoviewpromo(index: index)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else
                {
                 self.Clickoncoresalmoviewpromo(index: index)
                }
            }
            else
            {
              self.Clickoncoresalmoviewpromo(index: index)
            }
            
       
        
        }
        else
        {
            if Common.Islogin()
            {
                
                
                
                if(Common.isNotNull(object: (featurebanner.object(at: index) as AnyObject).value(forKey: "mature_content") as AnyObject?))
                {
                    
                    if((featurebanner.object(at: index) as! NSDictionary).value(forKey: "mature_content") as! String == "1")
                    {
                        
                        
                        
                        let alert = UIAlertController(title: "Dollywood Play", message: "This video is rated adult by CBFC, India. Please confirm that you have read the Terms of Use of this service and you confirm that you are an adult", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                             self.Clickonanothercorasal(index: index)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                          self.Clickonanothercorasal(index: index)
                    }
                }
                else
                {
                      self.Clickonanothercorasal(index: index)
                }
                

                
              
             
                
                
            }
            else
            {
                let alert = UIAlertController(title: "Dollywood Play", message: "Please login to watch videos on this app", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.destructive, handler: { action in
                    self.gotologinpage()
                }))
                self.present(alert, animated: true, completion: nil)            }
        }
        
        
        
    }
    
    
    
    
    func Clickoncoresalmoviewpromo(index:Int)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
         playerViewController.descriptiontext = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "des") as! String
         playerViewController.tilttext = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "title") as! String
         playerViewController.fromdownload = "no"
      
        
        var ids = String()
        let catdataarray = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        
        if(catdataarray.count == 0)
        {
            ids = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "category_id") as! String
            playerViewController.catid = ids
        }
        else
        {
            
            var ids = String()
            for i in 0..<catdataarray.count
            {
                
                let str = ((featurebanner.object(at: index) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids

        }

        playerViewController.cat_id = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "id") as! String
         self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    func Clickonanothercorasal(index:Int)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerViewController.descriptiontext = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "des") as! String
        playerViewController.tilttext = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "title") as! String
        playerViewController.fromdownload = "no"
        var ids = String()
        let catdataarray = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        
        if(catdataarray.count == 0)
        {
            ids = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "category_id") as! String
            playerViewController.catid = ids
        }
        else
        {
            
            var ids = String()
            for i in 0..<catdataarray.count
            {
                
                let str = ((featurebanner.object(at: index) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
          
              ids = ids.substring(to: ids.index(before: ids.endIndex))
              playerViewController.catid = ids
        }
        
        
         playerViewController.cat_id = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "id") as! String
         self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
      NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationDidBecomeActive, object: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func willResignActive(_ notification: Notification) {
        chekforceupgraorsoftupgrateapi()
    }
    
    //MARK:- Menu button Action
    @IBAction func Taptomenu(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }
    //MARK:- didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        
        AppUtility.lockOrientation(.portrait)
        self.perform(#selector(changeOrientation), with: nil, afterDelay: 5.0)
    }
    func changeOrientation()
    {
        AppUtility.lockOrientation(.portrait)
    }
    
    
}
//MARK:- SlideMenuControllerDelegate Action delegate
extension ViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
extension Bundle {
    var releaseVersionNumber: NSString? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? NSString
    }
    
    var buildVersionNumber: NSString? {
        return self.infoDictionary?["CFBundleVersion"] as? NSString
    }
    
}
