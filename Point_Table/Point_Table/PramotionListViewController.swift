//
//  HomeViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 02/09/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit

class PramotionListViewController: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    
    
    
    @IBOutlet weak var tblView: UITableView!
    
    var intPage = 1
    var isPaging = true
    
    var arrPramotion = [PramotionModel]()
    var arrOrderPramotion = [PramotionOrderModel]()
    
    var isOrderPramotion = false
    var shopId = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objApplication.isnotification = false
        SetupUI()
        
        getHistory()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        
        tblView.register(UINib(nibName: "PramotionCell", bundle: nil), forCellReuseIdentifier:"PramotionCell")
        
        tblView.register(UINib(nibName: "PramotionOrderCell", bundle: nil), forCellReuseIdentifier:"PramotionOrderCell")
        
        
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        
        
        
        
    }
    
    //MARK: - Get Homepage Detail
    func getHistory() -> Void {
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            
            let user = UserModel(json: userdict)
            
            
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                
                if isOrderPramotion == true {
                    param["ShopId"] = shopId
                } else {
                    param["UserId"] = user.UserId
                }
                param["PageNo"] = intPage
                param["PageSize"] = 20
                
                if isOrderPramotion == false {
                    APIManager.requestPostJsonEncoding(.getallpromotions, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                        
                        let Dict = JSONResponse as! [String:Any]
                        print(Dict)
                        
                        if let data1 = Dict["data"] as? [[String:Any]] {
                            if data1.count == 0 {
                                self.isPaging = false
                            }
                            
                            for objHis in data1 {
                                let obj = PramotionModel(json: objHis)
                                self.arrPramotion.append(obj)
                            }
                            self.tblView.reloadData()
                        }
                        
                    }) { (error) -> Void in
                        CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                    }
                } else {
                    APIManager.requestPostJsonEncoding(.getallorderpromotions, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                        
                        let Dict = JSONResponse as! [String:Any]
                        print(Dict)
                        
                        if let data1 = Dict["data"] as? [[String:Any]] {
                            if data1.count == 0 {
                                self.isPaging = false
                            }
                            
                            for objHis in data1 {
                                let obj = PramotionOrderModel(json: objHis)
                                self.arrOrderPramotion.append(obj)
                            }
                            self.tblView.reloadData()
                        }
                        
                        
                    }) { (error) -> Void in
                        CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                    }
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }else {
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                
                if isOrderPramotion == true {
                    param["ShopId"] = shopId
                } else {
                    param["UserId"] = 0
                }
                param["PageNo"] = intPage
                param["PageSize"] = 20
                
                if isOrderPramotion == false {
                    APIManager.requestPostJsonEncoding(.getallpromotions, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                        
                        let Dict = JSONResponse as! [String:Any]
                        print(Dict)
                        
                        if let data1 = Dict["data"] as? [[String:Any]] {
                            if data1.count == 0 {
                                self.isPaging = false
                            }
                            
                            for objHis in data1 {
                                let obj = PramotionModel(json: objHis)
                                self.arrPramotion.append(obj)
                            }
                            self.tblView.reloadData()
                        }
                        
                    }) { (error) -> Void in
                        CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                    }
                } else {
                    APIManager.requestPostJsonEncoding(.getallorderpromotions, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                        
                        let Dict = JSONResponse as! [String:Any]
                        print(Dict)
                        
                        if let data1 = Dict["data"] as? [[String:Any]] {
                            if data1.count == 0 {
                                self.isPaging = false
                            }
                            
                            for objHis in data1 {
                                let obj = PramotionOrderModel(json: objHis)
                                self.arrOrderPramotion.append(obj)
                            }
                            self.tblView.reloadData()
                        }
                        
                        
                    }) { (error) -> Void in
                        CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                    }
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

extension PramotionListViewController :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isOrderPramotion ? arrOrderPramotion.count : arrPramotion.count
    }
}
extension PramotionListViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isOrderPramotion == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PramotionCell", for: indexPath) as! PramotionCell
            cell.selectionStyle = .none
            cell.setupCell(indexPath.row, objHis: arrPramotion[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PramotionOrderCell", for: indexPath) as! PramotionOrderCell
            cell.selectionStyle = .none
            cell.setupCell(indexPath.row, objHis: arrOrderPramotion[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return isOrderPramotion ? UITableView.automaticDimension : 190
    }
    
    
}

