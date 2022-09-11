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

class UpdatePasswordViewController: UIViewController {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetupUI()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        CommonFunctions.setCornerRadius(view: btnSubmit, radius: 21)

        btnSubmit.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        txtPassword.font = UIFont(name: Font_Regular, size: 17)
        txtPassword.titleFormatter = { $0 }
        
    }
    
    // MARK: - IBAction Event
    
    @IBAction func btnBackclicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitclicked(_ sender: Any) {
        self.view.endEditing(true)
        if txtPassword.text == ""
        {
            CommonFunctions.showMessage(message: Message.password)
            return
        }
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            
            let user = UserModel(json: userdict)
            
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["Password"] = txtPassword.text!
            param["UserId"] = user.UserId

            
            
            
            
            APIManager.requestPostJsonEncoding(.updatepassword, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                let alertError = EMAlertController(icon: nil, title: appName, message: Message.successupdatepassword)
                alertError.addAction(EMAlertAction(title: "Ok", style: .normal, action: {
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                rootViewController.present(alertError, animated: true, completion: nil)
                
                
                
                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
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

