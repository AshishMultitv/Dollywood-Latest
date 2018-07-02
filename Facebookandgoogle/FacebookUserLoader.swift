import Foundation
import FBSDKLoginKit

/**

Load user profile information from Facebook.

*/
public class FacebookUserLoader {
  
  private var _loginManager: FBSDKLoginManager?
  
  private var loginManager: FBSDKLoginManager? {
    get {
      if FacebookUserLoader.isSimulated { return nil }
      
      if _loginManager == nil {
        _loginManager = FBSDKLoginManager()
      }
      
      return _loginManager
    }
  }
  
  private var currentConnection: FBSDKGraphRequestConnection?
  
  public init() { }
  
  deinit {
    cancel()
  }
  
  /**
  
  Loads Facebook user profile.
  
  - parameter askEmail: If true we ask Facebook to return user's email. User may reject this request and return no email.
  - parameter onError: A function that will be called in case of any error. It will also be called if users cancells the Facebook login.
  - parameter onSuccess: A function that will be called after user authenticates with Facebook. A user profile information is passed to the function.\
  */
  public func load(askEmail: Bool, onError:@escaping ()->(), onSuccess: @escaping (TegFacebookUser)->()) {
    if FacebookUserLoader.isSimulated {
       FacebookUserLoader.simulateError(onError: onError)
     // FacebookUserLoader.simulateError(onError)
      FacebookUserLoader.simulateSuccess(onSuccess: onSuccess)
      return
    }
    
    cancel()
    logOut()
    logInAndLoadUserProfile(askEmail: askEmail, onError: onError, onSuccess: onSuccess)
  }
  
  func cancel() {
    currentConnection?.cancel()
    currentConnection = nil
  }
  
  private func logInAndLoadUserProfile(askEmail: Bool, onError: @escaping ()->(),
    onSuccess: @escaping (TegFacebookUser)->()) {
      
    var permissions = ["public_profile"]
    
    if askEmail {
      permissions.append("email")
    }
    
    loginManager?.logIn(withReadPermissions: permissions) { [weak self] result, error in
      if error != nil {
        onError()
        return
      }
      
      if (result?.isCancelled)! {
        onError()
        return
      }
      
      self?.loadFacebookMeInfo(onError: onError, onSuccess: onSuccess)
    }
  }
  
  private func logOut() {
    loginManager?.logOut()
    
  }
  
  /// Loads user profile information from Facebook.
  private func loadFacebookMeInfo(onError: @escaping ()->(), onSuccess: @escaping (TegFacebookUser) -> ()) {
    if FBSDKAccessToken.current() == nil {
      onError()
      return
    }
    
    let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" as NSObject: "name, first_name, last_name, picture.type(large), email, gender" as AnyObject] as [NSObject : AnyObject])
    
    currentConnection = graphRequest?.start { [weak self] connection, result, error in
      if error != nil {
        onError()
        return
      }
      
      if let userData = result as? NSDictionary,
        let accessToken = self?.accessToken,
        let user = FacebookUserLoader.parseMeData(data: userData, accessToken: accessToken) {
        
        onSuccess(user)
      } else {
        onError()
      }
    }
  }
    
  
  
  /// Parses user profile dictionary returned by Facebook SDK.
  class func parseMeData(data: NSDictionary, accessToken: String) -> TegFacebookUser? {
    if let id = data["id"] as? String {
      return TegFacebookUser(
        id: id,
        accessToken: accessToken,
        email: data["email"] as? String,
        firstName: data["first_name"] as? String,
        lastName: data["last_name"] as? String,
        name: data["name"] as? String,
        sex: data["gender"] as? String,
        picture: ((data["picture"] as! NSDictionary).value(forKey: "data") as! NSDictionary).value(forKey: "url") as! String
   
       // picture: ((data.objectForKey("picture") as AnyObject).objectForKey("data") as AnyObject).object("url") as? String
        )
    }
    
    return nil
  }
  
  private var accessToken: String? {
    return FBSDKAccessToken.current().tokenString
  }
  
  // MARK: - Simulation for tests
  // -------------------------------
  
  /**
  
  If present, the `load` method will call `onSuccess` function with the supplied user without touching Facebook SDK. Used in tests.
  
  */
  public static var simulateSuccessUser: TegFacebookUser?
  
  /// If true the `load` method will call `onError` function without touching Facebook SDK. Used in tests.
  public static var simulateError = false
  
  /// Delay used to simulate Facebook response. If 0 response is returned synchronously.
  public static var simulateLoadAfterDelay = 0.1
  
  
  private class func simulateSuccess(onSuccess: @escaping (TegFacebookUser)->()) {
    if let successUser = simulateSuccessUser {
      runAfterDelay(delaySeconds: simulateLoadAfterDelay) { onSuccess(successUser) }
    }
  }
  
  private class func simulateError(onError: @escaping ()->()) {
    if simulateError {
      runAfterDelay(delaySeconds: simulateLoadAfterDelay) { onError() }
    }
  }
  
  /// Runs the block after the delay. If delay is 0 the block is called synchronously.
  private class func runAfterDelay(delaySeconds: Double, block: ()->()) {
    if delaySeconds == 0 {
      block()
    } else {
        let time: DispatchTime = DispatchTime.now() + Double(Int64((delaySeconds * Double(NSEC_PER_SEC))))
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
        })
    
        
//      let time = DispatchTime.now(dispatch_time_t(DispatchTime.now()), Int64(delaySeconds * Double(NSEC_PER_SEC)))
//      dispatch_after(time, DispatchQueue.main, block)
 }
  }
  
  /// Check if we are currently simulating the facebook loading, which is used in unit test.
  private static var isSimulated: Bool {
    if simulateSuccessUser != nil { return true }
    if simulateError { return true }
    return false
  }
}
