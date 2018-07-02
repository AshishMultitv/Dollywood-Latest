//
//  LoginViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 09/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import CoreTelephony
import AFNetworking
import FormToolbar


class LoginViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,UITextViewDelegate {
    
    @IBOutlet var mytextview: UITextView!
    @IBOutlet weak var Outer_view: UIView!
    @IBOutlet weak var Phoneno_txtfld: UITextField!
    @IBOutlet weak var email_textfld: UITextField!
    @IBOutlet weak var orlabel: UILabel!
    
    @IBOutlet weak var signin_button: UIButton!
    @IBOutlet weak var orlable1: UILabel!
    @IBOutlet weak var facebookbutton: UIButton!
    @IBOutlet weak var googlebutton: UIButton!
    private let loader = FacebookUserLoader()
    var dictionaryOtherDetail = NSDictionary()
    var devicedetailss =  NSDictionary()
    var socail_dict =  NSDictionary()
    var uniqsocial_id =  String()
    var phone =  String()
    
    var type =  String()
    var fboremail =  String()
    var logindatadict = NSMutableDictionary()
    var toolbar = FormToolbar()

    
    override func viewDidLoad() {
        super.viewDidLoad()
      AppUtility.lockOrientation(.portrait)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        mytextview.delegate = self
        mytextview.isUserInteractionEnabled = true
        mytextview.isEditable = false
        mytextview.isSelectable = true
        let linkAttributes = [
            NSLinkAttributeName: NSURL(string: LoginCredentials.Termsandconditioncapi)!,
            NSForegroundColorAttributeName: UIColor.blue,
            NSFontAttributeName: UIFont(name: "Ubuntu", size: 14.0)!
            ] as [String : Any]
        let linkAttributes1 = [
            NSLinkAttributeName: NSURL(string: LoginCredentials.Privacypolicyapi)!,
            NSForegroundColorAttributeName: UIColor.blue,
            NSFontAttributeName: UIFont(name: "Ubuntu", size: 14.0)!
            ] as [String : Any]
        
        
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Ubuntu", size: 14.0)! ]
        let attributedString = NSMutableAttributedString(string: "By clicking sign in, you agree to our terms and conditions and that you have read our Privacy Policy", attributes: myAttribute )
        
          // Set the 'click here' substring to be the link
        attributedString.setAttributes(linkAttributes, range:NSRange(location:38,length:20))
        attributedString.setAttributes(linkAttributes1, range:NSRange(location:85,length:15))

        

        mytextview.delegate = self
        mytextview.attributedText = attributedString
        
        
         self.toolbar = FormToolbar(inputs: [Phoneno_txtfld, email_textfld])
        self.navigationController?.isNavigationBarHidden = true
        self.makeUI()
        self.getloginpram()
    }
    
    func getaboutusandtc()
    {
        
        let url = "http://api.multitvsolution.com/automatorapi/v2/cms/page?type=tc&token=58eb522164a49"
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
              
           print(dict)
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
         }
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        // User click on a link in a textview
        print(characterRange)
        
