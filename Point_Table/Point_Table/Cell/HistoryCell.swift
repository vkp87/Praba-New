//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit



class HistoryCell: UITableViewCell {

   
    
    @IBOutlet weak var lblShopname: UILabel!
    @IBOutlet weak var lblPointbalenceval: UILabel!

    @IBOutlet weak var lblPointbalence: UILabel!
    @IBOutlet weak var lblTypetext: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewBack: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        CommonFunctions.setCornerRadius(view: viewBack, radius: 11)
        viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 2)

        
        lblShopname.font = UIFont(name: Font_Regular, size: 15)
        lblPointbalence.font = UIFont(name: Font_Regular, size: 13)
        lblPointbalenceval.font = UIFont(name: Font_Mon_Semibold, size: 20)

        lblTypetext.font = UIFont(name: Font_Regular, size: 12)
        lblDate.font = UIFont(name: Font_Regular, size: 11)

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(_ index: Int, objHis : TransactionHistory){
        
        lblShopname.text = objHis.BusinessName
        lblPointbalence.text = "Point Balance"
        lblTypetext.text = objHis.TypeText
        lblDate.text = objHis.OperationDate
        
        if objHis.TypeText == "Debited" {
            lblPointbalenceval.text = "- \(objHis.PointBalance!)"
            lblPointbalenceval.textColor = UIColor.red

        } else {
            if objHis.TypeText == "Point Redeemed" {
                lblPointbalenceval.text = "- \(objHis.PointBalance!)"
                lblPointbalenceval.textColor = UIColor.red

            } else {
                lblPointbalenceval.text = "+ \(objHis.PointBalance!)"
                lblPointbalenceval.textColor = Theme_green_Color

            }
        }
        

        if objHis.TypeText == "Debited" {
           lblTypetext.textColor = UIColor.red
        } else {
            if objHis.TypeText == "Point Redeemed" {
                lblTypetext.textColor = UIColor.red

            } else {
            lblTypetext.textColor = Theme_green_Color
            }
        }
        
        
        
    }
    
    
    
    
    
    
}
