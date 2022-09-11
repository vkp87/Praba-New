//
//  BLPatientRecordCell.swift
//  BilliyoClinicalHealth
//
//  Created by Jatin Rathod on 07/04/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
protocol ImageCellDelegate : class {
    
    func delegateSelectImage(_ obj : String, intIndex : Int)
    
}
class ProductDetailCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var lblTitle: UILabel!
    weak var delegate: ImageCellDelegate?
    @IBOutlet weak var lblDisplayweight: UILabel! //10

    @IBOutlet weak var lblPrize: UILabel!
    @IBOutlet weak var lblQtytitle: UILabel!
    @IBOutlet weak var lblQty: UITextField!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnKg: UIButton!
    @IBOutlet weak var btnItem: UIButton!

    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var lblDescTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblBrandname: UILabel!
    
    @IBOutlet weak var lblAdd: UILabel! // 14
    
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var collectionV: UICollectionView!
    
    @IBOutlet weak var btnAddWish: UIButton!
    @IBOutlet weak var lblPramotion: UILabel! // 14
    
    @IBOutlet weak var imgPriceMark: UIImageView! // 14

    var arrData = [[String:Any]]()
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var imgFav: UIImageView!

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDesc: UIButton!
    @IBOutlet weak var btnBrand: UIButton!
    @IBOutlet weak var imgPramotion: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblAdd.font = UIFont(name: Font_Regular, size: 15)
        btnAdd.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)

        collectionV.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "ProductImageCell")
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.isPagingEnabled = true
        collectionV.backgroundColor = UIColor.clear
        
        lblPramotion.font = UIFont(name: Font_Semibold, size: 14)

        lblDisplayweight.font = UIFont(name: Font_Semibold, size: 14)

        lblTitle.font = UIFont(name: Font_Mon_Regular, size: 17)
        
        lblPrize.font = UIFont(name: Font_Number, size: 17)
        
        lblQtytitle.font = UIFont(name: Font_Mon_Regular, size: 15)
        
        lblAvailable.font = UIFont(name: Font_Mon_Semibold, size: 15)
        
        
        lblQty.font = UIFont(name: Font_Mon_Regular, size: 15)
        
        btnMinus.titleLabel?.font = UIFont(name: Font_Regular, size: 18)
        btnPlus.titleLabel?.font = UIFont(name: Font_Regular, size: 18)
        lblDesc.font = UIFont(name: Font_Mon_Regular, size: 14)
        lblBrandname.font = UIFont(name: Font_Mon_Regular, size: 14)
        
        
        lblDescTitle.font = UIFont(name: Font_Mon_Regular, size: 17)
        lblBrand.font = UIFont(name: Font_Mon_Regular, size: 17)
        
        btnAddWish.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        
        
        
        CommonFunctions.setCornerRadius(view: btnAddWish, radius: 15)
        
        
        CommonFunctions.setCornerRadius(view: btnPlus, radius: 30/2)
        CommonFunctions.setCornerRadius(view: btnMinus, radius: 30/2)
        
        
        CommonFunctions.setCornerRadius(view: btnAdd, radius: 17)
        
        // Initialization code
    }
    
    func setupTable(dict : [String:Any]){
        
        lblTitle.text = dict["ProductName"] as? String
        if dict["ProductSize"] as! Double == 0 {
            self.attributetext(lbl1: lblTitle, main: dict["ProductName"] as! String, sub: "")
        } else {
            self.attributetext(lbl1: lblTitle, main: dict["ProductName"] as! String, sub: "(\(dict["ProductSize"] ?? 0) \(dict["ProductSizeType"] ?? ""))")
        }
        
        var symboll = ""
        if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
            symboll = symbol
        }
        
        let str =  CommonFunctions.appendString(data: dict["Price"] as! Double)
        lblPrize.text = "\(symboll) \(str)"
        
        if dict["ProductType"] as! Int > 0 {
            //Show kg with price
            
            
            
            let strPrice = "\(lblPrize.text!)/ \(dict["ProductSizeType"] as! String)"
            lblPrize.text = strPrice

            
        }
        
        // lblQty.text = "\(dict["AvailableQty"] as! Int)"
        lblQty.text = "1"
        lblAvailable.textColor = Theme_Color

        if let IsLowQty = dict["IsLowQty"] as? Bool
        {
            if IsLowQty == true {
                lblAvailable.textColor = UIColor.orange

            } else {
                lblAvailable.textColor = Theme_green_Color

            }
            
        }
        
        lblAvailable.text = "Available Stocks : \(dict["AvailableQty"] as! Double)"
    }
    
    func setupCollectionCell() {
        
        if arrData.count > 0
        {
            
            collectionV.delegate = self
            collectionV.dataSource = self
            collectionV.reloadData()
            
        }
        
        if arrData.count == 1
        {
            pagecontrol.isHidden = true
        }
        pagecontrol.numberOfPages = arrData.count
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func attributetext(lbl1: UILabel, main : String, sub : String) {
        let main_string = main + " " + sub
        
        let sub_string = sub
        let range = (main_string as NSString).range(of: sub_string)
        let mainrange = (main_string as NSString).range(of: main_string)
        
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttributes([NSAttributedString.Key.font: UIFont(name: Font_Semibold, size: 16) as Any], range: mainrange)
        
        attribute.addAttributes([NSAttributedString.Key.font: UIFont(name: Font_Regular, size: 14) as Any], range: range)
        
        lbl1.attributedText = attribute
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
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.width - 40, height: 150)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ProductImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath as IndexPath) as! ProductImageCell
        
        cell.imgView.kf.indicatorType = .activity
        cell.imgView.kf.setImage(
            with: URL(string: arrData[indexPath.row]["ProductImage"] as! String),
            placeholder: UIImage(named: "placeholder"),
            options: [.transition(.fade(0.2))],
            progressBlock: { receivedSize, totalSize in
                // print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
        },
            completionHandler: { result in
                // print(result)
                //print("\(indexPath.row + 1): Finished")
        }
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.delegateSelectImage(arrData[indexPath.row]["ProductImage"] as! String, intIndex: indexPath.row)

    }
}
