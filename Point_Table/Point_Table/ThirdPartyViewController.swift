//
//  ThirdPartyViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 12/04/20.
//  Copyright © 2020 Jatin Rathod. All rights reserved.
//

import UIKit

class ThirdPartyViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblHeader: UILabel!

    var isStore = false
    var arrData = [["Name" : "Alamofire", "Link" : "https://cocoapods.org/pods/Alamofire"],["Name" : "EMAlertController", "Link" : "https://cocoapods.org/pods/EMAlertController"],["Name" : "Fabric", "Link" : "https://cocoapods.org/pods/Fabric"],["Name" : "Crashlytics", "Link" : "https://cocoapods.org/pods/Crashlytics"],["Name" : "Firebase", "Link" : "https://cocoapods.org/pods/Firebase"],["Name" : "IQKeyboardManagerSwift", "Link" : "https://cocoapods.org/pods/IQKeyboardManagerSwift"],["Name" : "Kingfisher", "Link" : "https://cocoapods.org/pods/Kingfisher"],["Name" : "MBProgressHUD", "Link" : "https://cocoapods.org/pods/MBProgressHUD"],["Name" : "SkyFloatingLabelTextField", "Link" : "https://cocoapods.org/pods/SkyFloatingLabelTextField"],["Name" : "Stripe", "Link" : "https://cocoapods.org/pods/Stripe"]]
    override func viewDidLoad() {
        super.viewDidLoad()

        SetupUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        if isStore == true {
            lblHeader.text = "STORE LIST"

        } else {
            lblHeader.text = "THIRD PARTY FRAMEWORK"
        }
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        tblView.register(UINib(nibName: "ThirdPartyCell", bundle: nil), forCellReuseIdentifier:"ThirdPartyCell")

        tblView.reloadData()
        
        
        
        
    }
    // MARK: - IBAction Event
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
// MARK: - UITableview Delegate & Datasource

extension ThirdPartyViewController :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrData.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: arrData[indexPath.row]["Link"]!) else { return }
        UIApplication.shared.open(url)
    }
}
extension ThirdPartyViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdPartyCell", for: indexPath) as! ThirdPartyCell
            cell.selectionStyle = .none
        cell.lblLink.text = arrData[indexPath.row]["Link"]
        cell.lblName.text = arrData[indexPath.row]["Name"]

            return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
}
