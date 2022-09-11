//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit
import Kingfisher



class PramotionOrderCell: UITableViewCell {

   
    
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblPromotionText: UILabel!
    @IBOutlet weak var btnApply: UIButton!

    @IBOutlet weak var lblPromotionDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        CommonFunctions.setCornerRadius(view: btnApply, radius: 17)
        btnApply.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        
        lblCode.font = UIFont(name: Font_Bold, size: 20)
        lblPromotionText.font = UIFont(name: Font_Semibold, size: 15)
        lblPromotionDescription.font = UIFont(name: Font_Regular, size: 13)

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(_ index: Int, objHis : PramotionOrderModel){
        
        lblCode.text = objHis.Promocode
       
        lblPromotionText.text = objHis.PromotionText
        lblPromotionDescription.text = objHis.PromotionDescription

        
    }
    
    
    
    
    
    
}
