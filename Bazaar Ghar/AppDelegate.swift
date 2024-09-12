//
//  AppDelegate.swift
//  Bazaar Ghar
//
//  Created by Developer on 18/08/2023.
//

import UIKit
import FirebaseCore
import UserNotifications
import IQKeyboardManagerSwift
import Presentr
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import AuthenticationServices
import Firebase
import FirebaseAnalytics
import FBSDKCoreKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
var slugid = String()
    var isback = false
    var verifyid = String()
    var phoneno = String()
    var videotoken = String()
    var videoid = String()
    var phonenowithout = String()
    var isbutton = Bool()
    let settings = FBSDKCoreKit.Settings.shared
    
var currencylabel = "SAR "
var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
      var fcmtoken = String()
    var shouldUseCustomFont : Bool? {
        didSet {
            if let rootView = window?.rootViewController?.view {
                rootView.setAllLabelsFontConditionally(useCustomFont: shouldUseCustomFont ?? true)
            }
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        
      FirebaseApp.configure()
      registerForPushNotifications()
        
        
        
        if AppDefault.getAllCategoriesResponsedata?.count ?? 0 > 0{
            
        }else{
            self.onBoardingVc()
        }
        
        if AppDefault.languages == "en" {
             LanguageManager.language = AppDefault.languages

        }else {
            LanguageManager.language = AppDefault.languages
        }
        
        Messaging.messaging().delegate = self
              // [END set_messaging_delegate]
              // Register for remote notifications. This shows a permission dialog on first run, to
              // show the dialog at a more appropriate time move this registration accordingly.
              // [START register_for_notifications]
              UNUserNotificationCenter.current().delegate = self
              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
               options: authOptions,
               completionHandler: { _, _ in }
              )
              application.registerForRemoteNotifications()
        settings.isAdvertiserTrackingEnabled = true
        IQKeyboardManager.shared.enable = true
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         // Handle Facebook URL
         let facebookHandled = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
         // You can add custom URL handling here
         return facebookHandled
       }
     func refreshToken(refreshToken:String){
        APIServices.refreshToken(refreshToken:refreshToken){[weak self] data in
            switch data{
            case .success(let res):
                
                AppDefault.currentUser = res.user
                AppDefault.accessToken  = res.tokens?.access?.token ?? ""
                AppDefault.refreshToken = res.tokens?.refresh?.token ?? ""
                AppDefault.islogin = true
                DispatchQueue.main.async {
                    self?.GotoDashBoard(ischecklogin: false)
                }
            case .failure(let error):
                print(error)
                UIApplication.topViewController()?.view.makeToast(error)
            }
        }
    }

    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // 1. Check to see if permission is granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func onBoardingVc() {
        // Load the TabBarViewController from the Main storyboard
