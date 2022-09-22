//
//  OrderSummaryViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 05/01/20.
//  Copyright © 2020 Jatin Rathod. All rights reserved.
//

import UIKit
import MBProgressHUD
import EMAlertController

class OrderSummaryViewController: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var btnPramotion: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    
    var shopId = 0
    var addressDetail = [String: AnyObject]()
    var addressbillingDetail = [String: AnyObject]()
    
    var arrCartItem = [CartModel]()
    var subTotal = 0.0
    var total = 0.0
    var totalDiscount = 0.0
    var totalTax = 0.0
    var deliveryCharges = 0.0
    var deliveryDistance = 0
    var minimumCartAmount = 0.0
    var isRequireMinimumCartAmount = false
    var arrlstSlotManagement = [[String:Any]]()
    
    var arrProductPromotionList = [CartModel]()
    
    var symboll = ""
    var lat = 0.0
    var long = 0.0
    
    var distance = 0.0
    
    var slotSelect = false
    
    var intDeliveryType = 0
    
    var timeSlotindex = 0
    
    var strPromoCode = ""
    
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lbl1: UILabel!
    
    @IBOutlet weak var btnCod: UIButton!
    @IBOutlet weak var imgCod: UIImageView!
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var lblmin: UILabel!
    
    @IBOutlet weak var viewStore: UIView!
    
    @IBOutlet weak var constheight: NSLayoutConstraint!
    @IBOutlet weak var constlableheight: NSLayoutConstraint!
    
    var sId = -1
    
    var isDeliveryslot = false
    
    var isPromoApply = false
    
    var isDeliverDisp = false
    
    @IBOutlet weak var viewPromo: UIView!
    @IBOutlet weak var imgPromo: UIImageView!
    @IBOutlet weak var txtPromo: UITextField!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    @IBOutlet weak var lblinvalidCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
        tblView.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier:"AddressCell")
        tblView.register(UINib(nibName: "OrderAmountCell", bundle: nil), forCellReuseIdentifier:"OrderAmountCell")
        tblView.register(UINib(nibName: "TimeViewCell", bundle: nil), forCellReuseIdentifier:"TimeViewCell")
        
        tblView.register(UINib(nibName: "OrderNote", bundle: nil), forCellReuseIdentifier:"OrderNote")
        
        tblView.register(UINib(nibName: "OrderPromoCode", bundle: nil), forCellReuseIdentifier:"OrderPromoCode")
        
        tblView.register(UINib(nibName: "OrderPromoCodeApply", bundle: nil), forCellReuseIdentifier:"OrderPromoCodeApply")
        
        tblView.register(UINib(nibName: "AddressStore", bundle: nil), forCellReuseIdentifier:"AddressStore")
        
        tblView.register(UINib(nibName: "OrderItemCell", bundle: nil), forCellReuseIdentifier:"OrderItemCell")
        isDeliveryslot = true
        intDeliveryType = 0
        self.isDeliverDisp = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrCartItem.removeAll()
        arrProductPromotionList.removeAll()
        getOrderSummary()
    }
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        self.lblinvalidCode.text = ""
        imgPromo.isHidden = true
        viewPromo.isHidden = true
        
        
        
        
        CommonFunctions.setCornerRadius(view: viewPromo, radius: 5)
        
        CommonFunctions.setCornerRadius(view: txtPromo, radius: 5)
        
        CommonFunctions.setBorder(view: txtPromo, color: UIColor.gray, width: 1.0)
        
        txtPromo.font = UIFont(name: Font_Regular, size: 17)
        btnOk.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        btnCancel.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        
        
        constheight.constant = 0
        constlableheight.constant = 0
        
        //viewStore.isHidden = true
        btnCod.isHidden = true
        
        intDeliveryType = 0
        if objApplication.isStoreCollectionEnable == true {
            btnCod.isHidden = false
            constheight.constant = 100
            //viewStore.isHidden = false
            constlableheight.constant = 50
        }
        
        lblinvalidCode.font = UIFont(name: Font_Regular, size: 14)
        
        // btnCard.setImage(UIImage(named: "radio_deselect"), for: .normal)
        lbl1.textColor = .white
        imgCard.backgroundColor = UIColor.darkGray
        
        CommonFunctions.setBorder(view: imgCod, color: UIColor.darkGray, width: 1.5)
        CommonFunctions.setBorder(view: imgCard, color: UIColor.darkGray, width: 1.5)
        
        
        CommonFunctions.setCornerRadius(view: imgCod, radius: 21)
        CommonFunctions.setCornerRadius(view: imgCard, radius: 21)
        
        //  btnCod.setImage(UIImage(named: "radio_deselect"), for: .normal)
        lbl2.textColor = UIColor.darkGray
        imgCod.backgroundColor = UIColor.white
        
        
        lbl1.font = UIFont(name: Font_Regular, size: 18)
        lbl2.font = UIFont(name: Font_Regular, size: 18)
        
        lblmin.font = UIFont(name: Font_Regular, size: 15)
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        CommonFunctions.setCornerRadius(view: btnProceed, radius: 21)
        btnProceed.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        
        CommonFunctions.setCornerRadius(view: btnPramotion, radius: 21)
        btnPramotion.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        
        if let symbol = CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
            symboll = symbol
        }
    }
    func deg2rad(deg:Double) -> Double {
        return deg * .pi / 180
    }
    
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / .pi
    }
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        dist = dist * 1.609344
        
        return dist
    }
    
    func getlatlong() -> Void {
        
        if addressDetail.keys.count == 0 {
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            
            MBProgressHUD.showAdded(to:(objApplication.window?.rootViewController?.view)!, animated: true)
            
            var strAddress = "\(addressDetail["PostCode"] as! String)+\(addressDetail["StreetAddress1"] as! String)+\(addressDetail["StreetAddress2"] as? String ?? "")+\(addressDetail["Town"] as! String)"
            
            strAddress = strAddress.replacingOccurrences(of: " ", with: "+")
            strAddress = strAddress.replacingOccurrences(of: ",", with: "")
            strAddress = strAddress.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
            var request = URLRequest(url: URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(strAddress)&key=\(Google_Key)")!)
            //AIzaSyAPo68ktCCbXrry2Cw8vD812zSv6rB_cj0
            request.httpMethod = "GET"
            //request.httpBody = try? JSONSerialization.data(withJSONObject: [], options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                print(response!)
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    
                    if let result = json["results"] as? [[String : Any]] {
                        
                        if result.count > 0 {
                            
                            if let geometry = result[0]["geometry"] as? [String : Any] {
                                if let location = geometry["location"] as? [String : Any] {
                                    
                                    if let lat = location["lat"] as? Double {
                                        //  dictSendRequest["Latitude"] = lat
                                        self.lat = lat
                                    }
                                    
                                    if let lng = location["lng"] as? Double {
                                        //dictSendRequest["Longitude"] = lng
                                        self.long = lng
                                    }
                                    
                                    self.distance = self.distance(lat1: objApplication.applatitude, lon1: objApplication.applongitude, lat2: self.lat, lon2: self.long)
                                }
                            }
                            if self.deliveryDistance > Int(self.distance) {
                                DispatchQueue.main.sync {
                                    self.goToNextScreen()
                                }
                            } else {
                                DispatchQueue.main.sync {
                                    CommonFunctions.showMessage(message: Message.distancenot)
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.sync {
                                
                                CommonFunctions.showMessage(message: Message.notGettingDistance)
                            }
                        }
                    }
                    
                    
                } catch {
                    print("error")
                }
            })
            task.resume()
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
        
    }
    
    func goToNextScreen() {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        vc.shopId = self.shopId
        vc.UserAddressId = intDeliveryType == 0 ?  self.addressDetail["UserAddressId"] as! Int : 0
        vc.OrderId = self.arrCartItem[0].OrderID ?? 0
        vc.TotalAmount = self.total
        vc.slotId = self.sId
        vc.strPromocode = strPromoCode
        
        if intDeliveryType == 1 {
            vc.isDelivery = true
        } else {
            vc.isDelivery = false
        }
        
        
        
        vc.totamnt = symboll + "\((CommonFunctions.appendString(data: subTotal)))"
        vc.discont = symboll + "\((CommonFunctions.appendString(data: totalDiscount)))"
        vc.deliverych = symboll + "\((CommonFunctions.appendString(data: deliveryCharges)))"
        vc.payblamnt = symboll + "\((CommonFunctions.appendString(data: total)))"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getOrderSummary() {
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["ShopId"] = shopId
                param["UserId"] = user.UserId
                param["DeliveryType"] = intDeliveryType
                
                APIManager.requestPostJsonEncoding(.getOrderSummary, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [String:Any] {
                        if let add = data["AddressDetail"] as? [String: AnyObject] {
                            self.addressDetail = add
                        }
                        
                        if let add = data["BillingAddressDetail"] as? [String: AnyObject] {
                            self.addressbillingDetail = add
                        }
                        
                        if let val = data["MinimumCartAmount"] as? Double {
                            self.lblmin.text = "Minimum order value of  \(self.symboll)\(CommonFunctions.appendString(data: val)) is required for delivery. Please add more items. Thank you."
                        }
                        
                        let cartItem = data["OrderResponse"] as! [[String: AnyObject]]
                        for objAd in cartItem {
                            let obj = CartModel(json: objAd)
                            self.arrCartItem.append(obj)
                        }
                        
                        if let arr = data["ProductPromotionList"] as? [[String: AnyObject]] {
                            for obj in arr {
                                for objAd in cartItem {
                                    if objAd["ProductId"] as! Int == obj["ProductId"] as! Int {
                                        
                                        let obj = CartModel(json: objAd)
                                        obj.ExcludeMinimumCartValueMessage = objAd["ExcludeMinimumCartValueMessage"] as? String
                                        
                                        self.arrProductPromotionList.append(obj)
                                    }
                                }
                            }
                        }
                        
                        
                        
                        self.subTotal = data["SubTotal"] as! Double
                                               self.totalDiscount = data["TotalDiscount"] as! Double
                                               self.totalTax = data["TotalTax"] as! Double
                                               self.deliveryCharges = data["DeliveryCharges"] as! Double
                                               if self.arrCartItem.count > 0 {
                                                   self.deliveryDistance = self.arrCartItem[0].DeliveryDistance!
                                               }
                                               self.minimumCartAmount = data["MinimumCartAmount"] as! Double
                                               self.isRequireMinimumCartAmount = data["IsRequireMinimumCartAmount"] as! Bool
                                               
                                               if self.isRequireMinimumCartAmount == false {
                                                   self.lblmin.text = ""
                                                   self.constheight.constant = 50
                                                   self.constlableheight.constant = 0
                                               } else {
                                                   self.constheight.constant = 100
                                                   self.constlableheight.constant = 50
                                               }
                                              // if self.isDeliveryslot == true {
                                                   
                                                   if self.isRequireMinimumCartAmount == true {
                                                       if self.intDeliveryType == 0 {
                                                           
                                                           
                                                           for objAd in cartItem {
                                                               
                                                                   if objAd["IsExcludeMinimumCartValue"] as! Bool == true {
                                                                       let obj = CartModel(json: objAd)
                                                                       obj.ExcludeMinimumCartValueMessage = objAd["ExcludeMinimumCartValueMessage"] as? String
                                                                      
                                                                       let resultArray = self.arrProductPromotionList.filter {
                                                                           $0.ProductId == objAd["ProductId"] as! Int
                                                                       }
                                                                       
                                                                       if resultArray.count == 0 {
                                                                       self.arrProductPromotionList.append(obj)
                                                                       }
                                                                   }
                                                           }
                                                           
                                                           
                                                           
                                                       }
                                                   }
                                               //}
                                               self.total = data["Total"] as! Double
                        
                        if let arr = data["lstSlotManagementResponse"] as? [[String: AnyObject]] {
                            self.arrlstSlotManagement = arr
                            
                            var arrTimeSlot1 = [[String:Any]]()

                            
                            if(self.arrlstSlotManagement.count > 0) {
                                
                                
                                arrTimeSlot1 = self.arrlstSlotManagement[0]["lstSlotDetail"] as! [[String:Any]]
                                
                                for obj in arrTimeSlot1 {
                                    if obj["IsAvailalbe"] as! Bool == true {
                                        self.slotSelect = true;
                                        print(obj)
                                        self.sId = arrTimeSlot1[0]["SlotId"] as! Int
                                        self.tblView.reloadData()
                                        return
                                    }
                                }
                            }
                            
                            
                        }
                        
                       
                    }
                    self.tblView.reloadData()
                    
                }) { (error) -> Void in
                   // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
        
    }
    
    
    // MARK: - IBAction Event
    @IBAction func btnOkClicked(_ sender: UIButton) {
        
        txtPromo.resignFirstResponder()
        viewPromo.isHidden = true
        imgPromo.isHidden = true
        
        if txtPromo.text == ""
        {
            CommonFunctions.showMessage(message: "Please enter promo code.")
            return
        }
        
        strPromoCode = txtPromo.text!
        
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["ShopId"] = shopId
                param["UserId"] = user.UserId
                param["DeliveryType"] = intDeliveryType
                param["Promocode"] = strPromoCode
                
                APIManager.requestPostJsonEncoding(.applypromocode, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    self.txtPromo.text = ""
                    self.isPromoApply = true
                    
                    if let data = Dict["data"] as? [String:Any] {
                        
                        self.subTotal = data["SubTotal"] as! Double
                        self.totalDiscount = data["TotalDiscount"] as! Double
                        self.deliveryCharges = data["DeliveryCharges"] as! Double
                        self.minimumCartAmount = data["MinimumCartAmount"] as! Double
                        self.isRequireMinimumCartAmount = data["IsRequireMinimumCartAmount"] as! Bool
                        
                        if self.isRequireMinimumCartAmount == false {
                            self.lblmin.text = ""
                            self.constheight.constant = 50
                            self.constlableheight.constant = 0
                        } else {
                            self.lblmin.text = "Minimum order value of  \(self.symboll)\(CommonFunctions.appendString(data: self.minimumCartAmount)) is required for delivery. Please add more items. Thank you."
                            self.constheight.constant = 100
                            self.constlableheight.constant = 50
                        }
                        self.total = data["Total"] as! Double
                        
                        self.arrProductPromotionList.removeAll()
                        
                        if let arr = data["ProductPromotionList"] as? [[String: AnyObject]] {
                            for obj in arr {
                                for objAd in self.arrCartItem {
                                    if objAd.ProductId! == obj["ProductId"] as! Int {
                                        
                                        self.arrProductPromotionList.append(objAd)
                                    }
                                }
                            }
                        }
                       // if self.isDeliveryslot == true {
                            
                            if self.isRequireMinimumCartAmount == true {
                                if self.intDeliveryType == 0 {
                                    
                                    for objAd in self.arrCartItem {
                                        
                                        if objAd.IsExcludeMinimumCartValue == true {
                                               
                                                let resultArray = self.arrProductPromotionList.filter {
                                                    $0.ProductId == objAd.ProductId
                                                }
                                                
                                                if resultArray.count == 0 {
                                                self.arrProductPromotionList.append(objAd)
                                                }
                                            }
                                    }
                                    
                                    
                                    
                                    
                                }
                            //}
                        }
                        
                    }
                    self.tblView.reloadData()
                    
                }) { (error) -> Void in
                    //CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
        
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        txtPromo.resignFirstResponder()
        
        txtPromo.text = ""
        viewPromo.isHidden = true
        imgPromo.isHidden = true
        
    }
    
    @objc func btnClearPromo(_ sender: Any) {
        
        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
        let alertError = EMAlertController(icon: nil, title: appName, message: "Are you sure your promotion code will be removed?")
        alertError.addAction(EMAlertAction(title: "Yes", style: .normal, action: {
            
            self.txtPromo.text = ""
            
            self.strPromoCode = ""
            self.isPromoApply = false
            
            self.arrCartItem.removeAll()
            self.arrProductPromotionList.removeAll()
            self.addressDetail.removeAll()
            self.getOrderSummary()
            
        }))
        alertError.addAction(EMAlertAction(title: "No", style: .normal, action: {
            
        }))
        rootViewController.present(alertError, animated: true, completion: nil)
        
    }
    
    @objc func btnPromclicked(_ sender: Any) {
        
        self.txtPromo.text = ""
        strPromoCode = ""
        if isDeliveryslot == false {
            CommonFunctions.showMessage(message: "Please select order type");
            return
        }
        
        if self.isRequireMinimumCartAmount == true {
            CommonFunctions.showMessage(message: "Minimum order value of " + symboll + "\(CommonFunctions.appendString(data: self.minimumCartAmount)) " + "is required for delivery. Please add more items. Thank you.");
            return
        }
        
        viewPromo.isHidden = false
        imgPromo.isHidden = false
    }
    
    @IBAction func btnCodeClicked(_ sender: Any) {
        
        if self.isPromoApply == true {
            let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
            let alertError = EMAlertController(icon: nil, title: appName, message: "Are you sure your promotion code will be removed?")
            alertError.addAction(EMAlertAction(title: "Yes", style: .normal, action: {
                
                self.txtPromo.text = ""
                
                self.strPromoCode = ""
                self.isPromoApply = false
                
                self.intDeliveryType = 1
                self.isDeliveryslot = true
                self.isDeliverDisp = false
                
                // self.btnCod.setImage(UIImage(named: "radio_select"), for: .normal)
                self.lbl2.textColor = UIColor.white
                self.imgCod.backgroundColor = UIColor.darkGray
                
                
                //self.btnCard.setImage(UIImage(named: "radio_deselect"), for: .normal)
                self.lbl1.textColor = UIColor.darkGray
                self.imgCard.backgroundColor = UIColor.white
                
                self.arrCartItem.removeAll()
                self.arrProductPromotionList.removeAll()
                self.addressDetail.removeAll()
                self.getOrderSummary()
                
                
            }))
            alertError.addAction(EMAlertAction(title: "No", style: .normal, action: {
                
            }))
            rootViewController.present(alertError, animated: true, completion: nil)
        } else {
            
            intDeliveryType = 1
            isDeliveryslot = true
            self.isDeliverDisp = false
            
            // btnCod.setImage(UIImage(named: "radio_select"), for: .normal)
            self.lbl2.textColor = UIColor.white
            self.imgCod.backgroundColor = UIColor.darkGray
            
            // btnCard.setImage(UIImage(named: "radio_deselect"), for: .normal)
            self.lbl1.textColor = UIColor.darkGray
            self.imgCard.backgroundColor = UIColor.white
            
            arrCartItem.removeAll()
            self.arrProductPromotionList.removeAll()
            addressDetail.removeAll()
            getOrderSummary()
        }
        
    }
    
    @IBAction func btnCardClicked(_ sender: Any) {
        
        if self.isPromoApply == true {
            let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
            let alertError = EMAlertController(icon: nil, title: appName, message: "Are you sure your promotion code will be removed?")
            alertError.addAction(EMAlertAction(title: "Yes", style: .normal, action: {
                
                self.txtPromo.text = ""
                
                self.strPromoCode = ""
                self.isPromoApply = false
                
                self.isDeliveryslot = true
                
                self.intDeliveryType = 0
                self.isDeliverDisp = true
                
                //self.btnCard.setImage(UIImage(named: "radio_select"), for: .normal)
                self.lbl1.textColor = UIColor.white
                self.imgCard.backgroundColor = UIColor.darkGray
                
                // self.btnCod.setImage(UIImage(named: "radio_deselect"), for: .normal)
                self.lbl2.textColor = UIColor.darkGray
                self.imgCod.backgroundColor = UIColor.white
                
                self.arrCartItem.removeAll()
                self.arrProductPromotionList.removeAll()
                self.addressDetail.removeAll()
                self.getOrderSummary()
                
                
            }))
            alertError.addAction(EMAlertAction(title: "No", style: .normal, action: {
                
            }))
            rootViewController.present(alertError, animated: true, completion: nil)
        } else {
            isDeliveryslot = true
            
            intDeliveryType = 0
            self.isDeliverDisp = true
            
            //btnCard.setImage(UIImage(named: "radio_select"), for: .normal)
            self.lbl1.textColor = UIColor.white
            self.imgCard.backgroundColor = UIColor.darkGray
            
            //btnCod.setImage(UIImage(named: "radio_deselect"), for: .normal)
            self.lbl2.textColor = UIColor.darkGray
            self.imgCod.backgroundColor = UIColor.white
            
            arrCartItem.removeAll()
            arrProductPromotionList.removeAll()
            addressDetail.removeAll()
            getOrderSummary()
        }
        
    }
    
    @IBAction func btnProceedPayClicked(_ sender: Any) {
        
        if addressbillingDetail.keys.count == 0 {
            CommonFunctions.showMessage(message: "Please add your billing address")
            return
            
        }
        
        if isDeliveryslot == false {
            CommonFunctions.showMessage(message: "Please select order type")
            return
        }
        
        if slotSelect == false {
            if intDeliveryType == 1 {
                CommonFunctions.showMessage(message: "Please select collection slot")
            } else {
                CommonFunctions.showMessage(message: "Please select delivery slot")
            }
            
            return
        }
        if self.isRequireMinimumCartAmount == true {
            CommonFunctions.showMessage(message: "Minimum order value of " + symboll + "\(CommonFunctions.appendString(data: self.minimumCartAmount)) " + "is required for delivery. Please add more items. Thank you.");
            return
        }
        if intDeliveryType == 1 {
            self.goToNextScreen()
        } else {
            
            if objApplication.isSupportZipCodeLogic == true {
                //addressDetail["PostCode"] as! String)"
                if Reachability.isConnectedToNetwork() {
                    
                    var param  = [String : Any]()
                    param["ZipCode"] = "\(addressDetail["PostCode"] as! String)"
                    param["UserAddress"] = "\(addressDetail["StreetAddress1"] as! String), \(addressDetail["StreetAddress2"] as? String ?? ""), \(addressDetail["Town"] as! String), \(addressDetail["PostCode"] as! String)"


                    param["ShopId"] = shopId
                    
                    APIManager.requestPostJsonEncoding(.validatezipcode, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                        
                        let Dict = JSONResponse as! [String:Any]
                        print(Dict)
                        
                        if let data = Dict["data"] as? [String:Any] {
                            if let isValid = data["IsValid"] as? Bool {
                                if isValid == true {
                                    self.goToNextScreen()
                                } else {
                                    if let msgZipCodeMessage = data["ZipCodeMessage"] as? String {
                                        CommonFunctions.showMessage(message: msgZipCodeMessage)
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                        
                    }) { (error) -> Void in
                       // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                    }
                } else {
                    CommonFunctions.showMessage(message: Message.internetnotconnected)
                }
                
            } else {
                self.getlatlong()
                
            }
            
        }
    }
    
    @IBAction func btnPramotionClicked(_ sender: Any) {
        
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "OrderPramotionListViewController") as! OrderPramotionListViewController
        vc.isOrderPramotion = true
        vc.shopId = shopId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addAddressClicked1(_ sender: Any) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "AddBillingAddressViewController") as! AddBillingAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeAddressClicked1(_ sender: Any) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "AddBillingAddressViewController") as! AddBillingAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addAddressClicked(_ sender: Any) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "AddAdreessViewController") as! AddAdreessViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeAddressClicked(_ sender: Any) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "MyAddressListViewController") as! MyAddressListViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
}

extension OrderSummaryViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProductPromotionList.count > 0 ? arrProductPromotionList.count + 6 : 6
        //return 6
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if intDeliveryType == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddressStore", for: indexPath) as! AddressStore
                cell.lbl1.isHidden = false
                cell.viewBack.isHidden = false
                cell.lbl0.text = "Store Address"
                cell.lbl1.text = objApplication.brandName
                var strName = ""
                if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                    
                    
                    for i in 0..<objApplication.arrMainBanner.count {
                        if objApplication.arrMainBanner[i].BusinessId! == sid {
                            strName = objApplication.arrMainBanner[i].BusinessAddress!
                        }
                    }
                }
                cell.lbl2.text = strName
                
                
                return cell
            } else {
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
                
                if isDeliverDisp == false {
                    cell.viewBack.isHidden = true
                    
                } else {
                    if intDeliveryType == 1 {
                        cell.viewBack.isHidden = true
                    } else {
                        if isDeliveryslot == true {
                            cell.viewBack.isHidden = false
                        } else {
                            cell.viewBack.isHidden = true
                        }
                    }
                }
                cell.selectionStyle = .none
                cell.btnDefault.isHidden = true
                cell.btnEdit.isHidden = true
                cell.btnDelete.isHidden = true
                cell.btnChange.isHidden = false
                cell.lbl0.text = "Delivery Address"
                cell.lbl0.isHidden = false
                cell.constLeadingLbl0.constant = -20
                cell.constLeadingLbl1.constant = 10
                cell.constLeadingLbl2.constant = 10
                cell.constLeadingLbl4.constant = 10
                if isDeliverDisp == true {
                    
                    if addressDetail.keys.count == 0 {
                        cell.btnChange.setTitle("Add", for: .normal)
                        cell.lbl1.text = "You have not added any address"
                        cell.lbl2.isHidden = true
                        cell.lbl4.isHidden = true
                        cell.btnChange.removeTarget(self, action: #selector(self.changeAddressClicked), for: .touchUpInside)
                        
                        cell.btnChange.addTarget(self, action: #selector(self.addAddressClicked), for: .touchUpInside)
                    } else {
                        cell.lbl2.isHidden = false
                        cell.lbl4.isHidden = false
                        cell.btnChange.setTitle("Change", for: .normal)
                        cell.lbl1.text = "\(addressDetail["FirstName"] as! String) \(addressDetail["LastName"] as! String)"
                        cell.lbl2.text = "\(addressDetail["StreetAddress1"] as! String), \(addressDetail["StreetAddress2"] as? String ?? ""), \(addressDetail["Town"] as! String), \(addressDetail["PostCode"] as! String)"
                        cell.lbl4.text = "Phone : \(addressDetail["MobileNo"] as! String)"
                        cell.btnChange.removeTarget(self, action: #selector(self.addAddressClicked), for: .touchUpInside)
                        cell.btnChange.addTarget(self, action: #selector(self.changeAddressClicked), for: .touchUpInside)
                    }
                }
                return cell
            }
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
            
            cell.selectionStyle = .none
            cell.btnDefault.isHidden = true
            cell.btnEdit.isHidden = true
            cell.btnDelete.isHidden = true
            cell.btnChange.isHidden = false
            cell.lbl0.text = "Billing Address"
            cell.lbl0.isHidden = false
            cell.constLeadingLbl0.constant = -20
            cell.constLeadingLbl1.constant = 10
            cell.constLeadingLbl2.constant = 10
            cell.constLeadingLbl4.constant = 10
            cell.viewBack.isHidden = false
            
            if addressbillingDetail.keys.count == 0 {
                cell.btnChange.setTitle("Add", for: .normal)
                cell.lbl1.text = "You have not added any address"
                cell.lbl2.isHidden = true
                cell.lbl4.isHidden = true
                cell.btnChange.removeTarget(self, action: #selector(self.changeAddressClicked1), for: .touchUpInside)
                
                cell.btnChange.addTarget(self, action: #selector(self.addAddressClicked1), for: .touchUpInside)
            } else {
                cell.lbl2.isHidden = false
                cell.lbl4.isHidden = false
                cell.btnChange.setTitle("Change", for: .normal)
                cell.lbl1.text = "\(addressbillingDetail["FirstName"] as! String) \(addressbillingDetail["LastName"] as! String)"
                cell.lbl2.text = "\(addressbillingDetail["StreetAddress1"] as! String), \(addressbillingDetail["StreetAddress2"] as? String ?? ""), \(addressbillingDetail["Town"] as! String), \(addressbillingDetail["PostCode"] as! String)"
                cell.lbl4.text = "Phone : \(addressbillingDetail["MobileNo"] as! String)"
                cell.btnChange.removeTarget(self, action: #selector(self.addAddressClicked1), for: .touchUpInside)
                cell.btnChange.addTarget(self, action: #selector(self.changeAddressClicked1), for: .touchUpInside)
            }
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeViewCell", for: indexPath) as! TimeViewCell
            cell.selectionStyle = .none
            cell.arrSlot.removeAll()
            cell.SlotId  = sId;
            cell.arrSlot = arrlstSlotManagement
            cell.delegate = self
            cell.setupCollectionCell(deliveryType: intDeliveryType);
            return cell
        } else if indexPath.row == 3 {
            if isPromoApply {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPromoCodeApply", for: indexPath) as! OrderPromoCodeApply
                cell.selectionStyle = .none
                cell.btnClean.addTarget(self, action: #selector(self.btnClearPromo), for: .touchUpInside)
                cell.lblPromo.text = strPromoCode
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPromoCode", for: indexPath) as! OrderPromoCode
                cell.selectionStyle = .none
                cell.btnPromocode.tag = indexPath.row
                cell.btnPromocode.addTarget(self, action: #selector(self.btnPromclicked), for: .touchUpInside)
                return cell
            }
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderAmountCell", for: indexPath) as! OrderAmountCell
            cell.selectionStyle = .none
            
            if intDeliveryType == 1 {
                cell.lblDeliveryCharges.isHidden = true
                cell.lblTitleDelivery.isHidden = true
                
                cell.constTitle.constant = 0
                cell.constValue.constant = 0
                cell.constTitleTop.constant = 0
            } else {
                cell.lblDeliveryCharges.isHidden = false
                cell.lblTitleDelivery.isHidden = false
                cell.constTitle.constant = 20
                cell.constValue.constant = 20
                cell.constTitleTop.constant = 10
            }
            
            cell.lblSubTotal.text = symboll + "\((CommonFunctions.appendString(data: subTotal)))"
            cell.lblDiscount.text = symboll + "\((CommonFunctions.appendString(data: totalDiscount)))"
            cell.lblTax.text = symboll + "\( (CommonFunctions.appendString(data: totalTax)))"
            cell.lblDeliveryCharges.text = symboll + "\((CommonFunctions.appendString(data: deliveryCharges)))"
            cell.lblTotal.text = symboll + "\((CommonFunctions.appendString(data: total)))"
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderNote", for: indexPath) as! OrderNote
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderItemCell
            
            self.attributetext(lbl1: cell.lblTitle, main: arrProductPromotionList[indexPath.row - 6].ProductName!, sub: "")
            
            cell.lblmincartmsg.isHidden = false
            
            
            var symboll = ""
            if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
                symboll = symbol
            }
            
            cell.lblAmount.text = "\(symboll) \(arrProductPromotionList[indexPath.row - 6].Price!)"
            
            cell.imgView.kf.indicatorType = .activity
            cell.imgView.kf.setImage(
                with: URL(string: arrProductPromotionList[indexPath.row - 6].ProductImage!),
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
            
            if arrProductPromotionList[indexPath.row - 6].PromotionTitle! == "" {
                cell.lblPramotion.isHidden = true
                cell.imgPramotion.isHidden = true

            } else {
                cell.lblPramotion.isHidden = false
                cell.imgPramotion.isHidden = false

                cell.lblPramotion.text = " \(arrProductPromotionList[indexPath.row - 6].PromotionTitle!) "
            }
            
            
            cell.lblQty.text = "\(arrProductPromotionList[indexPath.row - 6].CartQty ?? 0)";
            if intDeliveryType == 0 && isRequireMinimumCartAmount == true {
                cell.lblmincartmsg.text = "\(arrProductPromotionList[indexPath.row - 6].ExcludeMinimumCartValueMessage ?? "")"
            } else {
                cell.lblmincartmsg.text = ""
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            if intDeliveryType == 1 {
                return 100
            }
            if isDeliverDisp == false {
                return 0
                
            }
            if isDeliveryslot == true {
                return addressDetail.keys.count == 0 ? 100 : UITableView.automaticDimension
            } else {
                return 0
            }
        } else if indexPath.row == 2 {
            if arrlstSlotManagement.count > 0 {
                
                if let arrTimeSlot = arrlstSlotManagement[timeSlotindex]["lstSlotDetail"] as? [[String:Any]] {
                    
                    if arrTimeSlot.count == 1 {
                        return 109 + 45 + 20
                        
                    } else if arrTimeSlot.count == 2 {
                        return 109 + 45 + 45 + 20
                        
                    } else if arrTimeSlot.count == 3 {
                        return 109 + 45 + 45 + 45 + 20
                        
                    } else {
                        return 240
                    }
                } else {
                    return 109
                }
            } else {
                return 109 + 20
            }
        } else if indexPath.row == 3 {
            if isPromoApply {
                return 75
            } else {
                return 55
            }
        } else if indexPath.row == 4 {
            if intDeliveryType == 1 {
                return 140 - 30
            } else {
                return 140
            }
        } else if indexPath.row == 5 {
            return 100
            
        } else {
            return addressbillingDetail.keys.count == 0 ? 120 : 140
            
        }
    }
}
// MARK: - Cell Delegate

extension OrderSummaryViewController :TimeViewCellDelegate {
    func delegateSelectSlot(_ obj: [String : Any], isselect : Bool, intIndex : Int) {
        
        slotSelect = isselect;
        print(obj)
        sId = obj["SlotId"] as! Int
    }
    
    
}
