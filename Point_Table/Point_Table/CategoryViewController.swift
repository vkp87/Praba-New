//
//  ProductGridViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 09/11/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collectionV: UICollectionView!
    
    @IBOutlet weak var lblCount: UILabel!
    
    var arrShope = [ShopeModel]()
    
    var arrCategory = [CategoryModel]()
    var arrProductSearch = [ProductSearchModel]()
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var tblProductSearch: UITableView!
    
    @IBOutlet weak var imgProductSearch: UIImageView!
    
    var isAdvertice = false
    var adverticeCateID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
        
        
        
        txtSearch.returnKeyType = .search
        CommonFunctions.setPadding(textField: txtSearch, width: 15)
        
        tblProductSearch.register(UINib(nibName: "SearchProduct", bundle: nil), forCellReuseIdentifier: "SearchProduct")
        
        collectionV.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        collectionV.isPagingEnabled = false
        collectionV.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Setup UI
    
    func SetupUI() -> Void {
        
        self.tblProductSearch.isHidden = true
        self.imgProductSearch.isHidden = true
        
        
        viewHeader.isHidden = false
        viewSearch.isHidden = true
        CommonFunctions.setCornerRadius(view: txtSearch, radius: 17)
        
        txtSearch.font = UIFont(name: Font_Regular, size: 17)
        
        
        lblCount.isHidden = true
        
        lblCount.font = UIFont(name: Font_Semibold, size: 14)
        
        CommonFunctions.setCornerRadius(view: lblCount, radius: 11)
        
        CommonFunctions.setBorder(view: lblCount, color: UIColor.white, width: 1)
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        
        self.getAllCategory()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getCartCount()
        
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
    
    func getAllCategory() -> Void {
        
        
        
        if Reachability.isConnectedToNetwork() {
            
            var param  = [String : Any]()
            param["ShopId"] = arrShope[0].BusinessId!
            
            
            
            
            APIManager.requestPostJsonEncoding(.getallcategory, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                if let data = Dict["data"] as? [[String:Any]] {
                    
                    for objAd in data {
                        let obj = CategoryModel(json: objAd)
                        self.arrCategory.append(obj)
                    }
                    
                }
                self.collectionV.reloadData()

                for obj in self.arrCategory {
                    if obj.CategoryId == self.adverticeCateID {
                        if obj.IsSubCategoryExists == false {
                            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                            let vc = storyBaord.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                            vc.shopId = self.arrShope[0].BusinessId ?? 0
                            vc.categoryId = obj.CategoryId ?? 0
                            
                            self.navigationController?.pushViewController(vc, animated: false)
                        } else {
                            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                            let vc = storyBaord.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
                            vc.shopId = self.arrShope[0].BusinessId ?? 0
                            vc.categoryId = obj.CategoryId ?? 0
                            
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
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
    
    func getCartCount() -> Void {
        
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["ShopId"] = arrShope[0].BusinessId!
                param["UserId"] = user.UserId
                
                APIManager.requestPostJsonEncoding(.cartcount, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [String:Any] {
                        if let cartCount = data["CartCount"] as? Int {
                            self.lblCount.text = "\(cartCount)"
                            //self.lblCount.isHidden = false
                            
                        }
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
    @objc func btnAllProductClicked(_ sender: UIButton!) {
           let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                         let vc = storyBaord.instantiateViewController(withIdentifier: "VProductViewController") as! VProductViewController
                         vc.shopId = arrShope[0].BusinessId!
          vc.strSearchKey = txtSearch.text!
                         vc.categoryId = 0
                         vc.subcategoryID = 0
                        
          self.navigationController?.pushViewController(vc, animated: true)
      }
    @IBAction func btnShopClicked(_ sender: UIButton) {
        if CommonFunctions.userLoginData() == true {
            
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
            vc.shopId = arrShope[0].BusinessId ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.cType = ControllerType.Cart
            vc.shopId = arrShope[0].BusinessId ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnWishlistClicked(_ sender: Any) {
        if CommonFunctions.userLoginData() == true {
            
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
            vc.shopId = arrShope[0].BusinessId ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.cType = ControllerType.WishList
            vc.shopId = arrShope[0].BusinessId ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
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
        
        if arrCategory[indexPath.row].IsSubCategoryExists == false {
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            vc.shopId = arrShope[0].BusinessId ?? 0
            vc.categoryId = arrCategory[indexPath.row].CategoryId ?? 0
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            vc.shopId = arrShope[0].BusinessId ?? 0
            vc.categoryId = arrCategory[indexPath.row].CategoryId ?? 0
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
// MARK: - UITableview Delegate & Datasource

extension CategoryViewController :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrProductSearch.count
        
    }
}
extension CategoryViewController :UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tblProductSearch.frame.size.width, height: 50))
        customView.backgroundColor = Theme_Color
        let btnAllProduct = UIButton(frame: CGRect(x: 0, y: 0, width: tblProductSearch.frame.size.width, height: 50))
        btnAllProduct.setTitle("View All Products", for: .normal)
        btnAllProduct.titleLabel?.font =  UIFont(name: Font_Semibold, size: 17)
        btnAllProduct.titleLabel?.textColor = UIColor.black

        btnAllProduct.addTarget(self, action: #selector(btnAllProductClicked), for: .touchUpInside)
        customView.addSubview(btnAllProduct)
        //tblProductSearch.tableFooterView = customView
        return customView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
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
