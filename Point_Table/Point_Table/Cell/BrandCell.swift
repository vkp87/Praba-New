//
//  BLPatientRecordCell.swift
//  BilliyoClinicalHealth
//
//  Created by Jatin Rathod on 07/04/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
//protocol BLChecklistCellDelegate : class {
//    func ChecklistComplete(_ sender: BLChecklist)
//    func ChecklistNotApplicable(_ sender: BLChecklist)
//
//}
class BrandCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgCheck: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont(name: Font_Mon_Regular, size: 17)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
      //  delegate?.ChecklistComplete(self)
   
}
