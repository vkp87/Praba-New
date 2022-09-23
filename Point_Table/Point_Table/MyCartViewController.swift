//
//  addcartViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 18/11/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import EMAlertController
import LocalAuthentication

class MyCartViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblNorecord: UILabel!
    @IBOutlet weak var lblNorecord1: UILabel!
    @IBOutlet weak var imgNoRecord: UIImageView!
    
    var arrBanner = [ShopeModel]()
    
    var shopId = 0
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblSaving: UILabel!
    
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnShope: UIButton!
    @IBOutlet weak var imgAuth: UIImageView!

    var arrCart = [CartModel]()
    var symboll = ""
    var isbackhide = false
       @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var imgBackUpdateQty: UIImageView!
    @IBOutlet weak var viewUpdateQty: UIView!

    @IBOutlet weak var lblUpdateQtyTitle: UILabel!
    @IBOutlet weak var txtUpdateQty: UITextField!
    @IBOutlet weak var lblUpdateQtyMessage: UILabel!
    @IBOutlet weak var btnUpdateQty: UIButton!
    @IBOutlet weak var btnCancelQty: UIButton!
    @IBOutlet weak var lblKg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUpdateQty.textAlignment = .center
        imgBackUpdateQty.isHidden = true
        viewUpdateQty.isHidden = true
        if isbackhide == true {
                   btnBack.isHidden = true
               } else {
                   btnBack.isHidden = false
               }
        
       // if(shopId == 0) {
            if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                
                
                for i in 0..<objApplication.arrMainBanner.count {
                    if objApplication.arrMainBanner[i].BusinessId! == sid {
                        shopId = objApplication.arrMainBanner[i].BusinessId!
                        
                        objApplication.applatitude = objApplication.arrMainBanner[i].Latitude!
                        objApplication.applongitude = objApplication.arrMainBanner[i].Longitude!
                        
                        objApplication.isAvailableStockDisplay = objApplication.arrMainBanner[i].IsAvailableStockDisplay!
                        
                        objApplication.brandName = objApplication.arrMainBanner[i].BusinessName!
                        objApplication.isCodEnableForCollection = objApplication.arrMainBanner[i].IsCodEnableForCollection!
                        objApplication.isCodEnable = objApplication.arrMainBanner[i].IsCodEnable!

                        objApplication.isSupportZipCodeLogic = objApplication.arrMainBanner[i].IsSupportZipCodeLogic!

                        objApplication.isSupportDistanceLogic = objApplication.arrMainBanner[i].IsSupportDistanceLogic!

                        
                        objApplication.isStoreCollectionEnable = objApplication.arrMainBanner[i].IsStoreCollectionEnable!
                        
                    }
                }
            }
       // }

        collectionV.register(UINib(nibName: "CartCell", bundle: nil), forCellWithReuseIdentifier: "CartCell")
        collectionV.isPagingEnabled = false
        collectionV.backgroundColor = UIColor.clear
        self.SetupUI()
        
       

        
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

        if CommonFunctions.userLoginData() == true {
            
                   getAllItem()
            
        } else {
//            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//            vc.cType = ControllerType.Cart
//            vc.shopId = shopId
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        var isSwitch = false
        if let isFinger = CommonFunctions.getUserDefault(key: UserDefaultsKey.FINGER) as? Bool {
            isSwitch = isFinger
        }
        imgAuth.isHidden = true
        if CommonFunctions.userLoginData() == true {
                   
                   
               } else {
                   
                   let storyBaord = UIStoryboard(name: "Main", bundle: nil)
                   let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                  // vc.cType = ControllerType.Cart
                   vc.shopId = shopId
                   vc.isBack = true
                   self.navigationController?.pushViewController(vc, animated: true)
               }
    }
    
   
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        txtUpdateQty.layer.cornerRadius = 11
        txtUpdateQty.layer.borderWidth = 1.5
        txtUpdateQty.layer.borderColor = UIColor.black.cgColor
        
        self.txtUpdateQty.delegate  = self

        lblUpdateQtyTitle.font = UIFont(name: Font_Semibold, size: 18)
        lblUpdateQtyMessage.font = UIFont(name: Font_Regular, size: 16)
        lblKg.font = UIFont(name: Font_Regular, size: 16)

        btnUpdateQty.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnUpdateQty, radius: 17)
        
        btnCancelQty.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnCancelQty, radius: 17)
        CommonFunctions.setCornerRadius(view: viewUpdateQty, radius: 17)

        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        lblNorecord.font = UIFont(name: Font_Semibold, size: 18)
        lblNorecord1.font = UIFont(name: Font_Regular, size: 15)
        lblHeader.text = lblHeader.text?.firstCharacterUpperCase()

        lblTotal.font = UIFont(name: Font_Semibold, size: 17)
        lblSaving.font = UIFont(name: Font_Semibold, size: 17)
        
        CommonFunctions.setCornerRadius(view: btnCheckOut, radius: 21)
        CommonFunctions.setCornerRadius(view: btnShope, radius: 21)
        
        
        
        btnShope.titleLabel?.font = UIFont(name: Font_Semibold, size: 15)
        
        
        btnCheckOut.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        
        lblNorecord.isHidden = true
        
        lblNorecord1.isHidden = true
        
        btnShope.isHidden = true
        imgNoRecord.isHidden = true
        
       if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
           symboll = symbol
       }
    }
    
    // MARK: - IBAction Event
    
    
    @IBAction func btnHomeClicked(_ sender: Any) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: CategoryViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
    }
    
    @IBAction func btnWishlistClicked(_ sender: Any) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
        vc.shopId = shopId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnShopeClicked(_ sender: Any) {
        
        self.arrBanner.removeAll()
        if Reachability.isConnectedToNetwork() {
            
            APIManager.requestPostJsonEncoding(.getallshops, isLoading: true,params: [:], headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                
                
                if let data = Dict["data"] as? [[String:Any]] {
                    
                    for objAd in data {
                        let obj = ShopeModel(json: objAd)
                        self.arrBanner.append(obj)
                    }
                }
                
                var intind = -1
                for i in 0..<self.arrBanner.count {
                    
                    if self.shopId == self.arrBanner[i].BusinessId {
                        intind = i
                    }
                }
                
                
                let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyBaord.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                vc.arrShope.append(self.arrBanner[intind])
                
                objApplication.applatitude = self.arrBanner[intind].Latitude!
                objApplication.applongitude = self.arrBanner[intind].Longitude!
                
                objApplication.isAvailableStockDisplay = self.arrBanner[intind].IsAvailableStockDisplay!
                
                
                objApplication.isStoreCollectionEnable = self.arrBanner[intind].IsStoreCollectionEnable!
                
                objApplication.isCodEnableForCollection = self.arrBanner[intind].IsCodEnableForCollection!

                objApplication.isCodEnable = self.arrBanner[intind].IsCodEnable!

                objApplication.brandName = self.arrBanner[intind].BusinessName!

                
                objApplication.isSupportDistanceLogic = self.arrBanner[intind].IsSupportDistanceLogic!

                          
                          objApplication.isStoreCollectionEnable = self.arrBanner[intind].IsStoreCollectionEnable!
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                
                
                // self.showPopover(base: sender, arr: arrBanner)
                
                
                
            }) { (error) -> Void in
                // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
        
        
        
        
    }
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCheckOutClicked(_ sender: Any) {
        
        var isAvai = true

        if self.arrCart.count > 0 {
            for i in 0..<arrCart.count {
                if arrCart[i].AvailableQty ?? 0 == 0 {
                    isAvai = false
                }
            }
        }
        
        if isAvai == false {
            
            CommonFunctions.showMessage(message: "Please remove out of stock item in this cart!")
            return
        }
        
        var isAvaiqty = true

        
        if self.arrCart.count > 0 {
            for i in 0..<arrCart.count {
                if arrCart[i].AvailableQty ?? 0.0 < Double(arrCart[i].CartQty ?? 0) {
                    isAvaiqty = false
                }
            }
        }
        
        if isAvaiqty == false {
            
            CommonFunctions.showMessage(message: "Some item(s) is out of stock or Some item(s) available quantities is smaller than cart quantities")
            return
        }
        
        
        if self.arrCart.count > 0 {
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "OrderSummaryViewController") as! OrderSummaryViewController
            vc.shopId = shopId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Get all product
    
    func getAllItem() -> Void {
        
        self.arrCart.removeAll()
        self.collectionV.reloadData()
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["ShopId"] = shopId
                param["UserId"] = user.UserId
                APIManager.requestPostJsonEncoding(.getcartdetail, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [[String:Any]] {
                        for objAd in data {
                            let obj = CartModel(json: objAd)
                            self.arrCart.append(obj)
                        }
                        self.calculateAmount()
                    }
                    
                    NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)

                    
                    if self.arrCart.count == 0 {
                        self.lblNorecord.isHidden = false
                        self.lblNorecord1.isHidden = false
                        
                        self.btnShope.isHidden = false
                        self.imgNoRecord.isHidden = false
                        
                        self.viewBottom.isHidden = true
                    } else {
                        self.lblNorecord.isHidden = true
                        
                        self.lblNorecord1.isHidden = true
                        self.imgNoRecord.isHidden = true
                        
                        self.btnShope.isHidden = true
                        
                        self.viewBottom.isHidden = false
                    }
                    
                    self.collectionV.reloadData()
                    
                }) { (error) -> Void in
                    //  CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
        
    }
    
    func addToCart(index : Int, type : Int, isManual : Bool, cartWeight : Double, cartQty : Int ) -> Void {
        NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)
        let productid = arrCart[index].ProductId ?? 0
        let qty = 1
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
//                var param  = [String : Any]()
//                param["ShopId"] = shopId
//                param["UserId"] = user.UserId
//
//                param["ProductId"] = productid
//                param["Qty"] = qty
//                param["Type"] = type
                var param  = [String : Any]()
                param["ShopId"] = shopId
                param["UserId"] = user.UserId
                param["ProductId"] = productid
                param["Age"] = 0
                param["ProductId"] = productid
                if arrCart[index].isQtyEdit == true {
                    param["Qty"] = arrCart[index].CartQty!

                } else {
                    param["Qty"] = cartQty == 0 ? qty : cartQty

                }
                param["Type"] = type
                param["ProductType"] = self.arrCart[index].ProductType ?? 0
                
                if self.arrCart[index].ProductType ?? 0 == 0 {
                    param["Weight"] = 0
                } else {
                    if self.arrCart[index].ProductType ?? 0 == 1 || self.arrCart[index].ProductType ?? 0 == 2{
                        if arrCart[index].isKg! == true {
                            param["Qty"] = cartQty == 0 ? 0 : cartQty
                            if arrCart[index].isQtyEdit == true {
                                param["Weight"] =  self.arrCart[index].CartWeight!
                            } else {
                               param["Weight"] = cartWeight == 0.0 ?  self.arrCart[index].WeightIncrement : cartWeight
                            }
                            

                        } else {
                            if arrCart[index].isQtyEdit == true {
                                                           param["Weight"] =  self.arrCart[index].CartWeight!
                                                       } else {
                                                          param["Weight"] = cartWeight == 0.0 ?  self.arrCart[index].WeightIncrement : cartWeight
                                                       }

                        }
                    } else {
                        if arrCart[index].isQtyEdit == true {
                                                       param["Weight"] =  self.arrCart[index].CartWeight!
                                                   } else {
                                                      param["Weight"] = cartWeight == 0.0 ?  self.arrCart[index].WeightIncrement : cartWeight
                                                   }

                    }
                }
                 
                if isManual == true {
                    param["IsFullValueChange"] = arrCart[index].isQtyEdit == true ? 1 : 0
                } else {
                    param["IsFullValueChange"] = 0

                }
                APIManager.requestPostJsonEncoding(.addorremovetocart, isLoading: false, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [String:Any] {
                        //if let cartCount = data["CartCount"] as? Int {
                        // self.lblCount.text = "\(cartCount)"
                        //}
                        
                        NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)
                        if let productQty = data["ProductQty"] as? Int {
                            self.arrCart[index].CartQty = cartQty == 0 ? productQty : 0
                        }
                        if let productQty = data["ProductWeight"] as? Double {
                            self.arrCart[index].CartWeight = cartWeight == 0.0 ? productQty : 0.0
                        }
                        if let qtyNotAvl = data["IsQtyNotAvailable"] as? Bool {
                            if qtyNotAvl == true {
                                self.arrCart[index].AvailableQty = Double(self.arrCart[index].CartQty!)
                            }
                        }
                        self.calculateAmount()
                    }
                    
                    if self.arrCart.count == 0 {
                        self.lblNorecord.isHidden = false
                        self.lblNorecord1.isHidden = false
                        self.imgNoRecord.isHidden = false
                        
                        self.btnShope.isHidden = false
                        
                        self.viewBottom.isHidden = true
                    } else {
                        self.lblNorecord.isHidden = true
                        
                        self.lblNorecord1.isHidden = true
                        self.imgNoRecord.isHidden = true
                        
                        
                        self.btnShope.isHidden = true
                        self.viewBottom.isHidden = false
                    }
                    
                    self.collectionV.reloadData()
                    
                }) { (error) -> Void in
                    // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
    
    func calculateAmount() {
        var totalAmt = 0.0
        var savingAmt = 0.0
        for data in arrCart {
            let product = data
            if product.ProductType == 2 {
                totalAmt += Double(product.CartWeight!) * product.Price!

            }
            else if product.ProductType == 1 {
                totalAmt += Double(product.CartWeight!) * product.Price!

            }else {
                totalAmt += Double(product.CartQty!) * product.Price!
            }
            if product.OldPrice! > 0 {
                savingAmt += Double(product.CartQty!) * (Double(product.OldPrice!) - product.Price!)
            }
        }
        lblTotal.text = "" + "\(symboll) " + "\(CommonFunctions.appendString(data: totalAmt))"
        lblSaving.text = "Your Saving " + "\(symboll) " + "\(CommonFunctions.appendString(data: savingAmt))"
        if savingAmt == 0 {
            lblSaving.isHidden = true
        } else {
            lblSaving.isHidden = false
        }
        
    }
    
    //MARK: - UICollectionView Delegate & DataSource ----
    
    public func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.width - 20, height: 200)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func attributetext(lbl1: UILabel, main : String, sub : String) {
        let main_string = main + " " + sub
        
        let sub_string = sub
        
        let range = (main_string as NSString).range(of: sub_string)
        
        let mainrange = (main_string as NSString).range(of: main_string)
        
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttributes([NSAttributedString.Key.font: UIFont(name: Font_Semibold, size: 16) as Any], range: mainrange)
        
        attribute.addAttributes([NSAttributedString.Key.font: UIFont(name: Font_Regular, size: 14) as Any], range: range)
        
        lbl1.attributedText = attribute
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CartCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartCell", for: indexPath as IndexPath) as! CartCell
        
        let pname = arrCart[indexPath.row].ProductName!.replacingOccurrences(of: "\t", with: "")

        arrCart[indexPath.row].isQtyEdit = false

        if arrCart[indexPath.row].ProductSize == 0 {
            self.attributetext(lbl1: cell.lblTitle, main: pname, sub: "")
        } else {
            self.attributetext(lbl1: cell.lblTitle, main: pname, sub: "(\(arrCart[indexPath.row].ProductSize!.clean) \(arrCart[indexPath.row].ProductSizeType!))")
        }
        
        cell.lblqtAvail.isHidden = true

        cell.lblqtAvail.textColor = UIColor.red
        
        if arrCart[indexPath.row].ProductType! > 0 && arrCart[indexPath.row].CartQty! > 0 {
            arrCart[indexPath.row].isKg! = false
        }
        
        if arrCart[indexPath.row].ProductType! > 0 && arrCart[indexPath.row].CartQty! == 0 && arrCart[indexPath.row].CartWeight! > 0 {
            arrCart[indexPath.row].isKg! = true
               }
        
        cell.lblOrAmount.text = "\(symboll) \(CommonFunctions.appendString(data: arrCart[indexPath.row].Price!))"
        if arrCart[indexPath.row].ProductType! > 0 {
            //Show kg with price
            
            
            if arrCart[indexPath.row].ProductSizeType! == "" {
                let strPrice = "\(cell.lblOrAmount.text!)"
                cell.lblOrAmount.text = strPrice
            } else {
                
                let strPrice = "\(cell.lblOrAmount.text!)/ \(arrCart[indexPath.row].ProductSizeType!)"
                cell.lblOrAmount.text = strPrice
            }

            
        }
        cell.lblQty.tag = 100 + indexPath.row
        cell.lblQty.delegate = self
        
        if arrCart[indexPath.row].AvailableQty ?? 0.0 < Double(arrCart[indexPath.row].CartQty ?? 0) {
            cell.lblqtAvail.isHidden = false
            
            cell.lblqtAvail.text = "\(arrCart[indexPath.row].AvailableQty ?? 0) qty available"

        }

        if arrCart[indexPath.row].PromotionTitle! == "" {
            cell.lblPramotion.isHidden = true
            cell.imgPramotion.isHidden = true

        } else {
            cell.lblPramotion.isHidden = false
            cell.imgPramotion.isHidden = false

            cell.lblPramotion.text = " \(arrCart[indexPath.row].PromotionTitle!) "
        }
        
        cell.lblAmount.text = "\(symboll) \(CommonFunctions.appendString(data: arrCart[indexPath.row].Price!))"
        
        cell.lblOrAmount.isHidden = false
        if arrCart[indexPath.row].OldPrice! == 0.0 {
            cell.lblAmount.isHidden = true
            cell.lblOrAmount.textColor = UIColor.black

        }
        

        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(symboll) \(CommonFunctions.appendString(data: Double(arrCart[indexPath.row].OldPrice!)))")
        
        //let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$ \(arrCart[indexPath.row].OldPrice!)")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        cell.lblAmount.attributedText = attributeString
        
        DispatchQueue.main.async {
            cell.imgView.kf.indicatorType = .activity
            cell.imgView.kf.setImage(
                with: URL(string: self.arrCart[indexPath.row].ProductImage!),
                placeholder: UIImage(named: "placeholder"),
                options: [.transition(.fade(0.2))],
                progressBlock: { receivedSize, totalSize in
                    // print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
            },
                completionHandler: { result in
                    // print(result)
                    // print("\(indexPath.row + 1): Finished")
            }
            )
        }
        
        
        
       // cell.lblOutofstock.isHidden = true
        cell.btnplus.isEnabled = true
        cell.btnplus.alpha = 1.0
        if arrCart[indexPath.row].AvailableQty ?? 0 == 0 {
            cell.lblOutofstock.isHidden = false
            
            
            cell.btnplus.isEnabled = false
            cell.btnplus.alpha = 0.7
        }
        if arrCart[indexPath.row].ProductType! > 0 {
            cell.lblOutofstock.isHidden = true
        }
        if arrCart[indexPath.row].AvailableQty ?? 0 == 0 {
            cell.lblOutofstock.isHidden = false

            if arrCart[indexPath.row].outOfStockMessage == "" {
                cell.lblOutofstock.text = "Out Of Stock"
            } else {
                cell.lblOutofstock.text = arrCart[indexPath.row].outOfStockMessage
            }
            cell.lblOutofstock.textColor = Theme_Color
            //cell.btnAdd.setImage(UIImage(named: "img1"), for: .normal)

        
            
            cell.btnplus.isEnabled = false
            cell.btnplus.alpha = 0.7
        } else {
            
            

            cell.lblOutofstock.text = "In Stock : \(arrCart[indexPath.row].AvailableQty ?? 0)"
            
        }
        
//        if arrCart[indexPath.row].AvailableQty ?? 0 == 0 {
//            if arrCart[indexPath.row].outOfStockMessage == "" {
//                cell.lblOutofstock.text = "Out Of Stock"
//            } else {
//                cell.lblOutofstock.text = arrCart[indexPath.row].outOfStockMessage
//            }
//            cell.lblOutofstock.textColor = Theme_Color
//            cell.btnplus.isEnabled = false
//            cell.btnplus.alpha = 0.7
//        } else {
//
//
//                cell.lblOutofstock.textColor = Theme_green_Color
//
//
//            cell.lblOutofstock.text = "In Stock : \(arrCart[indexPath.row].AvailableQty ?? 0)"
//
//        }
        
        
        //cell.lblQty.text = "\(arrCart[indexPath.row].CartQty ?? 0)"
        cell.lblTitleQty.text = "Qty"

        if arrCart[indexPath.row].ProductType! == 1 || arrCart[indexPath.row].ProductType! == 2{

            if arrCart[indexPath.row].isKg! == true {
                
                cell.lblTitleQty.text = "Kg"
                
                if arrCart[indexPath.row].CartWeight ?? 0.0 > 0 {
                    
                    cell.lblQty.text = "\(CommonFunctions.appendStringWeighItem(data: arrCart[indexPath.row].CartWeight!))"

                } else {

                    
                    cell.lblQty.text = "\(CommonFunctions.appendStringWeighItem(data: arrCart[indexPath.row].WeightIncrement!))"
                }
            } else {
                if arrCart[indexPath.row].CartQty ?? 0 > 0 {
                    cell.lblQty.text = "\(arrCart[indexPath.row].CartQty ?? 0)";

                } else {
                    cell.lblQty.text = "1"

                }


            }
        } else {
            if arrCart[indexPath.row].CartQty ?? 0 > 0 {
                cell.lblQty.text = "\(arrCart[indexPath.row].CartQty ?? 0)";

            } else {
                cell.lblQty.text = "1"

            }
        }
        cell.lblOutofstock.isHidden = true
        
        cell.lblOutofstock.text = ""
        if arrCart[indexPath.row].ProductType! == 1 || arrCart[indexPath.row].ProductType! == 2{
//            if arrCart[indexPath.row].CartQty ?? 0 > 0 {
//                cell.lblDisplayweight.isHidden = false
//
//            }
//
//            if arrCart[indexPath.row].CartWeight ?? 0.0 > 0 {
//                cell.lblDisplayweight.isHidden = false
//
//            }

                   if arrCart[indexPath.row].isKg! == false {

                    
                    let calculate = Double(arrCart[indexPath.row].CartQty ?? 0) * (arrCart[indexPath.row].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                    cell.lblOutofstock.isHidden = false

                    cell.lblOutofstock.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrCart[indexPath.row].ProductSizeType ?? "")"
                    }
                    if arrCart[indexPath.row].CartQty ?? 0 > 0 {
                    if calculate <  arrCart[indexPath.row].MinOrderQty ?? 0.0 {
                        cell.lblOutofstock.isHidden = false

                        cell.lblOutofstock.text = "\(cell.lblOutofstock.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrCart[indexPath.row].MinOrderQty ?? 0.0)) \(arrCart[indexPath.row].ProductSizeType ?? "")"

                    }
                    }

                   } else {
                    let calculate = (arrCart[indexPath.row].CartWeight ?? 0) * (arrCart[indexPath.row].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                        if arrCart[indexPath.row].CartWeight ?? 0.0 > 0 {

                    if calculate < arrCart[indexPath.row].MinOrderQty ?? 0.0 {
                        cell.lblOutofstock.isHidden = false

                        cell.lblOutofstock.text = "\(cell.lblOutofstock.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrCart[indexPath.row].MinOrderQty ?? 0.0)) \(arrCart[indexPath.row].ProductSizeType ?? "")"

                    }
                        }
                    }
                    
            }
            
        }
        
        if arrCart[indexPath.row].ProductType! == 0 {
            
            if arrCart[indexPath.row].CartQty ?? 0 > 0 {
                cell.lblOutofstock.isHidden = false

            }
            
            if arrCart[indexPath.row].CartWeight ?? 0.0 > 0 {
                cell.lblOutofstock.isHidden = false

            }
            
            if arrCart[indexPath.row].CartQty ?? 0 > 0 {
            if arrCart[indexPath.row].CartQty ?? 0 <  Int(arrCart[indexPath.row].MinOrderQty ?? 0.0) {

                cell.lblOutofstock.text = "\(cell.lblOutofstock.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrCart[indexPath.row].MinOrderQty ?? 0.0)) \(arrCart[indexPath.row].ProductSizeType ?? "")"

            }
            }
            
        }
        cell.btnplus.tag = indexPath.row
        cell.btnplus.addTarget(self, action: #selector(self.btnPlusclicked), for: .touchUpInside)
        
        cell.btnminus.tag = indexPath.row
        cell.btnminus.addTarget(self, action: #selector(self.btnMinusclicked), for: .touchUpInside)
        
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(self.btnRemoveClicked), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func btnRemoveClicked(sender:UIButton) {
        
        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
        let alertError = EMAlertController(icon: nil, title: appName, message: "Are you sure to remove this item?")
        alertError.addAction(EMAlertAction(title: "Ok", style: .normal, action: {
            
            
            
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                
                param["OrderDetailId"] = self.arrCart[sender.tag].OrderDetailId ?? 0
                param["OrderId"] = self.arrCart[sender.tag].OrderID ?? 0
                
                
                APIManager.requestPostJsonEncoding(.deletecartitem, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    // CommonFunctions.showMessage(message: Message.removeitem)
                    
                    self.getAllItem()
                    
                    
                    
                    
                    
                    
                }) { (error) -> Void in
                    // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
            
            
        }))
        alertError.addAction(EMAlertAction(title: "Cancel", style: .normal, action: {
            
        }))
        rootViewController.present(alertError, animated: true, completion: nil)
        
        
    }
    
    @objc private func btnPlusclicked(sender:UIButton)
    {
        if(arrCart[sender.tag].PerItemCartLimit ?? 0 == 0) {
            if Double(arrCart[sender.tag].CartQty ?? 0) < arrCart[sender.tag].AvailableQty ?? 0.0 {
                addToCart(index: sender.tag, type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
            }
            else {
                // addToCart(index: sender.tag, type: 1) // VK
                CommonFunctions.showMessage(message: Message.noQuantityavailable)
            }
        } else {
            if arrCart[sender.tag].CartQty ?? 0 < arrCart[sender.tag].PerItemCartLimit ?? 0 {
                if Double(arrCart[sender.tag].CartQty ?? 0) < arrCart[sender.tag].AvailableQty ?? 0.0 {
                    addToCart(index: sender.tag, type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                }
                else {
                    // addToCart(index: sender.tag, type: 1) // VK
                    CommonFunctions.showMessage(message: Message.noQuantityavailable)
                }
            } else {
                CommonFunctions.showMessage(message: Message.nocartlimit)
                
            }
        }
    }
    
    @objc private func btnMinusclicked(sender:UIButton)
    {
        if arrCart[sender.tag].ProductType ?? 0  == 1 || arrCart[sender.tag].ProductType ?? 0  == 2{
            if arrCart[sender.tag].CartWeight ?? 0 > 0 {
                addToCart(index: sender.tag, type: 2, isManual: false, cartWeight: 0.0, cartQty: 0)
            }
        } else {
            if arrCart[sender.tag].CartQty ?? 0 > 0 {
                addToCart(index: sender.tag, type: 2, isManual: false, cartWeight: 0.0, cartQty: 0)
            }
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*let storyBaord = UIStoryboard(name: "Home", bundle: nil)
         
         
         let vc = storyBaord.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
         
         vc.productId = arrCart[indexPath.row].ProductId!
         vc.shopId = shopId
         
         
         self.navigationController?.pushViewController(vc, animated: true)*/
    }
    
}
extension MyCartViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.txtUpdateQty.tag = textField.tag

        var isChange = false
        if arrCart[textField.tag - 100].CartQty ?? 0 > 0 {
            isChange = true
            imgBackUpdateQty.isHidden = false
            viewUpdateQty.isHidden = false
        }
        
        if arrCart[textField.tag - 100].CartWeight ?? 0.0 > 0 {
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

        if arrCart[textField.tag - 100].ProductType ?? 0 > 0 {
            
            if arrCart[textField.tag - 100].ProductType ?? 0 == 1 || arrCart[textField.tag - 100].ProductType ?? 0 == 2{
                
                if arrCart[textField.tag - 100].isKg == true {
                    self.txtUpdateQty.keyboardType = UIKeyboardType.decimalPad

                    lblUpdateQtyTitle.text = "Update Weight"
                }
            }
        }
        
        self.lblUpdateQtyMessage.isHidden = true
        
            self.lblUpdateQtyMessage.text = ""

        if arrCart[textField.tag - 100].ProductType! == 1 || arrCart[textField.tag - 100].ProductType! == 2{

                   if arrCart[textField.tag - 100].isKg! == false {

                    
                    let calculate = Double(arrCart[textField.tag - 100].CartQty ?? 0) * (arrCart[textField.tag - 100].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                    self.lblUpdateQtyMessage.isHidden = false

                    self.lblUpdateQtyMessage.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrCart[textField.tag - 100].ProductSizeType ?? "")"
                    }
                    if arrCart[textField.tag - 100].CartQty ?? 0 > 0 {
                    if calculate <  arrCart[textField.tag - 100].MinOrderQty ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(arrCart[textField.tag - 100].MinOrderQty ?? 0.0) \(arrCart[textField.tag - 100].ProductSizeType ?? "")"

                    }
                    }

                   } else {
                    let calculate = (arrCart[textField.tag - 100].CartWeight ?? 0) * (arrCart[textField.tag - 100].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                        if arrCart[textField.tag - 100].CartWeight ?? 0.0 > 0 {

                    if calculate < arrCart[textField.tag - 100].MinOrderQty ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrCart[textField.tag - 100].MinOrderQty ?? 0.0))\(arrCart[textField.tag - 100].ProductSizeType ?? "")"

                    }
                        }
                    }
                    
            }
            
        }
        
        if arrCart[textField.tag - 100].ProductType! == 0 {
            
           
            
            if arrCart[textField.tag - 100].CartQty ?? 0 > 0 {
            if arrCart[textField.tag - 100].CartQty ?? 0 <  Int(arrCart[textField.tag - 100].MinOrderQty ?? 0.0) {
                self.lblUpdateQtyMessage.isHidden = false

               self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrCart[textField.tag - 100].MinOrderQty ?? 0.0)) \(arrCart[textField.tag - 100].ProductSizeType ?? "")"

            }
            }
            
        }
            }

        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        
        

        arrCart[textField.tag - 100].isQtyEdit = true

        self.lblKg.isHidden = true
        
        
        
        if arrCart[textField.tag - 100].ProductType ?? 0 == 1 || arrCart[textField.tag - 100].ProductType ?? 0 == 2{
                       
                       if arrCart[textField.tag - 100].isKg == true {
                        self.lblKg.isHidden = false

                        if textField.text != "" {

                        arrCart[textField.tag - 100].CartWeight  = Double(textField.text!)
                        }
                       } else {
                        if textField.text != "" {
                        arrCart[textField.tag - 100].CartQty = Int(textField.text!)
                        }

            }
        } else {
            if textField.text != "" {
            arrCart[textField.tag - 100].CartQty = Int(textField.text!)
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
            
        
        if arrCart[textField.tag - 100].ProductType ?? 0 == 1 || arrCart[textField.tag - 100].ProductType ?? 0 == 2{
                       
                       if arrCart[textField.tag - 100].isKg == true {
                        self.lblKg.isHidden = false

                        if updatedText != "" {

                        arrCart[textField.tag - 100].CartWeight  = Double(updatedText)
                        }
                       } else {
                        if updatedText != "" {
                        arrCart[textField.tag - 100].CartQty = Int(updatedText)
                        }

            }
        } else {
            if updatedText != "" {
            arrCart[textField.tag - 100].CartQty = Int(updatedText)
            }
        }
            self.lblUpdateQtyMessage.text = ""

        if arrCart[textField.tag - 100].ProductType! == 1 || arrCart[textField.tag - 100].ProductType! == 2{

                   if arrCart[textField.tag - 100].isKg! == false {

                    
                    let calculate = Double(arrCart[textField.tag - 100].CartQty ?? 0) * (arrCart[textField.tag - 100].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                    self.lblUpdateQtyMessage.isHidden = false

                    self.lblUpdateQtyMessage.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrCart[textField.tag - 100].ProductSizeType ?? "")"
                    }
                    if arrCart[textField.tag - 100].CartQty ?? 0 > 0 {
                    if calculate <  arrCart[textField.tag - 100].MinOrderQty ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrCart[textField.tag - 100].MinOrderQty ?? 0.0)) \(arrCart[textField.tag - 100].ProductSizeType ?? "")"

                    }
                    }

                   } else {
                    let calculate = (arrCart[textField.tag - 100].CartWeight ?? 0) * (arrCart[textField.tag - 100].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                        if arrCart[textField.tag - 100].CartWeight ?? 0.0 > 0 {

                    if calculate < arrCart[textField.tag - 100].MinOrderQty ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrCart[textField.tag - 100].MinOrderQty ?? 0.0)) \(arrCart[textField.tag - 100].ProductSizeType ?? "")"


                    }
                        }
                    }
                    
            }
            
        }
        if arrCart[textField.tag - 100].ProductType! == 0 {
                   
                  
                   
                   if arrCart[textField.tag - 100].CartQty ?? 0 > 0 {
                   if arrCart[textField.tag - 100].CartQty ?? 0 <  Int(arrCart[textField.tag - 100].MinOrderQty ?? 0.0) {
                       self.lblUpdateQtyMessage.isHidden = false

                      self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrCart[textField.tag - 100].MinOrderQty ?? 0.0)) \(arrCart[textField.tag - 100].ProductSizeType ?? "")"


                   }
                   }
                   
               }
        }
        else {
            
        }
        
        return true
    }
}
extension MyCartViewController  {
    @IBAction func btnUpdateQtyClicked(_ sender: UIButton) {
        
        if self.txtUpdateQty.text == "" {
            return
        }
        arrCart[sender.tag].isQtyEdit = true
        
        if arrCart[sender.tag].ProductType ?? 0 == 1 || arrCart[sender.tag].ProductType ?? 0 == 2{
                       
                       if arrCart[sender.tag].isKg == true {
                        self.lblKg.isHidden = false

                        if txtUpdateQty.text != "" {

                        arrCart[sender.tag].CartWeight  = Double(txtUpdateQty.text!)
                        }
                       } else {
                        if txtUpdateQty.text != "" {
                        arrCart[sender.tag].CartQty = Int(txtUpdateQty.text!)
                        }

            }
        } else {
            if txtUpdateQty.text != "" {
            arrCart[sender.tag].CartQty = Int(txtUpdateQty.text!)
            }
        }
        self.lblUpdateQtyMessage.text = ""
        if arrCart[sender.tag].ProductType! == 1 || arrCart[sender.tag].ProductType! == 2{

                   if arrCart[sender.tag].isKg! == false {

                    
                    let calculate = Double(arrCart[sender.tag].CartQty ?? 0) * (arrCart[sender.tag].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                    self.lblUpdateQtyMessage.isHidden = false

                    self.lblUpdateQtyMessage.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrCart[sender.tag].ProductSizeType ?? "")"
                    }
                    if arrCart[sender.tag].CartQty ?? 0 > 0 {
                    if calculate <  arrCart[sender.tag].MinOrderQty ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrCart[sender.tag].MinOrderQty ?? 0.0)) \(arrCart[sender.tag].ProductSizeType ?? "")"
                        return

                    }
                    }

                   } else {
                    let calculate = arrCart[sender.tag].CartWeight ?? 0 * (arrCart[sender.tag].ProductSizePerQty ?? 0.0)
                    print(calculate)
                    if calculate > 0 {

                        if arrCart[sender.tag].CartWeight ?? 0.0 > 0 {

                    if calculate < arrCart[sender.tag].MinOrderQty ?? 0.0 {
                        self.lblUpdateQtyMessage.isHidden = false

                        self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrCart[sender.tag].MinOrderQty ?? 0.0)) \(arrCart[sender.tag].ProductSizeType ?? "")"
                        return


                    }
                        }
                    }
                    
            }
            
        }
        if arrCart[sender.tag].ProductType! == 0 {
                   
                  
                   
                   if arrCart[sender.tag].CartQty ?? 0 > 0 {
                   if arrCart[sender.tag].CartQty ?? 0 <  Int(arrCart[sender.tag].MinOrderQty ?? 0.0) {
                       self.lblUpdateQtyMessage.isHidden = false

                      self.lblUpdateQtyMessage.text = "\(self.lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrCart[sender.tag].MinOrderQty ?? 0.0)) \(arrCart[sender.tag].ProductSizeType ?? "")"
                    return


                   }
                   }
                   
               }
        
        self.view.endEditing(true)

        
     
        if CommonFunctions.userLoginData() == true {
            
            if(arrCart[sender.tag].PerItemCartLimit ?? 0 == 0) {
                
                if arrCart[sender.tag].ProductType ?? 0 == 1 || arrCart[sender.tag].ProductType ?? 0 == 2{
                    if arrCart[sender.tag].isKg == true {
                     if arrCart[sender.tag].CartWeight ?? 0.0 < arrCart[sender.tag].AvailableQty ?? 0.0 {
                        imgBackUpdateQty.isHidden = true
                        viewUpdateQty.isHidden = true
                       
                            
                            addToCart(index: sender.tag, type: 1, isManual: true, cartWeight: 0.0, cartQty: 0)
                        
                     } else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)

                    }
                    } else {
                        if arrCart[sender.tag].CartQty ?? 0 < Int(arrCart[sender.tag].AvailableQty ?? 0.0) {
                                               imgBackUpdateQty.isHidden = true
                                               viewUpdateQty.isHidden = true
                                             
                                                   addToCart(index: sender.tag, type: 1, isManual: true, cartWeight: 0.0, cartQty: 0)
                                               
                                            } else {
                                               CommonFunctions.showMessage(message: Message.noQuantityavailable)

                                           }
                    }
                } else {
                if arrCart[sender.tag].CartQty ?? 0 < Int(arrCart[sender.tag].AvailableQty ?? 0.0) {
                    imgBackUpdateQty.isHidden = true
                    viewUpdateQty.isHidden = true
                  
                    
                    addToCart(index: sender.tag, type: 1, isManual: true, cartWeight: 0.0, cartQty: 0)
                }
                else {
                    CommonFunctions.showMessage(message: Message.noQuantityavailable)
                }
                }
            } else {
                if arrCart[sender.tag].ProductType ?? 0 == 1 || arrCart[sender.tag].ProductType ?? 0 == 2{
                if arrCart[sender.tag].CartWeight ?? 0 < Double(arrCart[sender.tag].PerItemCartLimit ?? 0) {
                    if arrCart[sender.tag].CartWeight ?? 0 < arrCart[sender.tag].AvailableQty ?? 0.0 {
                        imgBackUpdateQty.isHidden = true
                        viewUpdateQty.isHidden = true
                       
                        
                        addToCart(index: sender.tag, type: 1, isManual: true, cartWeight: 0.0, cartQty: 0)
                    }
                    else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)
                    }
                    
                } else {
                    CommonFunctions.showMessage(message: Message.nocartlimit)
                    
                }
                } else {
                if arrCart[sender.tag].CartQty ?? 0 < arrCart[sender.tag].PerItemCartLimit ?? 0 {
                    if arrCart[sender.tag].CartQty ?? 0 < Int(arrCart[sender.tag].AvailableQty ?? 0.0) {
                        imgBackUpdateQty.isHidden = true
                        viewUpdateQty.isHidden = true
                       
                        
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
