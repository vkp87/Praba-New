//
//  PersonalLoanCollectionCell.swift
//  LandMe
//
//  Created by vipul patel on 14/06/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit

class ProductCellCollection: UICollectionViewCell {
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    @IBOutlet weak var btnminus: UIButton! // 18
    @IBOutlet weak var btnplus: UIButton! // 18
    

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var viewCart: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        CommonFunctions.setCornerRadius(view: viewBack, radius: 9)
        CommonFunctions.setCornerRadius(view: btnAdd, radius: 13)
        btnAdd.titleLabel?.font = UIFont(name: Font_Regular, size: 14)

        lblName.font = UIFont(name: Font_Semibold, size: 13)
        lblPrice.font = UIFont(name: Font_Regular, size: 13)
        lblQty.font = UIFont(name: Font_Regular, size: 13)

        // Initialization code
    }

}
