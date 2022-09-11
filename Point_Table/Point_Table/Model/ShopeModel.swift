//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class ShopeModel: NSObject {
    
    var BusinessId : Int?
    var BusinessName : String?
    var BusinessAddress : String?

    var Latitude : Double?
    var Longitude : Double?
    var IsAvailableStockDisplay : Bool?
    var PerItemCartLimit : Int?
    
    var IsStoreCollectionEnable : Bool?
    var IsCodEnable : Bool?
    var IsCodEnableForCollection : Bool?

    var IsSupportDistanceLogic : Bool?
       var IsSupportZipCodeLogic : Bool?
    
    
    
    init(json: [String: Any]?) {
        IsSupportZipCodeLogic = false
                             if let str = json!["IsSupportZipCodeLogic"] as? Bool {
                                 IsSupportZipCodeLogic = str
                             }
               
               IsSupportDistanceLogic = false
                      if let str = json!["IsSupportDistanceLogic"] as? Bool {
                          IsSupportDistanceLogic = str
                      }
        IsCodEnableForCollection = false
        if let str = json!["IsCodEnableForCollection"] as? Bool {
            IsCodEnableForCollection = str
        }
        
        PerItemCartLimit = 0
        if let str = json!["PerItemCartLimit"] as? Int {
            PerItemCartLimit = str
        }
        
        IsCodEnable = false
        if let str = json!["IsCodEnable"] as? Bool {
            IsCodEnable = str
        }
        
        IsStoreCollectionEnable = false
        if let str = json!["IsStoreCollectionEnable"] as? Bool {
            IsStoreCollectionEnable = str
        }
        
        
        IsAvailableStockDisplay = false
        if let str = json!["IsAvailableStockDisplay"] as? Bool {
            IsAvailableStockDisplay = str
        }
        
        Latitude = 0.0
        if let str = json!["Latitude"] as? Double {
            Latitude = str
        }
        
        Longitude = 0.0
        if let str = json!["Longitude"] as? Double {
            Longitude = str
        }
        
        
        BusinessId = 0
        if let str = json!["BusinessId"] as? Int {
            BusinessId = str
        }
        
        
        BusinessAddress = ""
        if let str = json!["BusinessAddress"] as? String {
            BusinessAddress = str
        }
        
        
        BusinessName = ""
        if let str = json!["BusinessName"] as? String {
            BusinessName = str
        }
        
        
        
        
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        dicParam["BusinessAddress"] = BusinessAddress as AnyObject

        dicParam["IsSupportDistanceLogic"] = IsSupportDistanceLogic as AnyObject
               dicParam["IsSupportZipCodeLogic"] = IsSupportZipCodeLogic as AnyObject
        dicParam["IsCodEnableForCollection"] = IsCodEnableForCollection as AnyObject

        dicParam["IsCodEnable"] = IsCodEnable as AnyObject
        dicParam["IsStoreCollectionEnable"] = IsStoreCollectionEnable as AnyObject
        
        
        dicParam["BusinessId"] = BusinessId as AnyObject
        dicParam["BusinessName"] = BusinessName as AnyObject
        
        dicParam["Latitude"] = Latitude as AnyObject
        dicParam["Longitude"] = Longitude as AnyObject
        
        dicParam["IsAvailableStockDisplay"] = IsAvailableStockDisplay as AnyObject
        dicParam["PerItemCartLimit"] = PerItemCartLimit as AnyObject
        
        
        
        return dicParam
    }
}
class SearchShopeModel: NSObject {
  
    
    var Latitude : String?
    var Longitude : String?

    var Name : String?
    var PostCode : String?
    
    
    init(json: [String: Any]?) {
        
        
        Latitude = ""
        if let str = json!["Latitude"] as? String {
            Latitude = str
        }
        
        
        Longitude = ""
        if let str = json!["Longitude"] as? String {
            Longitude = str
        }
        
            
            Name = ""
            if let str = json!["Name"] as? String {
                Name = str
            }
            
        
                 PostCode = ""
                 if let str = json!["PostCode"] as? String {
                     PostCode = str
                 }
        
        
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        dicParam["PostCode"] = PostCode as AnyObject

        dicParam["Name"] = Name as AnyObject
               dicParam["Longitude"] = Longitude as AnyObject
        dicParam["Latitude"] = Latitude as AnyObject

        
        
        return dicParam
    }
}
