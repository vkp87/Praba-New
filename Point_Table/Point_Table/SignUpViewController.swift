//
//  ForgotPasswordViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 01/09/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var txtFname: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLname: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var btnSignup: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        objApplication.setLocation()
        self.SetupUI()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        txtMobile.tag = 101
        txtEmail.tag = 102
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        btnSignup.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)

        txtFname.font = UIFont(name: Font_Regular, size: 17)
        txtFname.titleFormatter = { $0 }

        txtLname.font = UIFont(name: Font_Regular, size: 17)
        txtLname.titleFormatter = { $0 }

        txtEmail.font = UIFont(name: Font_Regular, size: 17)
        txtEmail.titleFormatter = { $0 }

        txtPassword.font = UIFont(name: Font_Regular, size: 17)
        txtPassword.titleFormatter = { $0 }

        txtMobile.font = UIFont(name: Font_Regular, size: 17)
        txtMobile.titleFormatter = { $0 }

        CommonFunctions.setCornerRadius(view: btnSignup, radius: 21)

        
    }
    
    // MARK: - IBAction Event
    
    @IBAction func btnBackclicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignupClicked(_ sender: Any) {
        self.view.endEditing(true)


        
        if txtFname.text == ""
        {
            CommonFunctions.showMessage(message: Message.fname)
            return
        }
        
        if txtLname.text == ""
        {
            CommonFunctions.showMessage(message: Message.lname)
            return
        }
        
        if txtMobile.text == ""
        {
            CommonFunctions.showMessage(message: Message.username)
            return
        }
        
        if txtEmail.text == ""
        {
            CommonFunctions.showMessage(message: Message.email)
            return
        }
        
        if txtPassword.text == ""
        {
            CommonFunctions.showMessage(message: Message.password)
            return
        }
        
        let isValidemail  = CommonFunctions.isValid(Email: txtEmail.text!)
        if isValidemail == false
        {
            CommonFunctions.showMessage(message: Message.ValidEmail)
            return
        }
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["FirstName"] = txtFname.text!
            
            param["LastName"] = txtLname.text!
            
            param["MobileNo"] = txtMobile.text!
            
            param["EmailId"] = txtEmail.text!
            
            param["Password"] = txtPassword.text!
            
            param["Latitude"] = 0.0
            param["Longitude"] = 0.0

            if let latt = CommonFunctions.getUserDefault(key: "SavedLat") as? Double {
                param["Latitude"] = latt
            }
            
            if let long = CommonFunctions.getUserDefault(key: "SavedLong") as? Double {
                param["Longitude"] = long
            }
            
            
            
            
            APIManager.requestPostJsonEncoding(.registration, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
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
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }) { (error) -> Void in
               // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
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
extension SignUpViewController : UITextFieldDelegate {
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
