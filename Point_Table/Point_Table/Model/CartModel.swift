//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class CartModel: NSObject {
    
    var OrderDetailId : Int?
    var DeliveryCharge : Int?
    var ProductSize : Double?
    var PercentageValue : Int?
    var TaxId : Int?
    var PromotionId : Int?
    var ProductId : Int?
    var ProductImage : String?
    var DiscountType : Int?
    var Price : Double?
    var ProductName : String?
    var PromotionTitle : String?
    var ProductType : Int?

    var AvailableQty : Int?
    var CartQty : Int?
    var PromotionDetailId : Int?
    var TaxValue : Int?
    var OrderID : Int?
    var OldPrice : Double?
    var DeliveryChargeEligibleTill : Int?
    var ProductSizeType : String?
    var DeliveryDistance : Int?

    var SellingPrice : Double?
    var Weight : Double?
    var Quantity : Int?
    var Discount : Int?
    var PerItemCartLimit : Int?

    var ExcludeMinimumCartValueMessage : String?
    var IsExcludeMinimumCartValue : Bool?
    var outOfStockMessage : String?

    init(json: [String: Any]?) {
        
        
        IsExcludeMinimumCartValue = false
        if let str = json!["IsExcludeMinimumCartValue"] as? Bool {
            IsExcludeMinimumCartValue = str
        }
        
        ExcludeMinimumCartValueMessage = ""
        if let str = json!["ExcludeMinimumCartValueMessage"] as? String {
            ExcludeMinimumCartValueMessage = str
        }
        
        ProductType = 0
        if let str = json!["ProductType"] as? Int {
            ProductType = str
        }
        
        PerItemCartLimit = 0
        if let str = json!["PerItemCartLimit"] as? Int {
            PerItemCartLimit = str
        }
        
        DeliveryDistance = 0
        if let str = json!["DeliveryDistance"] as? Int {
            DeliveryDistance = str
        }
        
        SellingPrice = 0
        if let str = json!["SellingPrice"] as? Double {
            SellingPrice = str
        }
        
        Quantity = 0
        if let str = json!["Quantity"] as? Int {
            Quantity = str
        }
        
        Discount = 0
        if let str = json!["Discount"] as? Int {
            Discount = str
        }
        
        
        PromotionTitle = ""
        if let str = json!["PromotionTitle"] as? String {
            PromotionTitle = str
        }
        
        
        ProductSizeType = ""
        if let str = json!["ProductSizeType"] as? String {
            ProductSizeType = str
        }
        
        DeliveryChargeEligibleTill = 0
        if let str = json!["DeliveryChargeEligibleTill"] as? Int {
            DeliveryChargeEligibleTill = str
        }
        
        OldPrice = 0.0
        if let str = json!["OldPrice"] as? Double {
            OldPrice = str
        }
        
        OrderID = 0
        if let str = json!["OrderID"] as? Int {
            OrderID = str
        }
        
        TaxValue = 0
        if let str = json!["TaxValue"] as? Int {
            TaxValue = str
        }
        
        
        PromotionDetailId = 0
        if let str = json!["PromotionDetailId"] as? Int {
            PromotionDetailId = str
        }
        
        CartQty = 0
        if let str = json!["CartQty"] as? Int {
            CartQty = str
        }
        
        AvailableQty = 0
        if let str = json!["AvailableQty"] as? Int {
            AvailableQty = str
        }
        
        ProductName = ""
        if let str = json!["ProductName"] as? String {
            ProductName = str
        }
        
        Price = 0.0
        if let str = json!["Price"] as? Double {
            Price = str
        }
        
        DiscountType = 0
        if let str = json!["DiscountType"] as? Int {
            DiscountType = str
        }
        
        ProductImage = ""
        if let str = json!["ProductImage"] as? String {
            ProductImage = str
        }
        
        ProductId = 0
        if let str = json!["ProductId"] as? Int {
            ProductId = str
        }
        
        PromotionId = 0
        if let str = json!["PromotionId"] as? Int {
            PromotionId = str
        }
        
        TaxId = 0
        if let str = json!["TaxId"] as? Int {
            TaxId = str
        }
        
        PercentageValue = 0
        if let str = json!["PercentageValue"] as? Int {
            PercentageValue = str
        }
        
        ProductSize = 0.0
        if let str = json!["ProductSize"] as? Double {
            ProductSize = str
        }
        
        DeliveryCharge = 0
        if let str = json!["DeliveryCharge"] as? Int {
            DeliveryCharge = str
        }
        
        Weight = 0
        if let str = json!["Weight"] as? Double {
            Weight = str
        }
        
        
        OrderDetailId = 0
        if let str = json!["OrderDetailId"] as? Int {
            OrderDetailId = str
        }
       
        outOfStockMessage = ""
        if let str = json!["OutOfStockMessage"] as? String {
            outOfStockMessage = str
        }
      
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        dicParam["PerItemCartLimit"] = PerItemCartLimit as AnyObject
        dicParam["IsExcludeMinimumCartValue"] = IsExcludeMinimumCartValue as AnyObject

        dicParam["ProductType"] = ProductType as AnyObject

        
        dicParam["PromotionTitle"] = PromotionTitle as AnyObject

        dicParam["DeliveryDistance"] = DeliveryDistance as AnyObject

        dicParam["Discount"] = Discount as AnyObject
        dicParam["SellingPrice"] = SellingPrice as AnyObject
        dicParam["Quantity"] = Quantity as AnyObject
        dicParam["ExcludeMinimumCartValueMessage"] = ExcludeMinimumCartValueMessage as AnyObject

        dicParam["OrderDetailId"] = OrderDetailId as AnyObject
        dicParam["DeliveryCharge"] = DeliveryCharge as AnyObject
        dicParam["ProductSize"] = ProductSize as AnyObject
        dicParam["PercentageValue"] = PercentageValue as AnyObject
        dicParam["TaxId"] = TaxId as AnyObject
        dicParam["PromotionId"] = PromotionId as AnyObject
        dicParam["ProductId"] = ProductId as AnyObject
        dicParam["ProductImage"] = ProductImage as AnyObject
        dicParam["DiscountType"] = DiscountType as AnyObject
        dicParam["Price"] = Price as AnyObject
        dicParam["ProductName"] = ProductName as AnyObject
        dicParam["AvailableQty"] = AvailableQty as AnyObject
        dicParam["CartQty"] = CartQty as AnyObject
        dicParam["PromotionDetailId"] = PromotionDetailId as AnyObject
        dicParam["TaxValue"] = TaxValue as AnyObject
        dicParam["OrderID"] = OrderID as AnyObject
        dicParam["OldPrice"] = OldPrice as AnyObject
        dicParam["DeliveryChargeEligibleTill"] = DeliveryChargeEligibleTill as AnyObject
        dicParam["ProductSizeType"] = ProductSizeType as AnyObject
        dicParam["OutOfStockMessage"] = outOfStockMessage as AnyObject
        dicParam["Weight"] = Weight as AnyObject

        return dicParam
    }
}
