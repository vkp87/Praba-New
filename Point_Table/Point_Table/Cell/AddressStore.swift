//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit



class AddressStore: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl0: UILabel!
    @IBOutlet weak var lbl2: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 3)
        lbl1.font = UIFont(name: Font_Semibold, size: 16)
        lbl2.font = UIFont(name: Font_Regular, size: 16)

        lbl0.font = UIFont(name: Font_Semibold, size: 15)

       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    
    
}
