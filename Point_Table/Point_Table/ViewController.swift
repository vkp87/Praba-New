//
//  ViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 01/09/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var txtUser: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var lblSignup: UILabel!

    var shopId = 0
    var objProductDetail = [String:Any]()
    var productId = 0
    var isBack = false

    var cType : ControllerType = ControllerType.Empty
    @IBOutlet weak var btnBack: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!DeviceType.isIPad) {
            IQKeyboardManager.shared.enable = false
        }
        if isBack == true {
            btnBack.isHidden = false
        } else {
            btnBack.isHidden = false
        }
        self.SetupUI()
        if(!DeviceType.isIPad) {
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                
                if UIScreen.main.nativeBounds.height == 2436 ||  UIScreen.main.nativeBounds.height == 2688 || UIScreen.main.nativeBounds.height == 1792 || UIScreen.main.nativeBounds.height == 2532  || UIScreen.main.nativeBounds.height == 2778  || UIScreen.main.nativeBounds.height == 2340{
                    self.view.frame.origin.y -= (keyboardSize.height - 220)
                    
                } else {
                    self.view.frame.origin.y -= (keyboardSize.height - 100)
                    
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
             // self.tabBarController?.tabBar.isHidden = true

    }
    override func viewDidLayoutSubviews() {
             // self.tabBarController?.tabBar.isHidden = false

    }
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = false

        if isBack == true {

        if CommonFunctions.userLoginData() == true {
            
            self.navigationController?.popViewController(animated: true)
            
        } else {
            
              
            }
        }
    }
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
       // txtUser.text = "1234567891"
       //  txtPassword.text = "1234"
        txtUser.tag = 101
        txtPassword.tag = 102
        
        lblTitle.font = UIFont(name: Font_Bold, size: 25)
        
        
        CommonFunctions.setCornerRadius(view: btnLogin, radius: 21)
        CommonFunctions.setCornerRadius(view: btnSignup, radius: 21)
        
        
        txtUser.font = UIFont(name: Font_Regular, size: 17)
        txtUser.titleFormatter = { $0 }
        
        btnForgot.titleLabel?.font = UIFont(name: Font_Regular, size: 17)
        
        btnLogin.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        
        
        txtPassword.font = UIFont(name: Font_Regular, size: 17)
        
        txtPassword.titleFormatter = { $0 }
        
        
        self.attributetext(lbl1: lblSignup, main: "New user?", sub: "Register Here")

    }
    
    func attributetext(lbl1: UILabel, main : String, sub : String) {
        let main_string = main + " " + sub
        
        let sub_string = sub
        let range = (main_string as NSString).range(of: sub_string)
        let mainrange = (main_string as NSString).range(of: main_string)
        
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttributes([NSAttributedString.Key.font: UIFont(name: Font_Regular, size: 16) as Any], range: mainrange)
        
        attribute.addAttributes([NSAttributedString.Key.font: UIFont(name: Font_Semibold, size: 17) as Any], range: range)
        
        lbl1.attributedText = attribute
        
    }
    
    //MARK:- IBAction Event
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        if isBack == true {
                  self.tabBarController!.selectedIndex = 0

              } else {
              self.navigationController?.popViewController(animated: true)
              }
        
    }
    
    @IBAction func btnForgotpasswordClicked(_ sender: Any) {
        
        let storyBaord = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func btnSignupClicked(_ sender: Any) {
        
        let storyBaord = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        if txtUser.text == ""
        {
            CommonFunctions.showMessage(message: Message.username)
            return
        }
        if txtPassword.text == ""
        {
            CommonFunctions.showMessage(message: Message.password)
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["MobileNo"] = txtUser.text!
            
            param["Password"] = txtPassword.text!
            
            
            
            
            
            APIManager.requestPostJsonEncoding(.dologin, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                if let userdict = Dict["data"] as? [String:Any] {
                    let user = UserModel(json: userdict)
                    user.isOtpVerify = true
                    CommonFunctions.setUserDefaultObject(object: user.toDict() as AnyObject, key: UserDefaultsKey.USER)
                }
                
                
                self.setToken()
                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
        
    }
    //MARK: - Set Toke For Push Notification
    
    func setToken() -> Void {
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            
            let user = UserModel(json: userdict)
            
            
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["UserId"] = user.UserId
                if let devtoken = CommonFunctions.getUserDefault(key: UserDefaultsKey.Devtoken) as? String {
                    param["TokenId"] = devtoken
                } else {
                    param["TokenId"] = "1234567890"
                    
                }
                
                
                APIManager.requestPostJsonEncoding(.addedittoken, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    
                    
                    if self.cType == ControllerType.WishList {
                        self.navigationController?.popViewController(animated: true)
                        
                        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyBaord.instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
                        vc.shopId = self.shopId
                        self.navigationController?.pushViewController(vc, animated: true)
                        NotificationCenter.default.post(name: Notification.Name("REFRESHLOGINAFTERDATA"), object: nil, userInfo: nil)
                        
                        
                    } else if self.cType == ControllerType.Cart {
                        self.navigationController?.popViewController(animated: true)
                        
                        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyBaord.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
                        vc.shopId = self.shopId
                        self.navigationController?.pushViewController(vc, animated: true)
                        NotificationCenter.default.post(name: Notification.Name("REFRESHLOGINAFTERDATA"), object: nil, userInfo: nil)
                        
                        
                    } else if self.cType == ControllerType.Home {
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: Notification.Name("REFRESHLOGINAFTERDATA"), object: nil, userInfo: nil)
                        
                        
                    } else if self.cType == ControllerType.OrderList {
                        
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: Notification.Name("REFRESHLOGINAFTERDATA"), object: nil, userInfo: nil)
                        
                    } else if self.cType == ControllerType.OrderDetail {
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: Notification.Name("REFRESHLOGINAFTERDATA"), object: nil, userInfo: nil)
                    } else if self.cType == ControllerType.AddRemoveWishlist {
                        if let isWish = self.objProductDetail["IsFavourite"] as? Bool {
                            if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                                let user = UserModel(json: userdict)
                                if Reachability.isConnectedToNetwork() {
                                    var param  = [String : Any]()
                                    param["UserId"] = user.UserId
                                    param["ShopId"] = self.shopId
                                    param["ProductId"] = self.productId
                                    param["OperationType"] = isWish ? 2 : 1
                                    APIManager.requestPostJsonEncoding(.addremovewishlist, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                                        
                                        let Dict = JSONResponse as! [String:Any]
                                        print(Dict)
                                        self.navigationController?.popViewController(animated: true)
                                        
                                        // NotificationCenter.default.post(name: Notification.Name("REFRESHLOGINAFTERDATA"), object: nil, userInfo: nil)
                                        
                                        
                                    }) { (error) -> Void in
                                        CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                                    }
                                } else {
                                    CommonFunctions.showMessage(message: Message.internetnotconnected)
                                }
                            }
                        }
                    } else {
                        
                        self.navigationController?.popViewController(animated: true)
                        
                        NotificationCenter.default.post(name: Notification.Name("REFRESHLOGINAFTERDATA"), object: nil, userInfo: nil)
                        
                    }
                    
                    
                    
                    
                    /* let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                     let vc = storyBaord.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                     self.navigationController?.pushViewController(vc, animated: true)*/
                    
                }) { (error) -> Void in
                    CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
    
}

//MARK: - Textfield Delegate
extension ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        
        if textField.tag == 101
        {
            let maxLength = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}

