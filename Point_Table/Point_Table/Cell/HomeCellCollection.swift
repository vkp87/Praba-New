//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit
import Kingfisher
import EMAlertController



class HomeCellCollection: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    var cellVc = UIViewController()
    
    
    
    
    @IBOutlet weak var pagecontrol: UIPageControl!
    
    @IBOutlet weak var collectionV: UICollectionView!
    
    
    @IBOutlet weak var collectionCat: UICollectionView!
    @IBOutlet weak var lblHearderTitle1: UILabel!
    
    
    @IBOutlet weak var collectionBrand: UICollectionView!
    @IBOutlet weak var lblHearderTitle2: UILabel!
    
    
    var arrCategory = [CategoryModel]()
    var arrBrand = [BrandModel]()
    
    
    var arrAdver = [Advertisement]()
    
    var arrProduct = [ProductModel]()
    @IBOutlet weak var collectionProduct: UICollectionView!
    @IBOutlet weak var lblHearderTitle3: UILabel!
    
    
    
    var advTimer: Timer?
    
    @IBOutlet weak var myCollectionViewHeight: NSLayoutConstraint!
    
    var intSender = -1
    var intType = -1
    
    
    
    var intSenderTag = 0
    var intSenderType = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        collectionBrand.register(UINib(nibName: "BrandCellCollection", bundle: nil), forCellWithReuseIdentifier: "BrandCellCollection")
        
        
        collectionProduct.register(UINib(nibName: "ProductCellCollection", bundle: nil), forCellWithReuseIdentifier: "ProductCellCollection")
        
        
        
        collectionCat.register(UINib(nibName: "CategoryCellCollection", bundle: nil), forCellWithReuseIdentifier: "CategoryCellCollection")
        
        
        
        
        collectionV.register(UINib(nibName: "AdverticementCell", bundle: nil), forCellWithReuseIdentifier: "AdverticementCell")
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.isPagingEnabled = true
        collectionV.backgroundColor = UIColor.clear
        
        lblHearderTitle1.text = "Shope by Category"
        lblHearderTitle1.font = UIFont(name: Font_Semibold, size: 17)
        
        lblHearderTitle2.text = "Brands"
        lblHearderTitle2.font = UIFont(name: Font_Semibold, size: 17)
        
        lblHearderTitle3.text = "Popular Products"
        lblHearderTitle3.font = UIFont(name: Font_Semibold, size: 17)
        
        
        advTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changeAdvertise), userInfo: nil, repeats: true)
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func setupCollectionCell(){
        
        var index = -1
        
        if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
            
            if objApplication.arrMainBanner.count == 0 {
                return
            }
            
            for i in 0..<objApplication.arrMainBanner.count {
                if objApplication.arrMainBanner[i].BusinessId! == sid {
                    index = i
                }
            }
            
            objApplication.applatitude = objApplication.arrMainBanner[index].Latitude!
            objApplication.applongitude = objApplication.arrMainBanner[index].Longitude!
            objApplication.isAvailableStockDisplay = objApplication.arrMainBanner[index].IsAvailableStockDisplay!
            
            objApplication.isStoreCollectionEnable = objApplication.arrMainBanner[index].IsStoreCollectionEnable!
            
            objApplication.isCodEnableForCollection = objApplication.arrMainBanner[index].IsCodEnableForCollection!
            objApplication.isCodEnable = objApplication.arrMainBanner[index].IsCodEnable!
            
            
            objApplication.isSupportDistanceLogic = objApplication.arrMainBanner[index].IsSupportDistanceLogic!
            
            
            objApplication.isStoreCollectionEnable = objApplication.arrMainBanner[index].IsStoreCollectionEnable!
            
            objApplication.brandName = objApplication.arrMainBanner[index].BusinessName!
        }
        
        if arrAdver.count > 0 {
            collectionV.delegate = self
            collectionV.dataSource = self
            collectionV.reloadData()
            
            
        }
        
        
        if arrBrand.count > 0 {
            collectionBrand.delegate = self
            collectionBrand.dataSource = self
            collectionBrand.reloadData()
            lblHearderTitle2.isHidden = false
            
        } else {
            lblHearderTitle2.isHidden = true
        }
        
        
        if arrProduct.count > 0 {
            collectionProduct.delegate = self
            collectionProduct.dataSource = self
            collectionProduct.reloadData()
            
            
        }
        
        
        if arrCategory.count > 0 {
            collectionCat.delegate = self
            collectionCat.dataSource = self
            collectionCat.reloadData()
            collectionCat.isScrollEnabled = false
            
            
            let height = collectionCat.collectionViewLayout.collectionViewContentSize.height
            myCollectionViewHeight.constant = height
            self.layoutIfNeeded()
        }
        
        if arrAdver.count == 1 {
            pagecontrol.isHidden = true
        }
        pagecontrol.numberOfPages = arrAdver.count
        
    }
    
    @objc func changeAdvertise() {
        if arrAdver.count == 0 {
            return
        }
        if arrAdver.count > 0 {
           if pagecontrol.currentPage == arrAdver.count - 1 {
               pagecontrol.currentPage = 0
           } else {
               pagecontrol.currentPage = pagecontrol.currentPage + 1
           }
           collectionV.scrollToItem(at: IndexPath(item: pagecontrol.currentPage, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
    }
    
    
    
    //MARK: - UICollectionView Delegate & DataSource ----
    
    public func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionV.contentOffset
        visibleRect.size = collectionV.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionV.indexPathForItem(at: visiblePoint) else { return }
        pagecontrol.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionProduct {
            return arrProduct.count
            
        }
        
        if collectionView == collectionBrand {
            return arrBrand.count
            
        }
        
        if collectionView == collectionCat {
            return arrCategory.count
            
        }
        return arrAdver.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionProduct{
            
            return CGSize(width: 120, height: 230)
        }
        
        if collectionView == collectionBrand {
            
            return CGSize(width: 120, height: 125)
        }
        
        if collectionView == collectionCat {
            
            if DeviceType.isIPhone8Plus || DeviceType.isIPad {
                if DeviceType.isPad {
                    return CGSize(width: 230, height: 220)
                    
                }
                
                return CGSize(width: 130, height: 160)
                
            }
            return CGSize(width: 120, height: 160)
        }
        return CGSize(width: ScreenSize.width, height: 200)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == collectionProduct) {
            let cell : ProductCellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCellCollection", for: indexPath as IndexPath) as! ProductCellCollection
            
            if arrProduct.count > 0 {
            cell.lblName.text =  arrProduct[indexPath.row].ProductName
            
            var symboll = ""
            if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
                symboll = symbol
            }
            
            
            cell.lblPrice.text = "\(symboll) \(CommonFunctions.appendString(data: arrProduct[indexPath.row].Price!))"
            
            
            cell.lblQty.text = "\(arrProduct[indexPath.row].CartQty ?? 0)";

            cell.btnAdd.tag = indexPath.row
                   cell.btnAdd.addTarget(self, action: #selector(self.btnAddclicked), for: .touchUpInside)
            cell.imgView.kf.indicatorType = .activity
            cell.imgView.kf.setImage(
                with: URL(string: arrProduct[indexPath.row].ProductImage!),
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
            
           
            
            
            
            if arrProduct[indexPath.row].CartQty! == 0 {
                cell.viewCart.isHidden = true
                cell.btnAdd.isHidden = false
                
            } else {
                cell.viewCart.isHidden = false
                cell.btnAdd.isHidden = true
            }
            
            cell.btnAdd.isEnabled = true
            cell.btnAdd.alpha = 1.0
            
            cell.btnplus.isEnabled = true
            cell.btnplus.alpha = 1.0
            
            if arrProduct[indexPath.row].AvailableQty ?? 0 == 0 {
                
                cell.btnAdd.isEnabled = false
                cell.btnAdd.alpha = 0.7
                
                cell.btnplus.isEnabled = false
                cell.btnplus.alpha = 0.7
            }
            
            
            
            /*if arrProduct[indexPath.row].CartQty! == 0 {
                cell.viewCart.isUserInteractionEnabled = false
                cell.viewCart.alpha = 0.5
                       
                       cell.btnAdd.alpha = 1
                       cell.btnAdd.isUserInteractionEnabled = true

                       cell.imgAdd.alpha = 1
                   } else {
                       cell.viewCart.alpha = 1
                       cell.viewCart.isUserInteractionEnabled = true

                cell.btnAdd.alpha = 0.5
                       cell.btnAdd.isUserInteractionEnabled = false

                cell.imgAdd.alpha = 0.5
                   }*/
            
            
            
            cell.lblQty.text = "\(arrProduct[indexPath.row].CartQty ?? 0)";
            
            cell.btnplus.tag = indexPath.row
            cell.btnplus.addTarget(self, action: #selector(self.btnPlusclicked), for: .touchUpInside)
            
            cell.btnminus.tag = indexPath.row
            cell.btnminus.addTarget(self, action: #selector(self.btnMinusclicked), for: .touchUpInside)
            }
            
            
            return cell
        }
        
        if (collectionView == collectionBrand) {
            let cell : BrandCellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCellCollection", for: indexPath as IndexPath) as! BrandCellCollection
            
            
            cell.imgView.kf.indicatorType = .activity
            cell.imgView.kf.setImage(
                with: URL(string: arrBrand[indexPath.row].BrandImage!),
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
        if (collectionView == collectionCat) {
            let cell : CategoryCellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCellCollection", for: indexPath as IndexPath) as! CategoryCellCollection
            
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
        let cell : AdverticementCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdverticementCell", for: indexPath as IndexPath) as! AdverticementCell
        
        cell.imgView.kf.indicatorType = .activity
        cell.imgView.kf.setImage(
            with: URL(string: arrAdver[indexPath.row].ImageDetail!),
            placeholder: UIImage(named: "placeholder"),
            options: [.transition(.fade(0.2))],
            progressBlock: { receivedSize, totalSize in
                // print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
        },
            completionHandler: { result in
                // print(result)
                // print("\(indexPath.row + 1): Finished")
        }
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionProduct {
            var index = -1;
            
            var shopId = 0
                   if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                       
                       
                       for i in 0..<objApplication.arrMainBanner.count {
                           if objApplication.arrMainBanner[i].BusinessId! == sid {
                               shopId = objApplication.arrMainBanner[i].BusinessId!
                           }
                       }
                   }
            
            if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                
                for i in 0..<objApplication.arrMainBanner.count {
                    if objApplication.arrMainBanner[i].BusinessId! == sid {
                        index = i
                    }
                }
               // return
            }
            objApplication.applatitude = objApplication.arrMainBanner[index].Latitude!
            objApplication.applongitude = objApplication.arrMainBanner[index].Longitude!
            //
            objApplication.isAvailableStockDisplay = objApplication.arrMainBanner[index].IsAvailableStockDisplay!
            
            objApplication.isStoreCollectionEnable = objApplication.arrMainBanner[index].IsStoreCollectionEnable!
            
            objApplication.isCodEnableForCollection = objApplication.arrMainBanner[index].IsCodEnableForCollection!
            objApplication.isCodEnable = objApplication.arrMainBanner[index].IsCodEnable!
            
            
            objApplication.isSupportDistanceLogic = objApplication.arrMainBanner[index].IsSupportDistanceLogic!
            
            
            objApplication.isStoreCollectionEnable = objApplication.arrMainBanner[index].IsStoreCollectionEnable!
            
            objApplication.brandName = objApplication.arrMainBanner[index].BusinessName!
            
            //Detail
            
            let storyBaord = UIStoryboard(name: "Home", bundle: nil)
            
            let vc = storyBaord.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            vc.productId = arrProduct[indexPath.row].ProductId!
            vc.shopId = shopId
            
            self.cellVc.navigationController?.pushViewController(vc, animated: true)

            
            return
        }
        if collectionView == collectionBrand {
            return
        }
        
        var shopId = 0
        if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
            
            
            for i in 0..<objApplication.arrMainBanner.count {
                if objApplication.arrMainBanner[i].BusinessId! == sid {
                    shopId = objApplication.arrMainBanner[i].BusinessId!
                }
            }
        }
        
        if collectionView == collectionCat {
            if arrCategory[indexPath.row].IsSubCategoryExists == false {
                let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyBaord.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                
                
                vc.shopId = shopId
                vc.categoryId = arrCategory[indexPath.row].CategoryId ?? 0
                
                self.cellVc.navigationController?.pushViewController(vc, animated: true)
            } else {
                let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyBaord.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
                vc.shopId = shopId
                vc.categoryId = arrCategory[indexPath.row].CategoryId ?? 0
                
                self.cellVc.navigationController?.pushViewController(vc, animated: true)
            }
            return

        }
        if arrAdver[indexPath.row].ItemType == 0 {
            guard let url = URL(string: arrAdver[indexPath.row].OnTapURL!) else { return }
            UIApplication.shared.open(url)
        }else if arrAdver[indexPath.row].ItemType == 1 {
            //Category
            var index = -1;
            
            if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                
                for i in 0..<objApplication.arrMainBanner.count {
                    if objApplication.arrMainBanner[i].BusinessId! == sid {
                        index = i
                    }
                }
                
                let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyBaord.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                vc.arrShope.append(objApplication.arrMainBanner[index])
                vc.isAdvertice = true
                vc.adverticeCateID =  arrAdver[indexPath.row].ItemId!
                
                objApplication.applatitude = objApplication.arrMainBanner[index].Latitude!
                objApplication.applongitude = objApplication.arrMainBanner[index].Longitude!
                //
                objApplication.isAvailableStockDisplay = objApplication.arrMainBanner[index].IsAvailableStockDisplay!
                
                objApplication.isStoreCollectionEnable = objApplication.arrMainBanner[index].IsStoreCollectionEnable!
                
                objApplication.isCodEnableForCollection = objApplication.arrMainBanner[index].IsCodEnableForCollection!
                objApplication.isCodEnable = objApplication.arrMainBanner[index].IsCodEnable!
                
                
                objApplication.isSupportDistanceLogic = objApplication.arrMainBanner[index].IsSupportDistanceLogic!
                
                
                objApplication.isStoreCollectionEnable = objApplication.arrMainBanner[index].IsStoreCollectionEnable!
                
                objApplication.brandName = objApplication.arrMainBanner[index].BusinessName!
                
                
                self.cellVc.navigationController?.pushViewController(vc, animated: false)
            }
        }else if arrAdver[indexPath.row].ItemType == 2 {
            //Product Detail
            var index = -1;
            
            if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                
                for i in 0..<objApplication.arrMainBanner.count {
                    if objApplication.arrMainBanner[i].BusinessId! == sid {
                        index = i
                    }
                }
                
                let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                
                let vc = storyBaord.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
                vc.productId = arrAdver[indexPath.row].ItemId!
                vc.shopId = objApplication.arrMainBanner[index].BusinessId!
                
                
                
                self.cellVc.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            
        }else if arrAdver[indexPath.row].ItemType == 3 {
            //Promotional Category
            var index = -1;
            
            if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                
                for i in 0..<objApplication.arrMainBanner.count {
                    if objApplication.arrMainBanner[i].BusinessId! == sid {
                        index = i
                    }
                }
                
                let storyBaord = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyBaord.instantiateViewController(withIdentifier: "PramotionCategoryViewController") as! PramotionCategoryViewController
                vc.arrShope.removeAll()
                vc.arrShope.append(objApplication.arrMainBanner[index])
                vc.isAdvertice = true
                vc.adverticeCateID =  arrAdver[indexPath.row].ItemId!
                
                self.cellVc.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    
    
    
}
//MARK: - Popular Product Event ----

extension HomeCellCollection {
    @objc private func btnPlusclicked(sender:UIButton)
    {
        
        intSenderTag = sender.tag
        intSenderType = 1
        if CommonFunctions.userLoginData() == true {
            
            if(arrProduct[sender.tag].PerItemCartLimit ?? 0 == 0) {
                if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                    intSender = sender.tag
                    intType = 1
                    addToCart(index: sender.tag, type: 1)
                    

                }
                else {
                    CommonFunctions.showMessage(message: Message.noQuantityavailable)
                }
            } else {
                if arrProduct[sender.tag].CartQty ?? 0 < arrProduct[sender.tag].PerItemCartLimit ?? 0 {
                    if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                        intSender = sender.tag
                        intType = 1
                        
                        addToCart(index: sender.tag, type: 1)
                    }
                    else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)
                    }
                } else {
                    CommonFunctions.showMessage(message: Message.nocartlimit)
                    
                }
            }
        } else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.cellVc.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func btnMinusclicked(sender:UIButton)
    {
        
        intSenderTag = sender.tag
        intSenderType = 2
        if CommonFunctions.userLoginData() == true {
            
            if arrProduct[sender.tag].CartQty ?? 0 > 0 {
                intSender = sender.tag
                intType = 2
                
                addToCart(index: sender.tag, type: 2)
            }
        } else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.cellVc.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func btnAddclicked(sender:UIButton)
    {
        
        intSenderTag = sender.tag
        intSenderType = 1
        if CommonFunctions.userLoginData() == true {
            
            if(arrProduct[sender.tag].PerItemCartLimit ?? 0 == 0) {
                if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                    intSender = sender.tag
                    intType = 1
                    
                    addToCart(index: sender.tag, type: 1)
                }
                else {
                    CommonFunctions.showMessage(message: Message.noQuantityavailable)
                }
            } else {
                if arrProduct[sender.tag].CartQty ?? 0 < arrProduct[sender.tag].PerItemCartLimit ?? 0 {
                    if arrProduct[sender.tag].CartQty ?? 0 < Int(arrProduct[sender.tag].AvailableQty ?? 0.0) {
                        intSender = sender.tag
                        intType = 1
                        
                        addToCart(index: sender.tag, type: 1)
                    }
                    else {
                        CommonFunctions.showMessage(message: Message.noQuantityavailable)
                    }
                    
                } else {
                    CommonFunctions.showMessage(message: Message.nocartlimit)
                    
                }
            }
        } else {
            let storyBaord = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBaord.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.cellVc.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func btnYesClicked() {
            
            let intMainAge = arrProduct[intSender].Age ?? 0
            
            
                
                
                let productid = arrProduct[intSender].ProductId ?? 0
                let qty = 1
                
                if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
                    let user = UserModel(json: userdict)
                    if Reachability.isConnectedToNetwork() {
                        
                        var param  = [String : Any]()
                        if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                            param["ShopId"] = sid

                        }
                        param["UserId"] = user.UserId
                        param["ProductId"] = productid
                        param["Age"] = intMainAge
                        param["ProductId"] = productid
                        param["Qty"] = qty
                        param["Type"] = intType
                        APIManager.requestPostJsonEncoding(.addorremovetocart, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                            
                            let Dict = JSONResponse as! [String:Any]
                            print(Dict)
                            
                            if let data = Dict["data"] as? [String:Any] {
                                if let cartCount = data["CartCount"] as? Int {
//                                    self.cartcount = cartCount
//                                    self.lblCount.text = "\(cartCount)"
//
                                    
                                    NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)
                                    if let productQty = data["ProductQty"] as? Int {
                                        self.arrProduct[self.intSender].CartQty = productQty
                                    }
                                    if let qtyNotAvl = data["IsQtyNotAvailable"] as? Bool {
                                        if qtyNotAvl == true {
                                            self.arrProduct[self.intSender].AvailableQty = Double(self.arrProduct[self.intSender].CartQty ?? 0)
                                        }
                                    }
                                }
                            }
                            
                            for i in 0..<self.arrProduct.count {
                                self.arrProduct[i].Age = 0
                                
                            }
                            self.collectionProduct.reloadData()
                            
                        }) { (error) -> Void in
                            CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                        }
                    } else {
                        CommonFunctions.showMessage(message: Message.internetnotconnected)
                    }
                }
                
    
            
        }

    
    func addToCart(index : Int, type : Int) -> Void {
        NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)
        
        if type != 2 {
        
        if arrProduct[index].Age ?? 0 != 0 {
            
            
            let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
            let alertError = EMAlertController(icon: nil, title: appName, message: "Please confirm that you are over \(self.arrProduct[index].Age ?? 0 ) years old to buy this product. Your Identity document will be checked by staff upon delivery or collection.")
            
            alertError.addAction(EMAlertAction(title: "Cancel", style: .normal, action: {
                
            }))
            
            alertError.addAction(EMAlertAction(title: "Confirm", style: .normal, action: {
                
                
               self.btnYesClicked()
                
            }))
            
            rootViewController.present(alertError, animated: true, completion: nil)
            
            //viewBirth.isHidden = false
            //imgBirth.isHidden = false
            return
        }
        }
        
        let productid = arrProduct[index].ProductId ?? 0
        let qty = 1
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                if let sid = CommonFunctions.getUserDefault(key: UserDefaultsKey.StoreID) as? Int {
                    param["ShopId"] = sid

                }
                param["UserId"] = user.UserId
                param["ProductId"] = productid
                param["Age"] = 0
                param["ProductId"] = productid
                param["Qty"] = qty
                param["Type"] = type
                APIManager.requestPostJsonEncoding(.addorremovetocart, isLoading: false, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data = Dict["data"] as? [String:Any] {
                        if let cartCount = data["CartCount"] as? Int {
//                            self.cartcount = cartCount
//                            self.lblCount.text = "\(cartCount)"
//
                            NotificationCenter.default.post(name: Notification.Name("CARTITEMREFRESH"), object: nil, userInfo: nil)
                            if let productQty = data["ProductQty"] as? Int {
                                self.arrProduct[index].CartQty = productQty
                            }
                            if let qtyNotAvl = data["IsQtyNotAvailable"] as? Bool {
                                if qtyNotAvl == true {
                                    self.arrProduct[index].AvailableQty = Double(self.arrProduct[index].AvailableQty ?? 0.0)
                                }
                            }
                        }
                    }
                    self.collectionProduct.reloadData()
                    
                }) { (error) -> Void in
                    CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
}
