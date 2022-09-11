//
//  ProductGridViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 09/11/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import LocalAuthentication

class PramotionCategoryViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collectionV: UICollectionView!

    
    var arrShope = [ShopeModel]()

    var arrCategory = [PromotionCategoryModel]()
    var isAdvertice = false
       var adverticeCateID = 0
    
    var isbackhide = false
    @IBOutlet weak var btnBack: UIButton!

    var arrProductSearch = [ProductSearchModel]()
    @IBOutlet weak var imgAuth: UIImageView!

    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var tblProductSearch: UITableView!

    @IBOutlet weak var imgProductSearch: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isbackhide == true {
            btnBack.isHidden = true
        } else {
            btnBack.isHidden = false
        }
        
        if(arrShope.count == 0) {
            if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                
                
                for i in 0..<objApplication.arrMainBanner.count {
                    if objApplication.arrMainBanner[i].BusinessId! == sid {
                        arrShope.append(objApplication.arrMainBanner[i])
                    }
                }
            }
        }

        
        SetupUI()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.Reloadlist(notification:)), name: Notification.Name("RELOADLISTITEM"), object: nil)


        collectionV.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        collectionV.isPagingEnabled = false
        collectionV.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
              self.tabBarController?.tabBar.isHidden = true

    }
    override func viewDidLayoutSubviews() {
              self.tabBarController?.tabBar.isHidden = false

    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false

        var isSwitch = false
        if let isFinger = CommonFunctions.getUserDefault(key: UserDefaultsKey.FINGER) as? Bool {
            isSwitch = isFinger
        }
        imgAuth.isHidden = true
        
    }
    
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        txtSearch.returnKeyType = .search

        CommonFunctions.setPadding(textField: txtSearch, width: 15)

        tblProductSearch.register(UINib(nibName: "SearchProduct", bundle: nil), forCellReuseIdentifier: "SearchProduct")

        self.tblProductSearch.isHidden = true
        self.imgProductSearch.isHidden = true

        
        viewHeader.isHidden = false
        viewSearch.isHidden = true
        CommonFunctions.setCornerRadius(view: txtSearch, radius: 17)

        txtSearch.font = UIFont(name: Font_Regular, size: 17)

        

        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        lblHeader.text = lblHeader.text?.firstCharacterUpperCase()

        self.getAllCategory()
      
    }
    
    @objc func Reloadlist(notification: Notification) {
        
    }
    
   
    //MARK: - UITextfield Delegate ----
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        getAllProductSearch()
        
        textField.resignFirstResponder()
        return true
    }
    //MARK: - Get Homepage Detail
    
    func getAllProductSearch() -> Void {
        
        self.arrProductSearch.removeAll()
        tblProductSearch.reloadData()
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["ShopId"] = arrShope[0].BusinessId!
            param["ProductSearchKeyword"] = txtSearch.text!
            
            APIManager.requestPostJsonEncoding(.productsearch, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                if let data = Dict["data"] as? [[String:Any]] {
                    
                    
                    
                    for objAd in data {
                        let obj = ProductSearchModel(json: objAd)
                        self.arrProductSearch.append(obj)
                    }
                    
                }
                
                if self.arrProductSearch.count == 0 {
                    
                    CommonFunctions.showMessage(message: Message.noproductfound)
                    return
                }
                self.tblProductSearch.isHidden = false
                self.imgProductSearch.isHidden = false

                self.tblProductSearch.reloadData()
                
                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
        
        
    }
    //MARK: - Get Pramotion Category Detail
    
    
    func getAllCategory() -> Void {
        
        
        
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["ShopId"] = arrShope[0].BusinessId!
            
            
            
            
            APIManager.requestPostJsonEncoding(.getallpromotioncategory, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                if let data = Dict["data"] as? [[String:Any]] {
                    
                    for objAd in data {
                        let obj = PromotionCategoryModel(json: objAd)
                        self.arrCategory.append(obj)
                    }
                    
                }
                self.collectionV.reloadData()
                
                for obj in self.arrCategory {
                    if obj.PromotionCategoryId == self.adverticeCateID {
                        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                            let vc = storyBaord.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                            vc.shopId = self.arrShope[0].BusinessId!
                            vc.isSpecialOffer = true
                        vc.categoryId = obj.PromotionCategoryId ?? 0
                        
                            vc.subcategoryID = 0
                            objApplication.applatitude = self.arrShope[0].Latitude!
                            objApplication.applongitude = self.arrShope[0].Longitude!
                            
                            objApplication.isAvailableStockDisplay = self.arrShope[0].IsAvailableStockDisplay!
                            
                            objApplication.brandName = self.arrShope[0].BusinessName!
                            objApplication.isCodEnableForCollection = self.arrShope[0].IsCodEnableForCollection!
                            objApplication.isCodEnable = self.arrShope[0].IsCodEnable!

                            objApplication.isSupportZipCodeLogic = self.arrShope[0].IsSupportZipCodeLogic!

                            objApplication.isSupportDistanceLogic = self.arrShope[0].IsSupportDistanceLogic!

                            
                            objApplication.isStoreCollectionEnable = self.arrShope[0].IsStoreCollectionEnable!
                            self.navigationController?.pushViewController(vc, animated: false)
                        
                        return
                        
                    }
                }
                
                
            }) { (error) -> Void in
                CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
    }
    
    
   
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSearchClicked(_ sender: Any) {
        
        viewHeader.isHidden = true
        viewSearch.isHidden = false
        
        txtSearch.becomeFirstResponder()
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        
        viewHeader.isHidden = false
        viewSearch.isHidden = true
        
        self.tblProductSearch.isHidden = true
        self.imgProductSearch.isHidden = true

        
        
        txtSearch.resignFirstResponder()
        txtSearch.text = ""
        
        self.arrProductSearch.removeAll()
        self.tblProductSearch.reloadData()
        
        
    }
    @objc func btnAllProductClicked(_ sender: UIButton!) {
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                          let vc = storyBaord.instantiateViewController(withIdentifier: "VProductViewController") as! VProductViewController
                          vc.shopId = arrShope[0].BusinessId!
           vc.strSearchKey = txtSearch.text!
                          vc.categoryId = 0
                          vc.subcategoryID = 0
                         
           self.navigationController?.pushViewController(vc, animated: true)
       }
    
    
    
    
    //MARK: - UICollectionView Delegate & DataSource ----
    
    public func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if DeviceType.isIPhone8Plus || DeviceType.isIPad {
            if DeviceType.isPad {
                return CGSize(width: 230, height: 220)
                
            }
            
            return CGSize(width: 180, height: 170)
            
        }
        return CGSize(width: 160, height: 170)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as! CategoryCell
        
        cell.lblTitle.text = arrCategory[indexPath.row].CategoryName!
        
        cell.imgView.kf.indicatorType = .activity
        cell.imgView.kf.setImage(
            with: URL(string: arrCategory[indexPath.row].CategoryImage!),
            placeholder: UIImage(named: "placeholder"),
            options: [.transition(.fade(0.2))],
            progressBlock: { receivedSize, totalSize in
                //print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
        },
            completionHandler: { result in
                // print(result)
                //  print("\(indexPath.row + 1): Finished")
        }
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            vc.shopId = self.arrShope[0].BusinessId!
            vc.isSpecialOffer = true
        vc.categoryId = self.arrCategory[indexPath.row].PromotionCategoryId ?? 0
        
            vc.subcategoryID = 0
            objApplication.applatitude = self.arrShope[0].Latitude!
            objApplication.applongitude = self.arrShope[0].Longitude!
            
            objApplication.isAvailableStockDisplay = self.arrShope[0].IsAvailableStockDisplay!
            
            objApplication.brandName = self.arrShope[0].BusinessName!
            objApplication.isCodEnableForCollection = self.arrShope[0].IsCodEnableForCollection!
            objApplication.isCodEnable = self.arrShope[0].IsCodEnable!

            objApplication.isSupportZipCodeLogic = self.arrShope[0].IsSupportZipCodeLogic!

            objApplication.isSupportDistanceLogic = self.arrShope[0].IsSupportDistanceLogic!

            
            objApplication.isStoreCollectionEnable = self.arrShope[0].IsStoreCollectionEnable!
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

// MARK: - UITableview Delegate & Datasource

extension PramotionCategoryViewController :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            return arrProductSearch.count
        
    }
}
extension PramotionCategoryViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchProduct") as! SearchProduct
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.lblName.text = arrProductSearch[indexPath.row].ProductName!
        cell.lblBrand.text = arrProductSearch[indexPath.row].BrandName!
        
        
        var symboll = ""
        if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
            symboll = symbol
        }
        if arrProductSearch[indexPath.row].PromotionTitle! == "" {
            cell.lblPramotion.isHidden = true
            cell.imgPramotion.isHidden = true

            //cell.lblconstheight.constant = 0
        } else {
            cell.lblPramotion.isHidden = false
            cell.imgPramotion.isHidden = false

            //cell.lblconstheight.constant = 22
            cell.lblPramotion.text = " \(arrProductSearch[indexPath.row].PromotionTitle!) "
        }
        if arrProductSearch[indexPath.row].IsPriceMarked == false {
                       cell.imgPricemark.isHidden = true
                   } else {
                                     cell.imgPricemark.isHidden = false

                   }
        cell.lblOrAmount.isHidden = true
        if arrProductSearch[indexPath.row].DiscountValue! != 0.0 {
            cell.lblOrAmount.isHidden = false
            cell.lblOrAmount.text = "\(symboll) \(CommonFunctions.appendString(data: arrProductSearch[indexPath.row].DiscountValue!))"
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(symboll) \(CommonFunctions.appendString(data: arrProductSearch[indexPath.row].SellingPrice!))")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            cell.lblAmount.attributedText = attributeString
        }
        else {
            cell.lblAmount.text = "\(symboll) \(CommonFunctions.appendString(data: arrProductSearch[indexPath.row].SellingPrice!))"
        }
        
        if arrProductSearch[indexPath.row].ProductSize == 0 {
            cell.lblSize.text = ""
        } else {
            cell.lblSize.text = "\(arrProductSearch[indexPath.row].ProductSize!.clean) \(arrProductSearch[indexPath.row].UnitName!)"
        }
        
        if arrProductSearch[indexPath.row].AvailableQty! <= 0 {
            if arrProductSearch[indexPath.row].outOfStockMessage == "" {
                cell.lblOutOfStock.text = "Out of Stock"
            } else {
                cell.lblOutOfStock.text = arrProductSearch[indexPath.row].outOfStockMessage
            }
            cell.lblOutOfStock.isHidden = false
        } else {
            cell.lblOutOfStock.isHidden = true
        }
        
        cell.imgProduct.kf.indicatorType = .activity
        cell.imgProduct.kf.setImage(
            with: URL(string: arrProductSearch[indexPath.row].ProductImage!),
            placeholder: UIImage(named: "placeholder"),
            options: [.transition(.fade(0.2))],
            progressBlock: { receivedSize, totalSize in
                //print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
        },
            completionHandler: { result in
                // print(result)
                //  print("\(indexPath.row + 1): Finished")
        }
        )
        
        return cell

    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
           let customView = UIView(frame: CGRect(x: 0, y: 0, width: tblProductSearch.frame.size.width, height: 50))
           customView.backgroundColor = Theme_Color
           let btnAllProduct = UIButton(frame: CGRect(x: 0, y: 0, width: tblProductSearch.frame.size.width, height: 50))
           btnAllProduct.setTitle("View All Products", for: .normal)
           btnAllProduct.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
           btnAllProduct.titleLabel?.textColor = UIColor.white

           btnAllProduct.addTarget(self, action: #selector(btnAllProductClicked), for: .touchUpInside)
           customView.addSubview(btnAllProduct)
           //tblProductSearch.tableFooterView = customView
           return customView
       }

       func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           return 50
       }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//            self.tblProductSearch.isHidden = true
//        self.imgProductSearch.isHidden = true

            
           // self.txtSearch.text = arrProductSearch[indexPath.row].ProductName!
        
        
        
        let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        
        let vc = storyBaord.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        vc.productId = arrProductSearch[indexPath.row].ProductId!
        vc.shopId = arrShope[0].BusinessId!
        
        self.navigationController?.pushViewController(vc, animated: true)
        
       /* let storyBaord = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBaord.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        vc.shopId = arrShope[0].BusinessId!
        vc.categoryId = arrProductSearch[indexPath.row].CategoryId!
        vc.subcategoryID = arrProductSearch[indexPath.row].SubCategoryId!
        
        
        vc.pscategoryId = arrProductSearch[indexPath.row].CategoryId!
        vc.pssubcategoryID = arrProductSearch[indexPath.row].SubCategoryId!
        
        vc.isSearch = true
        vc.searchData = self.txtSearch.text!
        
        
        self.navigationController?.pushViewController(vc, animated: true)

        */
       
    }
    
}
