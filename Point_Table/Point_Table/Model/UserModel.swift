//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class UserModel: NSObject {
 
    var UserId : Int?
    var FirstName : String?
    var LastName : String?
    var MobileNo : String?
    var EmailId : String?
    var PointBalance : Int?
    var Amount : Int?
    var isOtpVerify : Bool?
    var UserUUID : String?

   
    var UserImage : String?

    
    init(json: [String: Any]?) {
        
        
               UserImage = ""
               if let str = json!["UserImage"] as? String {
                   UserImage = str
               }
        
        UserUUID = ""
        if let str = json!["UserUUID"] as? String {
            UserUUID = str
        }
        
        isOtpVerify = false
        if let str = json!["isOtpVerify"] as? Bool {
            isOtpVerify = str
        }
        Amount = 0
        if let str = json!["Amount"] as? Int {
            Amount = str
        }
        
        PointBalance = 0
        if let str = json!["PointBalance"] as? Int {
            PointBalance = str
        }
        
        UserId = 0
        if let str = json!["UserId"] as? Int {
            UserId = str
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
        
        EmailId = ""
        if let str = json!["EmailId"] as? String {
            EmailId = str
        }
        
      
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        
       dicParam["PointBalance"] = PointBalance as AnyObject
        dicParam["UserId"] = UserId as AnyObject
        dicParam["FirstName"] = FirstName as AnyObject
        dicParam["LastName"] = LastName as AnyObject
        dicParam["MobileNo"] = MobileNo as AnyObject
        dicParam["EmailId"] = EmailId as AnyObject
        dicParam["Amount"] = Amount as AnyObject
        dicParam["isOtpVerify"] = isOtpVerify as AnyObject


        dicParam["UserUUID"] = UserUUID as AnyObject
        dicParam["UserImage"] = UserImage as AnyObject

        
        
        return dicParam
    }
}
