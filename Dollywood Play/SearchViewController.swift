//
//  SearchViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 22/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking

class SearchViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var resultcountlabel: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var mytableview: UITableView!
    var display_offset = String()

    var dataarray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        display_offset = "0"
        //searchbar.layer.borderColor = UIColor.blue.cgColor
       // searchbar.layer.borderWidth = 1.0
        searchbar.isTranslucent = true
        searchbar.alpha = 1
        searchbar.backgroundColor = UIColor.init(red: 61/255, green: 61/255, blue: 61/255, alpha: 1.0)
        searchbar.barTintColor = UIColor.init(red: 61/255, green: 61/255, blue: 61/255, alpha: 1.0)
        searchbar.backgroundImage = UIImage()
        searchbar.barTintColor = UIColor.clear

        // Do any additional setup after loading the view.
    }

    @IBAction func Taptoback(_ sender: UIButton) {
        
       self.navigationController?.popViewController(animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        searchwithstring(searchkey: searchbar.text!)
    }
    
    
    func searchwithstring(searchkey:String)
    {
      
        let parameters = [
            "device": "ios",
            "search_tag": searchkey,
            "content_count": "20",
            "display_limit" : "20"
        ]
        //var url = String(format: "%@%@/device/ios/search_tag/%@/max_counter/20/current_offset/%@", LoginCredentials.Searchapi,Apptoken,searchkey,display_offset)
        
         var url = String(format: "%@%@/device/ios/current_offset/%@/max_counter/20/search_tag/%@", LoginCredentials.Searchapi,Apptoken,display_offset,searchkey)
        
         
        url = url.trimmingCharacters(in: .whitespaces)
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        let manager = AFHTTPSessionManager()
        
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                var Catdata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptSearchapi)
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

             self.resultcountlabel.text = "Total results:\(Catdata_dict.value(forKey: "totalCount") as! NSNumber)"
            self.display_offset =   (Catdata_dict.value(forKey: "offset") as! NSNumber).stringValue
                if(self.dataarray.count == 0)
                {
                 EZAlertController.alert(title: "No result found")
                }
                
                    self.mytableview.reloadData()
  
                
                Common.stoploder(view: self.view)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        display_offset = "0"
        self.dataarray.removeAllObjects()
        Common.startloder(view: self.view)
        searchwithstring(searchkey: searchBar.text!)
        searchBar.resignFirstResponder()
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
        
        
        if Common.isNotNull(object: ((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as AnyObject)
        {
            cell.titletypwlabel.text = ((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as? String
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
                        self.Playvideourl(indexPath: indexPath)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else
                {
                    self.Playvideourl(indexPath: indexPath)
                }
            }
            else
            {
                self.Playvideourl(indexPath: indexPath)
            }
            
          }
        else
        {
            let alert = UIAlertController(title: "Dollywood Play", message: "Please login to watch videos on this app", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.destructive, handler: { action in
                self.gotologinpage()
            }))
            self.present(alert, animated: true, completion: nil)        }
        
    }

    
    
    
    
    
    func Playvideourl(indexPath:IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
        {
        playerViewController.descriptiontext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        }
        playerViewController.liketext =  ""
        
        if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as AnyObject?))
        {
            
        playerViewController.tilttext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        }
        
        playerViewController.fromdownload = "no"
        
        if Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
            
            playerViewController.downloadVideo_url = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as! String
            playerViewController.Download_dic = (dataarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        else
        {
            playerViewController.downloadVideo_url = ""
        }
        
        
        var ids = String()
        for i in 0..<((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count
        {
            
            
            let str = ((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
            ids = ids + str + ","
            
        }
        ids = ids.substring(to: ids.index(before: ids.endIndex))
        playerViewController.catid = ids
        playerViewController.cat_id = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        //playerViewController.likeornot = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes") as! String
        playerViewController.likeornot = "0"
        playerViewController.favornot =  "0"
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    
    func gotologinpage()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
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
