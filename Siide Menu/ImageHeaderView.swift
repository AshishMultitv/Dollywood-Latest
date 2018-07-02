//
//  ImageHeaderCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/3/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

class ImageHeaderView : UIView {
    
    @IBOutlet weak var profileNamelable: UILabel!
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var backgroundImage : UIImageView!
    var MyAccountViewController: UIViewController!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hex: "E0E0E0")
        self.profileImage.layoutIfNeeded()
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = UIColor.white.cgColor
         NotificationCenter.default.addObserver(self, selector: #selector(setprofilrnameimage), name: NSNotification.Name(rawValue: "Setprofiledata"), object: nil)
        setprofilrnameimage()
        
       // self.profileImage.setRandomDownloadImage(80, height: 80)
       // self.backgroundImage.setRandomDownloadImage(Int(self.bounds.size.width), height: 160)
    }
    
    
    @IBAction func TaptoProfile(_ sender: UIButton) {
        
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "taptoprofile"), object: nil, userInfo: nil)
      
    }
    
    func setprofilrnameimage()
    {
         let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            
            
            
            if(!(Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?)) && !(Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?)))
            {
                
                self.profileNamelable.text =  "User name"
            }
            
           else if((Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?)) && (Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?)))
            {
                
             self.profileNamelable.text = "\(dict.value(forKey: "first_name") as! String)\(" ")\(dict.value(forKey: "last_name") as! String)"
            }
            
           else if((Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?)))
            {
                
                self.profileNamelable.text = "\(dict.value(forKey: "first_name") as! String)"
            }
            
           else if((Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?)))
            {
                
                self.profileNamelable.text = "\(dict.value(forKey: "last_name") as! String)"
            }
            if Common.isNotNull(object: dict.value(forKey: "image") as AnyObject?)
            {
                let url =  dict.value(forKey: "image") as! String
                if(url != "")
                {
                    let urlImg = URL(string:url)
                 //profileImage.setImageWith(URL(string: url)!)
                    profileImage.sd_setImage(with: urlImg, placeholderImage: nil, options: .highPriority, completed: nil)
                }
            }
            
            
            
        }
        else
        {
            self.profileNamelable.text =  "User name"
            profileImage.image = UIImage.init(named: "userprofile")
        }
   
    }
    
}
