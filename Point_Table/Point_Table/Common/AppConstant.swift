//
//  Constant.swift
//  PDRemote
//
//  Created by Jatin Rathod on 10/18/16.
//  Copyright © 2016 Rathod. All rights reserved.
//

import Foundation
import UIKit


public let Google_Key = "AIzaSyCtfzBYm86_zgoW0xZNcB_LwvGbYXrPWl8"
public let Stripe_Live_Key = "pk_test_51It01vC6FRxOI6gySTInPRqiulf3Jt3skEW7iziyQWNnY4wcdTtsimClmbeLyFzDd7opyrstbf16L7v0NMYOKUd200eNABn6Td"
public let Stripe_Test_Key = "pk_test_XLbzYEXOWVnphE4qNXnsrnIs00NlvqoIlV"

//public let Font_Semibold = "OpenSans-Semibold"
//public let Font_Light = "OpenSans-Light"
//public let Font_Bold = "OpenSans-Bold"
//public let Font_Regular = "OpenSans"


public let Font_Semibold = "Arial-Mdm"
public let Font_Light = "Arial-Lgt"
public let Font_Bold = "Arial-BoldMT"
public let Font_Regular = "ArialMT"


public let Font_Mon_Semibold = "Arial-Mdm"
public let Font_Mon_Light = "Arial-Lgt"
public let Font_Mon_Bold = "Arial-BoldMT"
public let Font_Mon_Regular = "ArialMT"


public let Font_Number = "Impact"

//public let Font_Mon_Semibold = "Montserrat-SemiBold"
//public let Font_Mon_Light = "Montserrat-Light"
//public let Font_Mon_Bold = "Montserrat-Bold"
//public let Font_Mon_Regular = "Montserrat"





let uuid = UUID().uuidString
var appName : String = "Praba Grocery"
let bundleIdentifier = Bundle.main.bundleIdentifier
let objApplication     = UIApplication.shared.delegate as! AppDelegate



public let unselected_tab_color = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)

public let Theme_Color = UIColor(red: CGFloat(234 / 255.0), green: CGFloat(52 / 255.0), blue: CGFloat(37 / 255.0), alpha: CGFloat(1.0))


public let Theme_Red_Color = UIColor(red: CGFloat(233 / 255.0), green: CGFloat(50 / 255.0), blue: CGFloat(34 / 255.0), alpha: CGFloat(1.0))


public let selected_tab_color = UIColor(red: CGFloat(234 / 255.0), green: CGFloat(52 / 255.0), blue: CGFloat(37 / 255.0), alpha: CGFloat(1.0))


public let Theme_green_Color = UIColor(red: CGFloat(114 / 255.0), green: CGFloat(199 / 255.0), blue: CGFloat(71 / 255.0), alpha: CGFloat(1.0))

enum ApiMode: Int {
    case DEV = 1
    case QC = 2
    case PROD = 3
}

// Api Mode, Based on this dynamic links will be generated

var apiMode: ApiMode = .PROD

//MARK: API URL
struct Base {
    
    //Dev
//    public static let url =  "http://pointapidemo.softworldinfotech.com/"
    //382415 : Post Code

    //Production
    public static let url =  "https://pointtableapi.prabagrocery.com/"
    //9427384408
    //Test@12345
    //DN31SE : Post Code
    //DN11DE : Post Code
}


enum ControllerType : Int {
    case WishList = 1
    case Cart = 2
    case Home = 3
    case OrderList = 4
    case OrderDetail = 5
    case AddRemoveWishlist = 6
    case Empty = 7
    
}
//MARK: Screen Size
public struct MainScreenSize {
    public static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    public static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    public static let SCREEN_MAX_LENGTH = max(MainScreenSize.SCREEN_WIDTH, MainScreenSize.SCREEN_HEIGHT)
    public static let SCREEN_MIN_LENGTH = min(MainScreenSize.SCREEN_WIDTH, MainScreenSize.SCREEN_HEIGHT)
}
//MARK: Rounds the double

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}





//MARK: Device Type
public struct MainDeviceType {
    public static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && MainScreenSize.SCREEN_MAX_LENGTH < 568.0
    public static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && MainScreenSize.SCREEN_MAX_LENGTH == 568.0
    public static let IS_IPHONE_5_OR_GRETER = UIDevice.current.userInterfaceIdiom == .phone && MainScreenSize.SCREEN_MAX_LENGTH > 568.0
    public static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && MainScreenSize.SCREEN_MAX_LENGTH == 667.0
    public static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && MainScreenSize.SCREEN_MAX_LENGTH == 736.0
    public static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && MainScreenSize.SCREEN_MAX_LENGTH == 812.0
    public static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
}

public struct UserDefaultsKey {
    static let ACCESSTOKEN = "ACCESSTOKEN"
    static let PROFILE = "PROFILE"
    static let USER = "USER"
    static let FINGER = "isFinger"
    static let Devtoken = "DEVTOKEN"
    static let Currency = "CurrencySymbol"
    static let StoreID = "STOREID"

    static let PostVer = "POSTCODEVERSION"

    
}
public struct DateFormateStr {
    static let YYYYMMDD = "yyyy-MM-dd"
    static let DDMMYYYY = "dd/MM/yyyy"
    static let HHMM = "hh:mm a"
    static let YYMMDD = "yyMMdd"
    static let MMDDYYYY = "MM-dd-yyyy"

    
}

public struct HeaderKey {
    static let Authorization = "Authorization"
    
}





