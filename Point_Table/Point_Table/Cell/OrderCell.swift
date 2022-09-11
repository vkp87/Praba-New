//
//  TextTableViewCell.swift
//  LandMe
//
//  Created by vipul patel on 02/07/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit
import Kingfisher



class OrderCell: UITableViewCell {

   
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblInvoiceNumber: UILabel!

    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblItemcount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var btnre: UILabel!

    @IBOutlet weak var btnRepOrder: UIButton!

    
    @IBOutlet weak var viewBack: UIView!
    var symboll = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let symbol =  CommonFunctions.getUserDefault(key:UserDefaultsKey.Currency) as? String {
            symboll = symbol
        }
        
        viewBack.dropShadow(color: Theme_Color, opacity: 0.5, radius: 3)

        lblDate.font = UIFont(name: Font_Bold, size: 17)
        lblInvoiceNumber.font = UIFont(name: Font_Semibold, size: 15)
        lblTotal.font = UIFont(name: Font_Regular, size: 15)
        lblShopName.font = UIFont(name: Font_Regular, size: 15)
        lblItemcount.font = UIFont(name: Font_Regular, size: 15)
        lblStatus.font = UIFont(name: Font_Regular, size: 15)

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
    func setupCell(_ index: Int, objHis : OrderModel){
        
        lblDate.text = objHis.TransactionDate!
        lblInvoiceNumber.text = objHis.InvoiceNumber!
        lblTotal.text = "\(symboll) \(CommonFunctions.appendString(data: objHis.TotalAmount!))"
        lblShopName.text = objHis.ShopName!
        lblItemcount.text = "Item : \(objHis.ItemCount!)"
        let strStatus = objHis.OrderStatusText
        if strStatus == "Placed" {
            lblStatus.textColor = UIColor.gray
        } else if strStatus == "Payment Failed" {
            lblStatus.textColor = UIColor.red
        } else if strStatus == "Payment Pending" {
            lblStatus.textColor = UIColor.orange
        }
        lblStatus.text = "\(objHis.OrderStatusText!)"

    }
    
    
    
    
}
