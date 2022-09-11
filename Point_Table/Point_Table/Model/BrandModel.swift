//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class BrandModel: NSObject {
 
    var BrandId : Int?
    var BrandName : String?
   var isSelect : Bool?
    


   var BrandImage : String?


    
    init(json: [String: Any]?) {
        
        isSelect = false
        if let str = json!["isSelect"] as? Bool {
            isSelect = str
        }
        
        BrandId = 0
        if let str = json!["BrandId"] as? Int {
            BrandId = str
        }
        
        
        BrandName = ""
        if let str = json!["BrandName"] as? String {
            BrandName = str
        }
       
        
               BrandImage = ""
               if let str = json!["BrandImage"] as? String {
                   BrandImage = str
               }
        
        
      
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        
       dicParam["BrandName"] = BrandName as AnyObject
        dicParam["BrandId"] = BrandId as AnyObject
       dicParam["BrandImage"] = BrandImage as AnyObject

        dicParam["isSelect"] = isSelect as AnyObject

        return dicParam
    }
}

class ProductSearchModel: NSObject {
    
    var ProductId : Int?
    var ProductName : String?
    var CategoryId : Int?
    var SubCategoryId : Int?
    
    var BrandName : String?
    var ProductImage : String?
    var ProductSize : Double?
    var UnitName : String?
    var SellingPrice : Double?
    var AvailableQty : Int?
    var Price : Double?
    
    var TotalRecords : Int?
    var PromotionTitle : String?
    var DiscountValue : Double?
    var outOfStockMessage : String?
    
    var IsPriceMarked : Bool?

    init(json: [String: Any]?) {
        
        
               IsPriceMarked = false
               if let str = json!["IsPriceMarked"] as? Bool {
                   IsPriceMarked = str
               }
        
        TotalRecords = 0
        if let str = json!["TotalRecords"] as? Int {
            TotalRecords = str
        }
        DiscountValue = 0.0
              if let str = json!["DiscountValue"] as? Double {
                  DiscountValue = str
              }
        
        Price = 0.0
        if let str = json!["Price"] as? Double {
            Price = str
        }
        
        SellingPrice = 0.0
        if let str = json!["SellingPrice"] as? Double {
            SellingPrice = str
        }
        
        BrandName = ""
        if let str = json!["BrandName"] as? String {
            BrandName = str
        }
        
        ProductImage = ""
        if let str = json!["ProductImage"] as? String {
            ProductImage = str
        }
        
        ProductSize = 0
        if let str = json!["ProductSize"] as? Double {
            ProductSize = str
        }
        
        UnitName = ""
        if let str = json!["UnitName"] as? String {
            UnitName = str
        }
        
        ProductId = 0
        if let str = json!["ProductId"] as? Int {
            ProductId = str
        }
        
        ProductName = ""
        if let str = json!["ProductName"] as? String {
            ProductName = str
        }
        
        CategoryId = 0
        if let str = json!["CategoryId"] as? Int {
            CategoryId = str
        }
        
        SubCategoryId = 0
        if let str = json!["SubCategoryId"] as? Int {
            SubCategoryId = str
        }
        
        AvailableQty = 0
        if let str = json!["AvailableQty"] as? Int {
            AvailableQty = str
        }
        
        PromotionTitle = ""
        if let str = json!["PromotionTitle"] as? String {
            PromotionTitle = str
        }
        
        outOfStockMessage = ""
        if let str = json!["OutOfStockMessage"] as? String {
            outOfStockMessage = str
        }
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        dicParam["TotalRecords"] = TotalRecords as AnyObject
        dicParam["IsPriceMarked"] = IsPriceMarked as AnyObject

        dicParam["Price"] = Price as AnyObject

        dicParam["BrandName"] = BrandName as AnyObject
        dicParam["ProductImage"] = ProductImage as AnyObject
        dicParam["ProductSize"] = ProductSize as AnyObject
        dicParam["UnitName"] = UnitName as AnyObject

        dicParam["SellingPrice"] = SellingPrice as AnyObject

        dicParam["ProductId"] = ProductId as AnyObject
        dicParam["ProductName"] = ProductName as AnyObject
        
        dicParam["CategoryId"] = CategoryId as AnyObject
        dicParam["SubCategoryId"] = SubCategoryId as AnyObject
        dicParam["AvailableQty"] = AvailableQty as AnyObject
        dicParam["PromotionTitle"] = PromotionTitle as AnyObject
        dicParam["DiscountValue"] = DiscountValue as AnyObject
        dicParam["OutOfStockMessage"] = outOfStockMessage as AnyObject
        return dicParam
    }
}
