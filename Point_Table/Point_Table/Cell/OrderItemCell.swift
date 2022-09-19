//
//  PersonalLoanCollectionCell.swift
//  LandMe
//
//  Created by vipul patel on 14/06/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit

class OrderItemCell: UITableViewCell {
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPramotion: UILabel!
    @IBOutlet weak var imgPramotion: UIImageView!

    @IBOutlet weak var lblmincartmsg: UILabel!
    @IBOutlet weak var lblApprox: UILabel!

    @IBOutlet weak var lblAmount: UILabel! //15
    @IBOutlet weak var lblTitleType: UILabel! //10
    @IBOutlet weak var lblQty: UILabel! //10
    @IBOutlet weak var lblTitleQty: UILabel! //10

    override func awakeFromNib() {
        super.awakeFromNib()
        
        CommonFunctions.setCornerRadius(view: viewBack, radius: 9)
        viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 2)
        lblmincartmsg.font = UIFont(name: Font_Regular, size: 12)

        lblPramotion.font = UIFont(name: Font_Semibold, size: 14)

        lblTitle.font = UIFont(name: Font_Semibold, size: 15)
        lblAmount.font = UIFont(name: Font_Semibold, size: 13)
        lblApprox.font = UIFont(name: Font_Regular, size: 13)

        lblTitleType.font = UIFont(name: Font_Regular, size: 13)
        lblQty.font = UIFont(name: Font_Regular, size: 14)
        lblTitleQty.font = UIFont(name: Font_Regular, size: 14)
        lblTitleType.adjustsFontSizeToFitWidth = true
        // Initialization code
    }

}
