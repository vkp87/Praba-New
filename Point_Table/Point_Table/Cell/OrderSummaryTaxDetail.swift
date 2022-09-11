//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit



class OrderSummaryTaxDetail: UITableViewCell {

   
    
    
    
    
    
    
    
    @IBOutlet weak var viewBack3: UIView!
    
    @IBOutlet weak var lblFinalAmount: UILabel!
    @IBOutlet weak var lblTaxAmount: UILabel!
    @IBOutlet weak var lblTaxPercentage: UILabel!
    @IBOutlet weak var lblWithoutTaxAmount: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        


CommonFunctions.setCornerRadius(view: viewBack3, radius: 11)

        
        lblFinalAmount.font = UIFont(name: Font_Regular, size: 17)
        lblTaxAmount.font = UIFont(name: Font_Regular, size: 17)
        lblTaxPercentage.font = UIFont(name: Font_Regular, size: 17)
        lblWithoutTaxAmount.font = UIFont(name: Font_Regular, size: 17)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
   
    
    
    
    
}
