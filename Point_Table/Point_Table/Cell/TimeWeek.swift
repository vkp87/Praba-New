//
//  PersonalLoanCollectionCell.swift
//  LandMe
//
//  Created by vipul patel on 14/06/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit

class TimeWeek: UICollectionViewCell {
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!

 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CommonFunctions.setCornerRadius(view: viewBack, radius: 7)

        lblDay.font = UIFont(name: Font_Mon_Semibold, size: 17)
        lblDate.font = UIFont(name: Font_Mon_Regular, size: 14)

        // Initialization code
    }

}
