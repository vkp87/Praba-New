//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit
import Kingfisher

protocol HomeProfileCellDelegate : class {
    func delegateMemberClicked(_ sender: HomeProfileCell)
    func delegateImageClicked(_ sender: HomeProfileCell)



}

class HomeProfileCell: UITableViewCell {

   
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!

    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var btnmember: UIButton!
    weak var delegate: HomeProfileCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        

        CommonFunctions.setCornerRadius(view: imgProfile, radius: 35)
        CommonFunctions.setBorder(view: imgProfile, color: Theme_Color, width: 1.0)
        
        
        imgProfile.image = UIImage(named: "imgprofile")

        CommonFunctions.setCornerRadius(view: btnmember, radius: 11)

        lblName.font = UIFont(name: Font_Mon_Semibold, size: 18)
        lblEmail.font = UIFont(name: Font_Regular, size: 17)

        
        CommonFunctions.setBorder(view: btnmember, color: UIColor.black, width: 1.0)
        
        
        btnmember.titleLabel?.font = UIFont(name: Font_Mon_Semibold, size: 15)

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    //MARK: - Button Clicked
    
 
    
    @IBAction func btnImageClicked(_ sender: UIButton) {
              self.delegate?.delegateImageClicked(self)
          }
    @IBAction func btnMemberClicked(_ sender: UIButton) {
        self.delegate?.delegateMemberClicked(self)
    }
    
   
   
    
    
    
}
