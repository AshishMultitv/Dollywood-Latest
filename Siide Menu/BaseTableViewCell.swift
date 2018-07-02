//
//  BaseTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//
import UIKit
import AFNetworking

open class BaseTableViewCell : UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
    }
    
    open class func height() -> CGFloat {
        return 40
    }
    
    open func setData(_ data: Any?) {
       // self.backgroundColor = UIColor(hex: "F1F8E9")
       // self.textLabel?.font = UIFont.italicSystemFont(ofSize: 18)
        
        self.textLabel?.textColor = UIColor.white
        if let menuText = data as? String {
            
            let label = UILabel.init(frame: CGRect.init(x: 40, y: 13, width: 200, height: 20))
            label.text = menuText
            if(menuText == "Sign out")
            {
              if (dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict").count>0)
              {
                label.text = "Sign out"
                }
                else
              {
                 label.text = "Sign in"
                }
            }
            
            label.textColor = UIColor.white
            label.font = UIFont(name: "Ubuntu", size: CGFloat(16))

            self.contentView.addSubview(label)
            //self.textLabel?.text = menuText
        }
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect.init(x: 20, y: self.frame.size.height/2-10, width: 20, height: 20)
    }
    
    open func setmenuimage(_ data: Any?) {
        // self.backgroundColor = UIColor(hex: "F1F8E9")
        
         if let imageurl = data as? String {
               var iurl = imageurl
            iurl = iurl.replacingOccurrences(of: " ", with: "%20")
             let imageview = UIImageView.init(frame: CGRect.init(x: 10, y: 13, width: 20, height: 20))
           imageview.setImageWith(URL(string: iurl)!)
            self.contentView.addSubview(imageview)
            
//             let itemSize = CGSize.init(width: 25.0, height: 25.0)
//            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
//            let imageRect = CGRect.init(x: 10, y: 10, width: 30, height: 30)
//             self.imageView?.image!.draw(in: imageRect)
//            self.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
//            UIGraphicsEndImageContext();
            
        }
    }
    
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 1.0
        } else {
            self.alpha = 1.0
        }
    }
    
    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {
    }
  
}
