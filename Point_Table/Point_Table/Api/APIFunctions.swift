//
//  APIFunctions.swift
//  Base
//
//  Created by Jatin Rathod on 4/24/15.
//  Copyright (c) 2015 Rathod. All rights reserved.
//

import Foundation

/**
 Below is emun which is defining different API
 as constant.
 */
let baseURL: String = Base.url

enum API : String {
    
    case resendotp = "api/user/resendotp"
    case applypromocode = "api/order/applypromocode"
    case saveuserimage = "/api/user/saveuserimage"
    case validatezipcode = "api/order/validatezipcode"
    case searchStore = "/api/location/getlocations"

  
    case registration = "api/user/registration"
    case validateotp = "api/user/validateotp"
    case dologin = "api/user/dologin"
    case forgotpassword = "api/user/forgotpassword"

    case updatepassword = "api/user/updatepassword"
    case homepagedetail = "api/user/homepagedetail"

    case userpointhistory = "api/user/userpointhistory"
    case getallpromotions = "api/promotion/getallpromotions"

    case addedittoken = "api/user/addedittoken"

    
    case updateuserprofile = "api/user/updateuserprofile"

    
    case removetoken = "api/user/removetoken"

    case validatemobileno = "api/user/validatemobileno"

    case updateusermobileno = "api/user/updateusermobileno"
    case getallpromotioncategory = "api/category/getallpromotioncategory"

    
    case getallcategory = "api/category/getallcategory"
    
    case getallsubcategory = "api/category/getallsubcategory"

    case getallshops = "api/category/getallshops"

    case getallproduct = "api/product/getallproduct"

    case productsearch = "api/product/productsearch"
    case getallproductweb = "api/product/getallproductweb"

    case getallbrandweb = "api/product/getallbrandweb"

    
    case getallbrand = "api/product/getallbrand"
    case getproductdetail = "/api/product/getproductdetail"
    case addremovewishlist = "/api/product/addremovewishlist"

    case getallwishlistproduct = "/api/product/getallwishlistproduct"

    case addorremovetocart = "api/order/addorremovetocart"
    
    case cartcount = "api/order/cartcount"


    case getcartdetail = "api/order/getcartdetail"
    
    case deletecartitem = "api/order/deletecartitem"
    
    case getuseradresslist = "api/user/getuseradresslist"

    case addedituseradress = "api/user/addedituseradress"

    case updatedefaultaddress = "api/user/updatedefaultaddress"

    case deleteaddress = "api/user/deleteuseraddress"

    case getOrderSummary = "api/order/getordersummary"
    
    case getallorderpromotions = "api/order/getallpromotions"
    
    case placeorder = "api/order/placeorder"
    case confirmPayment = "api/order/paymentconfirmation"

    
    case getallmyorders = "api/order/getallmyorders"
    case getallmyordersdetail = "api/order/getallmyordersdetail"

    case getcodconfiguration = "api/order/getcodconfiguration"

    case getuserbillingadress = "api/user/getuserbillingadress"
    
    case addedituserbillingadress = "api/user/addedituserbillingadress"
    case repeatorder = "api/order/repeatorder"
    
    
    case getmobileversion = "api/user/getmobileversion"


}




struct APIFunctions {
    /**
     Below are that const veriables which are defining different
     API path in app.
     */
     
    static func requestPath( api : String, base : String) -> String {
     //   let path = String(format: base, api)
        let path = base +  api
        return path
    }
}
