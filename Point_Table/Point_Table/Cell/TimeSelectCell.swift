//
//  PersonalLoanCollectionCell.swift
//  LandMe
//
//  Created by vipul patel on 14/06/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit

class TimeSelectCell: UITableViewCell {
   
    
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblAnav: UILabel!


 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbltime.font = UIFont(name: Font_Mon_Regular, size: 16)
        lblAnav.font = UIFont(name: Font_Mon_Regular, size: 13)

        btnCheck.isUserInteractionEnabled = false
        
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
   
}
