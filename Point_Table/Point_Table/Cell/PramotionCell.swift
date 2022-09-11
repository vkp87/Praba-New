//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit
import Kingfisher



class PramotionCell: UITableViewCell {

   
    
    @IBOutlet weak var lblBusinessName: UILabel!

    @IBOutlet weak var lblPromotionText: UILabel!
    @IBOutlet weak var imgPramotion: UIImageView!

    @IBOutlet weak var viewBack: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
       // CommonFunctions.setCornerRadius(view: viewBack, radius: 16)
       // viewBack.dropShadow(color: UIColor.black, opacity: 0.5, radius: 3)
        CommonFunctions.setCornerRadius(view: imgPramotion, radius: 16)

        lblBusinessName.font = UIFont(name: Font_Bold, size: 19)
        lblPromotionText.font = UIFont(name: Font_Semibold, size: 17)

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(_ index: Int, objHis : PramotionModel){
        
        lblBusinessName.text = objHis.BusinessName
       
        lblPromotionText.text = objHis.PromotionText

       imgPramotion.kf.indicatorType = .activity
        imgPramotion.kf.setImage(
            with: URL(string: objHis.PromotionImage!),
            placeholder: UIImage(named: ""),
            options: [.transition(.fade(0.2))],
            progressBlock: { receivedSize, totalSize in
        },
            completionHandler: { result in
                print(result)
        }
        )
        
    }
    
    
    
    
    
    
}