//        guard let tabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else {
//            // Failed to instantiate TabBarViewController
//            return
//        }
        guard let tabBarViewController = UIStoryboard(name: "sidemenu", bundle: nil).instantiateViewController(withIdentifier: "Shake_ViewController") as? Shake_ViewController else {
            // Failed to instantiate TabBarViewController
            return
        }
        
        // Set the login status
       
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                // Failed to get AppDelegate
                return
            }
            
            // Dismiss any presented view controllers before setting the root view controller
            appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
            
            appDelegate.window?.rootViewController = tabBarViewController
    }
  
    func GotoDashBoard(ischecklogin: Bool) {
        // Load the TabBarViewController from the Main storyboard
//        guard let tabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else {
//            // Failed to instantiate TabBarViewController
//            return
//        }
        guard let tabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoundTabbarVc") as? RoundTabbarVc else {
            // Failed to instantiate TabBarViewController
            return
        }
        
        // Set the login status
        tabBarViewController.ischecklogin = ischecklogin
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                // Failed to get AppDelegate
                return
            }
            
            // Dismiss any presented view controllers before setting the root view controller
            appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
            
            appDelegate.window?.rootViewController = tabBarViewController
    }
     func GotoDashBoardnotification(ischecklogin: Bool,misc: String){
        
        // Load the TabBarViewController from the Main storyboard
        guard let tabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoundTabbarVc") as? RoundTabbarVc else {
            // Failed to instantiate TabBarViewController
            return
        }
        
        // Set the login status
        tabBarViewController.ischecklogin = ischecklogin
        tabBarViewController.miscid = misc
        
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                 // Failed to get AppDelegate
                 return
             }
             
             // Dismiss any presented view controllers before setting the root view controller
             appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
             
             appDelegate.window?.rootViewController = tabBarViewController
    }
       
    
    func showCustomerAlertControllerHeight(title:String,heading:String,btn1Title:String,btn1Callback:@escaping()->Void,btn2Title:String,btn2Callback:@escaping()->Void){
        guard let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: String(describing: PCustomAlertController.self)) as? PCustomAlertController else {return}
        let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: 0.2), center: .center))
        presenter.roundCorners = true
        presenter.cornerRadius = 10
        vc.btn1Title = btn1Title
        vc.btn1Callback = {
          btn1Callback()
        }
        vc.btn2Title = btn2Title
        vc.btn2Callback = {
          btn2Callback()
        }
        vc.titleText = title
        vc.headingText = heading
        UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
      }
    func showCustomerLanguageAlertControllerHeight(title:String,heading:String,btn1Title:String,btn1Callback:@escaping()->Void,btn2Title:String,btn2Callback:@escaping()->Void){
        guard let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: String(describing: LanguagePopupViewController.self)) as? LanguagePopupViewController else {return}
        let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: 0.2), center: .center))
        presenter.roundCorners = true
        presenter.cornerRadius = 10
        vc.btn1Title = btn1Title
        vc.btn1Callback = {
          btn1Callback()
        }
        vc.btn2Title = btn2Title
        vc.btn2Callback = {
          btn2Callback()
        }
        vc.titleText = title
        vc.headingText = heading
        UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
      }
    
    func ChineseShowCustomerAlertControllerHeight(title:String,heading:String,note:String,miscid:String,btn1Title:String,btn1Callback:@escaping()->Void,btn2Title:String,btn2Callback:@escaping(_ token:String,_ id:String)->Void){
        guard let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: String(describing: popupChineseBellViewController.self)) as? popupChineseBellViewController else {return}
        if miscid == "" {
            var h = 0.0
            if title.count < 45{
                h = 0.19
            }else {
                h = 0.22
            }
            let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: Float(h)), center: .center))
            presenter.roundCorners = true
            presenter.cornerRadius = 10
            vc.btn1Title = btn1Title
            vc.miscid = miscid
            vc.btn1Callback = {
              btn1Callback()
            }
            vc.btn2Title = btn2Title
            vc.btn2Callback = { (token, videoId) in
                btn2Callback(token, videoId)
            }
            vc.titleText = title
            vc.titleLblText = heading
            vc.noteText = note
            if miscid == "hide" {
                vc.btn1.isHidden = true
            }
            UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
        }else {
            let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: 0.18), center: .center))
            presenter.roundCorners = true
            presenter.cornerRadius = 10
            vc.btn1Title = btn1Title
            vc.miscid = miscid
            vc.btn1Callback = {
              btn1Callback()
            }
            vc.btn2Title = btn2Title
            vc.btn2Callback = { (token, videoId) in
                btn2Callback(token, videoId)
            }
            vc.titleText = title
            vc.titleLblText = heading
            vc.noteText = note

            UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
        }
     
      }
      func showCustomerAlertControllerwithOneButton(title:String,btn2Title:String,btn2Callback:@escaping()->Void){
        guard let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: String(describing: PCustomAlertController.self)) as? PCustomAlertController else {return}
        let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: 0.2), center: .center))
        presenter.roundCorners = true
        presenter.cornerRadius = 10
        vc.isOneButton = true
        //vc.btn1.isHidden = true
    //    vc.btn1Title = btn1Title
    //    vc.btn1Callback = {
    //      btn1Callback()
    //    }
        vc.btn2Title = btn2Title
        vc.btn2Callback = {
          btn2Callback()
        }
        vc.titleText = title
        UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
          
      }
      func showCustomerAlertController(title:String,btn1Title:String,btn1Callback:@escaping()->Void,btn2Title:String,btn2Callback:@escaping()->Void){
        guard let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: String(describing: PCustomAlertController.self)) as? PCustomAlertController else {return}
        let presenter = Presentr(presentationType: .custom(width: .fluid(percentage: 0.9), height: .fluid(percentage: 0.25), center: .center))
        presenter.roundCorners = true
        presenter.cornerRadius = 10
        vc.btn1Title = btn1Title
        vc.btn1Callback = {
          btn1Callback()
        }
        vc.btn2Title = btn2Title
        vc.btn2Callback = {
          btn2Callback()
        }
        vc.titleText = title
        UIApplication.pTopViewController().customPresentViewController(presenter, viewController: vc, animated: true)
      }
    
    
    
    
    func application(_ application: UIApplication,
                didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
       }
       // [START receive_message]
       func application(_ application: UIApplication,
                didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
        -> UIBackgroundFetchResult {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        return UIBackgroundFetchResult.newData
       }
       // [END receive_message]
       func application(_ application: UIApplication,
                didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
       }
       // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
       // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
       // the FCM registration token.
      func application(application: UIApplication,
               didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let firebaseAuth = Auth.auth()
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
        Messaging.messaging().token { (token, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error.localizedDescription)")
          } else if let token = token {
            self.fcmtoken = token
            UserDefaults.standard.set(token , forKey: "Token2")
            print("Token is firebase \(token)")
          }
        }
      }
    
    
    

}

