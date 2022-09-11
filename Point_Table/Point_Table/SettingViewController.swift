//
//  HomeViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 02/09/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import EMAlertController
import SkyFloatingLabelTextField
import LocalAuthentication

class SettingViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var lblHeader: UILabel!
    
        @IBOutlet weak var tblSearchStore: UITableView!
    var arrSearchStore = [SearchShopeModel]()

    @IBOutlet weak var tblView: UITableView!
    var index = -1;

    @IBOutlet weak var imgAuth: UIImageView!

    var arrSetting = [String]()
    
    var isbackhide = false

    @IBOutlet weak var viewStore: UIView!
    @IBOutlet weak var imgBackStore: UIImageView!
    @IBOutlet weak var lblTitleStore: UILabel!
    @IBOutlet weak var btnCloseStore: UIButton!
    @IBOutlet weak var btnDoneStore: UIButton!
    var imagePickerViewController:UIImagePickerController?

    @IBOutlet weak var tblStore: UITableView!
    var arrBanner = [ShopeModel]()
    
    @IBOutlet weak var viewZip: UIView!
    @IBOutlet weak var lblHeaderzip: UILabel!
    @IBOutlet weak var txtZip: SkyFloatingLabelTextField!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblDilivery: UILabel!
    @IBOutlet weak var constDelivery: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!

    
    @IBOutlet weak var btnClose: UIButton!
      @IBOutlet weak var imgQr: UIImageView!
      @IBOutlet weak var lblMemberId: UILabel!
      @IBOutlet weak var lblMember: UILabel!
      @IBOutlet weak var viewQr: UIView!
      @IBOutlet weak var imgBackQr: UIImageView!
    var indexStore = -1;
    @IBOutlet weak var constTblheight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSearchStore.register(UINib(nibName: "BLClientCell", bundle: nil), forCellReuseIdentifier:"BLClientCell")

        if isbackhide == true {
                          btnBack.isHidden = true
                      } else {
                          btnBack.isHidden = false
                      }
               
        SetupUI()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        var strName = ""
        if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
        
            
            for i in 0..<objApplication.arrMainBanner.count {
            if objApplication.arrMainBanner[i].BusinessId! == sid {
               index = i
                strName = objApplication.arrMainBanner[i].BusinessName!
            }
        }
            tblStore.reloadData()
        }
        if CommonFunctions.userLoginData() == true {
            arrSetting = ["","\(strName)", "Set Fingerprint", "Update Password", "User Profile", "Shipping address", "Billing address" ,"My Orders", "Third Party","Point History","Privacy Policy", "Terms And Conditions", "Logout", "Version " + (appVersion ?? "")]
        } else {
            arrSetting = ["\(strName)","Third Party", "Privacy Policy", "Terms And Conditions","Version " + (appVersion ?? "")]
            
        }
  self.tblView.reloadData()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
                    self.tabBarController?.tabBar.isHidden = true

          }
          override func viewDidLayoutSubviews() {
                    self.tabBarController?.tabBar.isHidden = false

          }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

        var isSwitch = false
        if let isFinger = CommonFunctions.getUserDefault(key: UserDefaultsKey.FINGER) as? Bool {
            isSwitch = isFinger
        }
        imgAuth.isHidden = true
        
          if isbackhide == true {
                            btnBack.isHidden = true
                        } else {
                            btnBack.isHidden = false
                        }
                 
          SetupUI()
          let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

          var strName = ""
          if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
          
              
              for i in 0..<objApplication.arrMainBanner.count {
              if objApplication.arrMainBanner[i].BusinessId! == sid {
                 index = i
                  strName = objApplication.arrMainBanner[i].BusinessName!
              }
          }
              tblStore.reloadData()
          }
          if CommonFunctions.userLoginData() == true {
              arrSetting = ["","\(strName)", "Set Fingerprint", "Update Password", "User Profile", "Shipping address", "Billing address" ,"My Orders", "Third Party","Point History","Privacy Policy", "Terms And Conditions", "Logout", "Version " + (appVersion ?? "")]
          } else {
              arrSetting = ["\(strName)","Third Party", "Privacy Policy", "Terms And Conditions","Version " + (appVersion ?? "")]
              
          }
        self.tblView.reloadData()
    if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
        
        let user = UserModel(json: userdict)
        lblMemberId.text = "\(user.UserUUID!)"
        self.GenerateQr(name: "\(user.UserUUID!)")
    }
          // Do any additional setup after loading the view.
      }
   
    //MARK:- Generate QR Code
    func GenerateQr(name : String) -> Void {
        let myString = name
        // Get data from the string
        let data = myString.data(using: String.Encoding.ascii)
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // Input the data
        qrFilter.setValue(data, forKey: "inputMessage")
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return }
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
        let processedImage = UIImage(cgImage: cgImage)
        
        imgQr.image = processedImage
    }
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        constTblheight.constant = 0
        tblSearchStore.isHidden = true
        imgBackQr.isHidden = true
              viewQr.isHidden = true
              lblMemberId.adjustsFontSizeToFitWidth = true
              lblMemberId.isHidden = true
        btnClose.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        lblMember.font = UIFont(name: Font_Semibold, size: 17)
              lblMemberId.font = UIFont(name: Font_Semibold, size: 22)
        CommonFunctions.setCornerRadius(view: btnClose, radius: 17)
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                 
                 let user = UserModel(json: userdict)
                 lblMemberId.text = "\(user.UserUUID!)"
                 self.GenerateQr(name: "\(user.UserUUID!)")
             }
        tblStore.tag = 1001
        
        imgBackStore.isHidden = true
        viewStore.isHidden = true
        viewZip.isHidden = true

                lblHeaderzip.font = UIFont(name: Font_Semibold, size: 17)

        txtZip.font = UIFont(name: Font_Regular, size: 17)
        txtZip.titleFormatter = { $0 }

        btnCancel.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        btnConfirm.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: viewZip, radius: 13)

        CommonFunctions.setCornerRadius(view: btnConfirm, radius: 17)
        CommonFunctions.setCornerRadius(view: btnCancel, radius: 17)

        
        tblView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier:"SettingCell")
        
        tblStore.register(UINib(nibName: "StoreCell", bundle: nil), forCellReuseIdentifier: "StoreCell")

        tblView.register(UINib(nibName: "HomeProfileCell", bundle: nil), forCellReuseIdentifier: "HomeProfileCell")

        
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        
        lblTitleStore.font = UIFont(name: Font_Semibold, size: 17)

        btnDoneStore.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnDoneStore, radius: 17)
        
        btnCloseStore.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnCloseStore, radius: 17)

        
    }
    
    
    // MARK: - IBAction Event
    
    func shopselected() {
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["Latitude"] = arrSearchStore[indexStore].Latitude
            param["Longitude"] = arrSearchStore[indexStore].Longitude
            param["ZipCode"] = arrSearchStore[indexStore].PostCode
            
            APIManager.requestPostJsonEncoding(.validatezipcode, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                if let data = Dict["data"] as? [String:Any] {
                  let message = data["ZipCodeMessage"] as? String
                    if let isValid = data["IsValid"] as? Bool {
                        if isValid == true {
                         if let ShopId = data["ShopId"] as? Int {
                         CommonFunctions.setUserDefault(object: ShopId as AnyObject, key: UserDefaultsKey.StoreID)
                          
                          let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

                          var strName = ""
                                 if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                                 
                                     
                                     for i in 0..<objApplication.arrMainBanner.count {
                                     if objApplication.arrMainBanner[i].BusinessId! == sid {
                                        self.index = i
                                         strName = objApplication.arrMainBanner[i].BusinessName!
                                     }
                                 }
                                 }
                                 if CommonFunctions.userLoginData() == true {
                                     self.arrSetting = ["","\(strName)", "Set Fingerprint", "Update Password", "User Profile", "Shiping address", "Billing address" ,"My Orders", "Third Party","Point History","Privacy Policy", "Terms And Conditions", "Logout", "Version " + (appVersion ?? "")]
                                 } else {
                                     self.arrSetting = ["\(strName)","Third Party", "Privacy Policy", "Terms And Conditions","Version " + (appVersion ?? "")]
                                     
                                 }
                          self.tblView.reloadData()
                          
                         }

                         self.btnCancel.setTitle("Continue", for: .normal)

                            self.constDelivery.constant = 250 + 200

                            self.lblDilivery.text = message
                         
                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.txtZip.text = ""
                             self.txtZip.resignFirstResponder()
                             self.lblDilivery.text = ""
                             self.viewZip.isHidden = true
                             self.imgBackStore.isHidden = true
                         }
                         
                         
                        } else {
                            self.constDelivery.constant = 250 + 200
                            self.lblDilivery.text = message
                            
                        }
                    }
                }
                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }

    }
    
    @IBAction func btnConfirmClicked(_ sender: Any) {
              indexStore = -1
              arrSearchStore.removeAll()
              tblSearchStore.reloadData()
              
              self.tblSearchStore.isHidden = true
              self.constTblheight.constant = 0
              self.constDelivery.constant = 250 - 40
              self.lblDilivery.text = ""
              var index = -1
              txtZip.resignFirstResponder()
              //viewZip.isHidden = true
             // imgBackZip.isHidden = true
              
              if txtZip.text == "" {
                  CommonFunctions.showMessage(message: Message.enterzip)
                  return
              }
              if Reachability.isConnectedToNetwork() {
                  
                  var param  = [String : Any]()
                  param["SearchKeyword"] = txtZip.text
                  
                  APIManager.requestPostJsonEncoding(.searchStore, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                      
                      let Dict = JSONResponse as! [String:Any]
                      print(Dict)
                      if let data = Dict["data"] as? [[String:Any]] {
                          if data.count > 0 {
                              
                                  
                                  for objAd in data {
                                      let obj = SearchShopeModel(json: objAd)
                                      self.arrSearchStore.append(obj)
                                  }
                              
                              self.tblSearchStore.reloadData()
                                  
                                  
                              self.tblSearchStore.isHidden = false
                              self.constTblheight.constant = 200
                              self.constDelivery.constant = 450 - 40

                          } else {
                              self.constDelivery.constant = 250

                              self.lblDilivery.text = "Delivery is not available for this area at the moment. You can still place order and collect it from our store. Thank you"
                              print("no shop found")
                          }
                      } else {
                          self.constDelivery.constant = 250

                          self.lblDilivery.text = "Delivery is not available for this area at the moment. You can still place order and collect it from our store. Thank you"
                      }
                     /* if let data = Dict["data"] as? [String:Any] {
                          if let isValid = data["IsValid"] as? Bool {
                              if isValid == true {
                                  if let ShopId = data["ShopId"] as? Int {
                                      CommonFunctions.setUserDefault(object: ShopId as AnyObject, key: UserDefaultsKey.StoreID)
                                  }
                                  self.constDelivery.constant = 260
                                  self.lblDilivery.text = "If avaliable say good news we deliver to your area with ✅ click continue rather than cancel"
                              } else {
                                  self.constDelivery.constant = 250

                                  self.lblDilivery.text = "Delivery is not available for this area at the moment. You can still place order and collect it from our store. Thank you"
                                  
                              }
                          }
                      }*/
                  }) { (error) -> Void in
                      CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                  }
              } else {
                  CommonFunctions.showMessage(message: Message.internetnotconnected)
              }
              
          }
          
          @IBAction func btnCancekClicked(_ sender: Any) {
              self.constDelivery.constant = 250 - 60
            self.constTblheight.constant = 0
            self.tblSearchStore.isHidden = true
           self.btnCancel.setTitle("Cancel", for: .normal)

              self.txtZip.text = ""
              txtZip.resignFirstResponder()
              lblDilivery.text = ""
              viewZip.isHidden = true
              imgBackStore.isHidden = true
          }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseStoreClicked(_ sender: Any) {
        imgBackStore.isHidden = true
        viewStore.isHidden = true
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
         imgBackQr.isHidden = true
         viewQr.isHidden = true
     }
    @IBAction func btnDoneStoreClicked(_ sender: Any) {
        
        if index == -1 {
            CommonFunctions.showMessage(message: Message.selectstore)
            return
        }
        
        imgBackStore.isHidden = true
        viewStore.isHidden = true
        
        CommonFunctions.setUserDefault(object: self.arrBanner[index].BusinessId! as AnyObject, key: UserDefaultsKey.StoreID)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        var strName = ""
               if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
               
                   
                   for i in 0..<objApplication.arrMainBanner.count {
                   if objApplication.arrMainBanner[i].BusinessId! == sid {
                      index = i
                       strName = objApplication.arrMainBanner[i].BusinessName!
                   }
               }
               }
               if CommonFunctions.userLoginData() == true {
                   arrSetting = ["","\(strName)", "Set Fingerprint", "Update Password", "User Profile", "Shiping address", "Billing address" ,"My Orders", "Third Party","Point History","Privacy Policy", "Terms And Conditions", "Logout", "Version " + (appVersion ?? "")]
               } else {
                   arrSetting = ["\(strName)","Third Party", "Privacy Policy", "Terms And Conditions","Version " + (appVersion ?? "")]
                   
               }
        tblView.reloadData()
        
        /*let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "MyOrderListViewControler") as! MyOrderListViewControler
        vc.shopId = arrBanner[index].BusinessId!
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    
    //MARK: - Ws Call
    
    func getShopedetail() -> Void {
        
        self.arrBanner.removeAll()
//        if Reachability.isConnectedToNetwork() {
//
//            APIManager.requestPostJsonEncoding(.getallshops, isLoading: true,params: [:], headers: [:],success: { (JSONResponse)  -> Void in
                
                self.imgBackStore.isHidden = false
                self.viewZip.isHidden = false
                self.constDelivery.constant = 270 - 60
        self.tblSearchStore.isHidden = true
        self.constTblheight.constant = 0

        
        arrBanner = objApplication.arrMainBanner
                
                
                self.tblStore.reloadData()
                
                
                
                // self.showPopover(base: sender, arr: arrBanner)
                
                
//
//            }) { (error) -> Void in
//                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
//            }
//        } else {
//            CommonFunctions.showMessage(message: Message.internetnotconnected)
//        }
    }
    
}
// MARK: - UITableview Delegate & Datasource

extension SettingViewController :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblSearchStore {
                   return arrSearchStore.count
               }
        if tableView == tblStore {
            return arrBanner.count
        }
        return arrSetting.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblSearchStore {
                   indexStore = indexPath.row
                   

                   
                   tblSearchStore.reloadData()
                   self.shopselected()
            
            return

               }
        
        if tableView == tblStore {
            index = indexPath.row
            tblStore.reloadData()
        } else {
            if CommonFunctions.userLoginData() == true {

        if  indexPath.row == 1 {
            
             print("Store Select")
            getShopedetail()
            
        }else if indexPath.row == 3 {
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            self.navigationController?.pushViewController(vc, animated: true)

        } else if indexPath.row == 4 {
            
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 5 {
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "MyAddressListViewController") as! MyAddressListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 6 {
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "AddBillingAddressViewController") as! AddBillingAddressViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 7 {
            
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "MyOrderListViewControler") as! MyOrderListViewControler
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 8 {
            
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ThirdPartyViewController") as! ThirdPartyViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 9 {
            
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionViewController
            self.navigationController?.pushViewController(vc, animated: true)

            
        }else if indexPath.row == 10 {
            
             if let url = URL(string: objApplication.strPrivacyPolicy) {
                           UIApplication.shared.open(url)
                       }
            
        }else if indexPath.row == 11 {
            
           if let url = URL(string: objApplication.strTermCondtion) {
                UIApplication.shared.open(url)
            }
            
        }else if indexPath.row == 12 {
            
            let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
            let alertError = EMAlertController(icon: nil, title: appName, message: "Are you sure to logout?")
            alertError.addAction(EMAlertAction(title: "Ok", style: .normal, action: {
                
                if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                    
                    let user = UserModel(json: userdict)
                    
                    if Reachability.isConnectedToNetwork() {
                        
                        var param  = [String : Any]()
                        if let devtoken = CommonFunctions.getUserDefault(key: UserDefaultsKey.Devtoken) as? String {
                            param["TokenId"] = devtoken
                        } else {
                            param["TokenId"] = "1234567890"
                            
                        }
                        param["UserId"] = user.UserId
                        
                        
                        APIManager.requestPostJsonEncoding(.removetoken, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                            
                            let Dict = JSONResponse as! [String:Any]
                            print(Dict)
                            
                            let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                            let alertError = EMAlertController(icon: nil, title: appName, message: Message.successlogout)
                            alertError.addAction(EMAlertAction(title: "Ok", style: .normal, action: {
                                CommonFunctions.removeUserDefaultForKey(key: UserDefaultsKey.USER)
                                //CommonFunctions.removeUserDefaultForKey(key: UserDefaultsKey.StoreID)

                                CommonFunctions.setUserDefault(object: false as AnyObject, key: UserDefaultsKey.FINGER)
                                
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
                                navi5.tabBarItem.title = "Setting"
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
                                tabBarController.viewControllers = [navi1, navi2,navi3,navi4,navi5]
                                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselected_tab_color], for: .normal)
                                
                                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selected_tab_color], for: .selected)
                                NotificationCenter.default.post(name: Notification.Name("REFRESHLOGINAFTERDATA"), object: nil, userInfo: nil)

                                objApplication.window?.rootViewController = tabBarController
                            }))
                            rootViewController.present(alertError, animated: true, completion: nil)
                            
                            
                            
                            
                        }) { (error) -> Void in
                            CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                        }
                    } else {
                        CommonFunctions.showMessage(message: Message.internetnotconnected)
                    }
                }
                
                
            }))
            alertError.addAction(EMAlertAction(title: "Cancel", style: .normal, action: {
                
            }))
            rootViewController.present(alertError, animated: true, completion: nil)
            
           
        }
            
            } else {
                if  indexPath.row == 0 {
                    getShopedetail()

                     print("Store Select")
                    
                }else if indexPath.row == 1 {
                    let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyBaord.instantiateViewController(withIdentifier: "ThirdPartyViewController") as! ThirdPartyViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if indexPath.row == 2 {
                    if let url = URL(string: objApplication.strPrivacyPolicy) {
                        UIApplication.shared.open(url)
                    }
                    
                    
                }else if indexPath.row == 3 {
                    if let url = URL(string: objApplication.strTermCondtion) {
                        UIApplication.shared.open(url)
                    }
                    
                    
                }
            }
            
            
        }
    }
}
extension SettingViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
               if tableView == tblSearchStore {
                   let cell = tableView.dequeueReusableCell(withIdentifier: "BLClientCell") as! BLClientCell
                   cell.selectionStyle = .none
                   cell.backgroundColor = UIColor.clear
                   cell.contentView.backgroundColor = UIColor.clear
                   cell.lblName.text = arrSearchStore[indexPath.row].Name

                   cell.imgCheck.isHidden = true

                   if(indexStore == indexPath.row) {
                       cell.imgCheck.isHidden = false
                   }
                   return cell
               } else if tableView == tblStore {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell") as! StoreCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.lblName.text = arrBanner[indexPath.row].BusinessName!
            cell.lblAddress.text = arrBanner[indexPath.row].BusinessAddress!

            cell.imgCheck.isHidden = true
            
            if(index == indexPath.row) {
                cell.imgCheck.isHidden = false
            }
            return cell
        } else {
            
            if indexPath.row == 0  {
                if CommonFunctions.userLoginData() == true {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileCell", for: indexPath) as! HomeProfileCell
                cell.selectionStyle = .none
                
                cell.delegate = self
                
                if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                
                let user = UserModel(json: userdict)
                    
                    cell.lblName.text = user.FirstName
                    cell.lblEmail.text = user.EmailId
                    
                    cell.imgProfile.kf.indicatorType = .activity
                    cell.imgProfile.kf.setImage(
                        with: URL(string: user.UserImage!),
                        placeholder: UIImage(named: "imgprofile"),
                        options: [.transition(.fade(0.2))],
                        progressBlock: { receivedSize, totalSize in
                           //print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
                    },
                        completionHandler: { result in
                           // print(result)
                          //  print("\(indexPath.row + 1): Finished")
                    }
                    )
                }
                
                return cell
                }
            }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.selectionStyle = .none
        cell.lblTitle.text = arrSetting[indexPath.row]
        
        cell.switchFinger.addTarget(self, action: #selector(SettingViewController.switchIsChanged(sender:)), for: UIControl.Event.valueChanged)
        var isSwitch = false
        if let isFinger = CommonFunctions.getUserDefault(key: UserDefaultsKey.FINGER) as? Bool {
            isSwitch = isFinger
        }
        cell.switchFinger.isOn = isSwitch
        cell.switchFinger.isHidden = true
            
            cell.lblTitle1.isHidden = true
            cell.lblTitle.isHidden = false
            
            
            
            if CommonFunctions.userLoginData() == true {
                if indexPath.row == 9 {
                    if objApplication.isHidePointHistory == true {
                        cell.lblTitle.isHidden = true
                        
                    }
                }
                if indexPath.row == 1 {
                    if objApplication.arrMainBanner.count == 1 {
                        cell.lblTitle.isHidden = true
                        cell.lblTitle1.isHidden = true
                        
                    }
                }
                
                if indexPath.row == 1 {
                    cell.lblTitle1.isHidden = false
                    
                }
                if indexPath.row == 2 {
                    if CommonFunctions.userLoginData() == true {
                        
                        cell.switchFinger.isHidden = false
                    }
                }
            } else {
                if indexPath.row == 0 {
                           if objApplication.arrMainBanner.count == 1 {
                               cell.lblTitle.isHidden = true
                               cell.lblTitle1.isHidden = true

                           }
                           }
                           
                           if indexPath.row == 0 {
                               cell.lblTitle1.isHidden = false

                           }
                           if indexPath.row == 1 {
                               if CommonFunctions.userLoginData() == true {
                                   
                                   cell.switchFinger.isHidden = false
                               }
                           }
            }
            
        return cell
        }

    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
              if tableView == tblSearchStore {
                  return UITableView.automaticDimension
                     }
        if tableView == tblStore {
            
            return 80
            
        }
        
        if CommonFunctions.userLoginData() == true {
            if indexPath.row == 0 {
                
                return 116
                
            }
            if indexPath.row == 1 {
                
                
                if objApplication.arrMainBanner.count == 1 {
                    return 0
                    
                }
            }
            
        } else {
            if indexPath.row == 0 {
                
                
                if objApplication.arrMainBanner.count == 1 {
                    return 0
                    
                }
            }
            
        }
        
        if indexPath.row == 9 {
        if objApplication.isHidePointHistory == true {
            return 0

        }
        }
        return 50
    }
    @objc func switchIsChanged(sender: UISwitch) {
        
        var isSwitch = false
        if sender.isOn == true {
            isSwitch = true
        }
        
        CommonFunctions.setUserDefault(object: isSwitch as AnyObject, key: UserDefaultsKey.FINGER)
        
    }
    
    
    
}

extension SettingViewController :HomeProfileCellDelegate {

    
    func delegateMemberClicked(_ sender: HomeProfileCell) {
        print("Member Clcked")
        if CommonFunctions.userLoginData() == true {
            
            imgBackQr.isHidden = false
            viewQr.isHidden = false
        } else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.cType = ControllerType.Home
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func delegateImageClicked(_ sender: HomeProfileCell) {
        
        if CommonFunctions.userLoginData() == true {
            
            let actionSheetController: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel" , style: .cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
            
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .default)
            { action -> Void in
                self.openCamera()
            }
            actionSheetController.addAction(takePictureAction)
            
            let choosePictureAction: UIAlertAction = UIAlertAction(title: "Picture Gallery", style: .default)
            { action -> Void in
                self.openGallery()
                
            }
            actionSheetController.addAction(choosePictureAction)
            
            
            //We need to provide a popover sourceView when using it on iPad
            actionSheetController.popoverPresentationController?.sourceView = sender as UIView
            
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
            
        }
        else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.cType = ControllerType.Home
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerViewController = UIImagePickerController()
            imagePickerViewController?.delegate = self
            if(UI_USER_INTERFACE_IDIOM() != .pad)
            {
                // imagePickerViewController?.allowsEditing = true
            }
            imagePickerViewController?.sourceType = .camera
            //imagePickerViewController?.mediaTypes = [kUTTypeImage as String]
            imagePickerViewController?.cameraCaptureMode = .photo
            present(imagePickerViewController!, animated: true, completion: nil)
        }
        else
        {
            print("Sorry cant take picture")
        }
    }
    
    func openGallery() {
        
        imagePickerViewController = UIImagePickerController()
        imagePickerViewController?.delegate = self
        
        if(UI_USER_INTERFACE_IDIOM() != .pad)
        {
            // imagePickerViewController?.allowsEditing = true
        }
        
        imagePickerViewController?.sourceType = .photoLibrary
        present(imagePickerViewController!, animated: true, completion: nil)
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            let d = image.jpegData(compressionQuality: 0.1)
            
            
            let base64 = d!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
            
            if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                let user = UserModel(json: userdict)
                if Reachability.isConnectedToNetwork() {
                    var param  = [String : Any]()
                    param["UserImage"] = base64
                    param["ImageExtension"] = ".jpeg"
                    
                    param["UserId"] = user.UserId
                    
                    APIManager.requestPostJsonEncoding(.saveuserimage, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                        
                        let Dict = JSONResponse as! [String:Any]
                        print(Dict)
                        
                        if let data1 = Dict["data"] as? [String:Any] {
                            
                            if let strrr = data1["UserImage"] as? String {
                                user.UserImage = strrr
                                CommonFunctions.setUserDefaultObject(object: user.toDict() as AnyObject, key: UserDefaultsKey.USER)
                                
                                self.tblView.reloadData()
                            }
                            
                            
                            
                            
                            
                            
                        }
                    }) { (error) -> Void in
                        CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                    }
                } else {
                    CommonFunctions.showMessage(message: Message.internetnotconnected)
                }
            }
            
        } else {
            print("Other source")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
