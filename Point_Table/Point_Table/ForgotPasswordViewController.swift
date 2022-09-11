//
//  ForgotPasswordViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 01/09/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtUser: SkyFloatingLabelTextField!
    @IBOutlet weak var lblforgot: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetupUI()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        txtUser.tag = 101
        txtUser.delegate = self
      lblforgot.font = UIFont(name: Font_Regular, size: 16)

        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        CommonFunctions.setCornerRadius(view: btnSubmit, radius: 21)

        btnSubmit.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        txtUser.font = UIFont(name: Font_Regular, size: 17)
        txtUser.titleFormatter = { $0 }

    }
    
    // MARK: - IBAction Event
    
    @IBAction func btnBackclicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitclicked(_ sender: Any) {
        self.view.endEditing(true)
        if txtUser.text == ""
        {
            CommonFunctions.showMessage(message: Message.username)
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["MobileNo"] = txtUser.text!
            
            
            APIManager.requestPostJsonEncoding(.forgotpassword, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                
                if let userdict = Dict["data"] as? [String:Any] {
                    let user = UserModel(json: userdict)
                    user.isOtpVerify = false
                    CommonFunctions.setUserDefaultObject(object: user.toDict() as AnyObject, key: UserDefaultsKey.USER)
                    
                }
                
                let storyBaord = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBaord.instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                vc.strMobile = self.txtUser.text!
                vc.isForgot = true
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
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
extension ForgotPasswordViewController : UITextFieldDelegate {
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
