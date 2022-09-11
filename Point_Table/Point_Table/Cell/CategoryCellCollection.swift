//
//  PersonalLoanCollectionCell.swift
//  LandMe
//
//  Created by vipul patel on 14/06/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit

class CategoryCellCollection: UICollectionViewCell {
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        CommonFunctions.setCornerRadius(view: viewBack, radius: 9)
        //viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 2)

        lblTitle.font = UIFont(name: Font_Regular, size: 13)

        // Initialization code
    }

}
