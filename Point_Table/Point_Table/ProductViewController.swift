//
//  ProductGridViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 09/11/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import EMAlertController
import CCBottomRefreshControl
private let headerId = "headerId"

class ProductViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var lblCount: UILabel!
    var isLoading = false
    var loadingView: LoadingReusableView?

    var shopId = 0
    var categoryId = 0
    var subcategoryID = 0
    var pageNo = 1
    var pageSize = 10
    var sortType = 1
    var strBrandId = ""
    var index = -1;
    var arrSort = ["Default", "New First", "Low Price First", "High Price First"];
    var isPaging = true
    var arrBrand = [BrandModel]()
    var totalPageV = 0
    var isPagingV = true
    var pageNoV = 1
    var arrProduct = [ProductModel]()
    
    var strProdId = ""
    
    var totalPage = 0
    var isSpecialOffer = false

    var arrProductSearch = [ProductSearchModel]()
    @IBOutlet weak var lblSort: UILabel!
    @IBOutlet weak var lblFilter: UILabel!
    
    
    @IBOutlet weak var viewSort: UIView!
    @IBOutlet weak var imgBackSort: UIImageView!
    @IBOutlet weak var lblTitleSort: UILabel!
    @IBOutlet weak var btnCloseSort: UIButton!
    @IBOutlet weak var btnDoneSort: UIButton!
    @IBOutlet weak var tblSort: UITableView!
    
    @IBOutlet weak var viewBrand: UIView!
    @IBOutlet weak var imgBackBrand: UIImageView!
    @IBOutlet weak var btnCloseBrand: UIButton!
    @IBOutlet weak var btnDoneBrand: UIButton!
    @IBOutlet weak var tblBrand: UITableView!
    
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var tblProductSearch: UITableView!
    @IBOutlet weak var imgProductSearch: UIImageView!
    
    
    var datePicker:UIDatePicker = UIDatePicker()
    @IBOutlet weak var viewBirth: UIView!
    @IBOutlet weak var imgBirth: UIView!
    @IBOutlet weak var lblBirthTitle: UILabel!
    @IBOutlet weak var txtBirth: SkyFloatingLabelTextField!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    var intSender = -1
    var intType = -1
    
    
    var isSearch = false
    
    var searchData = ""
    
    var cartcount = 0;
    
    var pscategoryId = 0
    var pssubcategoryID = 0
    
    var intSenderTag = 0
    var intSenderType = 0
    
    @IBOutlet weak var imgBackUpdateQty: UIImageView!
    @IBOutlet weak var viewUpdateQty: UIView!

    @IBOutlet weak var lblUpdateQtyTitle: UILabel!
    @IBOutlet weak var txtUpdateQty: UITextField!
    @IBOutlet weak var lblUpdateQtyMessage: UILabel!
    @IBOutlet weak var btnUpdateQty: UIButton!
    @IBOutlet weak var btnCancelQty: UIButton!
    @IBOutlet weak var lblKg: UILabel!

    var isPageLoading = false
    override func viewDidLoad() {
        
        txtUpdateQty.textAlignment = .center

        super.viewDidLoad()
        SetupUI()
        imgBackUpdateQty.isHidden = true
        viewUpdateQty.isHidden = true

        if isSpecialOffer == true {
            //consHeight.constant = 0
           // stack.isHidden = true
           // btnSearch.isHidden = true
            lblHeader.text = "Special Offers"

        } else {
            //consHeight.constant = 60
           // stack.isHidden = false
            lblHeader.text = "Product List"
            //btnSearch.isHidden = false

        }
        
        self.btnSearch.isHidden = false
        
        if isSearch == true {
            self.btnSearch.isHidden = true
            
            self.txtSearch.text = searchData
        }
        
        txtSearch.returnKeyType = .search
        CommonFunctions.setPadding(textField: txtSearch, width: 15)
        
        collectionV.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        collectionV.isPagingEnabled = false
        collectionV.backgroundColor = UIColor.clear
        
        
        //Register Loading Reuseable View
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        collectionV.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
        
       // collectionV.register(Header.self, forSupplementaryViewOfKind:
           // UICollectionView.elementKindSectionFooter, withReuseIdentifier: headerId)
        //collectionV.register(Header.self, forCellWithReuseIdentifier: headerId)
               
        
        tblSort.register(UINib(nibName: "BLClientCell", bundle: nil), forCellReuseIdentifier: "BLClientCell")
        
        tblBrand.register(UINib(nibName: "BrandCell", bundle: nil), forCellReuseIdentifier: "BrandCell")
        
        
        tblProductSearch.register(UINib(nibName: "SearchProduct", bundle: nil), forCellReuseIdentifier: "SearchProduct")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProductViewController.closeFilter(_:)))
        
        
        imgBackBrand.isUserInteractionEnabled = true
        imgBackBrand.addGestureRecognizer(tapGestureRecognizer)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.Reloadlist(notification:)), name: Notification.Name("RELOADLISTITEM"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshLoginData(notification:)), name: Notification.Name("REFRESHLOGINAFTERDATA"), object: nil)
        
        
