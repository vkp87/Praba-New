//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit



class AddressCell: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl0: UILabel!

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var btnDefault: UIButton!

    @IBOutlet weak var constHeight: NSLayoutConstraint!
    @IBOutlet weak var constLeadingLbl0: NSLayoutConstraint!
    @IBOutlet weak var constLeadingLbl1: NSLayoutConstraint!
    @IBOutlet weak var constLeadingLbl2: NSLayoutConstraint!
    @IBOutlet weak var constLeadingLbl4: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CommonFunctions.setCornerRadius(view: btnChange, radius: 10)
        CommonFunctions.setBorder(view: btnChange, color: Theme_Color, width: 1)
        CommonFunctions.setCornerRadius(view: viewBack, radius: 7)
        viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 3)
        lbl1.font = UIFont(name: Font_Semibold, size: 16)
        lbl2.font = UIFont(name: Font_Regular, size: 15)
        lbl4.font = UIFont(name: Font_Regular, size: 15)

        lbl0.font = UIFont(name: Font_Semibold, size: 15)

       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(_ index: Int, objHis : AddressModel){
      
        
        lbl1.text = "\(objHis.FirstName ?? "") \(objHis.LastName ?? "")"
        
        lbl2.text = "\(objHis.StreetAddress1 ?? ""), \(objHis.StreetAddress2 ?? ""), \(objHis.Town ?? ""), \(objHis.PostCode ?? "")"
        lbl4.text = "Phone : \(objHis.MobileNo ?? "")"

        
    }
    
    
    
    
    
    
}
