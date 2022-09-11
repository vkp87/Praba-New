//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class AddressModel: NSObject {
    
    var AddressType : Int?
    var AddressTypeText : String?
    var FirstName : String?
    
    var IsDefaultAddress :Bool
    
    var LastName :String?
    
    var MobileNo :String?
    var PostCode :String?
    var StreetAddress1 :String?
    
    var StreetAddress2 :String?
    var Town :String?
    var UserAddressId :Int?
    var UserId :Int?
    
    
    
    init(json: [String: Any]?) {
        
        
        Town = ""
        if let str = json!["Town"] as? String {
            Town = str
        }
        
        UserId = 0
        if let str = json!["UserId"] as? Int {
            UserId = str
        }
        
        UserAddressId = 0
        if let str = json!["UserAddressId"] as? Int {
            UserAddressId = str
        }
        
        IsDefaultAddress = false
        if let str = json!["IsDefaultAddress"] as? Bool {
            IsDefaultAddress = str
        }
        
        AddressType = 0
        if let str = json!["AddressType"] as? Int {
            AddressType = str
        }
        
        
        AddressTypeText = ""
        if let str = json!["AddressTypeText"] as? String {
            AddressTypeText = str
        }
        
        
        
        FirstName = ""
        if let str = json!["FirstName"] as? String {
            FirstName = str
        }
        
        LastName = ""
        if let str = json!["LastName"] as? String {
            LastName = str
        }
        
        MobileNo = ""
        if let str = json!["MobileNo"] as? String {
            MobileNo = str
        }
        
        
        PostCode = ""
        if let str = json!["PostCode"] as? String {
            PostCode = str
        }
        
        StreetAddress1 = ""
        if let str = json!["StreetAddress1"] as? String {
            StreetAddress1 = str
        }
        
        
        StreetAddress2 = ""
        if let str = json!["StreetAddress2"] as? String {
            StreetAddress2 = str
        }
        
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        
        
        
        dicParam["Town"] = Town as AnyObject
        dicParam["UserAddressId"] = UserAddressId as AnyObject
        dicParam["UserId"] = UserId as AnyObject
        
        
        dicParam["StreetAddress1"] = StreetAddress1 as AnyObject
        dicParam["StreetAddress2"] = StreetAddress2 as AnyObject
        
        
        dicParam["MobileNo"] = MobileNo as AnyObject
        
        dicParam["PostCode"] = PostCode as AnyObject
        
        dicParam["IsDefaultAddress"] = IsDefaultAddress as AnyObject
        
        dicParam["LastName"] = LastName as AnyObject
        
        dicParam["AddressType"] = AddressType as AnyObject
        dicParam["AddressTypeText"] = AddressTypeText as AnyObject
        
        dicParam["FirstName"] = FirstName as AnyObject
        
        return dicParam
    }
}
class BillingAddressModel: NSObject {
    
    var FirstName : String?
    
    
    var LastName :String?
    
    var MobileNo :String?
    var PostCode :String?
    var StreetAddress1 :String?
    
    var StreetAddress2 :String?
    var Town :String?
    var UserBillingAddressId :Int?
    var UserId :Int?
    
    
    
    init(json: [String: Any]?) {
        
        
        Town = ""
        if let str = json!["Town"] as? String {
            Town = str
        }
        
        UserId = 0
        if let str = json!["UserId"] as? Int {
            UserId = str
        }
        
        UserBillingAddressId = 0
        if let str = json!["UserBillingAddressId"] as? Int {
            UserBillingAddressId = str
        }
        
        
        FirstName = ""
        if let str = json!["FirstName"] as? String {
            FirstName = str
        }
        
        LastName = ""
        if let str = json!["LastName"] as? String {
            LastName = str
        }
        
        MobileNo = ""
        if let str = json!["MobileNo"] as? String {
            MobileNo = str
        }
        
        
        PostCode = ""
        if let str = json!["PostCode"] as? String {
            PostCode = str
        }
        
        StreetAddress1 = ""
        if let str = json!["StreetAddress1"] as? String {
            StreetAddress1 = str
        }
        
        
        StreetAddress2 = ""
        if let str = json!["StreetAddress2"] as? String {
            StreetAddress2 = str
        }
        
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        
        
        
        dicParam["Town"] = Town as AnyObject
        dicParam["UserBillingAddressId"] = UserBillingAddressId as AnyObject
        dicParam["UserId"] = UserId as AnyObject
        
        
        dicParam["StreetAddress1"] = StreetAddress1 as AnyObject
        dicParam["StreetAddress2"] = StreetAddress2 as AnyObject
        
        
        dicParam["MobileNo"] = MobileNo as AnyObject
        
        dicParam["PostCode"] = PostCode as AnyObject
        
        
        dicParam["LastName"] = LastName as AnyObject
        
        
        dicParam["FirstName"] = FirstName as AnyObject
        
        return dicParam
    }
}
