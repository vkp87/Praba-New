//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit



class ThirdPartyCell: UITableViewCell {

   
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLink: UILabel!
   

    

    override func awakeFromNib() {
        super.awakeFromNib()
        




        
        lblName.font = UIFont(name: Font_Regular, size: 17)
        lblLink.font = UIFont(name: Font_Regular, size: 15)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
   
    
    
    
    
}
