//
//  MoreViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 21/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking

class MoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var mytableview: UITableView!
    @IBOutlet weak var headerlabel: UILabel!
    var display_offset = String()
      var id = String()
     var headertext = String()
     var dataarray = NSMutableArray()
    var moreorzoner = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        display_offset = "0"
        print(id)
        print(headertext)
        headerlabel.text = headertext
        if(moreorzoner == "more")
        {
        getdata()
        }
        else if(moreorzoner == "zoner")
        {
          getZonerdata()
            
        }
      }
    
    
    @IBAction func taptosearch(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    func getZonerdata()
    {
        Common.startloder(view: self.view)
        let parameters = [
            "device": "ios",
            "genre_id": id,
            "content_count": "20",
            "display_limit" : "20"
        ]
      var url = String(format: "%@%@/device/ios/current_offset/%@/max_counter/100/genre_id/%@", LoginCredentials.Listapi,Apptoken,display_offset,id)
     url = url.trimmingCharacters(in: .whitespaces)

        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                
                if let _ = dict.value(forKey: "code")
                {
                    if(dict.value(forKey: "code") as! NSNumber == 0)
                    {
                        return
                    }
                }
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
                
                let array = Catdata_dict.value(forKey: "content") as! NSArray
                for i in 0..<array.count {
                    self.dataarray.add(array.object(at: i) as! NSDictionary)
                }
                self.display_offset =   (Catdata_dict.value(forKey: "offset") as! NSNumber).stringValue
                self.mytableview.reloadData()
                Common.stoploder(view: self.view)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
    }
    

    
    
    
    
    
    func getdata()
    {
        Common.startloder(view: self.view)
         let parameters = [
            "device": "ios",
            "cat_id": id,
            "content_count": "20",
            "display_limit" : "20"
            ]
        
          var url = String(format: "%@%@/device/ios/current_offset/%@/max_counter/100/cat_id/%@", LoginCredentials.Listapi,Apptoken,display_offset,id)
        
     //var url = String(format: "%@%@/device/ios/cat_id/%@/content_count/20/display_limit/20/display_offset/%@", LoginCredentials.Listapi,Apptoken,id,display_offset)
        url = url.trimmingCharacters(in: .whitespaces)

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
                
            self.dataarray = (Catdata_dict.value(forKey: "content") as! NSArray).mutableCopy() as! NSMutableArray
           self.mytableview.reloadData()
            Common.stoploder(view: self.view)
              }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
   
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        
        return self.dataarray.count
    }
    
    // cell height
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[0] as! Custometablecell
        cell.selectionStyle = .none
        Common.getRounduiview(view: cell.cellouterview, radius: 1.0)
        cell.cellouterview.layer.borderColor = UIColor.white.cgColor
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        Common.getRoundLabel(label:  cell.timelabel, borderwidth: 5.0)
        Common.getRounduiview(view: cell.timerview, radius: 5.0)

        Common.setlebelborderwidth(label: cell.timelabel, borderwidth: 1.0)
        cell.timelabel.layer.borderColor = UIColor.white.cgColor
        
       
           cell.titlelabel.text = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            
            
            if Common.isNotNull(object: (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "genre") as AnyObject)
            {
                cell.titletypwlabel.text = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "genre") as? String
            }
            else
            {
                cell.titletypwlabel.text = ""
            }
        var discriptiontext = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
        discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
         cell.desciptionlabel.text = discriptiontext
        
        
        let arra = ((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs")) as! NSArray
        for i in 0..<arra.count
        {
            let dict = arra.object(at: i) as! NSDictionary
            let name  = dict.value(forKey: "name") as! String
            if(name == "rectangle")
            {
                
                let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                 cell.imageview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
             
            }
            else
            {
                
            }
            
        }
        
        
        
         let videotime = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
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
      
        
        
        return cell
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
        
        if(Common.Islogin())
        {
     
            if(Common.isNotNull(object: (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "mature_content") as AnyObject?))
            {
                
                if((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "mature_content") as! String == "1")
                {
                    
                    
                    
                    let alert = UIAlertController(title: "Dollywood Play", message: "This video is rated adult by CBFC, India. Please confirm that you have read the Terms of Use of this service and you confirm that you are an adult", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                        self.playvideourl(indexPath: indexPath)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else
                {
                    self.playvideourl(indexPath: indexPath)
                }
            }
            else
            {
                self.playvideourl(indexPath: indexPath)
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
    
    
    
    func playvideourl(indexPath:IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
      if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
      {
        playerViewController.descriptiontext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        }
        playerViewController.liketext = ""
        
        if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as AnyObject?))
        {
        playerViewController.tilttext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        }
        playerViewController.fromdownload = "no"
   
        var ids = String()
        let catdataarray = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        
        if(catdataarray.count == 0)
        {
            ids = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
            playerViewController.catid = ids
        }
        else
        {
            
            var ids = String()
            for i in 0..<catdataarray.count
            {
                
                let str = ((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
             playerViewController.catid = ids
         }
        
      
       
        playerViewController.cat_id = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    func gotologinpage()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    @IBAction func TAptoback(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
