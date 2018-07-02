//
//  Common.swift
//  Eschool
//
//  Created by Desk28 on 03/08/15.
//  Copyright (c) 2015 Shree Ram. All rights reserved.
//

import UIKit
import CryptoSwift
import MBProgressHUD
import Foundation
import SystemConfiguration
import CoreTelephony
import ReachabilitySwift



//var MaterBaseUrl = "http://dollywood-api.multitvsolution.com/automatorapi/master/url_static/token/"
var MaterBaseUrl = "http://staging.multitvsolution.com:9004/automatorapi/v6/master/url_static_dollywood_prod/token/"


let Apptoken = "58eb522164a49"
var timer:Timer!
let mbhuview = MBProgressHUD.init()
let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();



class Common: NSObject {
    
    
   static func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    
    }
    static func setvideoplayeronview(testStr:UIView) {
        // println("validate calendar: \(testStr)")
    }

    
    static func startheartbeat()
    {
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(callheartBeatapi), userInfo: nil, repeats: true);
    }
    
    static func callheartBeatapi()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "heartBeatapi"), object: nil)
    }
    static func stopHeartbeat()
    {
        if timer != nil
        {
            timer.invalidate()
            timer  = nil
        }
    }

    static func callappanalytics()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "useranalytics"), object: nil)
    }

    
   static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
   static func isEmptyOrWhitespace(testStr:String) -> Bool {
    
    let str = testStr.trimmingCharacters(in: NSCharacterSet.whitespaces)
    
   // let str = testStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
   
         if(testStr.isEmpty || str.isEmpty) {
            return false
        }
    else
        {
            return true
    }
        
        //return (testStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "")
    }
    
    
   static func isNotNull(object:AnyObject?) -> Bool {
        guard let object = object else {
            return false
        }
        return (isNotNSNull(object: object) && isNotStringNull(object: object))
    }
   static func isNotNSNull(object:AnyObject) -> Bool {
        return object.classForCoder != NSNull.classForCoder()
    }
    
   static func isNotStringNull(object:AnyObject) -> Bool {
        if let object = object as? String, object.uppercased() == "NULL" {
            return false
        }
        return true
    }

    
    static func gatedateheder(testStr:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
       
        let date = dateFormatter.date(from: testStr)
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let result = formatter.string(from: date!)
        return result
        
    }
    
    
    
    
    
    
    static func getModelname()->String
    {
        let divice = UIDevice()
        return divice.modelName
    }
    
    static func getnetworktype()->String
        
    {
        let reachability = Reachability()!
        print(reachability.description)
        
        
        if(!reachability.isReachable)
        {
            return ""
            
        }
        
        if(reachability.isReachableViaWiFi)
        {
            return "WiFi"
        }
            
            
        else
        {
            
            let networkInfo = CTTelephonyNetworkInfo()
            let carrierType = networkInfo.currentRadioAccessTechnology
            switch carrierType{
            case CTRadioAccessTechnologyGPRS?,CTRadioAccessTechnologyEdge?,CTRadioAccessTechnologyCDMA1x?:
                return "2G"
            case CTRadioAccessTechnologyWCDMA?,CTRadioAccessTechnologyHSDPA?,CTRadioAccessTechnologyHSUPA?,CTRadioAccessTechnologyCDMAEVDORev0?,CTRadioAccessTechnologyCDMAEVDORevA?,CTRadioAccessTechnologyCDMAEVDORevB?,CTRadioAccessTechnologyeHRPD?:
                return "3G"
            case CTRadioAccessTechnologyLTE?:
                return "4G"
            default: return ""
            }
            
        }
        return ""
    }
    
    
    

    
    
    
    
    
    static func startloder(view:UIView)
    {
//      //let mbhuview = MBProgressHUD.init()
//     //  mbhuview.backgroundView.color = UIColor.clear
//      // MBProgressHUD.showAdded(to:view, animated: true)
//        mbhuview.frame = CGRect.init(x: view.frame.size.width/2-20, y: view.frame.size.height/2-20, width: 40, height: 40)
//        mbhuview.bezelView.color = UIColor.clear
//        mbhuview.bezelView.color = UIColor.black
//         mbhuview.removeFromSuperViewOnHide = true
//        view.addSubview(mbhuview)
//        mbhuview.show(animated: true)
        
        
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        view.addSubview(activityIndicator);
        
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        
        
      }
    static func stoploder(view:UIView)
    {
        
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
//        mbhuview.hide(animated: true)
//        // MBProgressHUD.hide(for: view, animated: true)
        
    }
    
 

    static func makewhitplaceholderintextview(textview:UITextView,string:String)
    {
        textview.text = string
        textview.textColor = UIColor.lightGray
    }
    
    static func Endtextviewplaceholder(textview:UITextView)
    {
        textview.text = nil
        textview.textColor = UIColor.black
    }
    
   
   
    
    
    static func decodedresponsedata(msg:String)-> NSMutableDictionary
    {
        let keyString = "0123456789abcdef0123456789abcdef"
         let encode =  msg.aesDecrypt(key: keyString)
        let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! NSDictionary
         return jsonObject.mutableCopy() as! NSMutableDictionary

    }
    
    static func decodedresponseheartbeat(msg:String)-> String
    {
        let keyString = "0123456789abcdef0123456789abcdef"
        let encode =  msg.aesDecrypt(key: keyString)
        //  let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! String
        return encode
        
    }
    
    
   static func makewhitplaceholder(textfiled:UITextField,string:String)
    {
        textfiled.attributedPlaceholder = NSAttributedString(string:string,
        attributes:[NSForegroundColorAttributeName: UIColor.white])
    }

    
    static func Isphonevalid(phoneNumber: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    
    static func Islogin() -> Bool
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            return true
        }
        else
        {
          return false
        }
    }
    

    static func convertdictinyijasondata(data:NSDictionary) -> String
    {
         do {
        let jsonData = try JSONSerialization.data(withJSONObject: data as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
        let otherDetailString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
        return otherDetailString
        }
         catch{
            
        }
        return ""
    }
    

    static func getRounduiview(view: UIView, radius:CGFloat) {
        view.layer.cornerRadius = radius;
         view.clipsToBounds=true
    }
    static func getRoundImage(imageView: UIImageView, radius:CGFloat) {
        imageView.layer.cornerRadius = radius;
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
     }
   
    static func getRounduibutton(button: UIButton, radius:CGFloat) {
        button.layer.cornerRadius = radius;
        button.clipsToBounds = true
         button.layer.masksToBounds = true
    }
    
    static func getRoundLabel(label: UILabel,borderwidth:CGFloat) {
        label.layer.cornerRadius = borderwidth
        label.clipsToBounds = true
        label.layer.masksToBounds = true
    }
   
    
    static func setuiviewdborderwidth(View: UIView, borderwidth:CGFloat) {
        View.layer.borderColor=UIColor.gray.cgColor
        View.layer.borderWidth=borderwidth
        View.clipsToBounds=true
    }
   
    
    static func settextfieldborderwidth(textfield: UITextField, borderwidth:CGFloat) {
        textfield.layer.borderColor=UIColor.gray.cgColor
        textfield.layer.borderWidth=borderwidth
        textfield.clipsToBounds=true
    }
   
    
    static func settextviewborderwidth(textview: UITextView, borderwidth:CGFloat) {
        textview.layer.borderColor=UIColor.gray.cgColor
        textview.layer.borderWidth=borderwidth
        textview.clipsToBounds=true
    }
  
    
    static func setbuttonborderwidth(button: UIButton, borderwidth:CGFloat) {
        button.layer.borderColor=UIColor.gray.cgColor
        button.layer.borderWidth=borderwidth
        button.clipsToBounds=true
    }
    
 
    
    static func setlebelborderwidth(label: UILabel, borderwidth:CGFloat) {
        label.layer.borderColor=UIColor.gray.cgColor
        label.layer.borderWidth=borderwidth
        label.clipsToBounds=true
    }

 
  
    
}
