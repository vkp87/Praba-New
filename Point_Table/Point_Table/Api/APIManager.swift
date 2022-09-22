//
//  APIManager.swift
//  Mellina
//
//  Created by Jatin Rathod on 10/08/18.
//  Copyright © 2018 iOS Rathod. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class APIManager: NSObject {
    
   
    class func getRequestPath(api : String) -> String
    {
        return APIFunctions.requestPath(api: api, base: baseURL)
    }
    class func requestGetAPI(_ strURL: API,isLoading:Bool,  headers : [String : String]?, success:@escaping (_ result: AnyObject?) -> Void, failure:@escaping (Error) -> Void) {
        
        print("Api ==>\(self.getRequestPath(api: strURL.rawValue))")
        print("Header ==>\(headers!)")
        if isLoading == true {
            MBProgressHUD.showAdded(to:(objApplication.window?.rootViewController?.view)!, animated: true)
        }
        Alamofire.request(self.getRequestPath(api: strURL.rawValue), headers: headers).responseJSON { (responseObject) -> Void in
            
            print("Responce ==>\(responseObject)")
            
            if isLoading == true {
                MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)
            }
            print(responseObject)
            
            let statusCode = responseObject.response?.statusCode
            if statusCode == 200 {
                if responseObject.result.isSuccess {
                    let  resJson = responseObject.result.value
                    success(resJson as AnyObject)
                }
            } else {
                if responseObject.result.isFailure {
                    if isLoading == true {
                        MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)
                    }
                    let error : Error = responseObject.result.error!
                    
                    failure(error)
                } else {
                    var msg = ""
                    let  resJson = responseObject.result.value
                    let Dict = resJson as! [String:Any]
                    msg = "Error for request"
                    if let message = Dict["message"] as? String {
                        msg = message
                    }
                    if msg != "The network connection was lost." {
                        CommonFunctions.showMessage(message: msg)

                    }
                    
                }
            }
        }
    }
    class func requestGet(_ strURL: String,isLoading:Bool,  headers : [String : String]?, success:@escaping (_ result: AnyObject?) -> Void, failure:@escaping (Error) -> Void) {

        if isLoading == true {
            MBProgressHUD.showAdded(to:(objApplication.window?.rootViewController?.view)!, animated: true)
        }
        Alamofire.request(strURL, headers: headers).responseJSON { (responseObject) -> Void in
            
            if isLoading == true {
                MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)
            }
            print(responseObject)
            
            let statusCode = responseObject.response?.statusCode
            if statusCode == 200 {
                if responseObject.result.isSuccess {
                    let  resJson = responseObject.result.value
                    success(resJson as AnyObject)
                }
            } else {
                if responseObject.result.isFailure {
                    if isLoading == true {
                        MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)
                    }
                    let error : Error = responseObject.result.error!
                    
                    failure(error)
                } else {
                    var msg = ""
                    let  resJson = responseObject.result.value
                    let Dict = resJson as! [String:Any]
                    msg = "Error for request"
                    if let message = Dict["message"] as? String {
                        msg = message
                    }
                    if msg != "The network connection was lost." {
                        CommonFunctions.showMessage(message: msg)

                    }
                    
                }
            }
        }
    }
    class func requestPostJsonEncoding(_ strURL : API,isLoading:Bool, params : [String : Any]?, headers : [String : String]?, success:@escaping (_ result: AnyObject?) -> Void, failure:@escaping (Error) -> Void){
        
        var param = params
        param!["Device"] = "IOS"
        param!["DeviceType"] = 2

        if isLoading == true {
            MBProgressHUD.showAdded(to:(objApplication.window?.rootViewController?.view)!, animated: true)
        }
        
        
        Alamofire.request(self.getRequestPath(api: strURL.rawValue), method: .post, parameters: param, encoding: JSONEncoding.default , headers: headers).responseJSON { (responseObject) -> Void in
            
            if isLoading == true {
                MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)
            }
            let statusCode = responseObject.response?.statusCode
            if statusCode == 200 {
                if responseObject.result.isSuccess {
                    let  resJson = responseObject.result.value
                    let Dict = resJson as! [String:Any]
                    if let custom_code = Dict["custom_code"] as? Int {
                        if custom_code == 999 || custom_code == 1001 {
                            var msg = ""
                            msg = "Error for request"
                            if let message = Dict["message"] as? String {
                                msg = message
                            }
                            if msg != "The network connection was lost." {
                                CommonFunctions.showMessage(message: msg)

                            }
                        }
                        else {
                            success(resJson as AnyObject)
                            
                        }
                    }
                    
                }
            } else {
                if responseObject.result.isFailure {
                    if isLoading == true {
                        MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)
                    }
                    let error : Error = responseObject.result.error!
                    
                    failure(error)
                } else {
                    var msg = ""
                    let  resJson = responseObject.result.value
                    let Dict = resJson as! [String:Any]
                    msg = "Error for request"
                    if let message = Dict["message"] as? String {
                        msg = message
                    }
                    if msg != "The network connection was lost." {
                        CommonFunctions.showMessage(message: msg)

                    }
                    
                }
            }
        }
    }
    class func requestPostJsonMultipart(_ strURL : API,isLoading:Bool, params : [String : Any]?, imageData: Data?, headers : [String : String]?, success:@escaping (_ result: AnyObject?) -> Void, failure:@escaping (Error) -> Void){
        
        if isLoading == true {
            MBProgressHUD.showAdded(to:(objApplication.window?.rootViewController?.view)!, animated: true)
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params! {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "File", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: self.getRequestPath(api: strURL.rawValue), method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if isLoading == true {
                        MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)
                    }
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 {
                        if response.result.isSuccess {
                            let  resJson = response.result.value
                            success(resJson as AnyObject)
                        }
                    }else {
                        var msg = ""
                        let  resJson = response.result.value
                        let Dict = resJson as! [String:Any]
                        msg = "Error for request"
                        if let message = Dict["message"] as? String {
                            msg = message
                        }
                        if msg != "The network connection was lost." {
                            CommonFunctions.showMessage(message: msg)

                        }
                        
                    }
                    
                }
            case .failure(let error):
                if isLoading == true {
                    MBProgressHUD.hide(for: (objApplication.window?.rootViewController?.view)!, animated: true)
                    failure(error)
                }
                
            }
        }
        
    }
    
    
}
