//
//  ForgotPasswordViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 01/09/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class OtpViewController: UIViewController {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtUser: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblResendOtp: UILabel!
    @IBOutlet weak var txtEnterOtp: SkyFloatingLabelTextField!
    @IBOutlet weak var lblEnterotp: UILabel!
    @IBOutlet weak var lblSitback: UILabel!
    
    var strMobile = ""
    
    var counter = 59
    var timer = Timer()
    var isForgot = false
    
    var isupdatePassword = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetupUI()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

        txtUser.tag = 101
        txtUser.delegate = self
        
        txtUser.text = strMobile
        txtUser.isUserInteractionEnabled = false
        
        txtEnterOtp.tag = 102
        txtEnterOtp.delegate = self
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        lblSitback.font = UIFont(name: Font_Semibold, size: 15)
        lblEnterotp.font = UIFont(name: Font_Light, size: 15)
        lblResendOtp.font = UIFont(name: Font_Light, size: 15)

        btnSubmit.setTitle("SUBMIT", for: .normal)
        btnSubmit.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        txtUser.font = UIFont(name: Font_Regular, size: 17)
        txtUser.titleFormatter = { $0 }
        lblResendOtp.text = "Resend After : 0:59"

        txtEnterOtp.font = UIFont(name: Font_Regular, size: 17)
        txtEnterOtp.titleFormatter = { $0 }
        CommonFunctions.setCornerRadius(view: btnSubmit, radius: 21)

     //   ChangeMobile()
        
    }
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
            lblResendOtp.text = "Resend After : 0:\(counter)"
            counter -= 1
        } else {
            timer.invalidate()
            btnSubmit.setTitle("RESEND", for: .normal)

        }
    }
    
    //MARK: - WS Call
    
    func ChangeMobile() -> Void
    {
        
        
         if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)

        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["MobileNo"] = strMobile
            param["UserId"] = user.UserId

            APIManager.requestPostJsonEncoding(.updateusermobileno, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                CommonFunctions.showMessage(message: "Your mobile number update successfully")

                
            }) { (error) -> Void in
                    // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
        }
        }
    
    
    // MARK: - IBAction Event
    
    @IBAction func btnBackclicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitclicked(_ sender: Any) {
        self.view.endEditing(true)

        
        if btnSubmit.titleLabel?.text == "RESEND" {
            
            if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                
                let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["UserId"] = user.UserId
                
                
                
                
                
                
                APIManager.requestPostJsonEncoding(.resendotp, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    
                    self.counter = 59

                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
                    self.btnSubmit.setTitle("SUBMIT", for: .normal)
                    
                }) { (error) -> Void in
                    //CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
            }
            
            


        } else {
        if txtUser.text == ""
        {
            CommonFunctions.showMessage(message: Message.username)
            return
        }
            
            if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                
                let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["UserId"] = user.UserId
                
                param["OTP"] = txtEnterOtp.text!
                
                
                
                
                
                APIManager.requestPostJsonEncoding(.validateotp, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    if self.isForgot == true {
                        
                        if self.isupdatePassword == true {
                            self.ChangeMobile()
                        } else {
                        let storyBaord = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBaord.instantiateViewController(withIdentifier: "UpdatePasswordViewController") as! UpdatePasswordViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                        user.isOtpVerify = true
                        CommonFunctions.setUserDefaultObject(object: user.toDict() as AnyObject, key: UserDefaultsKey.USER)
                    
                    let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyBaord.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }) { (error) -> Void in
                   // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
            }
        }


        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//MARK: - Textfield Delegate
extension OtpViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField.tag == 102
        {
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
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
