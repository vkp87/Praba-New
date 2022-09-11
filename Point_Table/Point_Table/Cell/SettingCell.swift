//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit
import Kingfisher



class SettingCell: UITableViewCell {

   
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchFinger: UISwitch!
    @IBOutlet weak var lblTitle1: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
      
        lblTitle.font = UIFont(name: Font_Regular, size: 17)
        lblTitle1.font = UIFont(name: Font_Regular, size: 17)

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
