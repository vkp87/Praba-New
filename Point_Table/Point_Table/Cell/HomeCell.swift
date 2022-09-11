//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit
import Kingfisher

protocol HomeCellDelegate : class {
    func delegateMemberClicked(_ sender: HomeCell)
    func delegateImageClicked(_ sender: HomeCell)

    func delegateTransactionClicked(_ sender: HomeCell)
    func delegateWishClicked(_ sender: HomeCell)
    func delegatePramotionClicked(_ sender: HomeCell)
    func delegateProductClicked(_ sender: HomeCell, btn : UIButton)
    func delegateZipClicked(_ sender: HomeCell)

}

class HomeCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

   
    @IBOutlet weak var lblpointval: UILabel!
    @IBOutlet weak var lblavailbleval: UILabel!
    @IBOutlet weak var viewSep: UIView!

    @IBOutlet weak var imgBarcode: UIImageView!
    @IBOutlet weak var lblLoginTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblpoint: UILabel!
    @IBOutlet weak var lblmembertitle: UILabel!
    @IBOutlet weak var lblpointrs: UILabel!
    @IBOutlet weak var lblbalence: UILabel!
    @IBOutlet weak var pagecontrol: UIPageControl!

    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var lblWish: UILabel!
    @IBOutlet weak var lblProduct: UILabel!

    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgProfileback: UIImageView!
    @IBOutlet weak var lblSpecialOffer: UILabel!

    weak var delegate: HomeCellDelegate?

    var arrAdver = [Advertisement]()
   
    @IBOutlet weak var viewWish: UIView!
    @IBOutlet weak var imgBackWish: UIImageView!
    @IBOutlet weak var imgWish: UIImageView!
    
    
    @IBOutlet weak var viewProduct: UIView!
    @IBOutlet weak var imgBackProduct: UIImageView!
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblZip: UILabel!

    @IBOutlet weak var btnmember: UIButton!
    
    @IBOutlet weak var constTop1: NSLayoutConstraint! // 55
    @IBOutlet weak var constTop2: NSLayoutConstraint! // 65
  @IBOutlet weak var constHeight: NSLayoutConstraint!

    @IBOutlet weak var constShopHeight: NSLayoutConstraint! // 80
      @IBOutlet weak var constWishHeight: NSLayoutConstraint! // 80

    var cellVc = UIViewController()
    
    var advTimer: Timer?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if DeviceType.isPad {
            
            constHeight.constant = 225
                      constTop1.constant = 55 + 100
                      constTop2.constant = 65 + 100
            
            constShopHeight.constant = 100
                    constWishHeight.constant = 100
            
            lblWish.font = UIFont(name: Font_Regular, size: 22)
                       lblProduct.font = UIFont(name: Font_Regular, size: 22)
            lblZip.font = UIFont(name: Font_Regular, size: 22)

           
            
            imgBackProduct.image = UIImage(named: "home-round-imgipad");
            imgBackWish.image = UIImage(named: "home-round-imgipad");
            
            imgProduct.image = UIImage(named: "productipad");
            imgWish.image = UIImage(named: "wishlistipad");
            lblSpecialOffer.font = UIFont(name: Font_Regular, size: 22)

        } else {
            
            constHeight.constant = 115
                    constTop1.constant = 55
                    constTop2.constant = 65
            
            constShopHeight.constant = 80
                      constWishHeight.constant = 80
            
            lblZip.font = UIFont(name: Font_Regular, size: 17)
            lblWish.font = UIFont(name: Font_Regular, size: 17)
                       lblProduct.font = UIFont(name: Font_Regular, size: 17)
            lblSpecialOffer.font = UIFont(name: Font_Regular, size: 17)

           

            imgBackProduct.image = UIImage(named: "home-round-img");
            imgBackWish.image = UIImage(named: "home-round-img");
            
            imgProduct.image = UIImage(named: "product");
            imgWish.image = UIImage(named: "wishlist");
        }
       

        
      //  CommonFunctions.setCornerRadius(view: viewTerm, radius: 18)
       // CommonFunctions.setCornerRadius(view: viewWish, radius: 18)
       // CommonFunctions.setCornerRadius(view: viewPramo, radius: 18)
       // CommonFunctions.setCornerRadius(view: viewProduct, radius: 18)
        
        
