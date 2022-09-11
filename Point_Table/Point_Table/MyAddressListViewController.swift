//
//  MyAddressListViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 29/12/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import EMAlertController

class MyAddressListViewController: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblView: UITableView!

    var arrAddress = [AddressModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier:"AddressCell")

        
        SetupUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrAddress.removeAll()
        getuseradresslist()

    }
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
       
    }
    
    func getuseradresslist() -> Void {
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                var param  = [String : Any]()
                param["UserId"] = user.UserId
                APIManager.requestPostJsonEncoding(.getuseradresslist, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                   
                    if let data1 = Dict["data"] as? [[String:Any]] {
                       
                        
                        for objHis in data1 {
                            let obj = AddressModel(json: objHis)
                            self.arrAddress.append(obj)
                        }
                       
                        
                        self.tblView.reloadData()
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
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAddressClicked(_ sender: Any) {
        
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "AddAdreessViewController") as! AddAdreessViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }

}
// MARK: - UITableview Delegate & Datasource

extension MyAddressListViewController :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrAddress.count
    }
}
extension MyAddressListViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        cell.selectionStyle = .none
        cell.setupCell(indexPath.row, objHis: arrAddress[indexPath.row])
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(self.btnEditClicked), for: .touchUpInside)
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.btnDeleteClicked), for: .touchUpInside)
        
     
        
        if(arrAddress[indexPath.row].IsDefaultAddress == true) {
            cell.btnDefault.setImage(UIImage(named: "checkboxon"), for: .normal)
            
            cell.lbl0.text = "Use as the shipping Address"
            cell.lbl0.isHidden = false
            cell.constHeight.constant = 25

        } else {
            cell.btnDefault.setImage(UIImage(named: "checkboxoff"), for: .normal)
            cell.lbl0.text = ""
            cell.lbl0.isHidden = true
            cell.constHeight.constant = 0



        }
        
        cell.btnDefault.tag = indexPath.row
        cell.btnDefault.addTarget(self, action: #selector(self.btnDefaultClicked), for: .touchUpInside)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc private func btnDefaultClicked(sender:UIButton)
    {
        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
        let alertError = EMAlertController(icon: nil, title: appName, message: "Are you sure to set as default address?")
        alertError.addAction(EMAlertAction(title: "Ok", style: .normal, action: {
            
            if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                
                let user = UserModel(json: userdict)
                
                if Reachability.isConnectedToNetwork() {
                    
                    var param  = [String : Any]()
                    
                    param["UserId"] = user.UserId
                    param["UserAddressId"] = self.arrAddress[sender.tag].UserAddressId!
                    
                    
                    APIManager.requestPostJsonEncoding(.updatedefaultaddress, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                        
                        let Dict = JSONResponse as! [String:Any]
                        print(Dict)
                        
                        self.arrAddress.removeAll()
                        self.getuseradresslist()
                        
                        
                    }) { (error) -> Void in
                        CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                    }
                } else {
                    CommonFunctions.showMessage(message: Message.internetnotconnected)
                }
            }
            
            
        }))
        alertError.addAction(EMAlertAction(title: "Cancel", style: .normal, action: {
            
        }))
        rootViewController.present(alertError, animated: true, completion: nil)
    }
    
    @objc private func btnEditClicked(sender:UIButton)
    {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "AddAdreessViewController") as! AddAdreessViewController
        vc.arrAddress.append(arrAddress[sender.tag])
        vc.addressCount = arrAddress.count
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc private func btnDeleteClicked(sender:UIButton)
    {
        if arrAddress[sender.tag].IsDefaultAddress == true {
            CommonFunctions.showMessage(message: Message.notdeladdress)

        } else {
        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
        let alertError = EMAlertController(icon: nil, title: appName, message: "Are you sure to delete this address?")
        alertError.addAction(EMAlertAction(title: "Ok", style: .normal, action: {
            
            if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                
                let user = UserModel(json: userdict)
                
                if Reachability.isConnectedToNetwork() {
                    
                    var param  = [String : Any]()
                    
                    param["UserId"] = user.UserId
                    param["UserAddressId"] = self.arrAddress[sender.tag].UserAddressId!

                    
                    APIManager.requestPostJsonEncoding(.deleteaddress, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                        
                        let Dict = JSONResponse as! [String:Any]
                        print(Dict)
                        
                       self.arrAddress.removeAll()
                        self.getuseradresslist()
                        
                        
                    }) { (error) -> Void in
                        CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                    }
                } else {
                    CommonFunctions.showMessage(message: Message.internetnotconnected)
                }
            }
            
            
        }))
        alertError.addAction(EMAlertAction(title: "Cancel", style: .normal, action: {
            
        }))
        rootViewController.present(alertError, animated: true, completion: nil)
        }
    }
    
}

