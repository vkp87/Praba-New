//
//  PersonalLoanCollectionCell.swift
//  LandMe
//
//  Created by vipul patel on 14/06/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lbloutofstock: UILabel!

    @IBOutlet weak var lblconstheight: NSLayoutConstraint! // 14

    @IBOutlet weak var lblAmount: UILabel! //15
    @IBOutlet weak var lblOrAmount: UILabel! //15
    @IBOutlet weak var imgPramotion: UIImageView! //15

    @IBOutlet weak var lblTitleType: UILabel! //10
    @IBOutlet weak var imgPriceMark: UIImageView!
    @IBOutlet weak var lblDisplayweight: UILabel! //10

    @IBOutlet weak var lblQty: UITextField! //10
    @IBOutlet weak var lblTitleQty: UILabel! //10
    @IBOutlet weak var btnminus: UIButton! // 18
    @IBOutlet weak var btnplus: UIButton! // 18
    
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var btnKg: UIButton! // 18
    @IBOutlet weak var btnItems: UIButton! // 18

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblPramotion: UILabel! // 14
    @IBOutlet weak var btnAddwishList: UIButton!
    @IBOutlet weak var constHeightamnt: NSLayoutConstraint!
    @IBOutlet weak var constTopamnt: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblQty.layer.cornerRadius = 11
        lblQty.layer.borderWidth = 1.5
        lblQty.layer.borderColor = UIColor.black.cgColor
        
       // lblPramotion.adjustsFontSizeToFitWidth = true
          CommonFunctions.setCornerRadius(view: viewBack, radius: 9)
        viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 2)
        
        //CommonFunctions.setCornerRadius(view: btnAdd, radius: 7)
        
        lblOrAmount.adjustsFontSizeToFitWidth = true
        CommonFunctions.setCornerRadius(view: btnplus, radius: 25/2)
        CommonFunctions.setCornerRadius(view: btnminus, radius: 25/2)
        
        lblPramotion.font = UIFont(name: Font_Semibold, size: 14)
        
        lblDisplayweight.font = UIFont(name: Font_Semibold, size: 16)
        
        lblTitle.font = UIFont(name: Font_Semibold, size: 14)
        lblAmount.font = UIFont(name: Font_Number, size: 24)
        lblOrAmount.font = UIFont(name: Font_Number, size: 18)
        
        lblTitleType.font = UIFont(name: Font_Regular, size: 13)
        lblQty.font = UIFont(name: Font_Regular, size: 14)
        lblTitleQty.font = UIFont(name: Font_Regular, size: 14)
        btnKg.titleLabel?.font = UIFont(name: Font_Regular, size: 16)
        btnItems.titleLabel?.font = UIFont(name: Font_Regular, size: 16)

        btnminus.titleLabel?.font = UIFont(name: Font_Regular, size: 18)
        btnplus.titleLabel?.font = UIFont(name: Font_Regular, size: 18)
       // btnAdd.titleLabel?.font = UIFont(name: Font_Regular, size: 14)
        
        lbloutofstock.font = UIFont(name: Font_Semibold, size: 14)
        
        lblTitleType.adjustsFontSizeToFitWidth = true
        
        // Initialization code
    }
    
}
