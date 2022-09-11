//
//  PersonalLoanCollectionCell.swift
//  LandMe
//
//  Created by vipul patel on 14/06/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit

class ProductImageCell: UICollectionViewCell {
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
 //
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CommonFunctions.setCornerRadius(view: viewBack, radius: 11)
       // viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 3)
        // Initialization code
    }

}
