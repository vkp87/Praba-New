//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class TransactionHistory: NSObject {
 
    var BusinessId : Int?
    var BusinessName : String?
    var HistoryId : Int?
    var OperationDate : String?
    var PointAgainstAmount : Int?
    var PointBalance : Int?
    var TotalRecords : Int?
    var TypeN : Int?
    var TypeText : String?
    var UserId : Int?
    
    init(json: [String: Any]?) {
        
        
        BusinessId = 0
        if let str = json!["BusinessId"] as? Int {
            BusinessId = str
        }
        
        HistoryId = 0
        if let str = json!["HistoryId"] as? Int {
            HistoryId = str
        }
        
        UserId = 0
        if let str = json!["UserId"] as? Int {
            UserId = str
        }
        
        TypeN = 0
        if let str = json!["Type"] as? Int {
            TypeN = str
        }
        
        TotalRecords = 0
        if let str = json!["TotalRecords"] as? Int {
            TotalRecords = str
        }
        
        PointBalance = 0
        if let str = json!["PointBalance"] as? Int {
            PointBalance = str
        }
        
        PointAgainstAmount = 0
        if let str = json!["PointAgainstAmount"] as? Int {
            PointAgainstAmount = str
        }
        
        BusinessName = ""
        if let str = json!["BusinessName"] as? String {
            BusinessName = str
        }
        OperationDate = ""
        if let str = json!["OperationDate"] as? String {
            OperationDate = str
        }
        
        
        TypeText = ""
        if let str = json!["TypeText"] as? String {
            TypeText = str
        }
        
        
      
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        
       dicParam["PointBalance"] = PointBalance as AnyObject
        dicParam["UserId"] = UserId as AnyObject
        dicParam["BusinessId"] = BusinessId as AnyObject
        dicParam["BusinessName"] = BusinessName as AnyObject
        dicParam["HistoryId"] = HistoryId as AnyObject
        dicParam["OperationDate"] = OperationDate as AnyObject
        dicParam["PointAgainstAmount"] = PointAgainstAmount as AnyObject
        dicParam["TotalRecords"] = TotalRecords as AnyObject
        dicParam["Type"] = TypeN as AnyObject
        dicParam["TypeText"] = TypeText as AnyObject


        
        
        
        return dicParam
    }
}
