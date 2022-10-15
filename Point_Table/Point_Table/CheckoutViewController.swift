//
//  CheckoutViewController.swift
//  Point_Table
//
//  Created by Vipul on 05/01/20.
//  Copyright © 2020 Jatin Rathod. All rights reserved.
//

import UIKit
import Stripe
import EMAlertController
import MBProgressHUD
import PassKit
import IQKeyboardManagerSwift


class CheckoutViewController: UIViewController, STPAuthenticationContext,STPApplePayContextDelegate {
    
    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: STPPaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        print(paymentMethod.stripeId)
        print(paymentInformation.token)
        print(paymentInformation)
        print(paymentInformation.token.transactionIdentifier)
        
        completion(self.paymentIntentClientSecret, nil)
        
    }
    
    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPPaymentStatus, error: Error?) {
        switch status {
              case .success:
                print(context.description)
                print(context.apiClient)
                self.confirmPayment(isSuccess: true, paymentId: self.paymentIntent ?? "")
                  // Payment succeeded, show a receipt view
                  break
              case .error:
                self.viewPaymentFail.isHidden = false
                //CommonFunctions.showMessage(message: "Payment failed. Order not placed.")
                  // Payment failed, show the error
                  break
              case .userCancellation:
                self.viewPaymentFail.isHidden = false
                  // User cancelled the payment
                  break
              @unknown default:
                  fatalError()
        }
    }
    
       
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var btnCod: UIButton!
    @IBOutlet weak var btnApplePay: UIButton!
    
    @IBOutlet weak var lblDeliveryTitle: UILabel!
    @IBOutlet weak var txtDeliveryNote: UITextView!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblTerm: UILabel!
    @IBOutlet weak var viewPaymentFail: UIView!
    @IBOutlet weak var btnPay: UIButton!

    @IBOutlet weak var constTop: NSLayoutConstraint!

    var TotalAmount = 0.0
    var PaymentMode = 2
    var shopId = 0
    var OrderId = 0
    var UserAddressId = 0
    var isCod = false
    var slotId = 0
    var isTerm = false
    var strPromocode = ""
    var paymentIntentClientSecret : String?
    var paymentIntent : String?
    var isApplePay = false
    
    var isDelivery = false

    var totamnt = ""
    var discont = ""
    var deliverych = ""
    var payblamnt = ""

    @IBOutlet weak var lblPriceDetail: UILabel!
    @IBOutlet weak var lblTitleTotalAmount: UILabel!
    @IBOutlet weak var lblTitleDiscount: UILabel!
    @IBOutlet weak var lblTitleDeliverycharge: UILabel!
    @IBOutlet weak var lblTitlePaybleAmount: UILabel!

    
    @IBOutlet weak var lblTotalAmount: UILabel!
       @IBOutlet weak var lblDiscount: UILabel!
       @IBOutlet weak var lblDeliverycharge: UILabel!
       @IBOutlet weak var lblPaybleAmount: UILabel!
    
    @IBOutlet weak var constDelivryHeight: NSLayoutConstraint!
    @IBOutlet weak var constDelivryTop: NSLayoutConstraint!
    @IBOutlet weak var constTitleDelivryHeight: NSLayoutConstraint!
    @IBOutlet weak var constTitleDelivryTop: NSLayoutConstraint!

    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DeviceType.isPad {
            //constTop.constant = 25

        } else {
            //constTop.constant = 16

        }
        if(!DeviceType.isIPad) {
            IQKeyboardManager.shared.enable = false
        }
        
        if(!DeviceType.isIPad) {
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        view.backgroundColor = .white
        
        btnCod.isHidden = true
        lbl2.isHidden = true
        
        stackView.addArrangedSubview(cardTextField)
        //stackView.addArrangedSubview(payButton)
        
        CommonFunctions.setCornerRadius(view: btnPay, radius: 22)
        btnPay.backgroundColor = Theme_Color
        btnPay.setTitleColor(UIColor.white, for: .normal)
        btnPay.setTitle("Pay", for: .normal)
        btnPay.titleLabel?.font = UIFont(name: Font_Semibold, size: 20)
        
        stackView.spacing = 15
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        lbl1.font = UIFont(name: Font_Regular, size: 18)
        lbl2.font = UIFont(name: Font_Regular, size: 18)
        
        lblPriceDetail.font = UIFont(name: Font_Bold, size: 18)
         lblTitleTotalAmount.font = UIFont(name: Font_Regular, size: 18)
          lblTitleDiscount.font = UIFont(name: Font_Regular, size: 18)
          lblTitleDeliverycharge.font = UIFont(name: Font_Regular, size: 18)
          lblTitlePaybleAmount.font = UIFont(name: Font_Bold, size: 18)
      
        
       lblTotalAmount.font = UIFont(name: Font_Regular, size: 18)
        lblDiscount.font = UIFont(name: Font_Regular, size: 18)
        lblDeliverycharge.font = UIFont(name: Font_Regular, size: 18)
         lblPaybleAmount.font = UIFont(name: Font_Bold, size: 18)
        
        
        lblTotalAmount.text = totamnt
        lblDiscount.text = discont
        lblDeliverycharge.text = deliverych
        lblPaybleAmount.text = payblamnt
        lblTitleDeliverycharge.isHidden = false
                   lblDeliverycharge.isHidden = false

        constDelivryHeight.constant = 20
        constDelivryTop.constant = 5
        constTitleDelivryHeight.constant = 20
        constTitleDelivryTop.constant = 5

        
        if isDelivery == true {
            lblTitleDeliverycharge.isHidden = true
            lblDeliverycharge.isHidden = true
            
            constDelivryHeight.constant = 0
            constDelivryTop.constant = 0
            constTitleDelivryHeight.constant = 0
            constTitleDelivryTop.constant = 0

        }
        lblDeliveryTitle.font = UIFont(name: Font_Semibold, size: 18)
        
        txtDeliveryNote.font = UIFont(name: Font_Regular, size: 18)
        
        CommonFunctions.setBorder(view: txtDeliveryNote, color: Theme_Color, width: 1.0)
        
        btnCard.setImage(UIImage(named: "radio_select"), for: .normal)
        btnCod.setImage(UIImage(named: "radio_deselect"), for: .normal)
        btnApplePay.setImage(UIImage(named: "radio_deselect"), for: .normal)
        
        self.lbl2.text = UserAddressId == 0 ? "Cash on Collection" : "Cash On Delivery"
        
        let main_string = "I confirm i am 18 years of age or older and i have read and agree to this application's Terms and Conditions."
        
        let sub_string = "Terms and Conditions."
                
        let range = (main_string as NSString).range(of: sub_string)
        
        let mainrange = (main_string as NSString).range(of: main_string)
        
        let attribute = NSMutableAttributedString.init(string: main_string)
        
        attribute.addAttributes([NSAttributedString.Key.font: UIFont(name: Font_Regular, size: 15) as Any, NSAttributedString.Key.foregroundColor : UIColor.black], range: mainrange)
        
        attribute.addAttributes([NSAttributedString.Key.font: UIFont(name: Font_Regular, size: 15) as Any, NSAttributedString.Key.foregroundColor : Theme_Color], range: range)
        objApplication.setLocation()

        lblTerm.attributedText = attribute
        
        getCodAvailable()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                
//                if UIScreen.main.nativeBounds.height == 2436 ||  UIScreen.main.nativeBounds.height == 2688 || UIScreen.main.nativeBounds.height == 1792{
                    self.view.frame.origin.y -= (keyboardSize.height - 100)
                    
//                } else {
//                    self.view.frame.origin.y -= (keyboardSize.height - 20)
//
//                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func getCodAvailable() {
        
        
//        if Reachability.isConnectedToNetwork() {
            
//            var param  = [String : Any]()
//            param["ShopId"] = shopId
//            APIManager.requestPostJsonEncoding(.getcodconfiguration, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
//
//                let Dict = JSONResponse as! [String:Any]
//                print(Dict)
//
//                if let data = Dict["data"] as? [String:Any] {
                    
//                    if let isCodEnable = data["IsCodEnable"] as? Bool {
//                        self.isCod = isCodEnable
//
//                        if self.isCod == true {
//                            self.btnCod.isHidden = false
//                            self.lbl2.isHidden = false
//                        }
//                    }
                    
                  
                        
                    if self.UserAddressId == 0 {
                        if objApplication.isCodEnableForCollection == true {
                            self.btnCod.isHidden = false
                            self.lbl2.isHidden = false
                        }
                    } else {
                        if objApplication.isCodEnable == true {
                            self.btnCod.isHidden = false
                            self.lbl2.isHidden = false
                        }

                    }
//                }
//
//            }) { (error) -> Void in
//                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
//            }
//        } else {
//            CommonFunctions.showMessage(message: Message.internetnotconnected)
//        }
        
    }
    
    @IBAction func pay() {
        
        if isTerm == false {
            CommonFunctions.showMessage(message: Message.acceptterm)
            return
        }
        
        if(PaymentMode == 1) {
            self.wsPay(token: "")
        } else {
            if isApplePay == false {
                if cardTextField.cardNumber?.count != 16 || cardTextField.expirationMonth == 0 || cardTextField.expirationYear == 0 || cardTextField.cvc == nil || cardTextField.cvc?.count != 3 {
                    CommonFunctions.showMessage(message: "Please enter card detail")
                } else {
                    self.generatSecretToken()
                }
            } else {
                self.generatSecretToken()
            }
            
            
           /* let cardParams = STPCardParams()
            cardParams.number = cardTextField.cardNumber
            cardParams.expMonth = cardTextField.expirationMonth
            cardParams.expYear = cardTextField.expirationYear
            cardParams.cvc = cardTextField.cvc
            
            MBProgressHUD.showAdded(to:(objApplication.window?.rootViewController?.view)!, animated: true)
           
            // Pass it to STPAPIClient to create a Token
            STPAPIClient.shared().createToken(withCard: cardParams) { token, error in
                guard let token = token else {
                    
                    // Handle the error
                    MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)

                    return
                }
                MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)

                let tokenID = token.tokenId
                
                print(tokenID)
                self.wsPay(token: tokenID)
                
            }*/
        }
    }
    
    
    func generatSecretToken() -> Void {
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["ShopId"] = shopId
                param["UserId"] = user.UserId
                
                param["OrderId"] = OrderId
                param["UserAddressId"] = UserAddressId
                
                if let num = NumberFormatter().number(from: "\(TotalAmount)") {
                    param["TotalAmount"] = num.doubleValue
                }
                param["TotalAmount"] = "\(TotalAmount)"
                param["PaymentMode"] = PaymentMode
                if isApplePay == true {
                    param["PaymentSubMode"] = "4"
                } else {
                    param["PaymentSubMode"] = "1"
                }
                
                param["CCTokenId"] = ""
                param["SlotId"] = slotId
                param["DeliveryNote"] = txtDeliveryNote.text!
                param["Promocode"] = strPromocode
                param["DeliveryType"] = UserAddressId == 0 ? 1 : 0
                               
                param["Latitude"] = 0.0
                param["Longitude"] = 0.0
                
                if let latt = CommonFunctions.getUserDefault(key: "SavedLat") as? Double {
                    param["Latitude"] = latt
                }
                
                if let long = CommonFunctions.getUserDefault(key: "SavedLong") as? Double {
                    param["Longitude"] = long
                }
                
                
                APIManager.requestPostJsonEncoding(.placeorder, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    let customCode = Dict["custom_code"] as! Int
                    if customCode == 1000 {
                        print(Dict)
                        let Data = Dict["data"] as! [String:Any]
                        self.paymentIntentClientSecret = (Data["PaymentId"] as! String)
                        self.paymentIntent = (Data["PaymentIntentId"] as! String)
//                        if let floatValue = Double(Data["TotalAmount"] as! String) {
//                            self.TotalAmount = floatValue
//                        }
                        
                        if self.isApplePay == true {
                            let merchantIdentifier = "merchant.com.sangaa.praba"
                            let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "GB", currency: "GBP")
                            paymentRequest.countryCode = "GB"

                            // Configure the line items on the payment request
                            paymentRequest.paymentSummaryItems = [
                                PKPaymentSummaryItem(label: "Praba Grocery", amount: NSDecimalNumber(value: self.TotalAmount)),
                            ]
                            
                            if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
                                // Present Apple Pay payment sheet
                                applePayContext.presentApplePay(on: self)
                            } else {
                                CommonFunctions.showMessage(message: "There is some problem with apple pay")
                                // There is a problem with your Apple Pay configuration
                            }
                        } else {
                            self.cardPay()
                        }
                    } else {
                        CommonFunctions.showMessage(message: "\(String(describing: Dict["message"]))")
                    }
                    
                }) { (error) -> Void in
                        //CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
    
    func cardPay() {
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            return
        }
        let cardParams = cardTextField.cardParams
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams

                                        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
            switch (status) {
                case .failed:
                    self.confirmPayment(isSuccess: false, paymentId : paymentIntent?.stripeId ?? "")
                    print("Payment failed")
                    self.viewPaymentFail.isHidden = false
                    //self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                    break
                case .canceled:
                    self.confirmPayment(isSuccess: false, paymentId : paymentIntent?.stripeId ?? "")
                    print("payment canceled")
                    self.viewPaymentFail.isHidden = false
                    break
                case .succeeded:
                    self.confirmPayment(isSuccess: true, paymentId : paymentIntent?.stripeId ?? "")
                    print("Payment succeeded")
                   // self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "", restartDemo: true)
                    break
                @unknown default:
                    fatalError()
                    break
                }
        }
    }
    
    func confirmPayment(isSuccess : Bool, paymentId : String) {
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                var param  = [String : Any]()
                param["ShopId"] = shopId
                param["UserId"] = user.UserId
                param["OrderId"] = OrderId
                param["PaymentId"] = paymentId
                param["IsSucess"] = isSuccess
                if isApplePay == true {
                    param["PaymentSubMode"] = "4"
                } else {
                    param["PaymentSubMode"] = "1"
                }
                  
                APIManager.requestPostJsonEncoding(.confirmPayment, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if Dict["custom_code"] as! Int == 1000 {
                        //let data = Dict["data"] as! [String: Any]
                        //if data["IsSuccess"] as! Int == 1 {
//                            let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
//                            let alertError = EMAlertController(icon: nil, title: appName, message: Message.orderplacesuc)
//                            alertError.addAction(EMAlertAction(title: "Ok", style: .normal, action: {
//                                let storyBaord = UIStoryboard(name: "Home", bundle: nil)
//                                let vc = storyBaord.instantiateViewController(withIdentifier: "MyOrderListViewControler") as! MyOrderListViewControler
//                                vc.shopId = self.shopId
//                                vc.isBack = false
//                                self.navigationController?.pushViewController(vc, animated: true)
//                                
//                            }))
//                            rootViewController.present(alertError, animated: true, completion: nil)
                        //}
//                        else {
//                            CommonFunctions.showMessage(message: "Payment failed. Order not placed.")
//                        }
                    } else {
                        CommonFunctions.showMessage(message: "\(Dict["message"])")
                    }
                                        
                }) { (error) -> Void in
                    CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
            
        }
    }
    
    func wsPay(token : String) -> Void {
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["ShopId"] = shopId
                param["UserId"] = user.UserId
                
                param["OrderId"] = OrderId
                param["UserAddressId"] = UserAddressId
                
                if let num = NumberFormatter().number(from: "\(TotalAmount)") {
                    param["TotalAmount"] = num.doubleValue
                }
                param["TotalAmount"] = "\(TotalAmount)"
                param["PaymentMode"] = PaymentMode
                
                param["CCTokenId"] = ""
                param["SlotId"] = slotId
                param["DeliveryNote"] = txtDeliveryNote.text!
                
                param["Promocode"] = strPromocode

                param["DeliveryType"] = UserAddressId == 0 ? 1 : 0
                
                if(PaymentMode == 2) {
                    param["CCTokenId"] = token
                }
                
                param["Latitude"] = 0.0
                param["Longitude"] = 0.0
                
                if let latt = CommonFunctions.getUserDefault(key: "SavedLat") as? Double {
                    param["Latitude"] = latt
                }
                
                if let long = CommonFunctions.getUserDefault(key: "SavedLong") as? Double {
                    param["Longitude"] = long
                }
                
                
                APIManager.requestPostJsonEncoding(.placeorder, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                    let alertError = EMAlertController(icon: nil, title: appName, message: Message.orderplacesuc)
                    alertError.addAction(EMAlertAction(title: "Ok", style: .normal, action: {
                        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyBaord.instantiateViewController(withIdentifier: "MyOrderListViewControler") as! MyOrderListViewControler
                        vc.shopId = self.shopId
                        vc.isBack = false
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }))
                    rootViewController.present(alertError, animated: true, completion: nil)
                    
                }) { (error) -> Void in
                  //  CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTermcheck(_ sender: Any) {
        if isTerm == false {
            
            btnCheck.setImage(UIImage(named: "check"), for: .normal)
            isTerm = true
        } else {
            btnCheck.setImage(UIImage(named: "uncheck"), for: .normal)

            isTerm = false
        }
    }
    
    @IBAction func btnTermClicked(_ sender: Any) {
        if let url = URL(string: objApplication.strTermCondtion) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func btnCodeClicked(_ sender: Any) {
        PaymentMode = 1
        isApplePay = false
        btnCod.setImage(UIImage(named: "radio_select"), for: .normal)
        btnCard.setImage(UIImage(named: "radio_deselect"), for: .normal)
        btnApplePay.setImage(UIImage(named: "radio_deselect"), for: .normal)
        
        cardTextField.clear()
        cardTextField.isEnabled = false
    }
    
    @IBAction func btnCardClicked(_ sender: Any) {
        PaymentMode = 2
        isApplePay = false
        btnCard.setImage(UIImage(named: "radio_select"), for: .normal)
        btnCod.setImage(UIImage(named: "radio_deselect"), for: .normal)
        btnApplePay.setImage(UIImage(named: "radio_deselect"), for: .normal)
        cardTextField.clear()
        cardTextField.isEnabled = true
    }
    
    @IBAction func btnApplepayClicked(_ sender: Any) {
        PaymentMode = 2
        isApplePay = true
        btnApplePay.setImage(UIImage(named: "radio_select"), for: .normal)
        btnCard.setImage(UIImage(named: "radio_deselect"), for: .normal)
        btnCod.setImage(UIImage(named: "radio_deselect"), for: .normal)
        cardTextField.clear()
        cardTextField.isEnabled = false
    }
    
    @IBAction func btnTryAgainClicked() {
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                    let user = UserModel(json: userdict)
                    if Reachability.isConnectedToNetwork() {
                        var param  = [String : Any]()
                        param["OrderId"] = OrderId
                        param["ShopId"] = shopId
                        param["UserId"] = user.UserId

                        APIManager.requestPostJsonEncoding(.repeatorder, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                                                                       
                            let Dict = JSONResponse as! [String:Any]
                            print(Dict)
                                                                      
                            if let data1 = Dict["data"] as? [String:Any] {
                                let success = data1["IsSuccess"]
                                if success as! Int == 1 {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        }) { (error) -> Void in
                          //  CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                        }
                    } else {
                        CommonFunctions.showMessage(message: Message.internetnotconnected)
                    }
                }
    }
    
        
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
