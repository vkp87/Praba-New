//
//  PersonalLoanCollectionCell.swift
//  LandMe
//
//  Created by vipul patel on 14/06/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit

class CartCell: UICollectionViewCell {
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOutofstock: UILabel!
    @IBOutlet weak var lblqtAvail: UILabel!
    @IBOutlet weak var imgPramotion: UIImageView! //15

    @IBOutlet weak var lblAmount: UILabel! //15
    @IBOutlet weak var lblOrAmount: UILabel! //15
    
    @IBOutlet weak var lblTitleType: UILabel! //10
    @IBOutlet weak var lblPramotion: UILabel! // 14

    @IBOutlet weak var lblQty: UILabel! //10
    @IBOutlet weak var lblTitleQty: UILabel! //10
    @IBOutlet weak var btnminus: UIButton! // 18
    @IBOutlet weak var btnplus: UIButton! // 18
    
    @IBOutlet weak var viewAdd: UIView!
    
    @IBOutlet weak var btnRemove: UIButton! // 18

   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CommonFunctions.setCornerRadius(view: viewBack, radius: 9)
        viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 2)

        btnRemove.titleLabel?.font = UIFont(name: Font_Semibold, size: 15)

        CommonFunctions.setCornerRadius(view: btnplus, radius: 20/2)
        CommonFunctions.setCornerRadius(view: btnminus, radius: 20/2)

        
        lblTitle.font = UIFont(name: Font_Semibold, size: 15)
        lblPramotion.font = UIFont(name: Font_Semibold, size: 14)

        lblAmount.font = UIFont(name: Font_Number, size: 24)
        lblOrAmount.font = UIFont(name: Font_Number, size: 24)

        lblTitleType.font = UIFont(name: Font_Regular, size: 13)
        lblQty.font = UIFont(name: Font_Regular, size: 14)
        lblTitleQty.font = UIFont(name: Font_Regular, size: 14)
        
        btnminus.titleLabel?.font = UIFont(name: Font_Regular, size: 18)
        btnplus.titleLabel?.font = UIFont(name: Font_Regular, size: 18)

        lblOutofstock.font = UIFont(name: Font_Semibold, size: 14)

        lblTitleType.adjustsFontSizeToFitWidth = true
        // Initialization code
    }

}
