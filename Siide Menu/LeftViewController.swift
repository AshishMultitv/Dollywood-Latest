//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum LeftMenu: Int {
    case main = 0
    case First
    case Second
    case Third
    case Fourth
    case fifth
    case Six
    case Seven
    case eight
    case nine
 }

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = [String]()
    var image = [String]()
    var HomeViewController: UIViewController!
    var MyAccountViewController: UIViewController!
    var FavouriteViewController: UIViewController!
    var WatchListViewController: UIViewController!
    var PrivacyPolicyViewController: UIViewController!
    var TermsofUseViewController: UIViewController!
    var DisclairmerViewController: UIViewController!
    var AboutViewController: UIViewController!
    var DownloadsViewController: UIViewController!
    var SignoutViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    var privacypocliy = String()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(createsidemenu(data:)), name: NSNotification.Name(rawValue: "Sidemenunotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TaptoProfile), name: NSNotification.Name(rawValue: "taptoprofile"), object: nil)

        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        self.tableView.backgroundColor = UIColor.black
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.HomeViewController = UINavigationController(rootViewController: homeViewController)
        
        let myAccountViewController = storyboard.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
        self.MyAccountViewController = UINavigationController(rootViewController: myAccountViewController)
        
        let favouriteViewController = storyboard.instantiateViewController(withIdentifier: "FavouriteViewController") as! FavouriteViewController
        self.FavouriteViewController = UINavigationController(rootViewController: favouriteViewController)
        
        let watchListViewController = storyboard.instantiateViewController(withIdentifier: "WatchListViewController") as! WatchListViewController
        self.WatchListViewController = UINavigationController(rootViewController: watchListViewController)
        
        let privacyPolicyViewController = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        self.PrivacyPolicyViewController = UINavigationController(rootViewController: privacyPolicyViewController)
        
        let termsofUseViewController = storyboard.instantiateViewController(withIdentifier: "TermsofUseViewController") as! TermsofUseViewController
        self.TermsofUseViewController = UINavigationController(rootViewController: termsofUseViewController)
        
        let disclairmerViewController = storyboard.instantiateViewController(withIdentifier: "DisclairmerViewController") as! DisclairmerViewController
        self.DisclairmerViewController = UINavigationController(rootViewController: disclairmerViewController)
        
        let aboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.AboutViewController = UINavigationController(rootViewController: aboutViewController)
        
        let downloadsViewController = storyboard.instantiateViewController(withIdentifier: "DownloadsViewController") as! DownloadsViewController
        self.DownloadsViewController = UINavigationController(rootViewController: downloadsViewController)
        
        
        let signoutViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.SignoutViewController = UINavigationController(rootViewController: signoutViewController)
        
        
 
        
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
        
    }
    
    
    func TaptoProfile()
    {
        if(Common.Islogin())
        {
        LoginCredentials.faveprofileorother = "Myaccount"
        self.slideMenuController()?.changeMainViewController(self.MyAccountViewController, close: true)
        }
        else
        {
            showWithoutloginalert()
        }
    }
    func createsidemenu(data:Notification)
    {
        menus.removeAll()
        print(data.object as Any)
        let array = (data.object as! NSDictionary).value(forKey: "left_menu") as! NSArray
         for i in 0..<array.count {
            let str = (array.object(at: i) as! NSDictionary).value(forKey: "page_title") as! String
            let imageurl = (array.object(at: i) as! NSDictionary).value(forKey: "thumbnail") as! String
           menus.append(str)
           image.append(imageurl)
            
          let str1 = (array.object(at: i) as! NSDictionary).value(forKey: "identifier") as! String
            if(str1 == "privacy")
            {
                privacypocliy = (array.object(at: i) as! NSDictionary).value(forKey: "page_description") as! String
                LoginCredentials.Privacypolcy = privacypocliy
            }
             if(str1 == "tc")
            {
                LoginCredentials.Termsanduse = (array.object(at: i) as! NSDictionary).value(forKey: "page_description") as! String
            }
              if(str1 == "disclaimer")
            {
                LoginCredentials.Disclaimer = (array.object(at: i) as! NSDictionary).value(forKey: "page_description") as! String
            }
            if(str1 == "about")
            {
                LoginCredentials.About = (array.object(at: i) as! NSDictionary).value(forKey: "page_description") as! String
            }
            
            
        }
        self.tableView.reloadData()
        
      print(menus)
        
        
    }
  
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    ///////Login/logout button Action////////////////
    
    func loginlogoutaction()
    {
     if (dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict").count>0)
          {
        let alertView = UIAlertController(title: "Dollywood Play", message: "Are you sure want to Signout?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Signout", style: .default, handler: { (alert) in
            dataBase.deletedataentity(entityname: "Logindata")
            dataBase.deletedataentity(entityname: "Downloadvideoid")
            dataBase.deletedataentity(entityname: "VideoDownload")
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Setprofiledata"), object: nil, userInfo: nil)
             self.redirecttologinscreen()
            Common.stopHeartbeat()
 
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            
        })
        alertView.addAction(action)
        alertView.addAction(cancel)
        self.present(alertView, animated: true, completion: nil)
        }
        else
          {
          redirecttologinscreen()
        }
      
        
        
    }
    
  func redirecttologinscreen()
  {
    
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    self.SignoutViewController = UINavigationController(rootViewController: loginViewController)
    self.slideMenuController()?.changeMainViewController(self.SignoutViewController, close: true)
  }
    
    
    
  
    
    func showWithoutloginalert()
    {
        
        let alertView = UIAlertController(title: "Dollywood Play", message: "Please login to access this section", preferredStyle: .alert)
        let action = UIAlertAction(title: "Login", style: .default, handler: { (alert) in
            self.redirecttologinscreen()
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            
        })
        alertView.addAction(action)
        alertView.addAction(cancel)
        self.present(alertView, animated: true, completion: nil)
        
        
        
        
    }
    

   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.HomeViewController, close: true)
        case .First:
            if(Common.Islogin())
            {
            LoginCredentials.faveprofileorother = "Myaccount"
            self.slideMenuController()?.changeMainViewController(self.MyAccountViewController, close: true)
            }
            else
            {
                showWithoutloginalert()
            }
        case .Second:
            if(Common.Islogin())
            {
            LoginCredentials.faveprofileorother = "favorite"
            self.slideMenuController()?.changeMainViewController(self.MyAccountViewController, close: true)
            }
            else
            {
                showWithoutloginalert()
            }
        case .Third:
            if(Common.Islogin())
            {
            LoginCredentials.faveprofileorother = "watching"
             self.slideMenuController()?.changeMainViewController(self.MyAccountViewController, close: true)
            }
            else
            {
                showWithoutloginalert()
            }
        case .Fourth:
             LoginCredentials.headerlabeltext = "Privacy Policy"
            self.slideMenuController()?.changeMainViewController(self.PrivacyPolicyViewController, close: true)
        case .fifth:
            LoginCredentials.headerlabeltext = "Terms of Use"
             self.slideMenuController()?.changeMainViewController(self.PrivacyPolicyViewController, close: true)
        case .Six:
            LoginCredentials.headerlabeltext = "Disclaimer"
              self.slideMenuController()?.changeMainViewController(self.PrivacyPolicyViewController, close: true)
        case .Seven:
            LoginCredentials.headerlabeltext = "About"
              self.slideMenuController()?.changeMainViewController(self.PrivacyPolicyViewController, close: true)
        case .eight:
            self.slideMenuController()?.changeMainViewController(self.DownloadsViewController, close: true)
        case .nine:
            self.loginlogoutaction()
            
           // self.slideMenuController()?.changeMainViewController(self.FavouriteViewController, close: true)
       
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main, .First, .Second, .Third, .Fourth, .fifth, .Six, .Seven, .eight, .nine:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main, .First, .Second, .Third, .Fourth, .fifth, .Six, .Seven, .eight, .nine:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                 cell.setData(menus[indexPath.row])
                cell.setmenuimage(image[indexPath.row])
                cell.backgroundColor = UIColor.black
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