        // True => User can click on the URL Ling (otherwise return false)
        return true
    }
    
    @IBAction func Taptologin(_ sender: UIButton) {
        
        
        if(Common.isEmptyOrWhitespace(testStr: email_textfld.text!))
        {
            if(Common.isValidEmail(testStr: email_textfld.text!))
            {
              phone = email_textfld.text!
                type = "email"
                getloginapi()
                 return
            }
            else
            {
                EZAlertController.alert(title: "Please enter Valid email id")
   
            }
        }
        else if((Common.isEmptyOrWhitespace(testStr: Phoneno_txtfld.text!)))
        {
            
            
            if(Common.Isphonevalid(phoneNumber: Phoneno_txtfld.text!))
            {
                
                 if ((Phoneno_txtfld.text?.characters.count)! <= 9 || (Phoneno_txtfld.text?.characters.count)! > 15)
                 {
                    EZAlertController.alert(title: "Please enter Valid phone no.")

                }
                else
                 {
                    phone = Phoneno_txtfld.text!
                    type = "phone"
                    getloginapi()
                    return
                }
              
            }
            else
            {
                EZAlertController.alert(title: "Please enter Valid phone no.")
   
            }
         
        }
        else if(!(Common.isEmptyOrWhitespace(testStr: email_textfld.text!)) || !(Common.isEmptyOrWhitespace(testStr: Phoneno_txtfld.text!)))
        {
        EZAlertController.alert(title: "Please enter email or phone")
        }
        
      
        
        
        
    }
    func makeUI()
    {
        Common.getRoundLabel(label: orlabel, borderwidth: orlabel.frame.size.height/2)
        Common.getRoundLabel(label: orlable1, borderwidth: orlabel.frame.size.height/2)
        Common.getRounduiview(view: Outer_view, radius: 10.0)
        Common.getRounduibutton(button: signin_button, radius: 10.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Taptogoogle(_ sender: UIButton) {
        type = "social"
        fboremail = "google"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
       // Common.startloder(view: self.view)
        
    }
    
    
    func getloginapi()
    {
        
        Common.startloder(view: self.view)
        
        do {
            
            
            /// phone, email, social
            var parameters = [String : Any]()
            
            if(type == "social")
            {
                if(fboremail == "facebook")
                {
                    parameters = [   "type":type,
                                     "dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                                     "dd":Common.convertdictinyijasondata(data: devicedetailss),
                                     "social":Common.convertdictinyijasondata(data: socail_dict),
                                     "device": "ios",
                                     "provider":"facebook",
                    ]
                }
                else if(fboremail == "google")
                {
                    
                    parameters = [   "type":type,
                                     "dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                                     "dd":Common.convertdictinyijasondata(data: devicedetailss),
                                     "social":Common.convertdictinyijasondata(data: socail_dict),
                                     "device": "ios",
                                     "provider":"google",
                    ]
                }
            }
            else
            {
                
                parameters = [ "type":type,
                               "dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                               "dd":Common.convertdictinyijasondata(data: devicedetailss),
                               "phone":phone,
                               "device": "ios"
                ]
                
                
            }
            
            
            
            
            print(parameters)
            let url = String(format: "%@%@", LoginCredentials.SocialAPI,Apptoken)
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    Common.stoploder(view: self.view)
                    print(dict)
                    if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
                    {
                        
                        EZAlertController.alert(title: "Please Enter Valid detail")
                    }
                    else
                    {
                    
                     self.logindatadict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print(self.logindatadict)
               if(self.type == "social")
               {
                dataBase.deletedataentity(entityname: "Logindata")
                dataBase.Savedatainentity(entityname: "Logindata", key: "logindatadict", data: self.logindatadict)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Setprofiledata"), object: nil, userInfo: nil)

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "usersession"), object: nil)

                self.gotohomeacreen()
                    }
                
                    else
               {
                
                
                
                if(Common.isNotNull(object: self.logindatadict.value(forKey: "otp") as AnyObject?))
                {
                  self.gotoOTPacreen(otp: "", userid: (self.logindatadict.value(forKey: "id") as! NSNumber).stringValue, type: self.type, value: self.phone, data:self.logindatadict, resendotp:"no")
                }
                else{
                  
                  self.gotoOTPacreen(otp: "", userid: (self.logindatadict.value(forKey: "id") as! NSNumber).stringValue, type: self.type, value: self.phone, data:self.logindatadict, resendotp:"yes")
                }
               
                
                
                
                
                    }
          
                    
                    }}
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
            }
        }
        catch
        {}
    }
    
    
    
    @IBAction func TAptoFacebook(_ sender: UIButton) {
        
        
        type = "social"
        fboremail = "facebook"
        
        Common.startloder(view: self.view)
        loader.load(askEmail: true, onError: { [weak self] in
            Common.stoploder(view: (self?.view)!)
            let alt:UIAlertView=UIAlertView(title: "Dollywood Play", message: "Cannot login with Facebook, something is missing. Try another account for login.", delegate: nil, cancelButtonTitle: "OK")
            alt.show()
            },
                    onSuccess: { [weak self] user in
                        self?.onUserLoaded(user: user)
        })
        
        
        
    }
    private func onUserLoaded(user: TegFacebookUser) {
        
        Common.stoploder(view: self.view)
        print("emailAddress\(user.email) and Gender is \(user.gender) and userFBID is \(user.id) and userprofilepIc url is \(user.profilePic)")
        
        if user.email != nil
        {
            uniqsocial_id = user.id as String
            socail_dict = [
                "first_name": user.firstName! as String,
                "last_name": user.lastName! as String,
                "gender": user.gender! as String,
                "link": "",
                "locale": "",
                "name": user.name! as String,
                "email": user.email! as String,
                "location": "",
                "dob": "",
                "id":user.id as String]
            self.getloginapi()
            
        }
        else
        {
            let alt:UIAlertView=UIAlertView(title: "Dollywood Play", message: "Cannot login with Facebook, email id is missing. Try another account or go for login.", delegate: nil, cancelButtonTitle: "OK")
            alt.show()
        }
    }
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        //print("Sign in presented")
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        // print("Sign in dismissed")
    }
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if error == nil
        {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("Welcome: ,\(userId), \(idToken), \(fullName), \(givenName), \(familyName), \(email)")
            uniqsocial_id = userId!
            
            socail_dict = [
                "first_name": "",
                "last_name": "",
                "gender": "",
                "link": "",
                "locale": "",
                "name": user.profile.name,
                "email": user.profile.email,
                "location": "",
                "dob": "",
                "id":user.userID ]
             self.getloginapi()
            
        }
        
    }
    
    func getloginpram()
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
        
        
        
    }
    
    @IBAction func BackButton_action(_ sender: UIButton) {
        
        
        
    }
    
    func gotoOTPacreen(otp:String,userid:String,type:String,value:String,data:NSMutableDictionary,resendotp:String)
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let oTPViewController = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        oTPViewController.otp = otp
        oTPViewController.user_id = userid
        oTPViewController.value = value
        oTPViewController.type = type
        oTPViewController.data = data
        oTPViewController.resendotp = resendotp

        self.navigationController?.pushViewController(oTPViewController, animated: true)
       // self.slideMenuController()?.changeMainViewController(oTPViewController, close: true)
 
    }
    
    
    
    func gotohomeacreen()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        //self.slideMenuController()?.changeMainViewController(SignoutViewController, close: true)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func Skipbutonaction(_ sender: UIButton) {
        UserDefaults.standard.setValue("skip", forKey: "skip")
        LoginCredentials.Isskip = true
        gotohomeacreen()
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        self.toolbar.update()
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 16.0, right: 0)
        self.view.frame.origin.y = -50
        //  myscroll.contentInset = contentInsets
        // myscroll.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0.0
        // myscroll.contentInset = .zero
        //  myscroll.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
