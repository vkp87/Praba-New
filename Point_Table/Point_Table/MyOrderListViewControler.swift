//
//  MyAddressListViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 29/12/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import EMAlertController

class MyOrderListViewControler: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var intPage = 1
    var isPaging = true
    var shopId = 0
    var arrOrder = [OrderModel]()
    var isBack = true
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDone: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier:"OrderCell")

        
        SetupUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrOrder.removeAll()
        getuseradresslist()

    }
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
       
        if isBack == true {
            btnBack.isHidden = false
            btnDone.isHidden = true
        } else {
            btnBack.isHidden = true
            btnDone.isHidden = false
        }
    }
    
    func getuseradresslist() -> Void {
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                var param  = [String : Any]()
                param["PageNo"] = intPage
                param["PageSize"] = 20
              //  param["ShopId"] = shopId

                //param["UserId"] = 6
                param["UserId"] = user.UserId

                APIManager.requestPostJsonEncoding(.getallmyorders, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                   
                    if let data1 = Dict["data"] as? [[String:Any]] {
                       
                        
                        for objHis in data1 {
                            let obj = OrderModel(json: objHis)
                            self.arrOrder.append(obj)
                        }
                        
                        self.tblView.reloadData()
                    }
                }) { (error) -> Void in
                   // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
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
                getuseradresslist()
            }
            
        }
        
    }
    // MARK: - IBAction Event
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: WishlistViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: PramotionCategoryViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: MyCartViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }

    @objc func addAddressClicked(_ sender: UIButton) {
           if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
               let user = UserModel(json: userdict)
               if Reachability.isConnectedToNetwork() {
                   var param  = [String : Any]()
                param["OrderId"] = arrOrder[sender.tag].OrderID
                   param["ShopId"] = arrOrder[sender.tag].ShopID

                   param["UserId"] = user.UserId

                   APIManager.requestPostJsonEncoding(.repeatorder, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                       
                       let Dict = JSONResponse as! [String:Any]
                       print(Dict)
                      
                       if let data1 = Dict["data"] as? [String:Any] {
                          
                         let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                         let vc = storyBaord.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
                        vc.shopId = self.arrOrder[sender.tag].ShopID ?? 0
                        for obj in objApplication.arrMainBanner {
                            
                            if self.arrOrder[sender.tag].ShopID ?? 0 == obj.BusinessId {
                                objApplication.applatitude = obj.Latitude!
                                objApplication.applongitude = obj.Longitude!
                                
                                objApplication.isAvailableStockDisplay = obj.IsAvailableStockDisplay!
                                
                                objApplication.brandName = obj.BusinessName!

                                
                                objApplication.isStoreCollectionEnable = obj.IsStoreCollectionEnable!
                                objApplication.isCodEnableForCollection = obj.IsCodEnableForCollection!
                                objApplication.isCodEnable = obj.IsCodEnable!
                                
                                objApplication.isSupportDistanceLogic = obj.IsSupportDistanceLogic!

                                
                                objApplication.isStoreCollectionEnable = obj.IsStoreCollectionEnable!
                            }
                            
                        }
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
// MARK: - UITableview Delegate & Datasource

extension MyOrderListViewControler :UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOrder.count
    }
}
extension MyOrderListViewControler :UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.selectionStyle = .none
        cell.setupCell(indexPath.row, objHis: arrOrder[indexPath.row])
        
        cell.btnRepOrder.tag = indexPath.row
        cell.btnRepOrder.addTarget(self, action: #selector(self.addAddressClicked), for: .touchUpInside)

        
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "MyOrderDetailViewControler") as! MyOrderDetailViewControler
        vc.orderId = arrOrder[indexPath.row].OrderID!
        vc.shopId = arrOrder[indexPath.row].ShopID!
        self.navigationController?.pushViewController(vc, animated: true)
    
    
    
    }
    
}

