//
//  AppDelegate.swift
//  Point_Table
//
//  Created by Jatin Rathod on 01/09/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import CoreLocation
import Stripe
import Firebase
import Fabric
import GooglePlaces
import LocalAuthentication
import EMAlertController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,CLLocationManagerDelegate,UITabBarControllerDelegate {

    var window: UIWindow?
    var locationManager : CLLocationManager?

    var isnotification = false
    var arrMainBanner = [ShopeModel]()

    var applatitude = 0.0
    var applongitude = 0.0
    
    var orderID = 0
    var ShopID = 0
    
    var isAvailableStockDisplay = false
    var isStoreCollectionEnable = false
    var isCodEnableForCollection = false
       
       var isCodEnable = false
    var strPrivacyPolicy = ""
    var strTermCondtion = ""
    var brandName = ""
    var isSupportDistanceLogic = false
    var isSupportZipCodeLogic = false
    var isHidePointHistory = false
    var postVersion = ""


    let notificationDelegate = SampleNotificationDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        

        GMSPlacesClient.provideAPIKey(Google_Key)


       // Stripe.setDefaultPublishableKey(Stripe_Live_Key)
        Stripe.setDefaultPublishableKey(Stripe_Test_Key)
        IQKeyboardManager.shared.enable = true
        application.statusBarStyle = .lightContent

        UNUserNotificationCenter.current().delegate = self

        if let postversion = CommonFunctions.getUserDefault(key: UserDefaultsKey.PostVer) as? String {
                   print(postversion)
               } else {
            CommonFunctions.setUserDefault(object: "0.0" as AnyObject, key: UserDefaultsKey.PostVer)

        }

        if let devtoken = CommonFunctions.getUserDefault(key: UserDefaultsKey.Devtoken) as? String {
            print(devtoken)
        } else {
//            if #available(iOS 10, *) {
//                UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
//                UNUserNotificationCenter.current().delegate = self
//                application.registerForRemoteNotifications()
//            }
            
            
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
                center.delegate = notificationDelegate
                let openAction = UNNotificationAction(identifier: "OpenNotification", title: NSLocalizedString("Abrir", comment: ""), options: UNNotificationActionOptions.foreground)
                let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [openAction], intentIdentifiers: [], options: [])
                center.setNotificationCategories(Set([deafultCategory]))
            } else {
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            }
            UIApplication.shared.registerForRemoteNotifications()
            
        }
        let notificationOption = launchOptions?[.remoteNotification]
        
        
        
        
            self.gotoHome()
        
        if let notification = notificationOption as? [String: AnyObject],
            let noti = notification["aps"] as? [String: AnyObject] {
            
            if(noti["type"] as! Int == 2) {
                
                orderID = noti["orderID"] as! Int
                ShopID = noti["businessId"] as! Int

                redirectOrderDetailPush()

            } else {
                
            redirectPush()
            }
        }
        
        // Override point for customization after application launch.
        return true
    }
    func redirectPush() {
        
        isnotification = true
       
                NotificationCenter.default.post(name: Notification.Name("OPENPRAMOTION"), object: nil, userInfo: nil)
        
        
    }
    
    func redirectOrderDetailPush() {
        
        isnotification = true
        
        
        NotificationCenter.default.post(name: Notification.Name("OPENORDERDETAIL"), object: nil, userInfo: nil)

    }

    func gotoHome() {
        
        
        UITabBar.appearance().tintColor = selected_tab_color
        
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc1 = storyBaord.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navi1 = UINavigationController(rootViewController: vc1)
        navi1.tabBarItem.title = "Shop"
        navi1.tabBarItem.image = UIImage(named: "shopseleted")
        navi1.tabBarItem.selectedImage = UIImage(named: "shop")
        
        
        
        let vc2 = storyBaord.instantiateViewController(withIdentifier: "PramotionCategoryViewController") as! PramotionCategoryViewController
        vc2.isbackhide = true
        let navi2 = UINavigationController(rootViewController: vc2)
        navi2.tabBarItem.title = "Offers"
        navi2.tabBarItem.image = UIImage(named: "offers")
        navi2.tabBarItem.selectedImage = UIImage(named: "offersselected")
        
        
        let vc3 = storyBaord.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        vc3.isbackhide = true
        let navi3 = UINavigationController(rootViewController: vc3)
        navi3.tabBarItem.title = "Cart"
        navi3.tabBarItem.image = UIImage(named: "cart")
        navi3.tabBarItem.selectedImage = UIImage(named: "cartselected")
        
        
        
        let vc4 = storyBaord.instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
        vc4.isbackhide = true
        let navi4 = UINavigationController(rootViewController: vc4)
        navi4.tabBarItem.title = "Wishlist"
        navi4.tabBarItem.image = UIImage(named: "wishlists")
        navi4.tabBarItem.selectedImage = UIImage(named: "wishlistselected")
        
        
        
        let vc5 = storyBaord.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        vc5.isbackhide = true
        let navi5 = UINavigationController(rootViewController: vc5)
        navi5.tabBarItem.title = "Settings"
        navi5.tabBarItem.image = UIImage(named: "profile")
        navi5.tabBarItem.selectedImage = UIImage(named: "profileselected")
        
        
        
        /*  let vc = storyBaord.instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
         vc.shopId = arrShope[0].BusinessId ?? 0
         self.navigationController?.pushViewController(vc, animated: true)
         
         
         let vc2 = storyBaord.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
         vc.shopId = arrShope[0].BusinessId ?? 0
         self.navigationController?.pushViewController(vc, animated: true)
         
         
         let storyBaord = UIStoryboard(name: "Home", bundle: nil)
         let vc = storyBaord.instantiateViewController(withIdentifier: "PramotionCategoryViewController") as! PramotionCategoryViewController
         vc.arrShope.removeAll()
         
         vc.arrShope.append(self.arrBanner[0])
         
         self.navigationController?.pushViewController(vc, animated: true)*/
        
        
        navi1.isNavigationBarHidden = true
        navi2.isNavigationBarHidden = true
        navi3.isNavigationBarHidden = true
        navi4.isNavigationBarHidden = true
        navi5.isNavigationBarHidden = true

        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        tabBarController.viewControllers = [navi1, navi2,navi3,navi4,navi5]
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselected_tab_color], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selected_tab_color], for: .selected)
        
        objApplication.window?.rootViewController = tabBarController
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if Reachability.isConnectedToNetwork() {
                
                let param  = [String : Any]()
                
                APIManager.requestPostJsonEncoding(.getmobileversion, isLoading: false, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [String:Any] {
                        
                        
                        if let version = data["PostCodeVersion"] as? String {
                            self.postVersion = version
                        }
                        if let version = data["IOSVersion"] as? String {
                            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                            if appVersion!.compare(version, options: .numeric) == .orderedAscending {
                                //CommonFunctions.showMessage(message: "A New version of Application is available, Please update to version \(version)")
                                
                                let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                                               let alertError = EMAlertController(icon: nil, title: appName, message: "A New version of Application is available, Please update to version \(version)")
                                               alertError.addAction(EMAlertAction(title: "Ok", style: .normal, action: {
                                                   if let url = URL(string: "itms-apps://itunes.apple.com/app/id1526491407") {
                                                       UIApplication.shared.open(url)
                                                   }
                                                
                                               }))
                                               rootViewController.present(alertError, animated: true, completion: nil)
                                
                            }
                        }
                        
                        print(data)
                     
                        
                    }
                    
                  
                    
                    
                }) { (error) -> Void in
                    CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            }
            
                   var isSwitch = false
                   if let isFinger = CommonFunctions.getUserDefault(key: UserDefaultsKey.FINGER) as? Bool {
                       isSwitch = isFinger
                   }
                   if let rootViewController = self.currentViewController() {
                       rootViewController.view.isUserInteractionEnabled = true

                       let v = rootViewController.view.viewWithTag(909090)
                       v?.removeFromSuperview()
                   }
                   if isSwitch == true {
                       
                       if let rootViewController = self.currentViewController() {
                                 //do sth with root view controller
                             
                           let v = rootViewController.view.viewWithTag(909090)
                                          v?.removeFromSuperview()
                                 
                                 let imv = UIImageView.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height))
                                 imv.image = UIImage(named: "background")
                                 rootViewController.view.isUserInteractionEnabled = false
                                 imv.tag = 909090
                                 rootViewController.view.addSubview(imv)
                                 
                             
                                //the type of currentVC is MyViewController inside the if statement, use it as you want to
                             }
                       let tabBarController : UITabBarController = objApplication.window?.rootViewController as! UITabBarController
                       
                       if let tabItems = tabBarController.tabBar.items {
                           // In this case we want to modify the badge number of the third tab:
                           tabItems.forEach { $0.isEnabled = false }
                       }
                       
                       self.authenticateUser()
                   } else {
                      // getHomepageDetail()
                       
                   }
               }
        /*let storyBaord = UIStoryboard(name: "Home", bundle: nil)
         let vc = storyBaord.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
         let navi = UINavigationController(rootViewController: vc)
         navi.isNavigationBarHidden = true
         objApplication.window?.rootViewController = navi*/
        
        
        
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
             return viewController != tabBarController.selectedViewController
       }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if Reachability.isConnectedToNetwork() {
            
            let param  = [String : Any]()
            
            APIManager.requestPostJsonEncoding(.getmobileversion, isLoading: false, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                if let data = Dict["data"] as? [String:Any] {
                    if let version = data["PostCodeVersion"] as? String {
                        self.postVersion = version
                    }
                    
                   if let version = data["IOSVersion"] as? String {
                        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                        if appVersion!.compare(version, options: .numeric) == .orderedAscending {
                            //CommonFunctions.showMessage(message: "A New version of Application is available, Please update to version \(version)")
                            
                            let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                                           let alertError = EMAlertController(icon: nil, title: appName, message: "A New version of Application is available, Please update to version \(version)")
                                           alertError.addAction(EMAlertAction(title: "Ok", style: .normal, action: {
                                               if let url = URL(string: "itms-apps://itunes.apple.com/app/id1526491407") {
                                                   UIApplication.shared.open(url)
                                               }
                                            
                                           }))
                                           rootViewController.present(alertError, animated: true, completion: nil)
                            
                        }
                    }
                 
                    
                }
                
              
                
                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        }
        
        var isSwitch = false
               if let isFinger = CommonFunctions.getUserDefault(key: UserDefaultsKey.FINGER) as? Bool {
                   isSwitch = isFinger
               }
               if let rootViewController = currentViewController() {
                   rootViewController.view.isUserInteractionEnabled = true

                   let v = rootViewController.view.viewWithTag(909090)
                   v?.removeFromSuperview()
               }
               if isSwitch == true {
                   
                   if let rootViewController = currentViewController() {
                             //do sth with root view controller
                         
                             let v = rootViewController.view.viewWithTag(909090)
                                                           v?.removeFromSuperview()
                             let imv = UIImageView.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height))
                      
                             imv.image = UIImage(named: "background")
                             rootViewController.view.isUserInteractionEnabled = false
                             imv.tag = 909090
                             rootViewController.view.addSubview(imv)
                             
                         
                            //the type of currentVC is MyViewController inside the if statement, use it as you want to
                         }
                   let tabBarController : UITabBarController = objApplication.window?.rootViewController as! UITabBarController
                   
                   if let tabItems = tabBarController.tabBar.items {
                       // In this case we want to modify the badge number of the third tab:
                       tabItems.forEach { $0.isEnabled = false }
                   }
                   
                   self.authenticateUser()
               } else {
                  // getHomepageDetail()
                   
               }
    }
    func authenticateUser() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [unowned self] success, authenticationError in
                    
                    DispatchQueue.main.async {
                        if success {
                            if let rootViewController = self.currentViewController() {
                                let v = rootViewController.view.viewWithTag(909090)
                                rootViewController.view.isUserInteractionEnabled = true

                                v?.removeFromSuperview()
                            }
                            let tabBarController : UITabBarController = objApplication.window?.rootViewController as! UITabBarController
                            
                            if let tabItems = tabBarController.tabBar.items {
                                // In this case we want to modify the badge number of the third tab:
                                tabItems.forEach { $0.isEnabled = true }
                            }
                            //self.getHomepageDetail()
                        } else {
                            let tabBarController : UITabBarController = objApplication.window?.rootViewController as! UITabBarController
                            
                            if let tabItems = tabBarController.tabBar.items {
                                // In this case we want to modify the badge number of the third tab:
                                tabItems.forEach { $0.isEnabled = false }
                            }
                            if let rootViewController = self.currentViewController() {
                                                 //do sth with root view controller
                                             let v = rootViewController.view.viewWithTag(909090)
                                             v?.removeFromSuperview()
                                                 
                                                 let imv = UIImageView.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height))
                                
                                                 imv.image = UIImage(named: "background")
                                                 rootViewController.view.isUserInteractionEnabled = false
                                                 imv.tag = 909090
                                                 rootViewController.view.addSubview(imv)
                                                 
                                             
                                                //the type of currentVC is MyViewController inside the if statement, use it as you want to
                                             }
                            
    //                        context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Please authenticate to proceed.") { [weak self] (success, error) in
    //
    //                            guard success else {
    //                                print("fail")
    //
    //                                return
    //                            }
    //                            print("yes")
    //
    //
    //                        }
                            
                            self.touchIDAuthentication()

                            /*let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                            
                            let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            rootViewController.present(ac, animated: true)*/
                        }
                    }
                }
            } else {
                
                if let rootViewController = currentViewController() {
                    let v = rootViewController.view.viewWithTag(909090)
                    rootViewController.view.isUserInteractionEnabled = true

                    v?.removeFromSuperview()
                }
                let tabBarController : UITabBarController = objApplication.window?.rootViewController as! UITabBarController
                
                if let tabItems = tabBarController.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    tabItems.forEach { $0.isEnabled = true }
                }
                
                let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                
                let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                rootViewController.present(ac, animated: true)
            }
        }
        
        func touchIDAuthentication() {
            let context = LAContext()
            var error:NSError?
            
            // edit line - deviceOwnerAuthentication
            guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
                //showAlertViewIfNoBiometricSensorHasBeenDetected()
                return
            }
            
            // edit line - deviceOwnerAuthentication
    //        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                
                // edit line - deviceOwnerAuthentication
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Please authenticate to proceed.", reply: { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            print("Authentication was successful")
                            if let rootViewController = self.currentViewController() {
                                let v = rootViewController.view.viewWithTag(909090)
                                rootViewController.view.isUserInteractionEnabled = true

                                v?.removeFromSuperview()
                            }
                            let tabBarController : UITabBarController = objApplication.window?.rootViewController as! UITabBarController
                            
                            if let tabItems = tabBarController.tabBar.items {
                                // In this case we want to modify the badge number of the third tab:
                                tabItems.forEach { $0.isEnabled = true }
                            }
                        }
                    }else {
                        DispatchQueue.main.async {
                            //self.displayErrorMessage(error: error as! LAError )
                            let tabBarController : UITabBarController = objApplication.window?.rootViewController as! UITabBarController
                            
                            if let tabItems = tabBarController.tabBar.items {
                                // In this case we want to modify the badge number of the third tab:
                                tabItems.forEach { $0.isEnabled = false }
                            }
                            print("Authentication was error")
                            if let rootViewController = self.currentViewController() {
                                                 //do sth with root view controller
                                             let v = rootViewController.view.viewWithTag(909090)
                                                                                         v?.removeFromSuperview()
                                                 
                                                 let imv = UIImageView.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height))
                             
                                                 imv.image = UIImage(named: "background")
                                                 rootViewController.view.isUserInteractionEnabled = false
                                                 imv.tag = 909090
                                                 rootViewController.view.addSubview(imv)
                                                 
                                             
                                                //the type of currentVC is MyViewController inside the if statement, use it as you want to
                                             }
                        }
                    }
                })
    //        }else {
    //            // self.showAlertWith(title: "Error", message: (errorPointer?.localizedDescription)!)
    //        }
        }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        if checkPushNotificationEnabledOrNot(){
//            print("====== User is registered for notification")
//
//        }else{
//            print("====== Show alert user is not registered for notification")
//
//        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
       // DeviceToken = deviceTokenString
        CommonFunctions.setUserDefault(object: deviceTokenString as AnyObject, key: UserDefaultsKey.Devtoken)

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler(
            [UNNotificationPresentationOptions.alert,
             UNNotificationPresentationOptions.sound,
             UNNotificationPresentationOptions.badge])
    }
    
   

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer {
            completionHandler()
        }
