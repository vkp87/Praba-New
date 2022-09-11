//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class CategoryModel: NSObject {
 
    var CategoryId : Int?
    var CategoryImage : String?
    var CategoryName : String?
    var IsSubCategoryExists : Bool?


   

    
    init(json: [String: Any]?) {
        
        
        CategoryId = 0
        if let str = json!["CategoryId"] as? Int {
            CategoryId = str
        }
        
        
        IsSubCategoryExists = false
        if let str = json!["IsSubCategoryExists"] as? Bool {
            IsSubCategoryExists = str
        }
        
        
        CategoryImage = ""
        if let str = json!["CategoryImage"] as? String {
            CategoryImage = str
        }
        
        
        CategoryName = ""
        if let str = json!["CategoryName"] as? String {
            CategoryName = str
        }
        
        
        
      
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        
       dicParam["CategoryId"] = CategoryId as AnyObject
        dicParam["CategoryImage"] = CategoryImage as AnyObject
       
        dicParam["CategoryName"] = CategoryName as AnyObject

        dicParam["IsSubCategoryExists"] = IsSubCategoryExists as AnyObject

        
        
        return dicParam
    }
}
class PromotionCategoryModel: NSObject {
 
    var PromotionCategoryId : Int?
    var CategoryName : String?
    var CategoryImage : String?

   

    
   

    
    init(json: [String: Any]?) {
        
        
        PromotionCategoryId = 0
        if let str = json!["PromotionCategoryId"] as? Int {
            PromotionCategoryId = str
        }
      
        
        CategoryImage = ""
        if let str = json!["CategoryImage"] as? String {
            CategoryImage = str
        }
        
        
        CategoryName = ""
        if let str = json!["CategoryName"] as? String {
            CategoryName = str
        }
        
        
        
      
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        
       dicParam["CategoryId"] = PromotionCategoryId as AnyObject
        dicParam["CategoryImage"] = CategoryImage as AnyObject
       
        dicParam["CategoryName"] = CategoryName as AnyObject


        
        
        return dicParam
    }
}

