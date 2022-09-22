//
//  MyAddressListViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 29/12/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import EMAlertController

class MyOrderDetailViewControler: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var intPage = 1
    var isPaging = true
    var orderId = 0
    var shopId = 0
    
    @IBOutlet weak var btnSummary: UIButton!
    @IBOutlet weak var btnItem: UIButton!
    @IBOutlet weak var btnRepeatOrder: UIButton!
    
    var objOrderMaster = [String : Any]()
    
    var objarrTaxDetail = [[String : Any]]()
    
    // var arrOrderDetail = [[String : Any]]()
    var arrOrderDetail = [CartModel]()
    
    var isSummary = true
    var symboll = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objApplication.isnotification = false
        
        
        tblView.register(UINib(nibName: "OrderItemCell", bundle: nil), forCellReuseIdentifier:"OrderItemCell")
        
        tblView.register(UINib(nibName: "OrderSummaryDetail", bundle: nil), forCellReuseIdentifier:"OrderSummaryDetail")
        
        tblView.register(UINib(nibName: "OrderSummaryTaxDetail", bundle: nil), forCellReuseIdentifier:"OrderSummaryTaxDetail")
        
        
        if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
            symboll = symbol
        }
        
        SetupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getuseradresslist()
        
    }
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        btnItem.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        btnSummary.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnRepeatOrder, radius: 21)

        btnRepeatOrder.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        

        CommonFunctions.setCornerRadius(view: btnSummary, radius: 17)
        btnSummary.setTitleColor(UIColor.white, for: .normal)
        btnSummary.backgroundColor = UIColor.black

        btnItem.setTitleColor(UIColor.black, for: .normal)

        btnItem.backgroundColor = UIColor.clear
        CommonFunctions.setCornerRadius(view: btnItem, radius: 0)
    }
    
    func getuseradresslist() -> Void {
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                var param  = [String : Any]()
                param["PageNo"] = intPage
                param["PageSize"] = 20
                param["ShopId"] = shopId
                param["OrderId"] = orderId
                
                //  param["UserId"] = 6
                param["UserId"] = user.UserId
                
                APIManager.requestPostJsonEncoding(.getallmyordersdetail, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data1 = Dict["data"] as? [String:Any] {
                        
                        if let ordermaster = data1["OrdersMasterResponse"] as? [String:Any] {
                            self.objOrderMaster = ordermaster
                        }
                        
                        if let ordermaster = data1["OrdersTaxDetailResponse"] as? [[String:Any]] {
                            self.objarrTaxDetail = ordermaster
                        }
                        
                        if self.objOrderMaster["OrderStatusText"] as! String == "Placed" {
                            // self.btnCancleOrder.isHidden = false
                        }
                        if let ordermaster = data1["OrdersDetailResponse"] as? [[String:Any]] {
                            
                            for objAd in ordermaster {
                                let obj = CartModel(json: objAd)
                                self.arrOrderDetail.append(obj)
                            }
                            
                        }
                        
                        
                        self.tblView.reloadData()
                    }
                }) { (error) -> Void in
                   // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            intPage = intPage + 1
            if isPaging == true {
                //getuseradresslist()
            }
            
        }
        
    }
    // MARK: - IBAction Event
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSummaryClicked(_ sender: Any) {

        CommonFunctions.setCornerRadius(view: btnSummary, radius: 17)
               btnSummary.setTitleColor(UIColor.white, for: .normal)
               btnSummary.backgroundColor = UIColor.black

               btnItem.setTitleColor(UIColor.black, for: .normal)
        btnItem.backgroundColor = UIColor.clear
          CommonFunctions.setCornerRadius(view: btnItem, radius: 0)
        
        isSummary = true
        tblView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        self.tblView.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
    
    @IBAction func btnRepeatOrderClicked(_ sender: Any) {

        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                var param  = [String : Any]()
             param["OrderId"] = orderId
                param["ShopId"] = shopId

                param["UserId"] = user.UserId

                APIManager.requestPostJsonEncoding(.repeatorder, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                   
                    if let data1 = Dict["data"] as? [String:Any] {
                       
                      let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                      let vc = storyBaord.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
                        vc.shopId = self.shopId
                        for obj in objApplication.arrMainBanner {
                            
                            if self.shopId == obj.BusinessId {
                                objApplication.applatitude = obj.Latitude!
                                objApplication.applongitude = obj.Longitude!
                                
                                objApplication.isAvailableStockDisplay = obj.IsAvailableStockDisplay!
                                
                                objApplication.brandName = obj.BusinessName!

                                
                                objApplication.isStoreCollectionEnable = obj.IsStoreCollectionEnable!
                                objApplication.isCodEnableForCollection = obj.IsCodEnableForCollection!
                                objApplication.isCodEnable = obj.IsCodEnable!
                                
                                objApplication.isSupportDistanceLogic = obj.IsSupportDistanceLogic!

                                                             
                                                             objApplication.isStoreCollectionEnable = obj.IsStoreCollectionEnable!
                            }
                            
                        }
                      self.navigationController?.pushViewController(vc, animated: true)
                    }
                }) { (error) -> Void in
                    //CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
    
    @IBAction func btnItemClicked(_ sender: Any) {
        
        
  CommonFunctions.setCornerRadius(view: btnItem, radius: 17)
               btnItem.setTitleColor(UIColor.white, for: .normal)
               btnItem.backgroundColor = UIColor.black

               btnSummary.setTitleColor(UIColor.black, for: .normal)
              btnSummary.backgroundColor = UIColor.clear
        CommonFunctions.setCornerRadius(view: btnSummary, radius: 0)

        
        
        isSummary = false
        tblView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        
        if(arrOrderDetail.count > 0) {
            
            self.tblView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
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
// MARK: - UITableview Delegate & Datasource

extension MyOrderDetailViewControler :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSummary == true {
            
            if objOrderMaster.keys.count > 0 {
                return 1 + objarrTaxDetail.count
            }
        }
        return arrOrderDetail.count
    }
}
extension MyOrderDetailViewControler :UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSummary == true {
            
            if(indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryDetail", for: indexPath) as! OrderSummaryDetail
                
                
                if(objOrderMaster["IsStoreCollection"] as! Bool == true) {
                    
                    cell.lblHeaderDelivery.text = "Collection Slot"
                    
                    
                } else {
                    cell.lblHeaderDelivery.text = "Delivery Slot"
                    
                }
                
                
                
                cell.lblName.text = "\(objOrderMaster["AddrFirstName"] as! String) \(objOrderMaster["AddrLastName"] as! String)"
                
                cell.lblAddress.text = "\(objOrderMaster["StreetAddress1"] as! String) \(objOrderMaster["StreetAddress2"] as? String ?? ""), \(objOrderMaster["PostCode"] as! String)"
                
                cell.lblPhone.text = "Phone No : \(objOrderMaster["AddrMobileNo"] as! String)"
                
                cell.lblOrderno.text = "Order No :"
                
                cell.lblOrdernoval.text = "\(objOrderMaster["InvoiceNumber"] as! String)"
                
                
                
                
                
                cell.lblPaymentoption.text = "Payment Option :"
                
                cell.lblPaymentoptionval.text = "\(objOrderMaster["PaymentModeText"] as! String)"
                
                if objOrderMaster["Promocode"] as! String == "" {
                    cell.lblPromo.isHidden = true
                    cell.lblPromocode.isHidden = true
                } else {
                    
                    cell.lblPromo.isHidden = false
                    cell.lblPromocode.isHidden = false

                    cell.lblPromo.text = "Promo Code :"
                    
                    cell.lblPromocode.text = "\(objOrderMaster["Promocode"] as! String)"
                }
                
                
                
                cell.lblOrderitem.text = "Order Item :"
                
                cell.lblOrderitemval.text = "\(objOrderMaster["ItemCount"] as! Int) Items"
                
                
                cell.lblSubtotal.text = "Sub Total :"
                
                cell.lblSubtotalval.text = "\(symboll) \(CommonFunctions.appendString(data:objOrderMaster["SubTotal"] as! Double))"
                
                
                cell.lblDiscount.text = "Saving :"
                
                cell.lblDiscountVal.text = "\(symboll) \(CommonFunctions.appendString(data:objOrderMaster["TotalDiscount"] as! Double))"
                
                
                
                
                
                
                
                cell.lbl1.text = "\(objOrderMaster["SlotDate"] as! String)"
                cell.lbl2.text = "\(objOrderMaster["SlotDuration"] as! String)"
                cell.lbl3.text = "Order Status : \(objOrderMaster["OrderStatusText"] as! String)"
                
                cell.lbl4.text = "Order Type : \(objOrderMaster["OrderTypeText"] as! String)"
                
                
                if(objOrderMaster["IsStoreCollection"] as! Bool == true) {
                    
                    
                    cell.lblName.font = UIFont(name: Font_Regular, size: 17)
                    cell.lblAddress.font = UIFont(name: Font_Regular, size: 17)

                    cell.lblName.text = "\(objOrderMaster["ShopName"] as! String)"
                    
                    cell.lblAddress.text = "\(objOrderMaster["ShopAddress"] as! String)"
                    cell.lblPhone.text = ""

                    
                    cell.lblHeaderAddress.isHidden = false
                    cell.viewBack1.isHidden = false
                    
                    cell.lblAddConst.constant = 30
                    cell.viewAddConst.constant = 70
                    
                    if objOrderMaster["Promocode"] as! String == "" {
                                                           cell.viewPaymentConst.constant = 245 - 30

                                   } else {
                                       
                                                           cell.viewPaymentConst.constant = 285 - 30

                                   }
                    
                    cell.lblPaymentConst.constant = 0
                    cell.lblPaymentConstVal.constant = 0
                    
                    cell.lblHeaderAddress.text = "Store Address"

                    
                    cell.lblDeliverychargesval.text = "\(symboll) \(CommonFunctions.appendString(data:objOrderMaster["TotalAmount"] as! Double))"
                    
                    
                    
                    cell.lblDeliverycharges.text = "Total :"
                    
                    
                    cell.lblTotal.text = ""
                    cell.lblTotalval.text = ""
                    
                } else {
                    
                    if objOrderMaster["Promocode"] as! String == "" {
                                            cell.viewPaymentConst.constant = 245

                    } else {
                        
                                            cell.viewPaymentConst.constant = 285

                    }
                    
                    cell.lblPaymentConst.constant = 30
                    cell.lblPaymentConstVal.constant = 30
                    
                    cell.lblName.font = UIFont(name: Font_Bold, size: 17)

                    cell.lblHeaderAddress.text = "Address"
                    cell.lblHeaderAddress.isHidden = false
                    cell.viewBack1.isHidden = false
                    
                    cell.lblTotal.text = "Total :"
                    
                    cell.lblTotalval.text = "\(symboll) \(CommonFunctions.appendString(data:objOrderMaster["TotalAmount"] as! Double))"
                    
                    
                    
                    cell.lblAddConst.constant = 30
                    cell.viewAddConst.constant = 115
                    
                    cell.lblDeliverychargesval.text = "\(symboll) \(CommonFunctions.appendString(data: objOrderMaster["DeliveryCharges"] as! Double))"
                    
                    
                    cell.lblDeliverycharges.text = "Delivery Charges :"
                }
                
                
                cell.backgroundColor = UIColor.clear
                cell.contentView.backgroundColor = UIColor.clear
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryTaxDetail", for: indexPath) as! OrderSummaryTaxDetail
                
                cell.lblFinalAmount.text = "\(symboll) \(CommonFunctions.appendString(data:objarrTaxDetail[indexPath.row - 1]["FinalAmount"] as! Double))"
                
                cell.lblTaxAmount.text = "\(symboll) \(CommonFunctions.appendString(data:objarrTaxDetail[indexPath.row - 1]["TaxAmount"] as! Double))"
                
                cell.lblTaxPercentage.text = "\( objarrTaxDetail[indexPath.row - 1]["TaxPercentage"] as! Int) %"
                
                cell.lblWithoutTaxAmount.text = "\(symboll) \(CommonFunctions.appendString(data:objarrTaxDetail[indexPath.row - 1]["WithoutTaxAmount"] as! Double))"
                cell.backgroundColor = UIColor.clear
                cell.contentView.backgroundColor = UIColor.clear
                
                return cell
                
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderItemCell
            
            if arrOrderDetail[indexPath.row].ProductSize == 0 {
                self.attributetext(lbl1: cell.lblTitle, main: arrOrderDetail[indexPath.row].ProductName!, sub: "")
            } else {
                self.attributetext(lbl1: cell.lblTitle, main: arrOrderDetail[indexPath.row].ProductName!, sub: "(\(arrOrderDetail[indexPath.row].ProductSize!) \(arrOrderDetail[indexPath.row].ProductSizeType!))")
            }
            var symboll = ""
            if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
                symboll = symbol
            }
            
            if arrOrderDetail[indexPath.row].PromotionTitle! == "" {
                cell.lblPramotion.isHidden = true
                cell.imgPramotion.isHidden = true
            } else {
                cell.lblPramotion.isHidden = false
                cell.imgPramotion.isHidden = false


                cell.lblPramotion.text = " \(arrOrderDetail[indexPath.row].PromotionTitle!) "
            }
            
            

            
            
            cell.lblAmount.text = "\(symboll) \((CommonFunctions.appendString(data: Double(arrOrderDetail[indexPath.row].SellingPrice!))))"
            
            cell.imgView.kf.indicatorType = .activity
            cell.imgView.kf.setImage(
                with: URL(string: arrOrderDetail[indexPath.row].ProductImage!),
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
            
            if arrOrderDetail[indexPath.row].ProductType! == 0 {
                cell.lblTitleQty.text = "Qty"
                cell.lblQty.text = "\(arrOrderDetail[indexPath.row].Quantity ?? 0)";

            }
            
            cell.lblApprox.isHidden = true
            
            if arrOrderDetail[indexPath.row].ProductType! > 0 && arrOrderDetail[indexPath.row].Quantity! > 0 && arrOrderDetail[indexPath.row].Weight! > 0{
                cell.lblTitleQty.text = "Qty"
                cell.lblApprox.isHidden = false

                cell.lblApprox.text = "Approx Weight \(arrOrderDetail[indexPath.row].Weight!) \(arrOrderDetail[indexPath.row].ProductSizeType!)"
                cell.lblQty.text = "\(arrOrderDetail[indexPath.row].Quantity ?? 0)";

            }
            
            if arrOrderDetail[indexPath.row].ProductType! > 0 && arrOrderDetail[indexPath.row].Quantity! == 0 && arrOrderDetail[indexPath.row].Weight! > 0{
                cell.lblTitleQty.text = "\(arrOrderDetail[indexPath.row].ProductSizeType!)"
                cell.lblQty.text = "\(arrOrderDetail[indexPath.row].Weight ?? 0.0)";

            }
            
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isSummary == true {
            if(indexPath.row == 0) {
                
                if objOrderMaster["Promocode"] as! String == "" {
                    if(objOrderMaster["IsStoreCollection"] as! Bool == true) {
                                       return 775 - 115
                                   } else {
                                       return 775
                                   }
                } else {
                if(objOrderMaster["IsStoreCollection"] as! Bool == true) {
                    return 785 - 115
                } else {
                    return 745 + 40
                }
                }
            }
            return 50
        }
        return 164
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
    
    
    
}

