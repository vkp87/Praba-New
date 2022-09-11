//
//  UserModel.swift
//
//  Created by jatin rathod on 3/23/18.
//  Copyright © 2018 jatin rathod. All rights reserved.
//

import UIKit

class SubCategoryModel: NSObject {
 
    var CategoryId : Int?
    var SubCategoryId : Int?

    
    var SubCategoryImage : String?
    var SubCategoryName : String?


   

    
    init(json: [String: Any]?) {
        
        SubCategoryId = 0
        if let str = json!["SubCategoryId"] as? Int {
            SubCategoryId = str
        }
        CategoryId = 0
        if let str = json!["CategoryId"] as? Int {
            CategoryId = str
        }
        
       
        
        
        SubCategoryImage = ""
        if let str = json!["SubCategoryImage"] as? String {
            SubCategoryImage = str
        }
        
        
        SubCategoryName = ""
        if let str = json!["SubCategoryName"] as? String {
            SubCategoryName = str
        }
        
        
        
      
    }
    
    func toDict() -> [String:AnyObject]
    {
        var dicParam = [String:AnyObject]()
        
       dicParam["CategoryId"] = CategoryId as AnyObject
        dicParam["SubCategoryImage"] = SubCategoryImage as AnyObject
       
        dicParam["SubCategoryName"] = SubCategoryName as AnyObject

        dicParam["SubCategoryId"] = SubCategoryId as AnyObject

        
        
        return dicParam
    }
}
