//
//  HomeViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 02/09/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import LocalAuthentication

class HomeViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {
    @IBOutlet weak var lblHeader: UILabel!

 

    @IBOutlet weak var tblView: UITableView!

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgQr: UIImageView!
    @IBOutlet weak var lblMemberId: UILabel!
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var viewQr: UIView!
    @IBOutlet weak var imgBackQr: UIImageView!
    var points = 0
    var rs = 0
    var arrAdverticement = [Advertisement]()
    @IBOutlet weak var imgAuth: UIImageView!
    var arrProductSearch = [ProductSearchModel]()

    var imagePickerViewController:UIImagePickerController?

    @IBOutlet weak var viewStore: UIView!
    @IBOutlet weak var imgBackStore: UIImageView!
    @IBOutlet weak var lblTitleStore: UILabel!
    @IBOutlet weak var btnCloseStore: UIButton!
    @IBOutlet weak var btnDoneStore: UIButton!

    @IBOutlet weak var tblStore: UITableView!
    var arrBanner = [ShopeModel]()
    var arrCategory = [CategoryModel]()
    var arrBrand = [BrandModel]()
    var arrProduct = [ProductModel]()

    var isFirst = false
    
    var index = -1;
    var isSpecial = false

    var isProduct = true
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblProductSearch: UITableView!
    @IBOutlet weak var imgProductSearch: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
        
        
        
        
      //  getHomepageDetail()

