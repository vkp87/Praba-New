//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class OrderModel: NSObject {
    
    var InvoiceNumber : String?
    var ItemCount : Int?
    var OrderID : Int?
    var OrderStatus : Int?
    var OrderStatusText : String?
    var TotalAmount : Double?
    var TotalRecords : Int?
    var TransactionDate : String?
    var UserId : Int?
    var ShopID : Int?
    var ShopName : String?
    

    init(json: [String: Any]?) {
        
        InvoiceNumber = ""
        if let str = json!["InvoiceNumber"] as? String {
            InvoiceNumber = str
        }
        
        ItemCount = 0
        if let str = json!["ItemCount"] as? Int {
            ItemCount = str
        }
        
        OrderID = 0
        if let str = json!["OrderID"] as? Int {
            OrderID = str
        }
        
        OrderStatus = 0
        if let str = json!["OrderStatus"] as? Int {
            OrderStatus = str
        }
        
        OrderStatusText = ""
        if let str = json!["OrderStatusText"] as? String {
            OrderStatusText = str
        }
        
        
        TotalAmount = 0.0
        if let str = json!["TotalAmount"] as? Double {
            TotalAmount = str
        }
        
        TotalRecords = 0
        if let str = json!["TotalRecords"] as? Int {
            TotalRecords = str
        }
        
        TransactionDate = ""
        if let str = json!["TransactionDate"] as? String {
            TransactionDate = str
        }
        
        UserId = 0
        if let str = json!["UserId"] as? Int {
            UserId = str
        }
        
        ShopID = 0
        if let str = json!["ShopId"] as? Int {
            ShopID = str
        }
        
        ShopName = ""
        if let str = json!["ShopName"] as? String {
            ShopName = str
        }
      
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        dicParam["InvoiceNumber"] = InvoiceNumber as AnyObject
        dicParam["ItemCount"] = ItemCount as AnyObject
        dicParam["OrderID"] = OrderID as AnyObject
        dicParam["OrderStatus"] = OrderStatus as AnyObject
        dicParam["OrderStatusText"] = OrderStatusText as AnyObject
        dicParam["TotalAmount"] = TotalAmount as AnyObject
        dicParam["TotalRecords"] = TotalRecords as AnyObject
        dicParam["TransactionDate"] = TransactionDate as AnyObject
        dicParam["UserId"] = UserId as AnyObject
        dicParam["ShopId"] = ShopID as AnyObject
        dicParam["ShopName"] = ShopName as AnyObject
        return dicParam
    }
}
