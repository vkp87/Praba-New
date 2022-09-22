//
//  ForgotPasswordViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 01/09/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import EMAlertController

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnChangeMobile: UIButton!

    @IBOutlet weak var txtFirst: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLast: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetupUI()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        btnSubmit.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        CommonFunctions.setCornerRadius(view: btnSubmit, radius: 21)
        CommonFunctions.setCornerRadius(view: btnChangeMobile, radius: 21)

        btnChangeMobile.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        
        txtFirst.font = UIFont(name: Font_Regular, size: 17)
        txtFirst.titleFormatter = { $0 }
        
        txtLast.font = UIFont(name: Font_Regular, size: 17)
        txtLast.titleFormatter = { $0 }
        
        txtEmail.font = UIFont(name: Font_Regular, size: 17)
        txtEmail.titleFormatter = { $0 }
        
        txtMobile.font = UIFont(name: Font_Regular, size: 17)
        txtMobile.titleFormatter = { $0 }
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            
            let user = UserModel(json: userdict)
            
            txtFirst.text = user.FirstName
            txtLast.text = user.LastName
            txtEmail.text = user.EmailId
            
            txtMobile.text = user.MobileNo
        }
        
    }
    
    // MARK: - IBAction Event
    
    @IBAction func btnBackclicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChangeMobileclicked(_ sender: Any) {
        
        if txtMobile.text == ""
        {
            CommonFunctions.showMessage(message: Message.fname)
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["MobileNo"] = txtMobile.text!
            
            
            APIManager.requestPostJsonEncoding(.validatemobileno, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                
                if let userdict = Dict["data"] as? [String:Any] {
                    let user = UserModel(json: userdict)
                    user.isOtpVerify = false
                    CommonFunctions.setUserDefaultObject(object: user.toDict() as AnyObject, key: UserDefaultsKey.USER)
                    
                }
                
                let storyBaord = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBaord.instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                vc.strMobile = self.txtMobile.text!
                vc.isForgot = true
                vc.isupdatePassword = true
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }) { (error) -> Void in
                //CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
    }
    
    @IBAction func btnSubmitclicked(_ sender: Any) {
        self.view.endEditing(true)
        if txtFirst.text == ""
        {
            CommonFunctions.showMessage(message: Message.fname)
            return
        }
        
        if txtLast.text == ""
        {
            CommonFunctions.showMessage(message: Message.lname)
            return
        }
        
        if txtEmail.text == ""
        {
            CommonFunctions.showMessage(message: Message.email)
            return
        }
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            
            let user = UserModel(json: userdict)
            
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["FirstName"] = txtFirst.text!
                param["LastName"] = txtLast.text!
                param["EmailId"] = txtEmail.text!
                param["UserId"] = user.UserId!

                
                
                
                
                
                APIManager.requestPostJsonEncoding(.updateuserprofile, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    user.FirstName = self.txtFirst.text!
                    user.LastName = self.txtLast.text!
                    user.EmailId = self.txtEmail.text!

                    
                    CommonFunctions.setUserDefaultObject(object: user.toDict() as AnyObject, key: UserDefaultsKey.USER)

                    
                    CommonFunctions.showMessage(message: Message.successupdateprofile)

                    
                    
                    
                    
                }) { (error) -> Void in
                    // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
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