//        let bottomRefreshController = UIRefreshControl()
//        //bottomRefreshController.triggerVerticalOffset = 50
//        bottomRefreshController.addTarget(self, action: #selector(ProductViewController.refreshBottom), for: .valueChanged)
//
//        collectionV.bottomRefreshControl = bottomRefreshController

        
        // Do any additional setup after loading the view.
    }
    @objc func refreshBottom() {
         //api call for loading more data
        
           if totalPage > (pageNo*10) {
            collectionV.bottomRefreshControl?.beginRefreshing()

            pageNo = pageNo + 1

            
            getAllProduct(isSearch: txtSearch.text!.count > 0 ? true : false)
            
            
           } else {
            collectionV.bottomRefreshControl?.endRefreshing()
        }
    }
    
    @objc func refreshLoginData(notification: Notification) {
        
        //4633
        arrProduct.removeAll()
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["ShopId"] = shopId
                // param["CategoryId"] = isSearch ? pscategoryId : categoryId
                // param["SubCategoryId"] = isSearch ? pssubcategoryID : subcategoryID
                param["UserId"] = user.UserId
                //   param["PageNo"] = pageNo
                //  param["PageSize"] = pageSize
                //  param["SortType"] = sortType
                //  param["BrandId"] = strBrandId
                param["ProductIds"] = self.strProdId
                
                //param["ProductSearchKeyword"] = txtSearch.text!
                APIManager.requestPostJsonEncoding(.getallproduct, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    self.strProdId = ""
                    
                    if let data = Dict["data"] as? [[String:Any]] {
                        
                        if data.count == 0 {
                            self.isPaging = false
                        }
                        
                        for objAd in data {
                            let obj = ProductModel(json: objAd)
                            self.arrProduct.append(obj)
                        }
                        
                        for obj in self.arrProduct {
                            self.totalPage = obj.TotalRecords ?? 0
                            
                        }
                        
                        
                        
                    } else {
                        self.isPaging = false
                    }
                    self.collectionV.reloadData()
                    
                    
                    
                    if self.arrProduct[self.intSenderTag].Age ?? 0 != 0 {
                        self.intSender = self.intSenderTag
                        self.intType = self.intSenderType
                        
                        self.lblBirthTitle.text = "Please enter your date of birth to confirm that you are over \(self.arrProduct[self.intSenderTag].Age ?? 0 ) year old"
                        //self.viewBirth.isHidden = false
                        //self.imgBirth.isHidden = false
                        
                        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                        let alertError = EMAlertController(icon: nil, title: appName, message: "Please confirm that you are over \(self.arrProduct[self.intSenderTag].Age ?? 0 ) years old to buy this product. Your Identity document will be checked by staff upon delivery or collection.")
                        alertError.addAction(EMAlertAction(title: "Cancel", style: .normal, action: {
                            
                        }))
                        
                        alertError.addAction(EMAlertAction(title: "Confirm", style: .normal, action: {
                            
                            let btn = UIButton()
                            self.btnYesClicked(btn)
                           
                        }))
                       
                        rootViewController.present(alertError, animated: true, completion: nil)
                        
                        return
                    }
                    
                    let productid = self.arrProduct[self.intSenderTag].ProductId ?? 0
                    let qty = 1
                    
                    if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                        let user = UserModel(json: userdict)
                        if Reachability.isConnectedToNetwork() {
                            
                            var param  = [String : Any]()
                            param["ShopId"] = self.shopId
                            param["UserId"] = user.UserId
                            param["ProductId"] = productid
                            param["Age"] = 0
                            param["ProductId"] = productid
                            param["Qty"] = qty
                            param["Type"] = self.intSenderType
                            APIManager.requestPostJsonEncoding(.addorremovetocart, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                                
                                let Dict = JSONResponse as! [String:Any]
                                print(Dict)
                                
                                if let data = Dict["data"] as? [String:Any] {
                                    if let cartCount = data["CartCount"] as? Int {
                                        self.cartcount = cartCount
                                        self.lblCount.text = "\(cartCount)"
                                        
                                        if let productQty = data["ProductQty"] as? Int {
                                            self.arrProduct[self.intSenderTag].CartQty = productQty
                                        }
                                        if let qtyNotAvl = data["IsQtyNotAvailable"] as? Bool {
                                            if qtyNotAvl == true {
                                                self.arrProduct[self.intSenderTag].AvailableQty = Double(self.arrProduct[self.intSenderTag].CartQty!)
                                            }
                                        }
                                    }
                                }
                                self.collectionV.reloadData()
                                
                            }) { (error) -> Void in
                                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                            }
                        } else {
                            CommonFunctions.showMessage(message: Message.internetnotconnected)
                        }
                    }
                    
                    
                    
                }) { (error) -> Void in
                    CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
        
        //getAllBrand()
        
    }
    
    @objc func Reloadlist(notification: Notification) {
        for i in 0..<self.arrProduct.count {
            self.arrProduct[i].Age = 0
            
        }
        self.collectionV.reloadData()
    }
    
    @objc func closeFilter(_ sender:AnyObject){
        imgBackBrand.isHidden = true
        viewBrand.isHidden = true
    }
    
    //MARK:- Setup UI
    
    @objc func dateChange(_ sender:UIDatePicker) {
        txtBirth.text =  sender.date.getDateWithFormate("dd/MM/yyyy")
    }
    func SetupUI() -> Void {
        
        
        
        self.tblProductSearch.isHidden = true
        self.imgProductSearch.isHidden = true
        self.txtUpdateQty.delegate  = self
        
        viewHeader.isHidden = false
        viewSearch.isHidden = true
        
        lblCount.isHidden = true
        
        lblCount.font = UIFont(name: Font_Semibold, size: 14)
        
        CommonFunctions.setCornerRadius(view: txtSearch, radius: 17)
        
        CommonFunctions.setCornerRadius(view: lblCount, radius: 11)
        
        CommonFunctions.setBorder(view: lblCount, color: UIColor.white, width: 1)
        
        tblSort.tag = 1001
        tblBrand.tag = 1002
        
        
        lblTitleSort.font = UIFont(name: Font_Semibold, size: 17)
        btnDoneSort.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnDoneSort, radius: 17)
        
        btnCloseSort.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnCloseSort, radius: 17)
        
        btnDoneBrand.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnDoneBrand, radius: 17)
        
        btnUpdateQty.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnUpdateQty, radius: 17)
        
        btnCancelQty.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnCancelQty, radius: 17)
        CommonFunctions.setCornerRadius(view: viewUpdateQty, radius: 17)

        
        btnCloseBrand.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnCloseBrand, radius: 17)
        
        imgBackSort.isHidden = true
        viewSort.isHidden = true
        
        imgBackBrand.isHidden = true
        viewBrand.isHidden = true
        
        
        viewBirth.isHidden = true
        imgBirth.isHidden = true
        
        
        lblUpdateQtyTitle.font = UIFont(name: Font_Semibold, size: 18)
        lblUpdateQtyMessage.font = UIFont(name: Font_Regular, size: 16)
        lblKg.font = UIFont(name: Font_Regular, size: 16)

        txtSearch.font = UIFont(name: Font_Regular, size: 17)
        
        
        lblFilter.font = UIFont(name: Font_Semibold, size: 16)
        lblSort.font = UIFont(name: Font_Semibold, size: 16)
        
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        
        lblBirthTitle.font = UIFont(name: Font_Semibold, size: 15)
        txtBirth.font = UIFont(name: Font_Regular, size: 17)
        txtBirth.titleFormatter = { $0 }
        btnYes.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        btnNo.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChange(_:)), for: UIControl.Event.valueChanged)
        txtBirth.inputView = datePicker
        
       // getAllBrand()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrProduct.removeAll()
        self.getCartCount()
        getAllBrand()

    }
    
    
    //MARK: - Get Product
    func getAllBrand() -> Void {
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["ShopId"] = shopId
            if isSpecialOffer == true {
                param["CategoryId"] = ""
                param["SubCategoryId"] = ""
            } else {
                param["CategoryId"] = categoryId
                param["SubCategoryId"] = subcategoryID
            }
            
            
            
            APIManager.requestPostJsonEncoding(isSpecialOffer == true ? .getallbrandweb : .getallbrand, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                if let data = Dict["data"] as? [[String:Any]] {
                    
                    
                    
                    for objAd in data {
                        let obj = BrandModel(json: objAd)
                        obj.isSelect = false
                        self.arrBrand.append(obj)
                    }
                    
                }
                self.tblBrand.reloadData()
                self.isLoading = false
                self.collectionV.collectionViewLayout.invalidateLayout()
                      
                self.getAllProduct(isSearch: self.txtSearch.text!.count > 0 ? true : false)
                
                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
    }
    
    func getAllProduct(isSearch : Bool) -> Void {
        
       
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
               
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                       
                       var param  = [String : Any]()
                       param["ShopId"] = shopId
                if isSpecialOffer == true {
                    param["CategoryId"] = ""
                    param["PromotionCategoryId"] = categoryId

                                   param["SubCategoryId"] = ""
                    param["IsDisplayHomePage"] = false
                    param["IsDisplayPromotionOnly"] = true
                    param["UserId"] = user.UserId
                    param["SortType"] = sortType
                    param["BrandId"] = strBrandId


                } else {
                    param["CategoryId"] = isSearch ? pscategoryId : categoryId
                                   param["SubCategoryId"] = isSearch ? pssubcategoryID : subcategoryID
                    param["UserId"] = user.UserId
                    param["SortType"] = sortType
                    param["BrandId"] = strBrandId


                }
               
                       param["PageNo"] = pageNo
                       param["PageSize"] = pageSize
                        param["ProductSearchKeyword"] = txtSearch.text!
                APIManager.requestPostJsonEncoding(isSpecialOffer == true ? .getallproductweb : .getallproduct, isLoading:  (self.isPageLoading ? false : true) , params: param, headers: [:],success: { (JSONResponse)  -> Void in
                           
                           let Dict = JSONResponse as! [String:Any]
                           print(Dict)
                           
                           if let data = Dict["data"] as? [[String:Any]] {
                               
                               if data.count == 0 {
                                 self.isPaging = false
                               }

                               for objAd in data {
                                   let obj = ProductModel(json: objAd)
                                   self.arrProduct.append(obj)
                               }
                            
                            for obj in self.arrProduct {
                                self.totalPage = obj.TotalRecords ?? 0
                                self.strProdId = self.strProdId + "\(obj.ProductId!),"

                            }
                            
                                if self.totalPage > 0 {
                                    self.isPageLoading = true
                                }
                            

                           } else {
                               self.isPaging = false
                           }
                   // self.collectionV.bottomRefreshControl?.endRefreshing()

                    DispatchQueue.main.async {
                     self.isLoading = false

                        self.collectionV.reloadData()
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
                   param["ShopId"] = shopId
           
                   param["PageNo"] = pageNo
                   param["PageSize"] = pageSize
                param["ProductSearchKeyword"] = txtSearch.text!

                if isSpecialOffer == true {
                    param["PromotionCategoryId"] = categoryId

                                   param["CategoryId"] = ""
                                                  param["SubCategoryId"] = ""
                                   param["IsDisplayHomePage"] = false
                                   param["IsDisplayPromotionOnly"] = true
                                   param["UserId"] = 0
                                   param["SortType"] = sortType
                                   param["BrandId"] = strBrandId


                               } else {
                                   param["CategoryId"] = isSearch ? pscategoryId : categoryId
                                                  param["SubCategoryId"] = isSearch ? pssubcategoryID : subcategoryID
                                   param["UserId"] = 0
                                   param["SortType"] = sortType
                                   param["BrandId"] = strBrandId


                               }
                
                APIManager.requestPostJsonEncoding( isSpecialOffer == true ? .getallproductweb : .getallproduct, isLoading:  isSpecialOffer == true ? true :  (self.isPageLoading ? false : true), params: param, headers: [:],success: { (JSONResponse)  -> Void in
                       
                       let Dict = JSONResponse as! [String:Any]
                       print(Dict)
                       
                       if let data = Dict["data"] as? [[String:Any]] {
                           
                           if data.count == 0 {
                             self.isPaging = false
                           }

                           for objAd in data {
                               let obj = ProductModel(json: objAd)
                               self.arrProduct.append(obj)
                           }
                        
                                                   for obj in self.arrProduct {
                                                    self.totalPage = obj.TotalRecords ?? 0

                                                       self.strProdId = self.strProdId + "\(obj.ProductId!),"

                                                   }
                        
                            if self.totalPage > 0 {
                                self.isPageLoading = true
                            }
                        
                        

                       } else {
                           self.isPaging = false
                       }
                   // self.collectionV.bottomRefreshControl?.endRefreshing()

                    DispatchQueue.main.async {
                     self.isLoading = false

                        self.collectionV.reloadData()
                    }

                       
                       
                   }) { (error) -> Void in
                       CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                   }
               } else {
                   CommonFunctions.showMessage(message: Message.internetnotconnected)
               }
        }
        
       
    }
    
    func getAllProductSearch() -> Void {
        
       var usrI = 0
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
           
        let user = UserModel(json: userdict)
            usrI = user.UserId ?? 0
        }
        if isSpecialOffer == false {
        self.arrProductSearch.removeAll()
        }
        tblProductSearch.reloadData()
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            if isSpecialOffer == false {
                param["ShopId"] = shopId
                param["ProductSearchKeyword"] = txtSearch.text!
            } else {
                param["ShopId"] = shopId
                param["PromotionCategoryId"] = categoryId

                param["CategoryId"] = ""
                param["SubCategoryId"] = ""
                param["IsDisplayHomePage"] = false
                param["IsDisplayPromotionOnly"] = true
                param["UserId"] = usrI
                param["SortType"] = sortType
                param["BrandId"] = strBrandId
                param["PageNo"] = pageNoV
                param["PageSize"] = pageSize
                param["ProductSearchKeyword"] = txtSearch.text!
            }
            
            APIManager.requestPostJsonEncoding(isSpecialOffer == true ? .getallproductweb : .productsearch, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                if let data = Dict["data"] as? [[String:Any]] {
                    
                    
                    if data.count == 0 {
                        self.isPagingV = false
                    }
                    
                    
                    
                    
                    
                    for objAd in data {
                        let obj = ProductSearchModel(json: objAd)
                        self.arrProductSearch.append(obj)
                    }
                    
                    for obj in self.arrProductSearch {
                        self.totalPageV = obj.TotalRecords ?? 0
                        
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
    
    func getCartCount() -> Void {
        
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["ShopId"] = shopId
                param["UserId"] = user.UserId
                
                APIManager.requestPostJsonEncoding(.cartcount, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [String:Any] {
                        if let cartCount = data["CartCount"] as? Int {
                            self.lblCount.text = "\(cartCount)"
                            self.lblCount.isHidden = false
                            
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
    
    func addToCart(index : Int, type : Int, isManual : Bool, cartWeight : Double, cartQty : Int ) -> Void {
        NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)

        
        if type != 2 {
        
        if arrProduct[index].Age ?? 0 != 0 {
            
            lblBirthTitle.text = "Please enter your date of birth to confirm that you are over \(arrProduct[index].Age ?? 0 ) year old"
            
            let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
            let alertError = EMAlertController(icon: nil, title: appName, message: "Please confirm that you are over \(self.arrProduct[index].Age ?? 0 ) years old to buy this product. Your Identity document will be checked by staff upon delivery or collection.")
            
            alertError.addAction(EMAlertAction(title: "Cancel", style: .normal, action: {
                
            }))
            
            alertError.addAction(EMAlertAction(title: "Confirm", style: .normal, action: {
                
                
               let btn = UIButton()
               self.btnYesClicked(btn)
                
            }))
            
            rootViewController.present(alertError, animated: true, completion: nil)
            
            //viewBirth.isHidden = false
            //imgBirth.isHidden = false
            return
        }
        }
        
        let productid = arrProduct[index].ProductId ?? 0
        let qty = 1
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                
                var param  = [String : Any]()
                param["ShopId"] = shopId
                param["UserId"] = user.UserId
                param["ProductId"] = productid
                param["Age"] = 0
                param["ProductId"] = productid
                if arrProduct[index].isQtyEdit == true {
                    param["Qty"] = arrProduct[index].CartQty!

                } else {
                    param["Qty"] = cartQty == 0 ? qty : cartQty

                }
                param["Type"] = type
                param["ProductType"] = self.arrProduct[index].ProductType ?? 0
                
                if self.arrProduct[index].ProductType ?? 0 == 0 {
                    param["Weight"] = 0
                } else {
                    if self.arrProduct[index].ProductType ?? 0 == 1 {
                        if arrProduct[index].isKg! == true {
                            param["Qty"] = cartQty == 0 ? 0 : cartQty
                            if arrProduct[index].isQtyEdit == true {
                                param["Weight"] =  self.arrProduct[index].CartWeight!
                            } else {
                               param["Weight"] = cartWeight == 0.0 ?  self.arrProduct[index].DefaultWeight : cartWeight
                            }
                            

                        } else {
                            if arrProduct[index].isQtyEdit == true {
                                                           param["Weight"] =  self.arrProduct[index].CartWeight!
                                                       } else {
                                                          param["Weight"] = cartWeight == 0.0 ?  self.arrProduct[index].DefaultWeight : cartWeight
                                                       }

                        }
                    } else {
                        if arrProduct[index].isQtyEdit == true {
                                                       param["Weight"] =  self.arrProduct[index].CartWeight!
                                                   } else {
                                                      param["Weight"] = cartWeight == 0.0 ?  self.arrProduct[index].DefaultWeight : cartWeight
                                                   }

                    }
                }
                 
                if isManual == true {
                    param["IsFullValueChange"] = arrProduct[index].isQtyEdit == true ? 1 : 0
                } else {
                    param["IsFullValueChange"] = 0

                }

                APIManager.requestPostJsonEncoding(.addorremovetocart, isLoading: false, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [String:Any] {
                        if let cartCount = data["CartCount"] as? Int {
                            self.cartcount = cartCount
                            self.lblCount.text = "\(cartCount)"
                            NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)

                            if let productQty = data["ProductQty"] as? Int {
                                self.arrProduct[index].CartQty = cartQty == 0 ? productQty : 0
                            }
                            if let productQty = data["ProductWeight"] as? Double {
                                self.arrProduct[index].CartWeight = cartWeight == 0.0 ? productQty : 0.0
                            }
                            if let qtyNotAvl = data["IsQtyNotAvailable"] as? Bool {
                                if qtyNotAvl == true {
                                    self.arrProduct[index].AvailableQty = Double(self.arrProduct[index].CartQty!)
                                }
                            }
                        }
                    }
                  
                    self.collectionV.reloadData()
                    
                }) { (error) -> Void in
                    CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tblBrand || scrollView == tblSort {
            return
        }
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            if isSpecialOffer == true {
                if scrollView == tblProductSearch {
                    if totalPageV > (pageNoV*10) {
                        pageNoV = pageNoV + 1

                        getAllProductSearch()
                    }

                }
            }
//               if totalPage > (pageNo*10) {
//                pageNo = pageNo + 1
//
//
//                getAllProduct(isSearch: txtSearch.text!.count > 0 ? true : false)
//
//
//            }
        }
    }
    /*func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == tblBrand || scrollView == tblSort {
                   return
               }
        targetContentOffset.pointee = scrollView.contentOffset
        var indexes = self.collectionV.indexPathsForVisibleItems
        indexes.sort()
        var index = indexes.first!
        let cell = self.collectionV.cellForItem(at: index)!
        let position = self.collectionV.contentOffset.x - cell.frame.origin.x
        if position > cell.frame.size.width/2{
           index.row = index.row+1
        }
        self.collectionV.scrollToItem(at: index, at: .left, animated: true )
    }*/

    
    // MARK: - IBAction Event
    
    @IBAction func btnYesClicked(_ sender: UIButton) {
        
        viewBirth.isHidden = true
        imgBirth.isHidden = true
        
//        if txtBirth.text == ""
//        {
//            CommonFunctions.showMessage(message: Message.enterage)
//            return
//        }
        
        
       // let intAge = CommonFunctions.calcAge(birthday: txtBirth.text!)
        let intMainAge = arrProduct[intSender].Age ?? 0
        
        txtBirth.text = ""
        
       // if(intMainAge <= intAge) {
            
            
            let productid = arrProduct[intSender].ProductId ?? 0
            let qty = 1
            
            if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                let user = UserModel(json: userdict)
                if Reachability.isConnectedToNetwork() {
                    
                    var param  = [String : Any]()
                    param["ShopId"] = shopId
                    param["UserId"] = user.UserId
                    param["ProductId"] = productid
                    param["Age"] = intMainAge
                    param["ProductId"] = productid
                    param["Qty"] = qty
                    param["Type"] = intType
                    APIManager.requestPostJsonEncoding(.addorremovetocart, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                        
                        let Dict = JSONResponse as! [String:Any]
                        print(Dict)
                        
                        if let data = Dict["data"] as? [String:Any] {
                            if let cartCount = data["CartCount"] as? Int {
                                self.cartcount = cartCount
                                self.lblCount.text = "\(cartCount)"
                                NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)

                                if let productQty = data["ProductQty"] as? Int {
                                    self.arrProduct[self.intSender].CartQty = productQty
                                }
                                if let qtyNotAvl = data["IsQtyNotAvailable"] as? Bool {
                                    if qtyNotAvl == true {
                                        self.arrProduct[self.intSender].AvailableQty = Double(self.arrProduct[self.intSender].CartQty!)
                                    }
                                }
                            }
                        }
                        
                        for i in 0..<self.arrProduct.count {
                            self.arrProduct[i].Age = 0
                            
                        }
                        self.collectionV.reloadData()
                        
                    }) { (error) -> Void in
                        CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                    }
                } else {
                    CommonFunctions.showMessage(message: Message.internetnotconnected)
                }
            }
            
            
            
//
//        } else {
//            CommonFunctions.showMessage(message: Message.notmatchage)
//
//        }
        
    }
    
    @IBAction func btnNoClicked(_ sender: UIButton) {
        
        txtBirth.text = ""
        viewBirth.isHidden = true
        imgBirth.isHidden = true
        
    }
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        
        viewHeader.isHidden = false
        viewSearch.isHidden = true
        
        self.tblProductSearch.isHidden = true
        self.imgProductSearch.isHidden = true
        
        
        txtSearch.resignFirstResponder()
        txtSearch.text = ""
        pageNo = 1
        arrProduct.removeAll()
        self.isLoading = false
                       self.collectionV.collectionViewLayout.invalidateLayout()
                            
        getAllProduct(isSearch: txtSearch.text!.count > 0 ? true : false)
        
        
    }
    @IBAction func btnShopClicked(_ sender: UIButton) {
        if CommonFunctions.userLoginData() == true {
            
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
            vc.shopId = shopId
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.cType = ControllerType.Cart
            vc.shopId = shopId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnWishlistClicked(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: WishlistViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: PramotionCategoryViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: MyCartViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func btnsearchClicked(_ sender: Any) {
        viewHeader.isHidden = true
        viewSearch.isHidden = false
        
        txtSearch.becomeFirstResponder()
    }
    
    @IBAction func btnsortClicked(_ sender: Any) {
        
        imgBackSort.isHidden = false
        viewSort.isHidden = false
    }
    @IBAction func btnsortdoneClicked(_ sender: Any) {
        
        imgBackSort.isHidden = true
        viewSort.isHidden = true
        
        
        pageNo = 1
        sortType = index + 1
        arrProduct.removeAll()
        self.isLoading = false
                       self.collectionV.collectionViewLayout.invalidateLayout()
                            
        getAllProduct(isSearch: txtSearch.text!.count > 0 ? true : false)
        
    }
    @IBAction func btnsortcancleClicked(_ sender: Any) {
        
        imgBackSort.isHidden = true
        viewSort.isHidden = true
    }
    @IBAction func btnfilterClicked(_ sender: Any) {
        
        if arrBrand.count == 0 {
            
            CommonFunctions.showMessage(message: Message.nofilterava)

            return
        }
        imgBackBrand.isHidden = false
        viewBrand.isHidden = false
    }
    
    @IBAction func btnfilterdoneClicked(_ sender: Any) {
        imgBackBrand.isHidden = true
        viewBrand.isHidden = true
        
        var strId = ""
        
        let arr = arrBrand.filter({$0.isSelect! == true})
        
        for i in 0..<arr.count {
            if i == 0 {
                strId = strId + "\(arr[i].BrandId!)"
            } else {
                if i == arrBrand.count - 1 {
                    strId = strId + "\(arr[i].BrandId!)"
                } else {
                    strId = strId + "\(arr[i].BrandId!),"
                }
            }
        }
        
        
        strBrandId = strId
        pageNo = 1
        arrProduct.removeAll()
        self.isLoading = false
                       self.collectionV.collectionViewLayout.invalidateLayout()
                            
        getAllProduct(isSearch: txtSearch.text!.count > 0 ? true : false)
        
    }
    @IBAction func btnfiltercancleClicked(_ sender: Any) {
        
        for obj in arrBrand {
            obj.isSelect = false
        }
        
        tblBrand.reloadData()
        
    }
    @objc func btnAllProductClicked(_ sender: UIButton!) {
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                          let vc = storyBaord.instantiateViewController(withIdentifier: "VProductViewController") as! VProductViewController
                          vc.shopId = shopId
           vc.strSearchKey = txtSearch.text!
                          vc.categoryId = 0
                          vc.subcategoryID = 0
                         

                          self.navigationController?.pushViewController(vc, animated: true)
       }
    
    //MARK: - UITextfield Delegate ----
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        
        
        getAllProductSearch()
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //MARK: - UICollectionView Delegate & DataSource ----
    
    public func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProduct.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
           if self.isLoading {
               return CGSize.zero
           } else {
               return CGSize(width: collectionView.bounds.size.width, height: 55)
           }
       }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
                        return CGSize(width: ScreenSize.width - 20, height: 230)

                 }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == arrProduct.count - 1 && !self.isLoading && self.isPaging {

               if totalPage > (pageNo*10) {
                self.isLoading = true
                

                pageNo = pageNo + 1

                
                getAllProduct(isSearch: txtSearch.text!.count > 0 ? true : false)
                
                
               } else {
                DispatchQueue.main.async {
                    self.isLoading = true

                                   self.collectionV.reloadData()
                               }

            }
            
        }
       }
    
   /* func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableCell(withReuseIdentifier: headerId, for: indexPath) as! Header
        header.dateLabel.stopAnimating()
        header.dateLabel.isHidden = true

            if isPaging == true {
                if totalPage > (pageNo*10) {

                header.dateLabel.isHidden = false
                    header.dateLabel.startAnimating()
                }
            }

        
        
       
        return header
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: ScreenSize.width, height: 40)

    }*/
    
    
    func attributetext(lbl1: UILabel, main : String, sub : String) {
        let main_string = main + " " + sub
        
        let sub_string = sub
        let range = (main_string as NSString).range(of: sub_string)
        let mainrange = (main_string as NSString).range(of: main_string)
        
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttributes([NSAttributedString.Key.font: UIFont(name: Font_Semibold, size: 13) as Any], range: mainrange)
        
        attribute.addAttributes([NSAttributedString.Key.font: UIFont(name: Font_Regular, size: 12) as Any], range: range)
        
        lbl1.attributedText = attribute
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath as IndexPath) as! ProductCell
        let pname = arrProduct[indexPath.row].ProductName!.replacingOccurrences(of: "\t", with: "")
        arrProduct[indexPath.row].isQtyEdit = false
        if arrProduct[indexPath.row].ProductSize == 0 {
            self.attributetext(lbl1: cell.lblTitle, main: pname, sub: "")
        } else {
            self.attributetext(lbl1: cell.lblTitle, main: pname, sub: "(\(arrProduct[indexPath.row].ProductSize!.clean) \(arrProduct[indexPath.row].ProductSizeType!))")
        }
        
        if arrProduct[indexPath.row].PromotionTitle! == "" {
            cell.lblPramotion.isHidden = true
            cell.lblconstheight.constant = 0
            cell.imgPramotion.isHidden = true

        } else {
            cell.lblPramotion.isHidden = false
            cell.imgPramotion.isHidden = false

            cell.lblconstheight.constant = 22
            cell.lblPramotion.text = " \(arrProduct[indexPath.row].PromotionTitle!)"
        }
        
        if  arrProduct[indexPath.row].CartQty! > 0 || arrProduct[indexPath.row].CartWeight! > 0 {
            cell.btnplus.isHidden = false
            cell.btnminus.isHidden = false

            cell.btnAdd.isHidden = true
        } else {
            cell.btnAdd.isHidden = false
            cell.btnplus.isHidden = true
            cell.btnminus.isHidden = true
        }


        if arrProduct[indexPath.row].ProductType! > 0 && arrProduct[indexPath.row].CartQty! > 0 {
            arrProduct[indexPath.row].isKg! = false
        }
        
        if arrProduct[indexPath.row].ProductType! > 0 && arrProduct[indexPath.row].CartQty! == 0 && arrProduct[indexPath.row].CartWeight! > 0 {
                   arrProduct[indexPath.row].isKg! = true
               }

        
        if arrProduct[indexPath.row].isKg! == true {
            cell.btnKg.setImage(UIImage(named: "radio_select"), for: .normal)
            cell.btnItems.setImage(UIImage(named: "radio_deselect"), for: .normal)
        } else {
            cell.btnKg.setImage(UIImage(named: "radio_deselect"), for: .normal)
            cell.btnItems.setImage(UIImage(named: "radio_select"), for: .normal)
        }
        //

        cell.btnKg.isHidden = true
        cell.btnItems.isHidden = true

        if arrProduct[indexPath.row].ProductType! == 1 {
            cell.btnKg.isHidden = false
            cell.btnItems.isHidden = false
        }
       
        
        
        var symboll = ""
        if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
            symboll = symbol
        }
        
        
        cell.lblOrAmount.text = "\(symboll) \(CommonFunctions.appendString(data: arrProduct[indexPath.row].Price!))"
        if arrProduct[indexPath.row].ProductType! > 0 {
            //Show kg with price
            
            
            
            let strPrice = "\(cell.lblOrAmount.text!)/ \(arrProduct[indexPath.row].ProductSizeType!)"
            cell.lblOrAmount.text = strPrice

            
        }
        
        cell.lblQty.tag = 100 + indexPath.row
        cell.lblQty.delegate = self
        cell.lblAmount.isHidden = false
        cell.constTopamnt.constant = 15
        cell.constHeightamnt.constant = 20

        cell.lblOrAmount.textColor = Theme_Red_Color

        if arrProduct[indexPath.row].OldPrice! == 0.0 {
            cell.lblAmount.isHidden = true
            cell.constTopamnt.constant = 0
            cell.constHeightamnt.constant = 0
            cell.lblOrAmount.textColor = UIColor.black

        }
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(symboll) \(CommonFunctions.appendString(data: arrProduct[indexPath.row].OldPrice!))")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        cell.lblAmount.attributedText = attributeString
        
        if arrProduct[indexPath.row].CartQty! == 0 {
//            cell.viewAdd.isHidden = true
//            cell.btnAdd.isHidden = false
        } else {
//            cell.viewAdd.isHidden = false
//            cell.btnAdd.isHidden = true
        }
        
        if arrProduct[indexPath.row].IsFavourite! == false {
            cell.btnAddwishList.setImage(UIImage(named: "Assetheartunfill"), for: .normal)
        } else {
            cell.btnAddwishList.setImage(UIImage(named: "Assetheart"), for: .normal)

        }
        
        if arrProduct[indexPath.row].IsPriceMarked! == false {
                   cell.imgPriceMark.isHidden = true
               } else {
                   cell.imgPriceMark.isHidden = false

               }
        
        
        cell.lblTitleQty.text = "Qty"

        if arrProduct[indexPath.row].ProductType! == 1 {

            if arrProduct[indexPath.row].isKg! == true {
                
                cell.lblTitleQty.text = "Kg"
                
                if arrProduct[indexPath.row].CartWeight ?? 0.0 > 0 {
                    
                    cell.lblQty.text = "\(CommonFunctions.appendStringWeighItem(data: arrProduct[indexPath.row].CartWeight!))"

                } else {

                    
        cell.lblQty.text = "\(CommonFunctions.appendStringWeighItem(data: arrProduct[indexPath.row].DefaultWeight!))"
                }
            } else {
                if arrProduct[indexPath.row].CartQty ?? 0 > 0 {
                    cell.lblQty.text = "\(arrProduct[indexPath.row].CartQty ?? 0)";

                } else {
                    cell.lblQty.text = "1"

                }


            }
        } else {
            if arrProduct[indexPath.row].CartQty ?? 0 > 0 {
                cell.lblQty.text = "\(arrProduct[indexPath.row].CartQty ?? 0)";

            } else {
                cell.lblQty.text = "1"

            }
        }
        
        
        
        cell.btnKg.tag = indexPath.row
        cell.btnKg.addTarget(self, action: #selector(self.btnKgClicked), for: .touchUpInside)
        
        cell.btnItems.tag = indexPath.row
        cell.btnItems.addTarget(self, action: #selector(self.btnitemClicked), for: .touchUpInside)
        
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(self.btnAddclicked), for: .touchUpInside)
        DispatchQueue.main.async {
            
            cell.imgView.kf.indicatorType = .activity
            cell.imgView.kf.setImage(
                with: URL(string: self.arrProduct[indexPath.row].ProductImage!),
                placeholder: UIImage(named: "placeholder"),
                options: [.transition(.fade(0.2))],
                progressBlock: { receivedSize, totalSize in
                    // print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
            },
                completionHandler: { result in
                    // print(result)
                    //print("\(indexPath.row + 1): Finished")
            }
            )
        }
        
        cell.btnAdd.isUserInteractionEnabled = true
        cell.btnAdd.alpha = 1.0
        cell.viewAdd.isHidden = false

        cell.btnplus.isEnabled = true
        cell.btnplus.alpha = 1.0
        cell.lbloutofstock.isHidden = false

        if arrProduct[indexPath.row].ProductType! == 1 {
            cell.lbloutofstock.isHidden = false

            cell.lbloutofstock.textColor = UIColor.black
            
            let priceper = "\(symboll)\(arrProduct[indexPath.row].PricePerQty!)/each"
            cell.lbloutofstock.text = priceper

        }

        if arrProduct[indexPath.row].ProductType! > 0 {
            cell.lbloutofstock.isHidden = true
        }
        //cell.btnAdd.setImage(UIImage(named: "img5"), for: .normal)
        if arrProduct[indexPath.row].AvailableQty ?? 0 == 0 {
            cell.lbloutofstock.isHidden = false

            if arrProduct[indexPath.row].outOfStockMessage == "" {
                cell.lbloutofstock.text = "Out Of Stock"
            } else {
                cell.lbloutofstock.text = arrProduct[indexPath.row].outOfStockMessage
            }
            cell.lbloutofstock.textColor = Theme_Color
            //cell.btnAdd.setImage(UIImage(named: "img1"), for: .normal)

            cell.btnAdd.isUserInteractionEnabled = false
            cell.btnAdd.alpha = 0.7
            cell.viewAdd.isHidden = true
            
            cell.btnplus.isEnabled = false
            cell.btnplus.alpha = 0.7
        } else {
            
            if arrProduct[indexPath.row].IsLowQty! == true {
                cell.lbloutofstock.textColor = UIColor.orange

            } else {
                cell.lbloutofstock.textColor = Theme_green_Color

            }

            cell.lbloutofstock.text = "In Stock : \(arrProduct[indexPath.row].AvailableQty ?? 0)"
            if arrProduct[indexPath.row].ProductType! == 1 {
                cell.lbloutofstock.isHidden = false

                cell.lbloutofstock.textColor = UIColor.black
                
                let priceper = "\(symboll)\(arrProduct[indexPath.row].PricePerQty!)/each"
                cell.lbloutofstock.text = priceper

            }
        }
        
        cell.lblDisplayweight.isHidden = true
        
        cell.lblDisplayweight.text = ""
        if arrProduct[indexPath.row].ProductType! == 1 {
//            if arrProduct[indexPath.row].CartQty ?? 0 > 0 {
//                cell.lblDisplayweight.isHidden = false
//
//            }
//
//            if arrProduct[indexPath.row].CartWeight ?? 0.0 > 0 {
//                cell.lblDisplayweight.isHidden = false
//
//            }

                   if arrProduct[indexPath.row].isKg! == false {

                    
                    let calculate = Double(arrProduct[indexPath.row].CartQty ?? 0) * (arrProduct[indexPath.row].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                    cell.lblDisplayweight.isHidden = false

                    cell.lblDisplayweight.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrProduct[indexPath.row].ProductSizeType ?? "")"
                    }
                    if arrProduct[indexPath.row].CartQty ?? 0 > 0 {
                    if calculate <  arrProduct[indexPath.row].MinOrderQtyOrWeigth ?? 0.0 {
                        cell.lblDisplayweight.isHidden = false

                        cell.lblDisplayweight.text = "\(cell.lblDisplayweight.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProduct[indexPath.row].MinOrderQtyOrWeigth ?? 0.0)) \(arrProduct[indexPath.row].ProductSizeType ?? "")"

                    }
                    }

                   } else {
                    let calculate = (arrProduct[indexPath.row].CartWeight ?? 0) * (arrProduct[indexPath.row].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                        if arrProduct[indexPath.row].CartWeight ?? 0.0 > 0 {

                    if calculate < arrProduct[indexPath.row].MinOrderQtyOrWeigth ?? 0.0 {
                        cell.lblDisplayweight.isHidden = false

                        cell.lblDisplayweight.text = "\(cell.lblDisplayweight.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProduct[indexPath.row].MinOrderQtyOrWeigth ?? 0.0)) \(arrProduct[indexPath.row].ProductSizeType ?? "")"

                    }
                        }
                    }
                    
            }
            
        }
        
        if arrProduct[indexPath.row].ProductType! == 0 {
            
            if arrProduct[indexPath.row].CartQty ?? 0 > 0 {
                cell.lblDisplayweight.isHidden = false

            }
            
            if arrProduct[indexPath.row].CartWeight ?? 0.0 > 0 {
                cell.lblDisplayweight.isHidden = false

            }
            
            if arrProduct[indexPath.row].CartQty ?? 0 > 0 {
            if arrProduct[indexPath.row].CartQty ?? 0 <  Int(arrProduct[indexPath.row].MinOrderQtyOrWeigth ?? 0.0) {

                cell.lblDisplayweight.text = "\(cell.lblDisplayweight.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProduct[indexPath.row].MinOrderQtyOrWeigth ?? 0.0)) \(arrProduct[indexPath.row].ProductSizeType ?? "")"

            }
            }
            
        }
        
        
        cell.btnplus.tag = indexPath.row
        cell.btnplus.addTarget(self, action: #selector(self.btnPlusclicked), for: .touchUpInside)
        
        cell.btnminus.tag = indexPath.row
        cell.btnminus.addTarget(self, action: #selector(self.btnMinusclicked), for: .touchUpInside)
        
        
        cell.btnAddwishList.tag = indexPath.row
        cell.btnAddwishList.addTarget(self, action: #selector(self.btnAddWishClicked), for: .touchUpInside)
        
        
        return cell
    }
    @objc private func btnKgClicked(sender:UIButton)
    {
        var isPopup = false
        if arrProduct[sender.tag].ProductType ?? 0 == 1 {
            if arrProduct[sender.tag].CartWeight ?? 0.0 > 0 {
                isPopup = true
             }
        
        } else {
            if arrProduct[sender.tag].CartQty ?? 0 > 0 {
               isPopup = true
            }
        }
        
        if isPopup == true {
        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
         let alertError = EMAlertController(icon: nil, title: appName, message: "If you change product option it will remove items your from cart, are you sure your cart will be removes?")
         alertError.addAction(EMAlertAction(title: "Yes", style: .normal, action: {
             self.intSender = sender.tag
             self.intType = 2
            self.arrProduct[sender.tag].isKg = true
              //self.collectionV.reloadData()
             self.addToCart(index: sender.tag, type: 2, isManual: false, cartWeight: self.arrProduct[sender.tag].CartWeight ?? 0.0, cartQty: self.arrProduct[sender.tag].CartQty ?? 0)
             
         }))
         
         alertError.addAction(EMAlertAction(title: "No", style: .normal, action: {
             
            
         }))
        
         rootViewController.present(alertError, animated: true, completion: nil)
        }else {
            self.arrProduct[sender.tag].isKg = true
                         self.collectionV.reloadData()
                       
        }
        
        

    }
    @objc private func btnitemClicked(sender:UIButton)
    {
        var isPopup = false
        if arrProduct[sender.tag].ProductType ?? 0 == 1 {
            if arrProduct[sender.tag].CartWeight ?? 0.0 > 0 {
                isPopup = true
             }
        
        } else {
            if arrProduct[sender.tag].CartQty ?? 0 > 0 {
               isPopup = true
            }
        }
        
        if isPopup == true {
        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
         let alertError = EMAlertController(icon: nil, title: appName, message: "If you change product option it will remove items your from cart, are you sure your cart will be removes?")
         alertError.addAction(EMAlertAction(title: "Yes", style: .normal, action: {
            
            self.arrProduct[sender.tag].isKg = false
            //self.collectionV.reloadData()
            
             self.intSender = sender.tag
             self.intType = 2
              
             self.addToCart(index: sender.tag, type: 2, isManual: false, cartWeight: self.arrProduct[sender.tag].CartWeight ?? 0.0, cartQty: self.arrProduct[sender.tag].CartQty ?? 0)
             
         }))
         
         alertError.addAction(EMAlertAction(title: "No", style: .normal, action: {
             
             
            
         }))
        
         rootViewController.present(alertError, animated: true, completion: nil)
        } else {
            self.arrProduct[sender.tag].isKg = false
                       self.collectionV.reloadData()
                       
        }
        
        

    }
    @objc private func btnAddWishClicked(sender:UIButton)
    {
        if CommonFunctions.userLoginData() == true {
            
            let indexPath = IndexPath(row: sender.tag, section: 0)
            
             let isWish = arrProduct[sender.tag].IsFavourite!
                if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                    let user = UserModel(json: userdict)
                    if Reachability.isConnectedToNetwork() {
                        var param  = [String : Any]()
                        param["UserId"] = user.UserId
                        param["ShopId"] = shopId
                        param["ProductId"] = arrProduct[sender.tag].ProductId
                        param["OperationType"] = isWish ? 2 : 1
                        APIManager.requestPostJsonEncoding(.addremovewishlist, isLoading: false, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                            
                            let Dict = JSONResponse as! [String:Any]
                            print(Dict)
                            if let cell = self.collectionV.cellForItem(at: indexPath) as? ProductCell
                            {
                                if isWish == true {
                                    
                                    cell.btnAddwishList.setImage(UIImage(named: "Assetheartunfill"), for: .normal)

                                    self.arrProduct[sender.tag].IsFavourite = false
                                } else {
                                    
                                    cell.btnAddwishList.setImage(UIImage(named: "Assetheart"), for: .normal)

                                    self.arrProduct[sender.tag].IsFavourite = true
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
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
                       let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                       self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc private func btnPlusclicked(sender:UIButton)
    {
        self.view.endEditing(true)

        intSenderTag = sender.tag
        intSenderType = 1
        if CommonFunctions.userLoginData() == true {
            
            if(arrProduct[sender.tag].PerItemCartLimit ?? 0 == 0) {
                if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                    intSender = sender.tag
                    intType = 1
                    addToCart(index: sender.tag, type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                }
                else {
                    CommonFunctions.showMessage(message: Message.noQuantityavailable)
                }
            } else {
                if arrProduct[sender.tag].CartQty ?? 0 < arrProduct[sender.tag].PerItemCartLimit ?? 0 {
                    if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                        intSender = sender.tag
                        intType = 1
                        
                        addToCart(index: sender.tag, type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                    }
                    else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)
                    }
                } else {
                    CommonFunctions.showMessage(message: Message.nocartlimit)
                    
                }
            }
        } else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func btnMinusclicked(sender:UIButton)
    {
        self.view.endEditing(true)

        intSenderTag = sender.tag
        intSenderType = 2
        if CommonFunctions.userLoginData() == true {
            
            if arrProduct[sender.tag].ProductType ?? 0  == 1 {
                if arrProduct[sender.tag].CartWeight ?? 0 > 0 {
                    intSender = sender.tag
                    intType = 2
                    
                    addToCart(index: sender.tag, type: 2, isManual: false, cartWeight: 0.0, cartQty: 0)
                }
            } else {
            
            if arrProduct[sender.tag].CartQty ?? 0 > 0 {
                intSender = sender.tag
                intType = 2
                
                addToCart(index: sender.tag, type: 2, isManual: false, cartWeight: 0.0, cartQty: 0)
            }
            }
        } else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func btnAddclicked(sender:UIButton)
    {
        
        self.view.endEditing(true)
        
        intSenderTag = sender.tag
        intSenderType = 1
        if CommonFunctions.userLoginData() == true {
            
            if(arrProduct[sender.tag].PerItemCartLimit ?? 0 == 0) {
                
                if arrProduct[sender.tag].ProductType ?? 0 == 1 {
                    if arrProduct[sender.tag].isKg == true {
                     if arrProduct[sender.tag].CartWeight ?? 0.0 < arrProduct[sender.tag].AvailableQty ?? 0.0 {
                        imgBackUpdateQty.isHidden = true
                        viewUpdateQty.isHidden = true
                        intSender = sender.tag
                            intType = 1
                            
                            addToCart(index: sender.tag, type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                        
                     } else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)

                    }
                    } else {
                        if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                                               imgBackUpdateQty.isHidden = true
                                               viewUpdateQty.isHidden = true
                                               intSender = sender.tag
                                                   intType = 1
                                                   
                                                   addToCart(index: sender.tag, type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                                               
                                            } else {
                                               CommonFunctions.showMessage(message: Message.noQuantityavailable)

                                           }
                    }
                } else {
                if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                    imgBackUpdateQty.isHidden = true
                    viewUpdateQty.isHidden = true
                    intSender = sender.tag
                    intType = 1
                    
                    addToCart(index: sender.tag, type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                }
                else {
                    CommonFunctions.showMessage(message: Message.noQuantityavailable)
                }
                }
            } else {
                if arrProduct[sender.tag].ProductType ?? 0 == 1 {
                if arrProduct[sender.tag].CartWeight ?? 0 < Double(arrProduct[sender.tag].PerItemCartLimit ?? 0) {
                    if arrProduct[sender.tag].CartWeight ?? 0 < arrProduct[sender.tag].AvailableQty ?? 0.0 {
                        intSender = sender.tag
                        intType = 1
                        
                        addToCart(index: sender.tag, type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                    }
                    else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)
                    }
                    
                } else {
                    CommonFunctions.showMessage(message: Message.nocartlimit)
                    
                }
                } else {
                if arrProduct[sender.tag].CartQty ?? 0 < arrProduct[sender.tag].PerItemCartLimit ?? 0 {
                    if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                        intSender = sender.tag
                        intType = 1
                        
                        addToCart(index: sender.tag, type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                    }
                    else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)
                    }
                    
                } else {
                    CommonFunctions.showMessage(message: Message.nocartlimit)
                    
                }
                }
            }
        } else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        
        let vc = storyBaord.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        vc.productId = arrProduct[indexPath.row].ProductId!
        vc.shopId = shopId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UITableview Delegate & Datasource

extension ProductViewController :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblBrand {
            return arrBrand.count
        }
        if tableView == tblProductSearch {
            return arrProductSearch.count
        }
        return arrSort.count
    }
}
extension ProductViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblBrand {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell") as! BrandCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.lblName.text = arrBrand[indexPath.row].BrandName!
            
            if(arrBrand[indexPath.row].isSelect! == false) {
                cell.imgCheck.image = UIImage(named: "uncheck")
            } else {
                cell.imgCheck.image = UIImage(named: "check")
                
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
            if arrProductSearch[indexPath.row].IsPriceMarked == false {
                           cell.imgPricemark.isHidden = true
                       } else {
                                         cell.imgPricemark.isHidden = false

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
                cell.lblSize.text = "\(arrProductSearch[indexPath.row].ProductSize!.clean) \(arrProductSearch[indexPath.row].UnitName!)"
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
            
            
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BLClientCell") as! BLClientCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.lblName.text = arrSort[indexPath.row]
        
        cell.imgCheck.isHidden = true
        
        if(index == indexPath.row) {
            cell.imgCheck.isHidden = false
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblProductSearch {
            return 180
        }
        return 50
        
    }
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          if tableView == tblProductSearch {
          let customView = UIView(frame: CGRect(x: 0, y: 0, width: tblProductSearch.frame.size.width, height: 50))
          customView.backgroundColor = UIColor.lightGray
          let btnAllProduct = UIButton(frame: CGRect(x: 0, y: 0, width: tblProductSearch.frame.size.width, height: 50))
          btnAllProduct.setTitle("View All Products", for: .normal)
          btnAllProduct.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
          btnAllProduct.titleLabel?.textColor = UIColor.black

          btnAllProduct.addTarget(self, action: #selector(btnAllProductClicked), for: .touchUpInside)
          customView.addSubview(btnAllProduct)
          //tblProductSearch.tableFooterView = customView
          return customView
          }
          return nil
      }

      func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           if isSpecialOffer == false {
              if tableView == tblProductSearch {

              return 50
              }
              return 0

          }
          return 0
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblBrand {
            if(arrBrand[indexPath.row].isSelect! == false) {
                arrBrand[indexPath.row].isSelect! = true
            } else {
                arrBrand[indexPath.row].isSelect! = false
                
            }
            tblBrand.reloadData()
            
        } else if tableView == tblProductSearch {
            
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            
            let vc = storyBaord.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            vc.productId = arrProductSearch[indexPath.row].ProductId!
            vc.shopId = shopId
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            /* self.tblProductSearch.isHidden = true
             self.imgProductSearch.isHidden = true
             
             self.txtSearch.text = arrProductSearch[indexPath.row].ProductName!
             
             pscategoryId = arrProductSearch[indexPath.row].CategoryId!
             
             pssubcategoryID = arrProductSearch[indexPath.row].SubCategoryId!
             
             pageNo = 1
             arrProduct.removeAll()
             getAllProduct(isSearch: txtSearch.text!.count > 0 ? true : false)*/
        } else {
            index = indexPath.row
            tblSort.reloadData()
        }
    }
    
}
/*class Header: UICollectionViewCell  {
    
    override init(frame: CGRect)    {
        super.init(frame: frame)
        setupHeaderViews()
    }
    
    let dateLabel: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView()
        act.style =  UIActivityIndicatorView.Style.gray
        return act
    }()
    func setupHeaderViews()   {
        addSubview(dateLabel)
        
        
        dateLabel.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: 40)

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}*/
extension ProductViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.txtUpdateQty.tag = textField.tag

        var isChange = false
        if arrProduct[textField.tag - 100].CartQty ?? 0 > 0 {
            isChange = true
            imgBackUpdateQty.isHidden = false
            viewUpdateQty.isHidden = false
        }
        
        if arrProduct[textField.tag - 100].CartWeight ?? 0.0 > 0 {
            isChange = true

            imgBackUpdateQty.isHidden = false
            viewUpdateQty.isHidden = false
        }
        
        if isChange == true {
            DispatchQueue.main.async {
                if textField != self.txtUpdateQty {
        textField.resignFirstResponder()
                }
            }
        self.txtUpdateQty.text = textField.text

        btnCancelQty.tag = textField.tag - 100
        btnUpdateQty.tag = textField.tag - 100
        
        lblUpdateQtyTitle.text = "Update Quantity"
            
            self.txtUpdateQty.keyboardType = UIKeyboardType.numberPad

        if arrProduct[textField.tag - 100].ProductType ?? 0 > 0 {
            
            if arrProduct[textField.tag - 100].ProductType ?? 0 == 1 {
                
                if arrProduct[textField.tag - 100].isKg == true {
                    self.txtUpdateQty.keyboardType = UIKeyboardType.decimalPad

                    lblUpdateQtyTitle.text = "Update Weight"
                }
            }
        }
        
        self.lblUpdateQtyMessage.isHidden = true
        
            self.lblUpdateQtyMessage.text = ""

        if arrProduct[textField.tag - 100].ProductType! == 1 {

                   if arrProduct[textField.tag - 100].isKg! == false {

                    
                    let calculate = Double(arrProduct[textField.tag - 100].CartQty ?? 0) * (arrProduct[textField.tag - 100].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                    self.lblUpdateQtyMessage.isHidden = false

                    self.lblUpdateQtyMessage.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrProduct[textField.tag - 100].ProductSizeType ?? "")"
                    }
                    if arrProduct[textField.tag - 100].CartQty ?? 0 > 0 {
                    if calculate <  arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0) \(arrProduct[textField.tag - 100].ProductSizeType ?? "")"

                    }
                    }

                   } else {
                    let calculate = (arrProduct[textField.tag - 100].CartWeight ?? 0) * (arrProduct[textField.tag - 100].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                        if arrProduct[textField.tag - 100].CartWeight ?? 0.0 > 0 {

                    if calculate < arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0))\(arrProduct[textField.tag - 100].ProductSizeType ?? "")"

                    }
                        }
                    }
                    
            }
            
        }
        
        if arrProduct[textField.tag - 100].ProductType! == 0 {
            
           
            
            if arrProduct[textField.tag - 100].CartQty ?? 0 > 0 {
            if arrProduct[textField.tag - 100].CartQty ?? 0 <  Int(arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0) {
                self.lblUpdateQtyMessage.isHidden = false

               self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0)) \(arrProduct[textField.tag - 100].ProductSizeType ?? "")"

            }
            }
            
        }
            }

        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        
        

        arrProduct[textField.tag - 100].isQtyEdit = true

        self.lblKg.isHidden = true
        
        
        
        if arrProduct[textField.tag - 100].ProductType ?? 0 == 1 {
                       
                       if arrProduct[textField.tag - 100].isKg == true {
                        self.lblKg.isHidden = false

                        if textField.text != "" {

                        arrProduct[textField.tag - 100].CartWeight  = Double(textField.text!)
                        }
                       } else {
                        if textField.text != "" {
                        arrProduct[textField.tag - 100].CartQty = Int(textField.text!)
                        }

            }
        } else {
            if textField.text != "" {
            arrProduct[textField.tag - 100].CartQty = Int(textField.text!)
            }
        }
        
        
       
        
        
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var updatedText = ""
        if let text = textField.text,
                   let textRange = Range(range, in: text) {
                   updatedText = text.replacingCharacters(in: textRange,
                                                               with: string)
                }
        if viewUpdateQty.isHidden == false {
            
        
        if arrProduct[textField.tag - 100].ProductType ?? 0 == 1 {
                       
                       if arrProduct[textField.tag - 100].isKg == true {
                        self.lblKg.isHidden = false

                        if updatedText != "" {

                        arrProduct[textField.tag - 100].CartWeight  = Double(updatedText)
                        }
                       } else {
                        if updatedText != "" {
                        arrProduct[textField.tag - 100].CartQty = Int(updatedText)
                        }

            }
        } else {
            if updatedText != "" {
            arrProduct[textField.tag - 100].CartQty = Int(updatedText)
            }
        }
            self.lblUpdateQtyMessage.text = ""

        if arrProduct[textField.tag - 100].ProductType! == 1 {

                   if arrProduct[textField.tag - 100].isKg! == false {

                    
                    let calculate = Double(arrProduct[textField.tag - 100].CartQty ?? 0) * (arrProduct[textField.tag - 100].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                    self.lblUpdateQtyMessage.isHidden = false

                    self.lblUpdateQtyMessage.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrProduct[textField.tag - 100].ProductSizeType ?? "")"
                    }
                    if arrProduct[textField.tag - 100].CartQty ?? 0 > 0 {
                    if calculate <  arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0)) \(arrProduct[textField.tag - 100].ProductSizeType ?? "")"

                    }
                    }

                   } else {
                    let calculate = (arrProduct[textField.tag - 100].CartWeight ?? 0) * (arrProduct[textField.tag - 100].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                        if arrProduct[textField.tag - 100].CartWeight ?? 0.0 > 0 {

                    if calculate < arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0)) \(arrProduct[textField.tag - 100].ProductSizeType ?? "")"


                    }
                        }
                    }
                    
            }
            
        }
        if arrProduct[textField.tag - 100].ProductType! == 0 {
                   
                  
                   
                   if arrProduct[textField.tag - 100].CartQty ?? 0 > 0 {
                   if arrProduct[textField.tag - 100].CartQty ?? 0 <  Int(arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0) {
                       self.lblUpdateQtyMessage.isHidden = false

                      self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProduct[textField.tag - 100].MinOrderQtyOrWeigth ?? 0.0)) \(arrProduct[textField.tag - 100].ProductSizeType ?? "")"


                   }
                   }
                   
               }
        }
        else {
            
        }
        
        return true
    }
}
extension ProductViewController  {
    @IBAction func btnUpdateQtyClicked(_ sender: UIButton) {
        
        if self.txtUpdateQty.text == "" {
            return
        }
        arrProduct[sender.tag].isQtyEdit = true

        if arrProduct[sender.tag].ProductType ?? 0 == 1 {
                       
                       if arrProduct[sender.tag].isKg == true {
                        self.lblKg.isHidden = false

                        if txtUpdateQty.text != "" {

                        arrProduct[sender.tag].CartWeight  = Double(txtUpdateQty.text!)
                        }
                       } else {
                        if txtUpdateQty.text != "" {
                        arrProduct[sender.tag].CartQty = Int(txtUpdateQty.text!)
                        }

            }
        } else {
            if txtUpdateQty.text != "" {
            arrProduct[sender.tag].CartQty = Int(txtUpdateQty.text!)
            }
        }
        self.lblUpdateQtyMessage.text = ""
        if arrProduct[sender.tag].ProductType! == 1 {

                   if arrProduct[sender.tag].isKg! == false {

                    
                    let calculate = Double(arrProduct[sender.tag].CartQty ?? 0) * (arrProduct[sender.tag].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                    self.lblUpdateQtyMessage.isHidden = false

                    self.lblUpdateQtyMessage.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrProduct[sender.tag].ProductSizeType ?? "")"
                    }
                    if arrProduct[sender.tag].CartQty ?? 0 > 0 {
                    if calculate <  arrProduct[sender.tag].MinOrderQtyOrWeigth ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProduct[sender.tag].MinOrderQtyOrWeigth ?? 0.0)) \(arrProduct[sender.tag].ProductSizeType ?? "")"
                        return

                    }
                    }

                   } else {
                    let calculate = arrProduct[sender.tag].CartWeight ?? 0 * (arrProduct[sender.tag].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                        if arrProduct[sender.tag].CartWeight ?? 0.0 > 0 {

                    if calculate < arrProduct[sender.tag].MinOrderQtyOrWeigth ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProduct[sender.tag].MinOrderQtyOrWeigth ?? 0.0)) \(arrProduct[sender.tag].ProductSizeType ?? "")"
                        return


                    }
                        }
                    }
                    
            }
            
        }
        if arrProduct[sender.tag].ProductType! == 0 {
                   
                  
                   
                   if arrProduct[sender.tag].CartQty ?? 0 > 0 {
                   if arrProduct[sender.tag].CartQty ?? 0 <  Int(arrProduct[sender.tag].MinOrderQtyOrWeigth ?? 0.0) {
                       self.lblUpdateQtyMessage.isHidden = false

                      self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProduct[sender.tag].MinOrderQtyOrWeigth ?? 0.0)) \(arrProduct[sender.tag].ProductSizeType ?? "")"
                    return


                   }
                   }
                   
               }
        
        self.view.endEditing(true)

        
        intSenderTag = sender.tag
        intSenderType = 1
        if CommonFunctions.userLoginData() == true {
            
            if(arrProduct[sender.tag].PerItemCartLimit ?? 0 == 0) {
                
                if arrProduct[sender.tag].ProductType ?? 0 == 1 {
                    if arrProduct[sender.tag].isKg == true {
                     if arrProduct[sender.tag].CartWeight ?? 0.0 < arrProduct[sender.tag].AvailableQty ?? 0.0 {
                        imgBackUpdateQty.isHidden = true
                        viewUpdateQty.isHidden = true
                        intSender = sender.tag
                            intType = 1
                            
                            addToCart(index: sender.tag, type: 1, isManual: true, cartWeight: 0.0, cartQty: 0)
                        
                     } else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)

                    }
                    } else {
                        if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                                               imgBackUpdateQty.isHidden = true
                                               viewUpdateQty.isHidden = true
                                               intSender = sender.tag
                                                   intType = 1
                                                   
                                                   addToCart(index: sender.tag, type: 1, isManual: true, cartWeight: 0.0, cartQty: 0)
                                               
                                            } else {
                                               CommonFunctions.showMessage(message: Message.noQuantityavailable)

                                           }
                    }
                } else {
                if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                    imgBackUpdateQty.isHidden = true
                    viewUpdateQty.isHidden = true
                    intSender = sender.tag
                    intType = 1
                    
                    addToCart(index: sender.tag, type: 1, isManual: true, cartWeight: 0.0, cartQty: 0)
                }
                else {
                    CommonFunctions.showMessage(message: Message.noQuantityavailable)
                }
                }
            } else {
                if arrProduct[sender.tag].ProductType ?? 0 == 1 {
                if arrProduct[sender.tag].CartWeight ?? 0 < Double(arrProduct[sender.tag].PerItemCartLimit ?? 0) {
                    if arrProduct[sender.tag].CartWeight ?? 0 < arrProduct[sender.tag].AvailableQty ?? 0.0 {
                        imgBackUpdateQty.isHidden = true
                        viewUpdateQty.isHidden = true
                        intSender = sender.tag
                        intType = 1
                        
                        addToCart(index: sender.tag, type: 1, isManual: true, cartWeight: 0.0, cartQty: 0)
                    }
                    else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)
                    }
                    
                } else {
                    CommonFunctions.showMessage(message: Message.nocartlimit)
                    
                }
                } else {
                if arrProduct[sender.tag].CartQty ?? 0 < arrProduct[sender.tag].PerItemCartLimit ?? 0 {
                    if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                        imgBackUpdateQty.isHidden = true
                        viewUpdateQty.isHidden = true
                        intSender = sender.tag
                        intType = 1
                        
                        addToCart(index: sender.tag, type: 1, isManual: true, cartWeight: 0.0, cartQty: 0)
                    }
                    else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)
                    }
                    
                } else {
                    CommonFunctions.showMessage(message: Message.nocartlimit)
                    
                }
                }
            }
        } else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func btnCloseQtyClicked(_ sender: UIButton) {
        imgBackUpdateQty.isHidden = true
              viewUpdateQty.isHidden = true
    }
}
