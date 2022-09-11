//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class Advertisement: NSObject {
 
    var AdvertisementId : Int?
    var ImageDetail : String?
    var OnTapURL : String?

    var ItemId : Int?
    var ItemType : Int?
    var IsExternalLink : Bool?


   

    
    init(json: [String: Any]?) {
        
        IsExternalLink = false
        if let str = json!["IsExternalLink"] as? Bool {
            IsExternalLink = str
        }
        
        ItemType = 0
        if let str = json!["ItemType"] as? Int {
            ItemType = str
        }
        ItemId = 0
        if let str = json!["ItemId"] as? Int {
            ItemId = str
        }
        
        AdvertisementId = 0
        if let str = json!["AdvertisementId"] as? Int {
            AdvertisementId = str
        }
        
       
        OnTapURL = ""
        if let str = json!["OnTapURL"] as? String {
            OnTapURL = str
        }
        ImageDetail = ""
        if let str = json!["ImageDetail"] as? String {
            ImageDetail = str
        }
        
        
      
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        
       dicParam["AdvertisementId"] = AdvertisementId as AnyObject
        dicParam["ImageDetail"] = ImageDetail as AnyObject
        dicParam["OnTapURL"] = OnTapURL as AnyObject


        dicParam["IsExternalLink"] = IsExternalLink as AnyObject
        dicParam["ItemId"] = ItemId as AnyObject
        dicParam["ItemType"] = ItemType as AnyObject

        
        
        return dicParam
    }
}
