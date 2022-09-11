//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class ProductModel: NSObject {
    
    var CartWeight : Double?
    var ProductType : Int?
    var PricePerQty : Double?
    var MinOrderQtyOrWeigth : Double?
    var DefaultWeight : Double?
    var WeightIncrement : Double?
    var ProductSizePerQty : Double?

    var AvailableQty : Double?
    var BrandId : Int?
    var OldPrice : Double?
    var Price : Double?
    var ProductId : Int?
    var ProductSize : Double?
    var TotalRecords : Int?
    var CartQty : Int?
    var ProductImage : String?
    var BrandName : String?
    var ProductName : String?
    var ProductSizeType : String?
    var PerItemCartLimit : Int?
    var PromotionTitle : String?
    
    var Age : Int?
    var outOfStockMessage : String?
    
    var IsFavourite : Bool?
     var  IsPriceMarked : Bool?
    var IsLowQty : Bool?
    var  isKg : Bool?
    var  isQtyEdit : Bool?

    init(json: [String: Any]?) {
        
        isKg = true
        if let str = json!["isKg"] as? Bool {
            isKg = str
        }
        isQtyEdit = false
        if let str = json!["isQtyEdit"] as? Bool {
            isQtyEdit = str
        }
        ProductSizePerQty = 0
               if let str = json!["ProductSizePerQty"] as? Double {
                   ProductSizePerQty = str
               }
        
        
        WeightIncrement = 0.0
        if let str = json!["WeightIncrement"] as? Double {
            WeightIncrement = str
        }
        
        DefaultWeight = 0.0
               if let str = json!["DefaultWeight"] as? Double {
                   DefaultWeight = str
               }
        
        MinOrderQtyOrWeigth = 0.0
        if let str = json!["MinOrderQtyOrWeigth"] as? Double {
            MinOrderQtyOrWeigth = str
        }
        
        PricePerQty = 0.0
               if let str = json!["PricePerQty"] as? Double {
                   PricePerQty = str
               }
        
        ProductType = 0
        if let str = json!["ProductType"] as? Int {
            ProductType = str
        }
        
        CartWeight = 0.0
               if let str = json!["CartWeight"] as? Double {
                   CartWeight = str
               }
        
        IsLowQty = false
        if let str = json!["IsLowQty"] as? Bool {
            IsLowQty = str
        }
        
        IsFavourite = false
        if let str = json!["IsFavourite"] as? Bool {
            IsFavourite = str
        }
        
        IsPriceMarked = false
        if let str = json!["IsPriceMarked"] as? Bool {
            IsPriceMarked = str
        }
        
        Age = 0
        if let str = json!["Age"] as? Int {
            Age = str
        }
        
        PerItemCartLimit = 0
        if let str = json!["PerItemCartLimit"] as? Int {
            PerItemCartLimit = str
        }
        
        CartQty = 0
        if let str = json!["CartQty"] as? Int {
            CartQty = str
        }
        
        AvailableQty = 0.0
        if let str = json!["AvailableQty"] as? Double {
            AvailableQty = str
        }
        
        BrandId = 0
        if let str = json!["BrandId"] as? Int {
            BrandId = str
        }
        
        OldPrice = 0.00
        if let str = json!["OldPrice"] as? Double {
            OldPrice = str
        }
        
        Price = 0.00
        if let str = json!["Price"] as? Double {
            Price = str
        }
        
        ProductId = 0
        if let str = json!["ProductId"] as? Int {
            ProductId = str
        }
        
        ProductSize = 0
        if let str = json!["ProductSize"] as? Double {
            ProductSize = str
        }
        
        TotalRecords = 0
        if let str = json!["TotalRecords"] as? Int {
            TotalRecords = str
        }
        
        
        PromotionTitle = ""
        if let str = json!["PromotionTitle"] as? String {
            PromotionTitle = str
        }
        
        ProductImage = ""
        if let str = json!["ProductImage"] as? String {
            ProductImage = str
        }
        
        ProductName = ""
        if let str = json!["ProductName"] as? String {
            ProductName = str
        }
        
        ProductSizeType = ""
        if let str = json!["ProductSizeType"] as? String {
            ProductSizeType = str
        }
        
        BrandName = ""
        if let str = json!["BrandName"] as? String {
            BrandName = str
        }
        
        outOfStockMessage = ""
        if let str = json!["OutOfStockMessage"] as? String {
            outOfStockMessage = str
        }
        
    }
    
    func toDict() -> [String:AnyObject] {
        var dicParam = [String:AnyObject]()
        
        dicParam["IsLowQty"] = IsLowQty as AnyObject

        
        dicParam["PromotionTitle"] = PromotionTitle as AnyObject
        
        dicParam["Age"] = Age as AnyObject
        
        dicParam["CartQty"] = CartQty as AnyObject
        
        dicParam["ProductName"] = ProductName as AnyObject
        
        dicParam["BrandName"] = BrandName as AnyObject
        
        dicParam["ProductImage"] = ProductImage as AnyObject
        
        dicParam["TotalRecords"] = TotalRecords as AnyObject
        dicParam["isKg"] = isKg as AnyObject

        dicParam["ProductSize"] = ProductSize as AnyObject
        
        dicParam["ProductId"] = ProductId as AnyObject
        
        dicParam["AvailableQty"] = AvailableQty as AnyObject
        
        dicParam["BrandId"] = BrandId as AnyObject
        
        dicParam["OldPrice"] = OldPrice as AnyObject
        
        dicParam["Price"] = Price as AnyObject
        dicParam["ProductSizeType"] = ProductSizeType as AnyObject
        dicParam["PerItemCartLimit"] = PerItemCartLimit as AnyObject
        dicParam["OutOfStockMessage"] = outOfStockMessage as AnyObject
        dicParam["IsFavourite"] = IsFavourite as AnyObject
        dicParam["IsPriceMarked"] = IsPriceMarked as AnyObject

        dicParam["CartWeight"] = CartWeight as AnyObject
        dicParam["ProductType"] = ProductType as AnyObject
        dicParam["PricePerQty"] = PricePerQty as AnyObject
        dicParam["MinOrderQtyOrWeigth"] = MinOrderQtyOrWeigth as AnyObject
        dicParam["DefaultWeight"] = DefaultWeight as AnyObject
        dicParam["WeightIncrement"] = WeightIncrement as AnyObject
        dicParam["ProductSizePerQty"] = ProductSizePerQty as AnyObject
     dicParam["isQtyEdit"] = isQtyEdit as AnyObject

        
        return dicParam
    }
}