//po print(response.notification.request.content.userInfo)
        
        /// Identify the action by matching its identifier.
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }


    if(response.notification.request.content.userInfo[AnyHashable("type")]! as! Int == 2) {
        
        orderID = response.notification.request.content.userInfo[AnyHashable("orderID")]! as! Int
        
        ShopID = response.notification.request.content.userInfo[AnyHashable("businessId")]! as! Int

        self.redirectOrderDetailPush()
    } else {
        self.redirectPush()
        }

        /// Perform the related action
      //  print("Open board tapped from a notification!")

        /// .. deeplink into the board
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Couldn’t register: (error)")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let stripeHandled = Stripe.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        } else {
            // This was not a Stripe url – handle the URL normally as you would
        }
        return false
    }

    // This method handles opening universal link URLs (e.g., "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = Stripe.handleURLCallback(with: url)
                if (stripeHandled) {
                    return true
                } else {
                    // This was not a Stripe url – handle the URL normally as you would
                }
            }
        }
        return false
    }
    
    //MARK: - Location Manages
    func setLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.distanceFilter = 200
        self.locationManager!.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cllocation:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(cllocation.latitude) \(cllocation.longitude)")
        
        CommonFunctions.setUserDefault(object: cllocation.latitude as AnyObject, key: "SavedLat")

        CommonFunctions.setUserDefault(object: cllocation.longitude as AnyObject, key: "SavedLong")

        manager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error.localizedDescription")
    }
    
    func currentViewController(
    _ viewController: UIViewController? =
        UIApplication.shared.keyWindow?.rootViewController)
            -> UIViewController? {
        guard let viewController =
        viewController else { return nil }

        if let viewController =
            viewController as? UINavigationController {
            if let viewController =
                viewController.visibleViewController {
                return currentViewController(viewController)
            } else {
                return currentViewController(
                    viewController.topViewController)
            }
        } else if let viewController =
                viewController as? UITabBarController {
            if let viewControllers =
                viewController.viewControllers,
                viewControllers.count > 5,
                viewController.selectedIndex >= 4 {
                return currentViewController(
                    viewController.moreNavigationController)
            } else {
                return currentViewController(
                    viewController.selectedViewController)
            }
        } else if let viewController =
                viewController.presentedViewController {
            return viewController
        } else if viewController.children.count > 0 {
            return viewController.children[0]
        } else {
            return viewController
        }
    }
}