//        viewTerm.backgroundColor = UIColor.white
//        viewWish.backgroundColor = UIColor.white
//        viewPramo.backgroundColor = UIColor.white
//        viewProduct.backgroundColor = UIColor.white
//
//        viewTerm.dropShadow1(color: Theme_Color, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
//        viewWish.dropShadow1(color: Theme_Color, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
//        viewPramo.dropShadow1(color: Theme_Color, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
//        viewProduct.dropShadow1(color: Theme_Color, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)

      //  CommonFunctions.setBorder(view: viewTerm, color: Theme_Color, width: 1.0)
        //CommonFunctions.setBorder(view: viewWish, color: Theme_Color, width: 1.0)
       // CommonFunctions.setBorder(view: viewPramo, color: Theme_Color, width: 1.0)
      //  CommonFunctions.setBorder(view: viewProduct, color: Theme_Color, width: 1.0)
        
        
        
        
        
        collectionV.register(UINib(nibName: "AdverticementCell", bundle: nil), forCellWithReuseIdentifier: "AdverticementCell")
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.isPagingEnabled = true
        collectionV.backgroundColor = UIColor.clear

        CommonFunctions.setCornerRadius(view: imgProfileback, radius: 60)

        CommonFunctions.setCornerRadius(view: imgProfile, radius: 50)
        CommonFunctions.setBorder(view: imgProfile, color: Theme_Color, width: 1.0)
        
        
        imgProfile.image = UIImage(named: "imgprofile")

        CommonFunctions.setCornerRadius(view: btnmember, radius: 18)

        lblName.font = UIFont(name: Font_Mon_Regular, size: 18)
        lblmembertitle.font = UIFont(name: Font_Mon_Regular, size: 15)
        lblpointrs.font = UIFont(name: Font_Semibold, size: 12)
        
       
        
        lblpointval.font = UIFont(name: Font_Regular, size: 14)
        lblavailbleval.font = UIFont(name: Font_Regular, size: 14)
        
        lblbalence.font = UIFont(name: Font_Regular, size: 15)
        lblpoint.font = UIFont(name: Font_Regular, size: 15)

        advTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changeAdvertise), userInfo: nil, repeats: true)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(_ index: Int, Name: String, point : String, pointrs: String,  balence : String){
        
        lblName.text = Name
        lblpointval.text = point
        lblpointrs.text = pointrs
        lblavailbleval.text = balence
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
    
    func setupCollectionCell(){
        
        if arrAdver.count > 0
        {
            
            collectionV.delegate = self
            collectionV.dataSource = self
            collectionV.reloadData()
            
        }
        
        if arrAdver.count == 1
        {
            pagecontrol.isHidden = true
        }
        
        if arrAdver.count == 0
        {
            pagecontrol.isHidden = true

        } else {
            pagecontrol.isHidden = false

        }
        if arrAdver.count == 0
        {
            pagecontrol.numberOfPages = 0

        } else {
        pagecontrol.numberOfPages = arrAdver.count
        }
        
    }

    
    //MARK: - Button Clicked
    
    @IBAction func btnZipclicked(_ sender: UIButton) {
        self.delegate?.delegateZipClicked(self)
    }
    
    @IBAction func btnImageClicked(_ sender: UIButton) {
              self.delegate?.delegateImageClicked(self)
          }
    @IBAction func btnMemberClicked(_ sender: UIButton) {
        self.delegate?.delegateMemberClicked(self)
    }
    
    @IBAction func btnTransactionClicked(_ sender: UIButton) {
        self.delegate?.delegateTransactionClicked(self)
    }
    
    @IBAction func btnPramotionClicked(_ sender: UIButton) {
        self.delegate?.delegatePramotionClicked(self)
    }
    @IBAction func btnProductClicked(_ sender: UIButton) {
        self.delegate?.delegateProductClicked(self, btn: sender)
    }
    
    @IBAction func btnWishClicked(_ sender: UIButton) {
        self.delegate?.delegateWishClicked(self)
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
        
      //  print(indexPath)
    pagecontrol.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arrAdver.count == 0 {
            return 0
        }
        return arrAdver.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.width, height: 200)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
