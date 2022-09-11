//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit



class OrderPromoCode: UITableViewCell {
 
    @IBOutlet weak var viewBack: UIView!


    @IBOutlet weak var btnPromocode: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnPromocode.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)

        
        CommonFunctions.setCornerRadius(view: btnPromocode, radius: 5)
       // viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 3)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(_ index: Int, objHis : TransactionHistory){
//        lblSubTotal.text = objHis.BusinessName
//        lblDiscount.text = "Point Balance"
//        lblTax.text = objHis.TypeText
//        lblDeliveryCharges.text = objHis.OperationDate
//        lblTotal.text = 
        
    }
    
}