let appDelegate = UIApplication.shared.delegate as! AppDelegate

//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print(deviceToken)
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print(error)
//    }
//}




extension AppDelegate: UNUserNotificationCenterDelegate {
 // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print(notification)
    let userInfo = notification.request.content.userInfo
    print(userInfo)
    let noti_type = userInfo["aps"] as? NSDictionary
    let alert = noti_type?["alert"] as? NSDictionary
    print(alert)
    let date = Date()
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd h:mm a"
    let dateString = df.string(from: date)
    print(dateString)
      
      let tittle = alert?["title"] as? String
     
      
          let misc = userInfo["misc"] as? String
      
      
      if(misc != ""){
          AppDefault.miscid = misc ?? ""
      }else{
          
      }
      let body = alert?["body"] as? String ?? ""
      let lastFourCharacters = String(body.suffix(5))
      if(lastFourCharacters == "busy."){
          appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Seller \(AppDefault.brandname) is busy." , heading: "Busy", note: "", miscid: "hide", btn1Title: "Cancel", btn1Callback: {
              
          }, btn2Title: "Ok") { token, id in
        }
      }else{
          if(AppDefault.miscid != ""){
              self.GotoDashBoardnotification(ischecklogin: false, misc: AppDefault.miscid )
          }
      }
           
        
      
      
      
      

    
  }
 func userNotificationCenter(_ center: UNUserNotificationCenter,
               didReceive response: UNNotificationResponse) async {
  let userInfo = response.notification.request.content.userInfo
  // [START_EXCLUDE]
  // Print message ID.
  if let messageID = userInfo[gcmMessageIDKey] {
   print("Message ID: \(messageID)")
  }
  // [END_EXCLUDE]
  // With swizzling disabled you must let Messaging know about the message, for Analytics
  // Messaging.messaging().appDidReceiveMessage(userInfo)
  // Print full message.
  print(userInfo)
   let noti_type = userInfo["aps"] as? NSDictionary
   let alert = noti_type?["alert"] as? NSDictionary
     
     let tittle = alert?["title"] as? String
     


         let misc = userInfo["misc"] as? String

     if(misc != ""){
         AppDefault.miscid = misc ?? ""
     }else{
         
     }
     
     
     
     
     let body = alert?["body"] as? String ?? ""
     let lastFourCharacters = String(body.suffix(5))
     if(lastFourCharacters == "busy."){
         appDelegate.ChineseShowCustomerAlertControllerHeight(title: "Seller \(AppDefault.brandname) is busy." , heading: "Busy", note: "", miscid: "hide", btn1Title: "Cancel", btn1Callback: {
             
         }, btn2Title: "Ok") { token, id in
        }
     }else{
         if(AppDefault.miscid != ""){
             self.GotoDashBoardnotification(ischecklogin: false, misc: AppDefault.miscid )
             
         }else {
         }
     }
     
     
     
     
     
     
    
      
         
     
    
   let date = Date()
   let df = DateFormatter()
   df.dateFormat = "yyyy-MM-dd h:mm a"
   let dateString = df.string(from: date)
   print(dateString)
     
     
     
     
     
   
     
 }
}

extension AppDelegate: MessagingDelegate {
 // [START refresh_token]
 func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
  print("Firebase registration token: \(String(describing: fcmToken))")
   UserDefaults.standard.set(fcmToken ?? "" , forKey: "Token2")
     AppDefault.FcmToken = fcmToken ?? ""
  let dataDict: [String: String] = ["token": fcmToken ?? ""]
  NotificationCenter.default.post(
   name: Notification.Name("FCMToken"),
   object: nil,
   userInfo: dataDict
  )
  // TODO: If necessary send token to application server.
  // Note: This callback is fired at each app startup and whenever a new token is generated.
 }
 // [END refresh_token]
}
