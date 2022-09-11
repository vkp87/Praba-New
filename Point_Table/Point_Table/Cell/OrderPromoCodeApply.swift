//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit



class OrderPromoCodeApply: UITableViewCell {
 
    @IBOutlet weak var viewBack: UIView!


    @IBOutlet weak var lblPromo: UILabel!
    @IBOutlet weak var lblPromodes: UILabel!

    @IBOutlet weak var btnClean: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnClean.titleLabel?.font = UIFont(name: Font_Semibold, size: 14)
        lblPromo.font = UIFont(name: Font_Bold, size: 18)
        lblPromodes.font = UIFont(name: Font_Regular, size: 15)

        
        viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 3)
        
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
