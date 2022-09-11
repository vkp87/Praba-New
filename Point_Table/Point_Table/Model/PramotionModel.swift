//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class PramotionOrderModel: NSObject {
    
    var Promocode : String?
    var PromotionText : String?
    var PromotionDescription : String?
    var PromotionId : Int?
    var TotalRecords : Int?
    
    
    
    
    
    init(json: [String: Any]?) {
        
        Promocode = ""
        if let str = json!["Promocode"] as? String {
            Promocode = str
        }
      
        
        PromotionId = 0
        if let str = json!["PromotionId"] as? Int {
            PromotionId = str
        }
        
        TotalRecords = 0
        if let str = json!["TotalRecords"] as? Int {
            TotalRecords = str
        }
        
        PromotionDescription = ""
        if let str = json!["PromotionDescription"] as? String {
            PromotionDescription = str
        }
        
        
        PromotionText = ""
        if let str = json!["PromotionText"] as? String {
            PromotionText = str
        }
        
        
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
      
        
        dicParam["Promocode"] = Promocode as AnyObject
        dicParam["PromotionText"] = PromotionText as AnyObject
        dicParam["PromotionDescription"] = PromotionDescription as AnyObject
        dicParam["PromotionId"] = PromotionId as AnyObject
        dicParam["TotalRecords"] = TotalRecords as AnyObject
       
        
        
        return dicParam
    }
}

class PramotionModel: NSObject {
 
    var BusinessId : Int?
    var BusinessName : String?
    var Description : String?
    var PromotionId : Int?

    var PromotionImage : String?
    var PromotionText : String?
    var TotalRecords : Int?
  

   

    
    init(json: [String: Any]?) {
        
        
        BusinessId = 0
        if let str = json!["BusinessId"] as? Int {
            BusinessId = str
        }
        
        PromotionId = 0
        if let str = json!["PromotionId"] as? Int {
            PromotionId = str
        }
        
        TotalRecords = 0
        if let str = json!["TotalRecords"] as? Int {
            TotalRecords = str
        }
        
        BusinessName = ""
        if let str = json!["BusinessName"] as? String {
            BusinessName = str
        }
        
        Description = ""
        if let str = json!["Description"] as? String {
            Description = str
        }
        PromotionImage = ""
        if let str = json!["PromotionImage"] as? String {
            PromotionImage = str
        }
        
        
        PromotionText = ""
        if let str = json!["PromotionText"] as? String {
            PromotionText = str
        }
        
      
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        
       
       dicParam["BusinessId"] = BusinessId as AnyObject
        dicParam["BusinessName"] = BusinessName as AnyObject
        dicParam["Description"] = Description as AnyObject
        dicParam["PromotionId"] = PromotionId as AnyObject
        dicParam["PromotionImage"] = PromotionImage as AnyObject
        dicParam["PromotionText"] = PromotionText as AnyObject
        dicParam["TotalRecords"] = TotalRecords as AnyObject


        
        
        
        return dicParam
    }
}