        var isSwitch = false
        if let isFinger = CommonFunctions.getUserDefault(key: UserDefaultsKey.FINGER) as? Bool {
            isSwitch = isFinger
        }
        imgAuth.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.OpenPramotionscreen(notification:)), name: Notification.Name("OPENPRAMOTION"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.OpenOrderDetail(notification:)), name: Notification.Name("OPENORDERDETAIL"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshLoginData(notification:)), name: Notification.Name("REFRESHLOGINAFTERDATA"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.cartRefreshData(notification:)), name: Notification.Name("CARTITEMREFRESH"), object: nil)

        
      //  NotificationCenter.default.addObserver(self, selector: #selector(launchActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func cartRefreshData(notification: Notification) {
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {

                param["ShopId"] = sid
                }
                param["UserId"] = user.UserId
                
                APIManager.requestPostJsonEncoding(.cartcount, isLoading: false, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [String:Any] {
                        if let cartCount = data["CartCount"] as? Int {
                            
                           
                           let tabBarController : UITabBarController = objApplication.window?.rootViewController as! UITabBarController
                            
                            if CommonFunctions.userLoginData() == true {

                            if let tabItems = tabBarController.tabBar.items {
                                // In this case we want to modify the badge number of the third tab:
                                let tabItem = tabItems[2]
                                tabItem.badgeColor = Theme_Color
                                tabItem.badgeValue = "\(cartCount)"
                            }
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
    }
    @objc func refreshLoginData(notification: Notification) {
//        getHomepageDetail()
//
//        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
//
//            let user = UserModel(json: userdict)
//            lblMemberId.text = "\(user.UserUUID!)"
//            self.GenerateQr(name: "\(user.UserUUID!)")
//        }
        
    }
    override func viewDidLayoutSubviews() {
              self.tabBarController?.tabBar.isHidden = false

    }
    override func viewWillDisappear(_ animated: Bool) {
              self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        

      self.tabBarController?.tabBar.isHidden = false
        
            getHomepageDetail()

            if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                
                let user = UserModel(json: userdict)
                lblMemberId.text = "\(user.UserUUID!)"
                self.GenerateQr(name: "\(user.UserUUID!)")
            }
        
        if objApplication.isnotification == true {
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "PramotionListViewController") as! PramotionListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    @objc func OpenPramotionscreen(notification: Notification) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "PramotionListViewController") as! PramotionListViewController
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    @objc func OpenOrderDetail(notification: Notification) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "MyOrderDetailViewControler") as! MyOrderDetailViewControler
        vc.orderId = objApplication.orderID
        vc.shopId = objApplication.ShopID
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
   

    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        tblStore.tag = 1001
        imgBackQr.isHidden = true
        viewQr.isHidden = true
        lblMemberId.adjustsFontSizeToFitWidth = true
        lblMemberId.isHidden = true

        
       
        txtSearch.returnKeyType = .search
        
        txtSearch.font = UIFont(name: Font_Regular, size: 17)

        
               self.tblProductSearch.isHidden = true
               self.imgProductSearch.isHidden = true
        
        imgBackStore.isHidden = true
        viewStore.isHidden = true
        tblView.register(UINib(nibName: "HomeCellCollection", bundle: nil), forCellReuseIdentifier:"HomeCellCollection")
        tblStore.register(UINib(nibName: "StoreCell", bundle: nil), forCellReuseIdentifier: "StoreCell")
        tblProductSearch.register(UINib(nibName: "SearchProduct", bundle: nil), forCellReuseIdentifier: "SearchProduct")

        CommonFunctions.setCornerRadius(view: viewQr, radius: 13)

        lblTitleStore.font = UIFont(name: Font_Semibold, size: 17)
        lblMember.font = UIFont(name: Font_Semibold, size: 17)
        lblMemberId.font = UIFont(name: Font_Semibold, size: 22)
        btnClose.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnClose, radius: 17)

        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        lblHeader.text = lblHeader.text?.firstCharacterUpperCase()

        btnDoneStore.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnDoneStore, radius: 17)

        btnCloseStore.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnCloseStore, radius: 17)

        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            
            let user = UserModel(json: userdict)
            lblMemberId.text = "\(user.UserUUID!)"
            self.GenerateQr(name: "\(user.UserUUID!)")
        }
        
        
        
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
    
    
    //MARK: - Ws Call
    func getMainShopedetail() -> Void {
        
        objApplication.arrMainBanner.removeAll()
        if Reachability.isConnectedToNetwork() {
            
            APIManager.requestPostJsonEncoding(.getallshops, isLoading: false,params: [:], headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                if let data = Dict["data"] as? [[String:Any]] {
                        for objAd in data {
                            let obj = ShopeModel(json: objAd)
                            objApplication.arrMainBanner.append(obj)
                        }
                }
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
    }
    
    
    func getAllCategory() -> Void {
        
        
        if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
        
       
        
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["ShopId"] = sid
            
            
            
            
            APIManager.requestPostJsonEncoding(.getallcategory, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                self.arrCategory.removeAll()
                if let data = Dict["data"] as? [[String:Any]] {
                    
                    for objAd in data {
                        let obj = CategoryModel(json: objAd)
                        self.arrCategory.append(obj)
                    }
                    
                }
                self.tblView.reloadData()

                self.getAllBrandWeb(sid: sid)
                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
        }
    }
    
    func getAllProduct(sid :Int) -> Void {
        
        
        if Reachability.isConnectedToNetwork() {
            var param  = [String : Any]()
            
            param["ShopId"] = sid
            
            param["PageNo"] = 1
            param["PageSize"] = 10
            param["SortType"] = 1
            param["BrandId"] = ""
            param["CategoryId"] = ""
            param["SubCategoryId"] = ""
            param["UserId"] = 0
            
            if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                let user = UserModel(json: userdict)
                
                param["UserId"] = user.UserId
            }
            param["IsDisplayHomePage"] = true
            
            APIManager.requestPostJsonEncoding(.getallproductweb , isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                self.arrProduct.removeAll()
                NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)

                if let data = Dict["data"] as? [[String:Any]] {
                    for objAd in data {
                        let obj = ProductModel(json: objAd)
                        self.arrProduct.append(obj)
                    }
                }
                self.tblView.reloadData()

                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
        
        
    }
    
    
    //MARK: - Get Product
    
    func getAllProductSearch() -> Void {
        if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {

       var usrI = 0
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
           
        let user = UserModel(json: userdict)
            usrI = user.UserId ?? 0
        }
        self.arrProductSearch.removeAll()
        tblProductSearch.reloadData()
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
                param["ShopId"] = sid
                param["ProductSearchKeyword"] = txtSearch.text!
            
            APIManager.requestPostJsonEncoding( .productsearch, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                if let data = Dict["data"] as? [[String:Any]] {
                    
                    
                    
                    
                    
                    for objAd in data {
                        let obj = ProductSearchModel(json: objAd)
                        self.arrProductSearch.append(obj)
                    }
                    
                    
                }
                
                if self.arrProductSearch.count == 0 {
                    
                    CommonFunctions.showMessage(message: Message.noproductfound)
                    return
                }
                self.tblProductSearch.isHidden = false
                self.imgProductSearch.isHidden = false
                
                self.tblProductSearch.reloadData()
                
                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
        }
        
    }
    
    //MARK: - UITextfield Delegate ----
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        
        
        getAllProductSearch()
        
        textField.resignFirstResponder()
        return true
    }
    
    
    func getAllBrandWeb(sid :Int) -> Void {
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["ShopId"] = sid
                param["CategoryId"] = ""
                param["SubCategoryId"] = ""
            
            param["ProductSearchKeyword"] = ""


            
            
            
            APIManager.requestPostJsonEncoding( .getallbrandweb , isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                self.arrBrand.removeAll()
                if let data = Dict["data"] as? [[String:Any]] {
                    
                    

                    for objAd in data {
                        let obj = BrandModel(json: objAd)
                        obj.isSelect = false
                        self.arrBrand.append(obj)
                    }

                }
                self.tblView.reloadData()

                self.getAllProduct(sid: sid)
                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
    }
    
  func getShopedetail() -> Void {
            
            if arrBanner.count == 0 {
                if !Reachability.isConnectedToNetwork() {
                    return
                }
            }
            
            index = -1
    //        self.arrBanner.removeAll()
    //        if Reachability.isConnectedToNetwork() {
    //
    //            APIManager.requestPostJsonEncoding(.getallshops, isLoading: true,params: [:], headers: [:],success: { (JSONResponse)  -> Void in
    //
    //                let Dict = JSONResponse as! [String:Any]
    //                print(Dict)
    //
    //                if let data = Dict["data"] as? [[String:Any]] {
    //
    //                        for objAd in data {
    //                            let obj = ShopeModel(json: objAd)
    //                            self.arrBanner.append(obj)
    //                        }
    //
    //                }
            self.tblStore.reloadData()
                    
            if(self.arrBanner.count == 1) {
                
                CommonFunctions.setUserDefault(object: self.arrBanner[0].BusinessId! as AnyObject, key: UserDefaultsKey.StoreID)

        getAllCategory()

                if self.isProduct == true {
            
                    if self.isSpecial == true {
                        self.isSpecial = false
                        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyBaord.instantiateViewController(withIdentifier: "PramotionCategoryViewController") as! PramotionCategoryViewController
                        vc.arrShope.removeAll()

                        vc.arrShope.append(self.arrBanner[0])

                        self.navigationController?.pushViewController(vc, animated: true)
                
                /*let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyBaord.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                vc.shopId = self.arrBanner[0].BusinessId!
                vc.isSpecialOffer = true
                vc.categoryId = 0
                vc.subcategoryID = 0
                objApplication.applatitude = self.arrBanner[0].Latitude!
                objApplication.applongitude = self.arrBanner[0].Longitude!
                
                objApplication.isAvailableStockDisplay = self.arrBanner[0].IsAvailableStockDisplay!
                
                objApplication.brandName = self.arrBanner[0].BusinessName!
                objApplication.isCodEnableForCollection = self.arrBanner[0].IsCodEnableForCollection!
                objApplication.isCodEnable = self.arrBanner[0].IsCodEnable!

                objApplication.isSupportZipCodeLogic = self.arrBanner[0].IsSupportZipCodeLogic!

                objApplication.isSupportDistanceLogic = self.arrBanner[0].IsSupportDistanceLogic!

                
                objApplication.isStoreCollectionEnable = self.arrBanner[0].IsStoreCollectionEnable!
                self.navigationController?.pushViewController(vc, animated: true)*/
                    } else {

            
                        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyBaord.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                        vc.arrShope.append(self.arrBanner[0])
                        objApplication.applatitude = self.arrBanner[0].Latitude!
                        objApplication.applongitude = self.arrBanner[0].Longitude!
            
                        objApplication.isAvailableStockDisplay = self.arrBanner[0].IsAvailableStockDisplay!
            
                        objApplication.isStoreCollectionEnable = self.arrBanner[0].IsStoreCollectionEnable!
            
                        objApplication.isCodEnableForCollection = self.arrBanner[0].IsCodEnableForCollection!
                        objApplication.isCodEnable = self.arrBanner[0].IsCodEnable!
            
                        objApplication.isSupportZipCodeLogic = self.arrBanner[0].IsSupportZipCodeLogic!
                        objApplication.isSupportDistanceLogic = self.arrBanner[0].IsSupportDistanceLogic!

            
                        objApplication.isStoreCollectionEnable = self.arrBanner[0].IsStoreCollectionEnable!

                        objApplication.brandName = self.arrBanner[0].BusinessName!

            
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyBaord.instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
                    objApplication.applatitude = self.arrBanner[0].Latitude!
                    objApplication.applongitude = self.arrBanner[0].Longitude!
            
                    vc.shopId = self.arrBanner[0].BusinessId!
            
                    objApplication.isAvailableStockDisplay = self.arrBanner[0].IsAvailableStockDisplay!
            
                    objApplication.isStoreCollectionEnable = self.arrBanner[0].IsStoreCollectionEnable!
            
                    objApplication.isCodEnableForCollection = self.arrBanner[0].IsCodEnableForCollection!
                    objApplication.isCodEnable = self.arrBanner[0].IsCodEnable!
                    objApplication.brandName = self.arrBanner[0].BusinessName!
            
                    objApplication.isSupportZipCodeLogic = self.arrBanner[0].IsSupportZipCodeLogic!
                    objApplication.isSupportDistanceLogic = self.arrBanner[0].IsSupportDistanceLogic!
            
                    objApplication.isStoreCollectionEnable = self.arrBanner[0].IsStoreCollectionEnable!

                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
        
                if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
            
                    for i in 0..<self.arrBanner.count {
                        if self.arrBanner[i].BusinessId! == sid {
                            index = i
                        }
                    }
                    if isProduct == true {
            
                        if self.isSpecial == true {
                            self.isSpecial = false
                    
                            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                            let vc = storyBaord.instantiateViewController(withIdentifier: "PramotionCategoryViewController") as! PramotionCategoryViewController
                            vc.arrShope.removeAll()
                            vc.arrShope.append(self.arrBanner[index])


                            self.navigationController?.pushViewController(vc, animated: true)
                    /*let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyBaord.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                    vc.shopId = self.arrBanner[index].BusinessId!
                    vc.isSpecialOffer = true
                    vc.categoryId = 0
                    vc.subcategoryID = 0
                    objApplication.applatitude = arrBanner[index].Latitude!
                    objApplication.applongitude = arrBanner[index].Longitude!
                    
                    objApplication.isAvailableStockDisplay = arrBanner[index].IsAvailableStockDisplay!
                    objApplication.isStoreCollectionEnable = self.arrBanner[index].IsStoreCollectionEnable!
                    objApplication.isCodEnableForCollection = self.arrBanner[index].IsCodEnableForCollection!
                    objApplication.isCodEnable = self.arrBanner[index].IsCodEnable!

                    objApplication.isSupportZipCodeLogic = self.arrBanner[index].IsSupportZipCodeLogic!

                                           objApplication.isSupportDistanceLogic = self.arrBanner[index].IsSupportDistanceLogic!
                    
                    objApplication.brandName = self.arrBanner[index].BusinessName!

                    self.navigationController?.pushViewController(vc, animated: true)*/
                        } else {
                            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                            let vc = storyBaord.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                            vc.arrShope.append(arrBanner[index])
                            objApplication.applatitude = arrBanner[index].Latitude!
                            objApplication.applongitude = arrBanner[index].Longitude!
                
                            objApplication.isAvailableStockDisplay = arrBanner[index].IsAvailableStockDisplay!
                
                            objApplication.isCodEnableForCollection = self.arrBanner[index].IsCodEnableForCollection!
                            objApplication.isCodEnable = self.arrBanner[index].IsCodEnable!
                            objApplication.isStoreCollectionEnable = self.arrBanner[index].IsStoreCollectionEnable!
                
                            objApplication.isSupportZipCodeLogic = self.arrBanner[index].IsSupportZipCodeLogic!

                            objApplication.isSupportDistanceLogic = self.arrBanner[index].IsSupportDistanceLogic!
                
                            objApplication.isStoreCollectionEnable = self.arrBanner[index].IsStoreCollectionEnable!
                
                            objApplication.brandName = self.arrBanner[index].BusinessName!

                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                       let vc = storyBaord.instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
                        objApplication.applatitude = arrBanner[index].Latitude!
                        objApplication.applongitude = arrBanner[index].Longitude!

                        vc.shopId = arrBanner[index].BusinessId!
                
                        objApplication.isAvailableStockDisplay = arrBanner[index].IsAvailableStockDisplay!
                
                        objApplication.isStoreCollectionEnable = self.arrBanner[index].IsStoreCollectionEnable!
                
                        objApplication.isCodEnableForCollection = self.arrBanner[index].IsCodEnableForCollection!
                        objApplication.isCodEnable = self.arrBanner[index].IsCodEnable!
                
                        objApplication.isSupportZipCodeLogic = self.arrBanner[index].IsSupportZipCodeLogic!
                        objApplication.isSupportDistanceLogic = self.arrBanner[index].IsSupportDistanceLogic!

                
                        objApplication.isStoreCollectionEnable = self.arrBanner[index].IsStoreCollectionEnable!
                
                        objApplication.brandName = self.arrBanner[index].BusinessName!

                       self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
        
                    self.imgBackStore.isHidden = false
                    self.viewStore.isHidden = false
                }
            }

    // self.showPopover(base: sender, arr: arrBanner)

    //            }) { (error) -> Void in
    //                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
    //            }
    //        } else {
    //            CommonFunctions.showMessage(message: Message.internetnotconnected)
    //        }
        }
    
    func getHomepageDetail() -> Void {
            
            self.arrAdverticement.removeAll()
        objApplication.arrMainBanner.removeAll()

            if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                
                let user = UserModel(json: userdict)
                
                if user.isOtpVerify == true {
                    if Reachability.isConnectedToNetwork() {
                        
                        var param  = [String : Any]()
                        param["UserId"] = user.UserId
                        if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                        param["ShopId"] = sid
                        } else {
                            param["ShopId"] = 0

                        }

                        
                        APIManager.requestPostJsonEncoding(.homepagedetail, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                            
                            let Dict = JSONResponse as! [String:Any]
                            print(Dict)
                            
                            
                            if let data = Dict["data"] as? [String:Any] {
                                if let arrAdvertisement = data["Advertisement"] as? [[String:Any]] {
                                    
                                    for objAd in arrAdvertisement {
                                        let obj = Advertisement(json: objAd)
                                        self.arrAdverticement.append(obj)
                                    }
                                    
                                }
                                if let data = data["ShopList"] as? [[String:Any]] {
                                    
                                        for objAd in data {
                                            let obj = ShopeModel(json: objAd)
                                            self.arrBanner.append(obj)
                                        }
                                        
                                }
                                
                                if let data = data["ShopList"] as? [[String:Any]] {
                                        for objAd in data {
                                            let obj = ShopeModel(json: objAd)
                                            objApplication.arrMainBanner.append(obj)
                                        }
                                }
                                
                                if let userdict = data["UserDetail"] as? [String:Any] {
                                    
                                    let user = UserModel(json: userdict)
                                    user.isOtpVerify = true
                                    CommonFunctions.setUserDefaultObject(object: user.toDict() as AnyObject, key: UserDefaultsKey.USER)
                                }
                                
                                if let conf = data["Configuration"] as? [String:Any] {
                                    
                                    if let sym = conf["PrivacyAndPolicy"] as? String {
                                        
                                        objApplication.strPrivacyPolicy = sym
                                        
                                    }
                                    if let sym = conf["TermsAndConditions"] as? String {
                                        objApplication.strTermCondtion = sym
                                        
                                    }
                                    if let sym = conf["IsHidePointHistory"] as? Bool {
                                                                           objApplication.isHidePointHistory = sym
                                                                           
                                    }
                                    if let sym = conf["CurrencySymbol"] as? String {
                                        CommonFunctions.setUserDefault(object: sym as AnyObject, key: UserDefaultsKey.Currency)
                                        
                                    }
                                    
                                    if let ponts = conf["Point"] as? Int {
                                        if let Price = conf["Price"] as? Int {
                                            self.points = ponts
                                            self.rs = Price
                                        }
                                    }
                                    if let version = conf["IOSVersion"] as? String {
                                        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                                        if appVersion!.compare(version, options: .numeric) == .orderedAscending {
                                            //CommonFunctions.showMessage(message: "A New version of Application is available, Please update to version \(version)")
                                        }
                                    }
                                }
                                if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                                    print(sid)
                                    self.getAllCategory()

                                } else {
                                    
                                    if(self.arrBanner.count == 1) {
                                        CommonFunctions.setUserDefault(object: self.arrBanner[0].BusinessId! as AnyObject, key: UserDefaultsKey.StoreID)
                                        self.getAllCategory()

                                    } else {
                                        self.imgBackStore.isHidden = false
                                        self.viewStore.isHidden = false
                                    }
                                }
                                
                                self.tblView.reloadData()
                                self.tblStore.reloadData()
                                
                                self.tblView.reloadData()
                                
                            }
                            
                            
                            
                            
                        }) { (error) -> Void in
                            CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                        }
                    } else {
                        CommonFunctions.showMessage(message: Message.internetnotconnected)
                    }

                } else {
                    if Reachability.isConnectedToNetwork() {
                        
                        var param  = [String : Any]()
                        param["UserId"] = 0
                        if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                        param["ShopId"] = sid
                        } else {
                            param["ShopId"] = 0

                        }

                        
                        APIManager.requestPostJsonEncoding(.homepagedetail, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                            
                            let Dict = JSONResponse as! [String:Any]
                            print(Dict)
                            
                            
                            if let data = Dict["data"] as? [String:Any] {
                                if let arrAdvertisement = data["Advertisement"] as? [[String:Any]] {
                                    
                                    for objAd in arrAdvertisement {
                                        let obj = Advertisement(json: objAd)
                                        self.arrAdverticement.append(obj)
                                    }
                                    
                                }
                                if let data = data["ShopList"] as? [[String:Any]] {
                                    
                                        for objAd in data {
                                            let obj = ShopeModel(json: objAd)
                                            self.arrBanner.append(obj)
                                        }
                                        
                                }
                                if let data = data["ShopList"] as? [[String:Any]] {
                                        for objAd in data {
                                            let obj = ShopeModel(json: objAd)
                                            objApplication.arrMainBanner.append(obj)
                                        }
                                }
                                
                                if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                                                                   print(sid)
                                    self.getAllCategory()

                                                                   
                                                               } else {
                                                                   
                                                                   if(self.arrBanner.count == 1) {
                                                                       CommonFunctions.setUserDefault(object: self.arrBanner[0].BusinessId! as AnyObject, key: UserDefaultsKey.StoreID)
                                                                    
                                                                    self.getAllCategory()
                                                                       
                                                                   } else {
                                                                       self.imgBackStore.isHidden = false
                                                                       self.viewStore.isHidden = false
                                                                   }
                                                               }
                                                               
                                                               self.tblView.reloadData()
                                                               self.tblStore.reloadData()
                                
                                //                        if let userdict = data["UserDetail"] as? [String:Any] {
                                //
                                //                            let user = UserModel(json: userdict)
                                //                            user.isOtpVerify = true
                                //                            CommonFunctions.setUserDefaultObject(object: user.toDict() as AnyObject, key: UserDefaultsKey.USER)
                                //                        }
                                
                                if let conf = data["Configuration"] as? [String:Any] {
                                    
                                    if let sym = conf["PrivacyAndPolicy"] as? String {
                                        
                                        objApplication.strPrivacyPolicy = sym
                                        
                                    }
                                    if let sym = conf["TermsAndConditions"] as? String {
                                        objApplication.strTermCondtion = sym
                                        
                                    }
                                    
                                    if let sym = conf["CurrencySymbol"] as? String {
                                        CommonFunctions.setUserDefault(object: sym as AnyObject, key: UserDefaultsKey.Currency)
                                        
                                    }
                                    
                                    if let ponts = conf["Point"] as? Int {
                                        if let Price = conf["Price"] as? Int {
                                            self.points = ponts
                                            self.rs = Price
                                        }
                                    }
                                    if let version = conf["IOSVersion"] as? String {
                                        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                                        if appVersion!.compare(version, options: .numeric) == .orderedAscending {
                                            CommonFunctions.showMessage(message: "A New version of Application is available, Please update to version \(version)")
                                        }
                                    }
                                }
                                self.tblView.reloadData()
                                
                            }
                            
                            
                            
                            
                        }) { (error) -> Void in
                            CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                        }
                    } else {
                        CommonFunctions.showMessage(message: Message.internetnotconnected)
                    }
                }
            } else {
                if Reachability.isConnectedToNetwork() {
                    
                    var param  = [String : Any]()
                    param["UserId"] = 0
                    
                    if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                    param["ShopId"] = sid
                    } else {
                        param["ShopId"] = 0

                    }

                    APIManager.requestPostJsonEncoding(.homepagedetail, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                        
                        let Dict = JSONResponse as! [String:Any]
                        print(Dict)
                        
                        
                        if let data = Dict["data"] as? [String:Any] {
                            if let arrAdvertisement = data["Advertisement"] as? [[String:Any]] {
                                
                                for objAd in arrAdvertisement {
                                    let obj = Advertisement(json: objAd)
                                    self.arrAdverticement.append(obj)
                                }
                                
                            }
                            if let data = data["ShopList"] as? [[String:Any]] {
                                
                                    for objAd in data {
                                        let obj = ShopeModel(json: objAd)
                                        self.arrBanner.append(obj)
                                    }
                                    
                            }
                            if let data = data["ShopList"] as? [[String:Any]] {
                                    for objAd in data {
                                        let obj = ShopeModel(json: objAd)
                                        objApplication.arrMainBanner.append(obj)
                                    }
                            }
                            
                            if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                                                               print(sid)
                                                               self.getAllCategory()

                                                           } else {
                                                               
                                                               if(self.arrBanner.count == 1) {
                                                                   CommonFunctions.setUserDefault(object: self.arrBanner[0].BusinessId! as AnyObject, key: UserDefaultsKey.StoreID)
                                                                self.getAllCategory()

                                                               } else {
                                                                   self.imgBackStore.isHidden = false
                                                                   self.viewStore.isHidden = false
                                                               }
                                                           }
                                                           
                                                           self.tblView.reloadData()
                                                           self.tblStore.reloadData()
    //                        if let userdict = data["UserDetail"] as? [String:Any] {
    //
    //                            let user = UserModel(json: userdict)
    //                            user.isOtpVerify = true
    //                            CommonFunctions.setUserDefaultObject(object: user.toDict() as AnyObject, key: UserDefaultsKey.USER)
    //                        }
                            
                            if let conf = data["Configuration"] as? [String:Any] {
                                
                                if let sym = conf["PrivacyAndPolicy"] as? String {
                                    
                                    objApplication.strPrivacyPolicy = sym
                                    
                                }
                                if let sym = conf["TermsAndConditions"] as? String {
                                    objApplication.strTermCondtion = sym

                                }
                                
                                if let sym = conf["CurrencySymbol"] as? String {
                                    CommonFunctions.setUserDefault(object: sym as AnyObject, key: UserDefaultsKey.Currency)

                                }
                                
                                if let ponts = conf["Point"] as? Int {
                                    if let Price = conf["Price"] as? Int {
                                        self.points = ponts
                                        self.rs = Price
                                    }
                                }
                                if let version = conf["IOSVersion"] as? String {
                                    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                                    if appVersion!.compare(version, options: .numeric) == .orderedAscending {
                                        CommonFunctions.showMessage(message: "A New version of Application is available, Please update to version \(version)")
                                    }
                                }
                            }
                            self.tblView.reloadData()

                        }
                        
                        
                        
                        
                    }) { (error) -> Void in
                        CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                    }
                } else {
                    CommonFunctions.showMessage(message: Message.internetnotconnected)
                }
            }
        }
    
    

    // MARK: - IBAction Event
    
    @IBAction func btnCloseSearchClicked(_ sender: UIButton) {
           
        
           
           self.tblProductSearch.isHidden = true
           self.imgProductSearch.isHidden = true
           
           
           txtSearch.resignFirstResponder()
           txtSearch.text = ""
        arrProductSearch.removeAll()
        tblProductSearch.reloadData()
           
           
    }
    
    @IBAction func btnMapClicked(_ sender: Any) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
               let vc = storyBaord.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
               self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnCloseStoreClicked(_ sender: Any) {
        imgBackStore.isHidden = true
        viewStore.isHidden = true
        isSpecial = false

    }
    @IBAction func btnDoneStoreClicked(_ sender: Any) {
      
        if index == -1 {
            CommonFunctions.showMessage(message: Message.selectstore)
            return
        }
        
        imgBackStore.isHidden = true
        viewStore.isHidden = true
        
        CommonFunctions.setUserDefault(object: self.arrBanner[index].BusinessId! as AnyObject, key: UserDefaultsKey.StoreID)

        getHomepageDetail()
        
        getAllCategory()

        /*if isProduct == true {
        
            if self.isSpecial == true {
                self.isSpecial = false
                let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyBaord.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                vc.shopId = self.arrBanner[index].BusinessId!
                vc.isSpecialOffer = true
                vc.categoryId = 0
                vc.subcategoryID = 0
                objApplication.applatitude = arrBanner[index].Latitude!
                objApplication.applongitude = arrBanner[index].Longitude!
                
                objApplication.isAvailableStockDisplay = arrBanner[index].IsAvailableStockDisplay!
                objApplication.isStoreCollectionEnable = self.arrBanner[index].IsStoreCollectionEnable!
                objApplication.isCodEnableForCollection = self.arrBanner[index].IsCodEnableForCollection!
                objApplication.isCodEnable = self.arrBanner[index].IsCodEnable!

                objApplication.isSupportZipCodeLogic = self.arrBanner[index].IsSupportZipCodeLogic!

                                       objApplication.isSupportDistanceLogic = self.arrBanner[index].IsSupportDistanceLogic!
                
                objApplication.brandName = self.arrBanner[index].BusinessName!

                self.navigationController?.pushViewController(vc, animated: true)
            } else {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        vc.arrShope.append(arrBanner[index])
            objApplication.applatitude = arrBanner[index].Latitude!
            objApplication.applongitude = arrBanner[index].Longitude!
            
            objApplication.isAvailableStockDisplay = arrBanner[index].IsAvailableStockDisplay!
            
            objApplication.isCodEnableForCollection = self.arrBanner[index].IsCodEnableForCollection!
            objApplication.isCodEnable = self.arrBanner[index].IsCodEnable!
            objApplication.isStoreCollectionEnable = self.arrBanner[index].IsStoreCollectionEnable!
            
            

            objApplication.isSupportDistanceLogic = self.arrBanner[index].IsSupportDistanceLogic!

            
            objApplication.isStoreCollectionEnable = self.arrBanner[index].IsStoreCollectionEnable!
            
            objApplication.brandName = self.arrBanner[index].BusinessName!



        self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                   let vc = storyBaord.instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
            objApplication.applatitude = arrBanner[index].Latitude!
            objApplication.applongitude = arrBanner[index].Longitude!

            vc.shopId = arrBanner[index].BusinessId!
            
            objApplication.isAvailableStockDisplay = arrBanner[index].IsAvailableStockDisplay!
            
            objApplication.isStoreCollectionEnable = self.arrBanner[index].IsStoreCollectionEnable!
            
            objApplication.isCodEnableForCollection = self.arrBanner[index].IsCodEnableForCollection!
            objApplication.isCodEnable = self.arrBanner[index].IsCodEnable!
            
            objApplication.isSupportDistanceLogic = self.arrBanner[index].IsSupportDistanceLogic!

            
            objApplication.isStoreCollectionEnable = self.arrBanner[index].IsStoreCollectionEnable!
            
            objApplication.brandName = self.arrBanner[index].BusinessName!


            
            
                   
                   self.navigationController?.pushViewController(vc, animated: true)
        }*/
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        imgBackQr.isHidden = true
        viewQr.isHidden = true
    }
    @IBAction func btnreloadClicked(_ sender: Any) {
        self.getHomepageDetail()
    }
    @IBAction func btnSettingClicked(_ sender: Any) {
        
        
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Image Pick
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


// MARK: - UITableview Delegate & Datasource

extension HomeViewController :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tblStore {
            return arrBanner.count
        }
        if tableView == tblProductSearch {
            return arrProductSearch.count
        }
        return 1
    }
}
extension HomeViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblStore {
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
        } else if tableView == tblProductSearch {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchProduct") as! SearchProduct
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.lblName.text = arrProductSearch[indexPath.row].ProductName!
            cell.lblBrand.text = arrProductSearch[indexPath.row].BrandName!
            
            
            var symboll = ""
            if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
                symboll = symbol
            }
            if arrProductSearch[indexPath.row].PromotionTitle! == "" {
                cell.lblPramotion.isHidden = true
                cell.imgPramotion.isHidden = true
                //cell.lblconstheight.constant = 0
            } else {
                cell.lblPramotion.isHidden = false
                cell.imgPramotion.isHidden = false

                //cell.lblconstheight.constant = 22
                cell.lblPramotion.text = " \(arrProductSearch[indexPath.row].PromotionTitle!) "
            }
            
            cell.lblOrAmount.isHidden = true
            if arrProductSearch[indexPath.row].DiscountValue! != 0.0 {
                cell.lblOrAmount.isHidden = false
                cell.lblOrAmount.text = "\(symboll) \(CommonFunctions.appendString(data: arrProductSearch[indexPath.row].DiscountValue!))"
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(symboll) \(CommonFunctions.appendString(data: arrProductSearch[indexPath.row].SellingPrice!))")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                
                cell.lblAmount.attributedText = attributeString
            }
            else {
                cell.lblAmount.text = "\(symboll) \(CommonFunctions.appendString(data: arrProductSearch[indexPath.row].SellingPrice!))"
            }
            
            if arrProductSearch[indexPath.row].ProductSize == 0 {
                cell.lblSize.text = ""
            } else {
                cell.lblSize.text = "\(arrProductSearch[indexPath.row].ProductSize!) \(arrProductSearch[indexPath.row].UnitName!)"
            }
            
            if arrProductSearch[indexPath.row].AvailableQty! <= 0 {
                if arrProductSearch[indexPath.row].outOfStockMessage == "" {
                    cell.lblOutOfStock.text = "Out of Stock"
                } else {
                    cell.lblOutOfStock.text = arrProductSearch[indexPath.row].outOfStockMessage
                }
                cell.lblOutOfStock.isHidden = false
            } else {
                cell.lblOutOfStock.isHidden = true
            }
            
            cell.imgProduct.kf.indicatorType = .activity
            cell.imgProduct.kf.setImage(
                with: URL(string: arrProductSearch[indexPath.row].ProductImage!),
                placeholder: UIImage(named: "placeholder"),
                options: [.transition(.fade(0.2))],
                progressBlock: { receivedSize, totalSize in
                    //print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
            },
                completionHandler: { result in
                    // print(result)
                    //  print("\(indexPath.row + 1): Finished")
            }
            )
            
            return cell

        }else {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellCollection", for: indexPath) as! HomeCellCollection

            
            
        cell.selectionStyle = .none
        //cell.delegate = self
            cell.cellVc = self

             /*if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            
            let user = UserModel(json: userdict)
                
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
            }*/
            
        
            /*if CommonFunctions.userLoginData() == true {

                cell.lblpoint.isHidden = false
                cell.lblpointval.isHidden = false
                cell.viewSep.isHidden = false
                cell.lblavailbleval.isHidden = false
                cell.lblbalence.isHidden = false

                cell.imgBarcode.isHidden = false
                cell.lblLoginTitle.isHidden = true
                cell.lblmembertitle.isHidden = false
            }
            else {
                cell.lblpoint.isHidden = true
                              cell.lblpointval.isHidden = true
                              cell.viewSep.isHidden = true
                              cell.lblavailbleval.isHidden = true
                              cell.lblbalence.isHidden = true
                
                cell.imgBarcode.isHidden = true
                cell.lblLoginTitle.isHidden = false
                cell.lblmembertitle.isHidden = true
            }*/
            
            if arrProduct.count > 0 {
                           cell.arrProduct = arrProduct
                           cell.setupCollectionCell()
                       }else {
                       cell.arrProduct.removeAll()
                       cell.setupCollectionCell()

                       cell.collectionProduct.reloadData()
                       }
            
            if arrBrand.count > 0 {
                           cell.arrBrand.removeAll()
                           
                           for obj in arrBrand {
                               if obj.BrandImage != "" {
                                   cell.arrBrand.append(obj)
                               } else {
                                   print("No image data")
                               }
                           }
                           //cell.arrBrand = arrBrand
                           cell.setupCollectionCell()
                       }else {
                           cell.arrBrand.removeAll()
                           cell.setupCollectionCell()
                           
                           cell.collectionBrand.reloadData()
                       }
            
            if arrCategory.count > 0 {
                cell.arrCategory = arrCategory
                cell.setupCollectionCell()
            }else {
            cell.arrCategory.removeAll()
            cell.setupCollectionCell()

            cell.collectionV.reloadData()
            }
            
        if arrAdverticement.count > 0 {
            cell.arrAdver = arrAdverticement
            cell.setupCollectionCell()
        }else {
        cell.arrAdver.removeAll()
        cell.setupCollectionCell()

        cell.collectionV.reloadData()
        }
            /*if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            
            let user = UserModel(json: userdict)
            
            var symboll = ""
            if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
                symboll = symbol
            }
            
            cell.setupCell(indexPath.row, Name: "\(user.FirstName!)", point: "\(user.PointBalance!)", pointrs: "\(points) Points = Rs. \(rs)", balence: "\(symboll) \(user.Amount!).00")
        }*/
        
        
        return cell
        }
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let val = ((arrCategory.count/3) * 170) + 150
        if tableView == tblProductSearch {
            return 140
        }
        if tableView == tblStore {
            return UITableView.automaticDimension

        } else {
           
            if DeviceType.isPad {
                return CGFloat(670 + 40 + 140  + Int(val))

            }
            return CGFloat(670 + 40 + 40  + Int(val))
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == tblProductSearch {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tblProductSearch.frame.size.width, height: 50))
        customView.backgroundColor = Theme_Color
        let btnAllProduct = UIButton(frame: CGRect(x: 0, y: 0, width: tblProductSearch.frame.size.width, height: 50))
        btnAllProduct.setTitle("View All Products", for: .normal)
        btnAllProduct.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        btnAllProduct.titleLabel?.textColor = UIColor.white

        btnAllProduct.addTarget(self, action: #selector(btnAllProductClicked), for: .touchUpInside)
        customView.addSubview(btnAllProduct)
        //tblProductSearch.tableFooterView = customView
        return customView
        }
        return nil
    }
    
    @objc func btnAllProductClicked(_ sender: UIButton!) {
         let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                       let vc = storyBaord.instantiateViewController(withIdentifier: "VProductViewController") as! VProductViewController
        if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {

                       vc.shopId = sid
        }
        vc.strSearchKey = txtSearch.text!
                       vc.categoryId = 0
                       vc.subcategoryID = 0
                      

                       self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            if tableView == tblProductSearch {

            return 50
            }
            return 0

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblProductSearch {
            
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            
            let vc = storyBaord.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            vc.productId = arrProductSearch[indexPath.row].ProductId!
            if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {

                           vc.shopId = sid
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        if tableView == tblStore {
            index = indexPath.row
            tblStore.reloadData()
        }
    }
    
}
// MARK: - Cell Delegate

/*extension HomeViewController :HomeCellDelegate {
    func delegatePramotionClicked(_ sender: HomeCell) {
        isProduct = true
        isSpecial = true
        self.getShopedetail()
    }
    
    func delegateImageClicked(_ sender: HomeCell) {
        
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
    
    func delegateMapClicked(_ sender: HomeCell) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func delegateSideClicked(_ sender: HomeCell) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func delegateProductClicked(_ sender: HomeCell, btn : UIButton) {
        print("Product Clcked")
        isProduct = true
        self.getShopedetail()
       

    }
    
   
    
    func delegateWishClicked(_ sender: HomeCell) {
        print("Wish Clcked")
        
        if CommonFunctions.userLoginData() == true {

        isProduct = false
        self.getShopedetail()
        }
        else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.cType = ControllerType.Home
            self.navigationController?.pushViewController(vc, animated: true)
        }
       

    }
    
    
    
    func delegateMemberClicked(_ sender: HomeCell) {
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
    
}*/

