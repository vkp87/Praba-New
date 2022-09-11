//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit



class OrderSummaryDetail: UITableViewCell {

   
    @IBOutlet weak var viewBack0: UIView!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!

    
    @IBOutlet weak var viewBack1: UIView!
    @IBOutlet weak var viewAddConst: NSLayoutConstraint!
    @IBOutlet weak var lblAddConst: NSLayoutConstraint!

    

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!

    @IBOutlet weak var lblHeadertitle: UILabel!

    @IBOutlet weak var viewBack2: UIView!
    @IBOutlet weak var lblOrderno: UILabel!
    @IBOutlet weak var lblPaymentoption: UILabel!
    @IBOutlet weak var lblOrderitem: UILabel!
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblDeliverycharges: UILabel!
    
    
    @IBOutlet weak var lblOrdernoval: UILabel!
    @IBOutlet weak var lblPaymentoptionval: UILabel!
    @IBOutlet weak var lblOrderitemval: UILabel!
    @IBOutlet weak var lblSubtotalval: UILabel!
    @IBOutlet weak var lblDeliverychargesval: UILabel!
    @IBOutlet weak var lblTotalval: UILabel!
    @IBOutlet weak var lblDiscountVal: UILabel!

    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblPromo: UILabel!
    @IBOutlet weak var lblPromocode: UILabel!

    
    @IBOutlet weak var lblDiscount: UILabel!
    
    @IBOutlet weak var lblHeaderAddress: UILabel!
    @IBOutlet weak var lblHeaderTax: UILabel!
    @IBOutlet weak var lblHeaderDelivery: UILabel!

    
    @IBOutlet weak var lblFinalAmount: UILabel!
    @IBOutlet weak var lblTaxAmount: UILabel!
    @IBOutlet weak var lblTaxPercentage: UILabel!
    @IBOutlet weak var lblWithoutTaxAmount: UILabel!

    @IBOutlet weak var viewBack3: UIView!
    @IBOutlet weak var viewPaymentConst: NSLayoutConstraint! // 255
    @IBOutlet weak var lblPaymentConst: NSLayoutConstraint! // 30
    @IBOutlet weak var lblPaymentConstVal: NSLayoutConstraint! // 30

    override func awakeFromNib() {
        super.awakeFromNib()
        
        CommonFunctions.setCornerRadius(view: viewBack1, radius: 11)

        CommonFunctions.setCornerRadius(view: viewBack2, radius: 11)
        
        CommonFunctions.setCornerRadius(view: viewBack0, radius: 11)
        CommonFunctions.setCornerRadius(view: viewBack3, radius: 11)


       // viewBack1.dropShadow(color: Theme_Color, opacity: 0.5, radius: 11)

       // viewBack2.dropShadow(color: Theme_Color, opacity: 0.5, radius: 11)
        
        lbl1.font = UIFont(name: Font_Regular, size: 17)
        lbl2.font = UIFont(name: Font_Regular, size: 17)
        lbl3.font = UIFont(name: Font_Regular, size: 17)
        lbl4.font = UIFont(name: Font_Regular, size: 17)


        lblAddress.font = UIFont(name: Font_Regular, size: 17)
        lblPhone.font = UIFont(name: Font_Regular, size: 17)
        
        lblPromo.font = UIFont(name: Font_Regular, size: 17)
        lblPromocode.font = UIFont(name: Font_Regular, size: 17)

        
        lblOrderno.font = UIFont(name: Font_Regular, size: 17)
        lblPaymentoption.font = UIFont(name: Font_Regular, size: 17)
        lblOrderitem.font = UIFont(name: Font_Regular, size: 17)
        lblSubtotal.font = UIFont(name: Font_Regular, size: 17)
        lblDeliverycharges.font = UIFont(name: Font_Regular, size: 17)
        lblDiscount.font = UIFont(name: Font_Regular, size: 17)
        lblTotal.font = UIFont(name: Font_Regular, size: 17)

        lblHeadertitle.font = UIFont(name: Font_Regular, size: 17)
        lblHeaderAddress.font = UIFont(name: Font_Regular, size: 17)

        lblHeaderTax.font = UIFont(name: Font_Regular, size: 17)
        
        lblHeaderDelivery.font = UIFont(name: Font_Regular, size: 17)
        
        lblFinalAmount.font = UIFont(name: Font_Semibold, size: 14)
        lblTaxAmount.font = UIFont(name: Font_Semibold, size: 14)
        lblTaxPercentage.font = UIFont(name: Font_Semibold, size: 14)
        lblWithoutTaxAmount.font = UIFont(name: Font_Semibold, size: 14)

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
   
    
    
    
    
}
