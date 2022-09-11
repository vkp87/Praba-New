//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit



class SearchProduct: UITableViewCell {

   
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblBrand: UILabel!

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblOutOfStock: UILabel!
    @IBOutlet weak var lblPramotion: UILabel!
    @IBOutlet weak var lblOrAmount: UILabel!
    @IBOutlet weak var imgPricemark: UIImageView!
    @IBOutlet weak var imgPramotion: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
//
        lblAmount.font = UIFont(name: Font_Number, size: 20)
       // lblAmount.adjustsFontSizeToFitWidth = true
        lblName.font = UIFont(name: Font_Semibold, size: 17)
        lblSize.font = UIFont(name: Font_Regular, size: 15)
        lblBrand.font = UIFont(name: Font_Regular, size: 15)
        lblOutOfStock.font = UIFont(name: Font_Regular, size: 15)
        lblOrAmount.font = UIFont(name: Font_Number, size: 20)
        lblPramotion.font = UIFont(name: Font_Semibold, size: 14)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
}
