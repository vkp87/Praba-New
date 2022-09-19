//
//  addcartViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 18/11/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import EMAlertController
import LocalAuthentication

class WishlistViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblNorecord: UILabel!
    
    var arrProduct = [ProductModel]()
    var pageNo = 1
    var pageSize = 10
    var isPaging = true
    var shopId = 0
    @IBOutlet weak var collectionV: UICollectionView!
    var cartcount = 0;
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imgAuth: UIImageView!

    var datePicker:UIDatePicker = UIDatePicker()
    @IBOutlet weak var viewBirth: UIView!
    @IBOutlet weak var imgBirth: UIView!
    @IBOutlet weak var lblBirthTitle: UILabel!
    @IBOutlet weak var txtBirth: SkyFloatingLabelTextField!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    var intSender = -1
    var intType = -1
    var isbackhide = false
    @IBOutlet weak var imgBackUpdateQty: UIImageView!
       @IBOutlet weak var viewUpdateQty: UIView!

       @IBOutlet weak var lblUpdateQtyTitle: UILabel!
       @IBOutlet weak var txtUpdateQty: UITextField!
       @IBOutlet weak var lblUpdateQtyMessage: UILabel!
       @IBOutlet weak var btnUpdateQty: UIButton!
       @IBOutlet weak var btnCancelQty: UIButton!
       @IBOutlet weak var lblKg: UILabel!
       
       @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetupUI()
        txtUpdateQty.textAlignment = .center

        imgBackUpdateQty.isHidden = true
        viewUpdateQty.isHidden = true
        if isbackhide == true {
                          btnBack.isHidden = true
                      } else {
                          btnBack.isHidden = false
                      }
        if(shopId == 0) {
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
        }
        
        collectionV.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        collectionV.isPagingEnabled = false
        collectionV.backgroundColor = UIColor.clear
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.Reloadlist(notification:)), name: Notification.Name("RELOADLISTITEM"), object: nil)
        
       

        // Do any additional setup after loading the view.
    }
    
    @objc func Reloadlist(notification: Notification) {
        for i in 0..<self.arrProduct.count {
            self.arrProduct[i].Age = 0
            
        }
        self.collectionV.reloadData()
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
            
                   self.getCartCount()

        } else {
//            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
//                      let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                      vc.cType = ControllerType.WishList
//                      vc.shopId = shopId
//                      self.navigationController?.pushViewController(vc, animated: true)
            
            
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
                             //vc.cType = ControllerType.WishList
                             vc.shopId = shopId
                   vc.isBack = true

                             self.navigationController?.pushViewController(vc, animated: true)
                   
                   
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
                           // self.lblCount.isHidden = false
                            
                        }
                    }
                    
                    self.arrProduct.removeAll()
                    
                    self.getAllProduct()
                    
                }) { (error) -> Void in
                    CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
    
    func getAllProduct() -> Void {
        
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["ShopId"] = shopId
                param["PageNo"] = pageNo
                param["PageSize"] = pageSize
                param["UserId"] = user.UserId
                APIManager.requestPostJsonEncoding(.getallwishlistproduct, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
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
                        
                        if self.arrProduct.count == 0 {
                            self.lblNorecord.isHidden = false
                            
                        } else {
                            self.lblNorecord.isHidden = true
                            
                        }
                        
                    } else {
                        self.isPaging = false
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
        
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            pageNo = pageNo + 1
            if isPaging == true {
                getAllProduct()
            }
        }
    }
    
    //MARK:- Setup UI
    @objc func dateChange(_ sender:UIDatePicker) {
        txtBirth.text =  sender.date.getDateWithFormate("dd/MM/yyyy")
    }
    func SetupUI() -> Void {
        
        txtUpdateQty.delegate = self
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        lblNorecord.font = UIFont(name: Font_Semibold, size: 18)
        lblHeader.text = lblHeader.text?.firstCharacterUpperCase()
        lblUpdateQtyTitle.font = UIFont(name: Font_Semibold, size: 18)
               lblUpdateQtyMessage.font = UIFont(name: Font_Regular, size: 16)
               lblKg.font = UIFont(name: Font_Regular, size: 16)

        btnUpdateQty.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
               CommonFunctions.setCornerRadius(view: btnUpdateQty, radius: 17)
               
               btnCancelQty.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
               CommonFunctions.setCornerRadius(view: btnCancelQty, radius: 17)
               CommonFunctions.setCornerRadius(view: viewUpdateQty, radius: 17)
        lblNorecord.isHidden = true
        
        //lblCount.isHidden = true
        
        lblCount.font = UIFont(name: Font_Semibold, size: 14)
        
        CommonFunctions.setCornerRadius(view: lblCount, radius: 11)
        
        CommonFunctions.setBorder(view: lblCount, color: UIColor.white, width: 1)
        
        viewBirth.isHidden = true
        imgBirth.isHidden = true
        
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
        
    }
    
    // MARK: - IBAction Event
    
    @IBAction func btnYesClicked(_ sender: UIButton) {
        
        viewBirth.isHidden = true
        imgBirth.isHidden = true
        
//        if txtBirth.text == ""
//        {
//            CommonFunctions.showMessage(message: Message.enterage)
//            return
//        }
//
//
//        let intAge = CommonFunctions.calcAge(birthday: txtBirth.text!)
        let intMainAge = arrProduct[intSender].Age ?? 0
        
        txtBirth.text = ""
        
      //  if(intMainAge <= intAge) {
            
            
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
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShopClicked(_ sender: UIButton) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        vc.shopId = shopId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnHomeClicked(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: CategoryViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    //MARK: - UICollectionView Delegate & DataSource ----
    
    public func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.width - 20, height: 230)
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

//        intSenderTag = sender.tag
//        intSenderType = 1
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

//        intSenderTag = sender.tag
//        intSenderType = 2
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
        
//        intSenderTag = sender.tag
//        intSenderType = 1
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
        
        vc.isWishView = true
        
        vc.productId = arrProduct[indexPath.row].ProductId!
        vc.shopId = shopId
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension WishlistViewController : UITextFieldDelegate {
    
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
extension WishlistViewController  {
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

        
//        intSenderTag = sender.tag
//        intSenderType = 1
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
