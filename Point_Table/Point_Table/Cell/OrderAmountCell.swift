//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit



class OrderAmountCell: UITableViewCell {
    
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDeliveryCharges: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var viewBack: UIView!

    @IBOutlet weak var lblTitleDelivery: UILabel!

    @IBOutlet weak var constTitle: NSLayoutConstraint!
    @IBOutlet weak var constValue: NSLayoutConstraint!
    @IBOutlet weak var constTitleTop: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //CommonFunctions.setCornerRadius(view: viewBack, radius: 5)
        viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 2)
        
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
