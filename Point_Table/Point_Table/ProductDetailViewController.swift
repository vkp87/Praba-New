//
//  ProductGridViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 09/11/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import QuickLook
import MBProgressHUD
import EMAlertController
class ProductDetailViewController: UIViewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblCart: UILabel!
    @IBOutlet weak var lblBuy: UILabel!
    let previewController = QLPreviewController()
       var previewItems: [PreviewItem] = []
    var strUrl = ""
    var strFile = "png"
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewCart: UIView!
    @IBOutlet weak var lblCount: UILabel!
    
    var cartcount = 0;
    
    var shopId = 0
    var productId = 0
    
    var arrProductDetail = [[String:Any]]()
    
    var isWishView = false
    
    var isDesc = true
    var isBrand = false
    var isKg = true
    var  isQtyEdit = false

    var datePicker:UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var viewBirth: UIView!
    @IBOutlet weak var imgBirth: UIView!
    @IBOutlet weak var lblBirthTitle: UILabel!
    @IBOutlet weak var txtBirth: SkyFloatingLabelTextField!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    var intType = -1
    var intSenderType = -1
    var isLoadingImage = false

    var isFlag = false
    
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
        SetupUI()
        imgBackUpdateQty.isHidden = true
               viewUpdateQty.isHidden = true

        tblView.register(UINib(nibName: "ProductDetailCell", bundle: nil), forCellReuseIdentifier:"ProductDetailCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshLoginData(notification:)), name: Notification.Name("REFRESHLOGINAFTERDATA"), object: nil)
        
    }
    
    @objc func refreshLoginData(notification: Notification) {
        
        
        isFlag = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isLoadingImage == false {
        arrProductDetail.removeAll()
        self.tblView.reloadData()
        getProductdetail()
        }
        
    }
    
    //MARK:- Setup UI
    @objc func dateChange(_ sender:UIDatePicker) {
        txtBirth.text =  sender.date.getDateWithFormate("dd/MM/yyyy")
    }
    func SetupUI() -> Void {
        
        self.txtUpdateQty.delegate = self
        self.lblCount.isHidden = true
        lblUpdateQtyTitle.font = UIFont(name: Font_Semibold, size: 16)
               lblUpdateQtyMessage.font = UIFont(name: Font_Regular, size: 16)
               lblKg.font = UIFont(name: Font_Regular, size: 16)

        btnUpdateQty.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
               CommonFunctions.setCornerRadius(view: btnUpdateQty, radius: 17)
               
               btnCancelQty.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
               CommonFunctions.setCornerRadius(view: btnCancelQty, radius: 17)
               CommonFunctions.setCornerRadius(view: viewUpdateQty, radius: 17)

        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        lblCart.font = UIFont(name: Font_Semibold, size: 14)
        
        lblBuy.font = UIFont(name: Font_Semibold, size: 14)
        
        lblCount.font = UIFont(name: Font_Semibold, size: 14)
        
        CommonFunctions.setCornerRadius(view: lblCount, radius: 10)
        
        CommonFunctions.setBorder(view: lblCount, color: UIColor.white, width: 1)
        
        if isWishView == true {
            viewCart.isHidden = true
        } else {
            viewCart.isHidden = false
        }
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
    
    func getProductdetail() -> Void {
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                var param  = [String : Any]()
                param["UserId"] = user.UserId
                param["ShopId"] = shopId
                param["ProductId"] = productId
                APIManager.requestPostJsonEncoding(.getproductdetail, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [String:Any] {
                        var dict = [String : Any]()
                        dict = data
                        self.arrProductDetail.append(dict)
                    }
                    self.getCartCount()
                    
                    if(self.isFlag == true) {
                        self.isFlag = false
                        if self.arrProductDetail[0]["Age"] as! Int != 0 {
                            self.intType = self.intSenderType
                            
                            self.lblBirthTitle.text = "Please enter your date of birth to confirm that you are over  \(self.arrProductDetail[0]["Age"] as! Int ) year old"
                            //self.viewBirth.isHidden = false
                            //self.imgBirth.isHidden = false
                            
                            let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                            let alertError = EMAlertController(icon: nil, title: appName, message: "Please confirm that you are over \(self.arrProductDetail[0]["Age"] as! Int ) years old to buy this product. Your Identity document will be checked by staff upon delivery or collection.")
                            
                            alertError.addAction(EMAlertAction(title: "Cancel", style: .normal, action: {
                               
                            }))
                            
                            alertError.addAction(EMAlertAction(title: "Confirm", style: .normal, action: {
                                
                                let btn = UIButton()
                                                               self.btnYesClicked(btn)
                               
                                
                            }))
                           
                            rootViewController.present(alertError, animated: true, completion: nil)
                            
                            return
                        }
                        
                        let productid = self.arrProductDetail[0]["ProductId"]
                        
                        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                            let user = UserModel(json: userdict)
                            if Reachability.isConnectedToNetwork() {
                                
                                var param  = [String : Any]()
                                param["ShopId"] = self.shopId
                                param["UserId"] = user.UserId
                                param["Age"] = 0
                                
                                param["ProductId"] = productid
                                param["Qty"] = 1
                                param["Type"] = self.intSenderType
                                APIManager.requestPostJsonEncoding(.addorremovetocart, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                                    
                                    let Dict = JSONResponse as! [String:Any]
                                    print(Dict)
                                    
                                    if let data = Dict["data"] as? [String:Any] {
                                        if let cartCount = data["CartCount"] as? Int {
                                            self.cartcount = cartCount
                                            self.lblCount.text = "\(cartCount)"
                                        }
                                        if let productQty = data["ProductQty"] as? Int {
                                            self.arrProductDetail[0]["CartQty"] = productQty
                                        }
                                        if let qtyNotAvl = data["IsQtyNotAvailable"] as? Bool {
                                            if qtyNotAvl == true {
                                                self.arrProductDetail[0]["AvailableQty"] = Double(self.arrProductDetail[0]["CartQty"] as! Int)
                                            }
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
                        
                    }
                    
                    self.tblView.reloadData()
                    
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
                param["ShopId"] = shopId
                param["ProductId"] = productId
                APIManager.requestPostJsonEncoding(.getproductdetail, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [String:Any] {
                        var dict = [String : Any]()
                        dict = data
                        self.arrProductDetail.append(dict)
                    }
                    self.getCartCount()
                    
                    self.tblView.reloadData()
                    
                }) { (error) -> Void in
                    CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
    
    func addToCart(type : Int, isManual : Bool, cartWeight : Double, cartQty : Int ) -> Void {
        NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)

        if type != 2 {

        if arrProductDetail[0]["Age"] as! Int != 0 {
            
            lblBirthTitle.text = "Please enter your date of birth to confirm that you are over  \(arrProductDetail[0]["Age"] as! Int ) year old"
            
            let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
            let alertError = EMAlertController(icon: nil, title: appName, message: "Please confirm that you are over \(self.arrProductDetail[0]["Age"] as! Int ) years old to buy this product. Your Identity document will be checked by staff upon delivery or collection.")
            
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
        
        let productid = arrProductDetail[0]["ProductId"]
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
                if isQtyEdit == true {
                    param["Qty"] = arrProductDetail[0]["CartQty"] as! Int

                } else {
                    param["Qty"] = cartQty == 0 ? qty : cartQty

                }
                param["Type"] = type
                param["ProductType"] = self.arrProductDetail[0]["ProductType"] as! Int
                
                if self.arrProductDetail[0]["ProductType"] as! Int == 0 {
                    param["Weight"] = 0
                } else {
                    if self.arrProductDetail[0]["ProductType"] as! Int == 1 {
                        if isKg == true {
                            param["Qty"] = cartQty == 0 ? 0 : cartQty
                            if isQtyEdit == true {
                                param["Weight"] =  self.arrProductDetail[0]["CartWeight"] as! Double
                            } else {
                               param["Weight"] = cartWeight == 0.0 ?  (self.arrProductDetail[0]["DefaultWeight"] as! Double): cartWeight
                            }
                            

                        } else {
                            if isQtyEdit == true {
                                                           param["Weight"] =  self.arrProductDetail[0]["CartWeight"] as! Double
                                                       } else {
                                                          param["Weight"] = cartWeight == 0.0 ?  (self.arrProductDetail[0]["DefaultWeight"] as! Double) : cartWeight
                                                       }

                        }
                    } else {
                        if isQtyEdit == true {
                                                       param["Weight"] =  self.arrProductDetail[0]["CartWeight"] as! Double
                                                   } else {
                                                      param["Weight"] = cartWeight == 0.0 ?  self.arrProductDetail[0]["DefaultWeight"] as! Double : cartWeight
                                                   }

                    }
                }
                 
                if isManual == true {
                    param["IsFullValueChange"] = isQtyEdit == true ? 1 : 0
                } else {
                    param["IsFullValueChange"] = 0

                }
                
//                var param  = [String : Any]()
//                param["ShopId"] = shopId
//                param["UserId"] = user.UserId
//                param["Age"] = 0
//
//                param["ProductId"] = productid
//                param["Qty"] = 1
//                param["Type"] = type
                APIManager.requestPostJsonEncoding(.addorremovetocart, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [String:Any] {
                        if let cartCount = data["CartCount"] as? Int {
                            self.cartcount = cartCount
                            self.lblCount.text = "\(cartCount)"
                        }
                        NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)

                       
                        if let productQty = data["ProductQty"] as? Int {
                            self.arrProductDetail[0]["CartQty"] = cartQty == 0 ? productQty : 0
                        }
                        if let productQty = data["ProductWeight"] as? Double {
                            self.arrProductDetail[0]["CartWeight"] = cartWeight == 0.0 ? productQty : 0.0
                        }
                        if let qtyNotAvl = data["IsQtyNotAvailable"] as? Bool {
                            if qtyNotAvl == true {
                                self.arrProductDetail[0]["AvailableQty"] = Double(self.arrProductDetail[0]["CartQty"] as! Int)
                            }
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
                    
                }) { (error) -> Void in
                    CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
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
        let intMainAge = arrProductDetail[0]["Age"] as! Int
        
        txtBirth.text = ""
        
        //if(intMainAge <= intAge) {
            
            
            let productid = arrProductDetail[0]["ProductId"]
            
            if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                let user = UserModel(json: userdict)
                if Reachability.isConnectedToNetwork() {
                    
                    var param  = [String : Any]()
                    param["ShopId"] = shopId
                    param["UserId"] = user.UserId
                    param["Age"] = intMainAge
                    
                    param["ProductId"] = productid
                    param["Qty"] = 1
                    param["Type"] = intType
                    APIManager.requestPostJsonEncoding(.addorremovetocart, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                        
                        let Dict = JSONResponse as! [String:Any]
                        print(Dict)
                        
                        if let data = Dict["data"] as? [String:Any] {
                            if let cartCount = data["CartCount"] as? Int {
                                self.cartcount = cartCount
                                self.lblCount.text = "\(cartCount)"
                            }
                            NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)

                            if let productQty = data["ProductQty"] as? Int {
                                self.arrProductDetail[0]["CartQty"] = productQty
                            }
                            if let qtyNotAvl = data["IsQtyNotAvailable"] as? Bool {
                                if qtyNotAvl == true {
                                    self.arrProductDetail[0]["AvailableQty"] = Double(self.arrProductDetail[0]["CartQty"] as! Int)
                                }
                            }
                        }
                        
                        self.arrProductDetail[0]["Age"] = 0
                        
                        self.tblView.reloadData()
                        
                        NotificationCenter.default.post(name: Notification.Name("RELOADLISTITEM"), object: nil, userInfo: nil)
                        
                        
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
    
    @IBAction func btnShopClicked(_ sender: UIButton) {
        isLoadingImage = false

        if CommonFunctions.userLoginData() == true {
            
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
            vc.shopId = shopId
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else  {
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
    }
    
    
    
}
// MARK: - UITableview Delegate & Datasource

extension ProductDetailViewController :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return arrProductDetail.count
    }
}
extension ProductDetailViewController :ImageCellDelegate {
    func delegateSelectImage(_ obj: String, intIndex: Int) {
        
        isLoadingImage = false
        let url = URL(string:obj)!
        
        strFile = strUrl.fileExtension

        quickLook(url: url)
        
       
    }
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { previewItems.count }
    func quickLook(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data, error == nil else {
                //  in case of failure to download your data you need to present alert to the user
             self.presentAlertController(with: error?.localizedDescription ?? "Failed to download the \(self.strFile)!!!")
                return
            }
            // you neeed to check if the downloaded data is a valid pdf
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                let mimeType = httpURLResponse.mimeType,
             mimeType.hasSuffix(self.strFile)
            else {
                print((response as? HTTPURLResponse)?.mimeType ?? "")
             self.presentAlertController(with: "the data downloaded it is not a valid \(self.strFile) file")
                return
            }
            do {
                // rename the temporary file or save it to the document or library directory if you want to keep the file
             let suggestedFilename = httpURLResponse.suggestedFilename ?? "quicklook.\(self.strFile)"
                var previewURL = FileManager.default.temporaryDirectory.appendingPathComponent(suggestedFilename)
                try data.write(to: previewURL, options: .atomic)   // atomic option overwrites it if needed
                previewURL.hasHiddenExtension = true
                let previewItem = PreviewItem()
                previewItem.previewItemURL = previewURL
                self.previewItems.append(previewItem)
                DispatchQueue.main.async {
                    self.isLoadingImage = true

                    MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)

                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.previewController.delegate = self
                    self.previewController.dataSource = self
                    self.previewController.currentPreviewItemIndex = 0
                    self.present(self.previewController, animated: true)
                 }
            } catch {
                print(error)
                return
            }
        }.resume()
        MBProgressHUD.showAdded(to:(objApplication.window?.rootViewController?.view)!, animated: true)
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem { previewItems[index] }
    func presentAlertController(with message: String) {
         // present your alert controller from the main thread
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)
            self.isLoadingImage = true

            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
}
extension ProductDetailViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailCell", for: indexPath) as! ProductDetailCell
        cell.selectionStyle = .none
        cell.delegate = self
        isQtyEdit = false

        if let arr = arrProductDetail[0]["ProductImages"] as? [[String:Any]] {
            if arr.count > 0 {
                cell.arrData = arr
                cell.setupCollectionCell()
            }
        }
        
        if let isPricemark = arrProductDetail[0]["IsPriceMarked"] as? Bool
        {
            if isPricemark == false {
                cell.imgPriceMark.isHidden = true
            } else {
                              cell.imgPriceMark.isHidden = false

            }
        }
        cell.imgFav.isHidden = true

        cell.setupTable(dict: arrProductDetail[0])
        if let isWish = arrProductDetail[0]["IsFavourite"] as? Bool
        {
            if isWish == true {
                cell.imgFav.isHidden = false

                cell.btnAddWish.setTitle("Remove from wishlist", for: .normal)
            } else {
                cell.imgFav.isHidden = true
                cell.btnAddWish.setTitle("Add to wishlist", for: .normal)
            }
        }
        
        if arrProductDetail[0]["PromotionTitle"] as! String == "" {
            cell.lblPramotion.isHidden = true
            cell.imgPramotion.isHidden = true

        } else {
            cell.lblPramotion.isHidden = false
            cell.imgPramotion.isHidden = false

            
            cell.lblPramotion.text = " \(arrProductDetail[0]["PromotionTitle"] as! String) "
        }
        cell.lblQty.tag = 100 + indexPath.row
        cell.lblQty.delegate = self
        
        cell.btnAddWish.tag = indexPath.row
        cell.btnAddWish.addTarget(self, action: #selector(self.btnAddWishClicked), for: .touchUpInside)
        
        /*  if isDesc == false {
         cell.lblDescTitle.text = "Description"
         cell.lblDesc.isHidden = true
         cell.lblDesc.text = ""
         
         } else {*/
        cell.lblDescTitle.text = "Description"
        cell.lblDesc.isHidden = false
        cell.lblDesc.text = arrProductDetail[0]["Description"] as? String
        
        
        // }
        if  arrProductDetail[0]["CartQty"] as! Int > 0 || arrProductDetail[0]["CartWeight"] as! Double > 0 {
            cell.btnPlus.isHidden = false
            cell.btnMinus.isHidden = false

            cell.btnAdd.isHidden = true
        } else {
            cell.btnAdd.isHidden = false
            cell.btnPlus.isHidden = true
            cell.btnMinus.isHidden = true
        }
        
        if arrProductDetail[0]["ProductType"] as! Int > 0 && arrProductDetail[0]["CartQty"] as! Int > 0 {
            isKg = false
        }
        
        if arrProductDetail[0]["ProductType"] as! Int > 0 && arrProductDetail[0]["CartQty"]  as! Int  == 0 && arrProductDetail[0]["CartWeight"] as! Double  > 0 {
            isKg = true
               }
        
        cell.lblAvailable.isHidden = true
        
        if objApplication.isAvailableStockDisplay == true {
            cell.lblAvailable.isHidden = false
            
        }
        
        if isKg == true {
                   cell.btnKg.setImage(UIImage(named: "radio_select"), for: .normal)
                   cell.btnItem.setImage(UIImage(named: "radio_deselect"), for: .normal)
               } else {
                   cell.btnKg.setImage(UIImage(named: "radio_deselect"), for: .normal)
                   cell.btnItem.setImage(UIImage(named: "radio_select"), for: .normal)
               }
               

               cell.btnKg.isHidden = true
               cell.btnItem.isHidden = true

               if arrProductDetail[0]["ProductType"] as! Int == 1 {
                   cell.btnKg.isHidden = false
                   cell.btnItem.isHidden = false
               }
        
        cell.lblQtytitle.text = "Qty"

        if arrProductDetail[0]["ProductType"] as! Int == 1 {

            if isKg == true {
                
                cell.lblQtytitle.text = "Kg"
                
                if arrProductDetail[0]["CartWeight"] as! Double > 0 {
                    
                    cell.lblQty.text = "\(CommonFunctions.appendStringWeighItem(data: arrProductDetail[0]["CartWeight"] as! Double))"

                } else {

                    
        cell.lblQty.text = "\(CommonFunctions.appendStringWeighItem(data: arrProductDetail[0]["DefaultWeight"] as! Double))"
                }
            } else {
                if arrProductDetail[0]["CartQty"] as! Int > 0 {
                    cell.lblQty.text = "\(arrProductDetail[0]["CartQty"] as! Int)";

                } else {
                    cell.lblQty.text = "1"

                }


            }
        } else {
            if arrProductDetail[0]["CartQty"] as! Int > 0 {
                cell.lblQty.text = "\(arrProductDetail[0]["CartQty"] as! Int)";

            } else {
                cell.lblQty.text = "1"

            }
        }
        
//        if arrProductDetail[0]["ProductType"] as? Int == 1 {
//
//        cell.lblQty.text = "\(arrProductDetail[0]["DefaultWeight"] as! Double)"
//        } else {
//            cell.lblQty.text = "\(arrProductDetail[0]["CartQty"] as! Double)"
//
//        }
        
        cell.btnAdd.isEnabled = true
        cell.btnAdd.alpha = 1.0
        var symboll = ""
        if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
            symboll = symbol
        }
        cell.btnPlus.isEnabled = true
        cell.btnPlus.alpha = 1.0
            if arrProductDetail[0]["ProductType"] as! Int > 0 {
               cell.lblAvailable.isHidden = true
             }
        if arrProductDetail[0]["ProductType"] as! Int == 1 {
            cell.lblAvailable.isHidden = false

            cell.lblAvailable.textColor = UIColor.black
            
            let priceper = "\(symboll)\(arrProductDetail[0]["PricePerQty"]!)/each"
            cell.lblAvailable.text = priceper

        }
        
        if (arrProductDetail[0]["AvailableQty"] as! Double) == 0 {
            cell.lblAvailable.text = "Out of stock"
            if arrProductDetail[0]["OutOfStockMessage"] as? String == "" {
                cell.lblAvailable.text = "Out of Stock"
            } else {
                cell.lblAvailable.text = arrProductDetail[0]["OutOfStockMessage"] as? String
            }
            
            cell.lblAvailable.isHidden = false
            
            cell.btnAdd.isEnabled = false
            cell.btnAdd.alpha = 0.7
            
            cell.btnPlus.isEnabled = false
            cell.btnPlus.alpha = 0.7
        } else {
            
         
            var symboll = ""
                   if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
                       symboll = symbol
                   }
            cell.lblAvailable.text = "In Stock : \(arrProductDetail[0]["AvailableQty"] as! Double)"
            if arrProductDetail[0]["ProductType"] as! Int == 1 {
                cell.lblAvailable.isHidden = false

                cell.lblAvailable.textColor = UIColor.black
                
                let priceper = "\(symboll)\(arrProductDetail[0]["PricePerQty"]!)/each"
                cell.lblAvailable.text = priceper

            }
        }
        
       // cell.lblAvailable.isHidden = false

//        if arrProductDetail[0]["ProductType"] as! Int > 0 {
//            cell.lblAvailable.isHidden = true
//        }
//        var symboll = ""
//               if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
//                   symboll = symbol
//               }
//        if arrProductDetail[0]["ProductType"] as! Int == 1 {
//            cell.lblAvailable.isHidden = false
//
//            cell.lblAvailable.textColor = UIColor.black
//
//            let priceper = "\(symboll)\(arrProductDetail[0]["PricePerQty"] as! Double)/each"
//            cell.lblAvailable.text = priceper
//
//        }
        
        if arrProductDetail[0]["CartQty"] as! Int == 0 {
         
        } else {
           
        }
        
        if isBrand == false {
            cell.lblBrand.text = "+ Brand"
            cell.lblBrandname.isHidden = true
            cell.lblBrandname.text = ""
            
        } else {
            cell.lblBrand.text = "- Brand"
            cell.lblBrandname.isHidden = false
            cell.lblBrandname.text = arrProductDetail[0]["BrandName"] as? String
            
        }
        cell.lblDisplayweight.text = ""
        if arrProductDetail[0]["ProductType"] as! Int == 1 {


                   if isKg == false {

                    
                    let calculate = Double(arrProductDetail[0]["CartQty"] as! Int) * (arrProductDetail[0]["ProductSizePerQty"] as! Double)
                    print(calculate)
                    if calculate > 0 {

                    cell.lblDisplayweight.isHidden = false

                    cell.lblDisplayweight.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrProductDetail[0]["ProductSizeType"] as! String)"
                    }
                    if arrProductDetail[0]["CartQty"] as! Int > 0 {
                    if calculate <  arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double{
                        cell.lblDisplayweight.isHidden = false

                        cell.lblDisplayweight.text = "\(cell.lblDisplayweight.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

                    }
                    }

                   } else {
                    let calculate = (arrProductDetail[0]["CartWeight"] as! Double) * (arrProductDetail[0]["ProductSizePerQty"] as! Double)
                    print(calculate)
                    if calculate > 0 {

                        if arrProductDetail[0]["CartWeight"] as! Double > 0 {

                    if calculate  <  (arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double) {
                        cell.lblDisplayweight.isHidden = false

                        cell.lblDisplayweight.text = "\(cell.lblDisplayweight.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

                    }
                        }
                    }
                    
            }
            
        }
        
        if arrProductDetail[0]["ProductType"] as! Int == 0 {
            
            if arrProductDetail[0]["CartQty"] as! Int > 0 {
                cell.lblDisplayweight.isHidden = false

            }
            
            if arrProductDetail[0]["CartWeight"] as! Double > 0 {
                cell.lblDisplayweight.isHidden = false

            }
            
            if arrProductDetail[0]["CartQty"] as! Int > 0 {
            if (arrProductDetail[0]["CartQty"] as! Int) <  Int(arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double) {

                cell.lblDisplayweight.text = "\(cell.lblDisplayweight.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

            }
            }
            
        }
        cell.btnDesc.tag = indexPath.row
        cell.btnDesc.addTarget(self, action: #selector(self.btnDescClicked), for: .touchUpInside)
        
        cell.btnBrand.tag = indexPath.row
        cell.btnBrand.addTarget(self, action: #selector(self.btnBrandClicked), for: .touchUpInside)
        
        
        
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(self.btnAddclicked), for: .touchUpInside)
        
        
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.addTarget(self, action: #selector(self.btnPlusclicked), for: .touchUpInside)
        
        cell.btnMinus.tag = indexPath.row
        cell.btnMinus.addTarget(self, action: #selector(self.btnMinusclicked), for: .touchUpInside)
        
        cell.btnKg.tag = indexPath.row
        cell.btnKg.addTarget(self, action: #selector(self.btnKgClicked), for: .touchUpInside)
        
        cell.btnItem.tag = indexPath.row
        cell.btnItem.addTarget(self, action: #selector(self.btnitemClicked), for: .touchUpInside)
        
        return cell
        
    }
    @objc private func btnKgClicked(sender:UIButton)
    {
        var isPopup = false
        if arrProductDetail[0]["ProductType"] as! Int == 1 {
            if arrProductDetail[0]["CartWeight"] as! Double > 0 {
                isPopup = true
             }
        
        } else {
            if arrProductDetail[0]["CartQty"] as! Int > 0 {
               isPopup = true
            }
        }
        
        if isPopup == true {
        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
         let alertError = EMAlertController(icon: nil, title: appName, message: "If you change product option it will remove items your from cart, are you sure your cart will be removes?")
         alertError.addAction(EMAlertAction(title: "Yes", style: .normal, action: {
             self.intType = 2
             self.isKg = true
              //self.collectionV.reloadData()
             self.addToCart(type: 2, isManual: false, cartWeight: self.arrProductDetail[0]["CartWeight"] as! Double, cartQty: self.arrProductDetail[0]["CartQty"] as! Int)
             
         }))
         
        
         alertError.addAction(EMAlertAction(title: "No", style: .normal, action: {
             
            
         }))
        
         rootViewController.present(alertError, animated: true, completion: nil)
        }else {
            isKg = true
            self.tblView.reloadData()
                       
        }
        
        

    }
    @objc private func btnitemClicked(sender:UIButton)
    {
        
            var isPopup = false
            if arrProductDetail[0]["ProductType"] as! Int == 1 {
                if arrProductDetail[0]["CartWeight"] as! Double > 0 {
                    isPopup = true
                 }
            
            } else {
                if arrProductDetail[0]["CartQty"] as! Int > 0 {
                   isPopup = true
                }
            }
        
        if isPopup == true {
        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
         let alertError = EMAlertController(icon: nil, title: appName, message: "If you change product option it will remove items your from cart, are you sure your cart will be removes?")
         alertError.addAction(EMAlertAction(title: "Yes", style: .normal, action: {
            
            self.isKg = false
            //self.collectionV.reloadData()
            
             self.intType = 2
              
             self.addToCart(type: 2, isManual: false, cartWeight: self.arrProductDetail[0]["CartWeight"] as! Double, cartQty: self.arrProductDetail[0]["CartQty"] as! Int)

         }))
         
         alertError.addAction(EMAlertAction(title: "No", style: .normal, action: {
             
             
            
         }))
        
         rootViewController.present(alertError, animated: true, completion: nil)
        } else {
            self.isKg = false
                       self.tblView.reloadData()
                       
        }
        
        

    }
    
    @objc private func btnAddclicked(sender:UIButton)
    {
        intSenderType = 1
        
        if CommonFunctions.userLoginData() == true {
            
            if(arrProductDetail[0]["PerItemCartLimit"] as! Int == 0) {
                if arrProductDetail[0]["ProductType"] as! Int == 1 {
                    if isKg == true {
                     if (arrProductDetail[0]["CartWeight"] as! Double) < (arrProductDetail[0]["AvailableQty"] as! Double) {
                         self.imgBackUpdateQty.isHidden = true
                         self.viewUpdateQty.isHidden = true
                         self.intType = 1
                            
                         self.addToCart(type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                        
                     } else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)

                    }
                    } else {
                        if (arrProductDetail[0]["CartQty"] as! Int) < Int(arrProductDetail[0]["AvailableQty"] as! Double) {
                            self.imgBackUpdateQty.isHidden = true
                            self.viewUpdateQty.isHidden = true
                            self.intType = 1
                                                   
                            self.addToCart( type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                                               
                                            } else {
                                               CommonFunctions.showMessage(message: Message.noQuantityavailable)

                                           }
                    }
                } else {
                if (arrProductDetail[0]["CartQty"] as! Int) < Int(arrProductDetail[0]["AvailableQty"] as! Double) {
                    
                    
                    intType = 1
                    addToCart(type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                }
                else {
                    CommonFunctions.showMessage(message: Message.noQuantityavailable)
                }}
            } else {
                if (arrProductDetail[0]["CartQty"] as! Int) < (arrProductDetail[0]["PerItemCartLimit"] as! Int) {
                    if (arrProductDetail[0]["CartQty"] as! Int) < Int(arrProductDetail[0]["AvailableQty"] as! Double) {
                        intType = 1
                        
                        addToCart(type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                    }
                    else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)
                    }
                } else {
                    CommonFunctions.showMessage(message: Message.nocartlimit)
                    
                }
            }
        } else {
            isLoadingImage = false

            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.cType = ControllerType.OrderDetail
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc private func btnPlusclicked(sender:UIButton)
    {
        intSenderType = 1
        
        if CommonFunctions.userLoginData() == true {
            
            if(arrProductDetail[0]["PerItemCartLimit"] as! Int == 0) {
                if (arrProductDetail[0]["CartQty"] as! Int) < Int(arrProductDetail[0]["AvailableQty"] as! Double) {
                    intType = 1
                    
                    addToCart(type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                }
                else {
                    CommonFunctions.showMessage(message: Message.noQuantityavailable)
                }
            } else {
                if (arrProductDetail[0]["CartQty"] as! Int) < (arrProductDetail[0]["PerItemCartLimit"] as! Int) {
                    
                    if (arrProductDetail[0]["CartQty"] as! Int) < Int(arrProductDetail[0]["AvailableQty"] as! Double) {
                        intType = 1
                        
                        addToCart(type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                    }
                    else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)
                    }
                } else {
                    CommonFunctions.showMessage(message: Message.nocartlimit)
                    
                }
            }
        } else {
            isLoadingImage = false

            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.cType = ControllerType.OrderDetail
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func btnMinusclicked(sender:UIButton)
    {
        intSenderType = 2
        
        if CommonFunctions.userLoginData() == true {
            
            if arrProductDetail[0]["ProductType"] as! Int  == 1 {
                if arrProductDetail[0]["CartWeight"] as! Double > 0 {
                    intType = 2
                    
                    addToCart(type: 2, isManual: false, cartWeight: 0.0, cartQty: 0)
                }
            } else {
                if (arrProductDetail[0]["CartQty"] as! Int) > 0 {
                intType = 2
                
                addToCart(type: 2, isManual: false, cartWeight: 0.0, cartQty: 0)
            }
            }
        } else {
            isLoadingImage = false

            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.cType = ControllerType.OrderDetail
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func btnDescClicked(sender:UIButton)
    {
        if isDesc == false {
            isDesc = true
        } else {
            isDesc = false
        }
        self.tblView.reloadData()
        
    }
    
    @objc private func btnBrandClicked(sender:UIButton)
    {
        if isBrand == false {
            isBrand = true
        } else {
            isBrand = false
        }
        self.tblView.reloadData()
    }
    
    @objc private func btnAddWishClicked(sender:UIButton)
    {
        if CommonFunctions.userLoginData() == true {
            
            let indexPath = IndexPath(row: sender.tag, section: 0)
            
            if let isWish = arrProductDetail[0]["IsFavourite"] as? Bool {
                if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                    let user = UserModel(json: userdict)
                    if Reachability.isConnectedToNetwork() {
                        var param  = [String : Any]()
                        param["UserId"] = user.UserId
                        param["ShopId"] = shopId
                        param["ProductId"] = productId
                        param["OperationType"] = isWish ? 2 : 1
                        APIManager.requestPostJsonEncoding(.addremovewishlist, isLoading: false, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                            
                            let Dict = JSONResponse as! [String:Any]
                            print(Dict)
                            if let cell = self.tblView.cellForRow(at: indexPath) as? ProductDetailCell
                            {
                                if isWish == true {
                                    
                                    cell.imgFav.isHidden = true

                                    self.arrProductDetail[0]["IsFavourite"] = false
                                    cell.btnAddWish.setTitle("Add to wishlist", for: .normal)
                                } else {
                                    
                                    cell.imgFav.isHidden = false

                                    self.arrProductDetail[0]["IsFavourite"] = true
                                    cell.btnAddWish.setTitle("Remove from wishlist", for: .normal)
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
        } else {
            isLoadingImage = false

            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.cType = ControllerType.AddRemoveWishlist
            vc.productId = productId
            vc.shopId = shopId
            vc.objProductDetail = arrProductDetail[0]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 680
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
extension ProductDetailViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.txtUpdateQty.tag = textField.tag

        var isChange = false
        if arrProductDetail[0]["CartQty"] as! Int > 0 {
            isChange = true
            imgBackUpdateQty.isHidden = false
            viewUpdateQty.isHidden = false
        }
        
        if arrProductDetail[0]["CartWeight"] as! Double > 0 {
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

        if arrProductDetail[0]["ProductType"] as! Int  > 0 {
            
            if arrProductDetail[0]["ProductType"] as! Int == 1 {
                
                if isKg == true {
                    self.txtUpdateQty.keyboardType = UIKeyboardType.decimalPad

                    lblUpdateQtyTitle.text = "Update Weight"
                }
            }
        }
        
        self.lblUpdateQtyMessage.isHidden = true
        
        
            lblUpdateQtyMessage.text = ""
            if arrProductDetail[0]["ProductType"] as! Int == 1 {


                       if isKg == false {

                        
                        let calculate = Double(arrProductDetail[0]["CartQty"] as! Int) * (arrProductDetail[0]["ProductSizePerQty"] as! Double)
                        print(calculate)
                        if calculate > 0 {

                            lblUpdateQtyMessage.isHidden = false

                        lblUpdateQtyMessage.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrProductDetail[0]["ProductSizeType"] as! String)"
                        }
                        if arrProductDetail[0]["CartQty"] as! Int > 0 {
                        if calculate <  arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double{
                            lblUpdateQtyMessage.isHidden = false

                            lblUpdateQtyMessage.text = "\(lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

                        }
                        }

                       } else {
                        let calculate = (arrProductDetail[0]["CartWeight"] as! Double) * (arrProductDetail[0]["ProductSizePerQty"] as! Double)
                        print(calculate)
                        if calculate > 0 {

                            if arrProductDetail[0]["CartWeight"] as! Double > 0 {

                        if calculate  <  (arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double) {
                            lblUpdateQtyMessage.isHidden = false

                            lblUpdateQtyMessage.text = "\(lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

                        }
                            }
                        }
                        
                }
                
            }
            
            if arrProductDetail[0]["ProductType"] as! Int == 0 {
                
                if arrProductDetail[0]["CartQty"] as! Int > 0 {
                    lblUpdateQtyMessage.isHidden = false

                }
                
                if arrProductDetail[0]["CartWeight"] as! Double > 0 {
                    lblUpdateQtyMessage.isHidden = false

                }
                
                if arrProductDetail[0]["CartQty"] as! Int > 0 {
                if (arrProductDetail[0]["CartQty"] as! Int) <  Int(arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double) {

                    lblUpdateQtyMessage.text = "\(lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

                }
                }
                
            }
            }

        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        
        

        isQtyEdit = true

        self.lblKg.isHidden = true
        
        
        
        if arrProductDetail[0]["ProductType"] as! Int == 1 {
                       
                       if isKg == true {
                        self.lblKg.isHidden = false

                        if textField.text != "" {

                            arrProductDetail[0]["CartWeight"]  = Double(textField.text!)
                        }
                       } else {
                        if textField.text != "" {
                            arrProductDetail[0]["CartQty"] = Int(textField.text!)
                        }

            }
        } else {
            if textField.text != "" {
                arrProductDetail[0]["CartQty"] = Int(textField.text!)
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
            
        
        if arrProductDetail[0]["ProductType"] as! Int == 1 {
                       
                       if isKg == true {
                        self.lblKg.isHidden = false

                        if updatedText != "" {

                            arrProductDetail[0]["CartWeight"]  = Double(updatedText)
                        }
                       } else {
                        if updatedText != "" {
                            arrProductDetail[0]["CartQty"] = Int(updatedText)
                        }

            }
        } else {
            if updatedText != "" {
                arrProductDetail[0]["CartQty"] = Int(updatedText)
            }
        }
        
            self.lblUpdateQtyMessage.isHidden = true
            
            
                lblUpdateQtyMessage.text = ""
                if arrProductDetail[0]["ProductType"] as! Int == 1 {


                           if isKg == false {

                            
                            let calculate = Double(arrProductDetail[0]["CartQty"] as! Int) * (arrProductDetail[0]["ProductSizePerQty"] as! Double)
                            print(calculate)
                            if calculate > 0 {

                                lblUpdateQtyMessage.isHidden = false

                            lblUpdateQtyMessage.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrProductDetail[0]["ProductSizeType"] as! String)"
                            }
                            if arrProductDetail[0]["CartQty"] as! Int > 0 {
                            if calculate <  arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double{
                                lblUpdateQtyMessage.isHidden = false

                                lblUpdateQtyMessage.text = "\(lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

                            }
                            }

                           } else {
                            let calculate = (arrProductDetail[0]["CartWeight"] as! Double) * (arrProductDetail[0]["ProductSizePerQty"] as! Double)
                            print(calculate)
                            if calculate > 0 {

                                if arrProductDetail[0]["CartWeight"] as! Double > 0 {

                            if calculate  <  (arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double) {
                                lblUpdateQtyMessage.isHidden = false

                                lblUpdateQtyMessage.text = "\(lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

                            }
                                }
                            }
                            
                    }
                    
                }
                
                if arrProductDetail[0]["ProductType"] as! Int == 0 {
                    
                    if arrProductDetail[0]["CartQty"] as! Int > 0 {
                        lblUpdateQtyMessage.isHidden = false

                    }
                    
                    if arrProductDetail[0]["CartWeight"] as! Double > 0 {
                        lblUpdateQtyMessage.isHidden = false

                    }
                    
                    if arrProductDetail[0]["CartQty"] as! Int > 0 {
                    if (arrProductDetail[0]["CartQty"] as! Int) <  Int(arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double) {

                        lblUpdateQtyMessage.text = "\(lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

                    }
                    }
                    
                }
        }
        else {
            
        }
        
        return true
    }
}
extension ProductDetailViewController  {
    @IBAction func btnUpdateQtyClicked(_ sender: UIButton) {
        
        if self.txtUpdateQty.text == "" {
            return
        }
        isQtyEdit = true

        if arrProductDetail[0]["ProductType"] as! Int == 1 {
                       
                       if isKg == true {
                        self.lblKg.isHidden = false

                           if txtUpdateQty.text != "" {

                               arrProductDetail[0]["CartWeight"]  = Double(txtUpdateQty.text ?? "0.0")
                        }
                       } else {
                        if txtUpdateQty.text != "" {
                            arrProductDetail[0]["CartQty"] = Int(txtUpdateQty.text ?? "0")
                        }

            }
        } else {
            if txtUpdateQty.text != "" {
                arrProductDetail[0]["CartQty"] = Int(txtUpdateQty.text ?? "0")
            }
        }
        
        self.lblUpdateQtyMessage.isHidden = true
        
        
            lblUpdateQtyMessage.text = ""
            if arrProductDetail[0]["ProductType"] as! Int == 1 {


                       if isKg == false {

                        
                        let calculate = Double(arrProductDetail[0]["CartQty"] as! Int) * (arrProductDetail[0]["ProductSizePerQty"] as! Double)
                        print(calculate)
                        if calculate > 0 {

                            lblUpdateQtyMessage.isHidden = false

                        lblUpdateQtyMessage.text = "Approx weight \(CommonFunctions.appendStringWeighItem(data:calculate)) \(arrProductDetail[0]["ProductSizeType"] as! String)"
                        }
                        if arrProductDetail[0]["CartQty"] as! Int > 0 {
                        if calculate <  arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double{
                            lblUpdateQtyMessage.isHidden = false

                            lblUpdateQtyMessage.text = "\(lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

                        }
                        }

                       } else {
                        let calculate = (arrProductDetail[0]["CartWeight"] as! Double) * (arrProductDetail[0]["ProductSizePerQty"] as! Double)
                        print(calculate)
                        if calculate > 0 {

                            if arrProductDetail[0]["CartWeight"] as! Double > 0 {

                        if calculate  <  (arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double) {
                            lblUpdateQtyMessage.isHidden = false

                            lblUpdateQtyMessage.text = "\(lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

                        }
                            }
                        }
                        
                }
                
            }
            
            if arrProductDetail[0]["ProductType"] as! Int == 0 {
                
                if arrProductDetail[0]["CartQty"] as! Int > 0 {
                    lblUpdateQtyMessage.isHidden = false

                }
                
                if arrProductDetail[0]["CartWeight"] as! Double > 0 {
                    lblUpdateQtyMessage.isHidden = false

                }
                
                if arrProductDetail[0]["CartQty"] as! Int > 0 {
                if (arrProductDetail[0]["CartQty"] as! Int) <  Int(arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double) {

                    lblUpdateQtyMessage.text = "\(lblUpdateQtyMessage.text ?? "") you need to by minimum \(CommonFunctions.appendStringWeighItem(data:arrProductDetail[0]["MinOrderQtyOrWeigth"] as! Double)) \(arrProductDetail[0]["ProductSizeType"] as! String)"

                }
                }
                
            }
        
        self.view.endEditing(true)

        
        intSenderType = 1
        if CommonFunctions.userLoginData() == true {
            
            if(arrProductDetail[0]["PerItemCartLimit"] as! Int == 0) {
                if arrProductDetail[0]["ProductType"] as! Int == 1 {
                    if isKg == true {
                     if (arrProductDetail[0]["CartWeight"] as! Double) < (arrProductDetail[0]["AvailableQty"] as! Double) {
                         self.imgBackUpdateQty.isHidden = true
                         self.viewUpdateQty.isHidden = true
                         self.intType = 1
                            
                         self.addToCart(type: 1, isManual: true, cartWeight: 0.0, cartQty: 0)
                        
                     } else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)

                    }
                    } else {
                        if (arrProductDetail[0]["CartQty"] as! Int) < Int(arrProductDetail[0]["AvailableQty"] as! Double) {
                            self.imgBackUpdateQty.isHidden = true
                            self.viewUpdateQty.isHidden = true
                            self.intType = 1
                                                   
                            self.addToCart( type: 1, isManual: true, cartWeight: 0.0, cartQty: 0)
                                               
                                            } else {
                                               CommonFunctions.showMessage(message: Message.noQuantityavailable)

                                           }
                    }
                } else {
                if (arrProductDetail[0]["CartQty"] as! Int) < Int(arrProductDetail[0]["AvailableQty"] as! Double) {
                    
                    
                    intType = 1
                    addToCart(type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                }
                else {
                    CommonFunctions.showMessage(message: Message.noQuantityavailable)
                }}
            } else {
                if (arrProductDetail[0]["CartQty"] as! Int) < (arrProductDetail[0]["PerItemCartLimit"] as! Int) {
                    if (arrProductDetail[0]["CartQty"] as! Int) < Int(arrProductDetail[0]["AvailableQty"] as! Double) {
                        intType = 1
                        
                        addToCart(type: 1, isManual: false, cartWeight: 0.0, cartQty: 0)
                    }
                    else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)
                    }
                } else {
                    CommonFunctions.showMessage(message: Message.nocartlimit)
                    
                }
            }
        } else {
            isLoadingImage = false

            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.cType = ControllerType.OrderDetail
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func btnCloseQtyClicked(_ sender: UIButton) {
        imgBackUpdateQty.isHidden = true
              viewUpdateQty.isHidden = true
    }
}
