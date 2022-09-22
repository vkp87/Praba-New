//
//  HomeViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 02/09/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblNorecord: UILabel!

    
    
    @IBOutlet weak var tblView: UITableView!
    
    var intPage = 1
    var isPaging = true

    var arrHistory = [TransactionHistory]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
        
        getHistory()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        
        tblView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier:"HistoryCell")
        
       
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        
        lblNorecord.font = UIFont(name: Font_Semibold, size: 18)

        lblNorecord.isHidden = true
        
        
    }
    
    //MARK: - Get Homepage Detail
    func getHistory() -> Void {
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            
            let user = UserModel(json: userdict)
            
            
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["UserId"] = user.UserId
                param["PageNo"] = intPage
                param["PageSize"] = 20

                
                APIManager.requestPostJsonEncoding(.userpointhistory, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)

                    if let data1 = Dict["data"] as? [[String:Any]] {
                        if data1.count == 0 {
                          self.isPaging = false
                        }
                        
                        for objHis in data1 {
                            let obj = TransactionHistory(json: objHis)
                            self.arrHistory.append(obj)
                        }
                        if self.arrHistory.count == 0 {
                            self.lblNorecord.isHidden = false

                        } else {
                            self.lblNorecord.isHidden = true

                        }
                        
                        self.tblView.reloadData()
                    }
                    
                }) { (error) -> Void in
                    //CommonFunctions.showMessage(message: "\(error.localizedDescription)")
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
            getHistory()
            }
            
        }
        
    }
    
    // MARK: - IBAction Event
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
// MARK: - UITableview Delegate & Datasource

extension TransactionViewController :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrHistory.count
    }
}
extension TransactionViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.selectionStyle = .none
        cell.setupCell(indexPath.row, objHis: arrHistory[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 95
    }
    
    
}

