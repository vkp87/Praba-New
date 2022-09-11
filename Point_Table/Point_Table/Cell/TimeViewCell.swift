//
//  PersonalLoanCollectionCell.swift
//  LandMe
//
//  Created by vipul patel on 14/06/18.
//  Copyright © 2018 vipul patel. All rights reserved.
//

import UIKit
protocol TimeViewCellDelegate : class {
   
    func delegateSelectSlot(_ obj : [String:Any], isselect : Bool, intIndex : Int)
    
}
class TimeViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate {
   
    
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblHeader: UILabel!

    
    weak var delegate: TimeViewCellDelegate?

    
    var intIndex = -1;
    
    var SlotId  = -1;
    
    var arrSlot = [[String:Any]]()

    var arrTimeSlot = [[String:Any]]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblHeader.text = "Choose delivery slot for this address"
        
        tblView.register(UINib(nibName: "TimeSelectCell", bundle: nil), forCellReuseIdentifier:"TimeSelectCell")
        tblView.backgroundColor = UIColor.clear

        collectionV.register(UINib(nibName: "TimeWeek", bundle: nil), forCellWithReuseIdentifier: "TimeWeek")
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.isPagingEnabled = false
        collectionV.backgroundColor = UIColor.clear
        
        lblHeader.font = UIFont(name: Font_Mon_Semibold, size: 14)

        
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setupCollectionCell(deliveryType: Int){
        
        if arrSlot.count > 0
        {
            
            intIndex = 0;
            if deliveryType == 1 {
                lblHeader.text = "Choose collection slot"
            } else {
                lblHeader.text = "Choose delivery slot for this address"
            }
            arrTimeSlot = arrSlot[intIndex]["lstSlotDetail"] as! [[String:Any]]
            
            collectionV.delegate = self
            collectionV.dataSource = self
            collectionV.reloadData()
            tblView.delegate = self
            tblView.dataSource = self
            tblView.reloadData()
            
        }
   
        
    }
    
    //MARK: - UICollectionView Delegate & DataSource ----
    
    public func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSlot.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 60)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : TimeWeek = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeWeek", for: indexPath as IndexPath) as! TimeWeek
        
        
        if(intIndex == indexPath.row) {
            cell.viewBack.borderColor = Theme_Color
            cell.viewBack.borderWidth = 1.0;

            cell.lblDate.textColor = UIColor.black
            cell.lblDay.textColor = UIColor.black

        } else {
            cell.viewBack.borderColor = UIColor.white
            cell.viewBack.borderWidth = 0.0

            cell.lblDate.textColor = UIColor.black
            cell.lblDay.textColor = UIColor.black
        }
        cell.lblDay.text = arrSlot[indexPath.row]["DayText"] as? String
        cell.lblDate.text = arrSlot[indexPath.row]["SlotDateText"] as? String;
        
      
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)

        
        {
            
            SlotId = -1
            intIndex = indexPath.row
            
            if arrSlot.count > 0 {
                collectionView.reloadData()

            arrTimeSlot = arrSlot[intIndex]["lstSlotDetail"] as! [[String:Any]]
            self.tblView.reloadData()
            
            self.delegate?.delegateSelectSlot(arrTimeSlot[0], isselect: false, intIndex: indexPath.row)
            }
            
            
        

    }
    
    
    // MARK: - UITableview Delegate & Datasource

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSelectCell", for: indexPath) as! TimeSelectCell
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        
        
        cell.lbltime.attributedText = NSAttributedString(string: (arrTimeSlot[indexPath.row]["SlotText"] as! String))
        
        
        cell.lblAnav.isHidden = true

        
        if arrTimeSlot[indexPath.row]["IsAvailalbe"] as! Bool == false {
            cell.lbltime.attributedText = (arrTimeSlot[indexPath.row]["SlotText"] as! String).strikeThrough()
            cell.lblAnav.isHidden = false

        }
        cell.btnCheck.setImage(UIImage(named: "radio_deselect"), for: .normal)
        if SlotId == arrTimeSlot[indexPath.row]["SlotId"] as! Int {
            cell.btnCheck.setImage(UIImage(named: "radio_select"), for: .normal)
        }
        
      
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        
        return arrTimeSlot.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrTimeSlot[indexPath.row]["IsAvailalbe"] as! Bool == true {
            self.delegate?.delegateSelectSlot(arrTimeSlot[indexPath.row], isselect: true, intIndex: intIndex)

            SlotId = arrTimeSlot[indexPath.row]["SlotId"] as! Int
            self.tblView.reloadData()
        }
    }
}

