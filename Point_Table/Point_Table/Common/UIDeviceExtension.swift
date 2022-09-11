//
//  UIDeviceExtension.swift
//  XXSIM
//
//  Created by Yudiz Solutions on 22/01/18.
//  Copyright © 2018 Yudiz Solutions. All rights reserved.
//

import UIKit

class ScreenSize: NSObject {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let frame        = UIScreen.main.bounds
    static let maxLength    = max(width, height)
    static let minLength    = min(width, height)    
    @objc class var widthRatio: CGFloat {
        return width/375
    }
    @objc class var heightRatio: CGFloat {
        return height/812
    }
}

struct DeviceType {
    static let isIPhone4OrLess  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength < 568.0
    static let isIPhone5        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 568.0
    static let isIPhone8        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 667.0
    static let isIPhone8Plus    = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 736.0
    static let isIPhoneX        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 812.0
    static let isIPad           = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1024.0
    static let isIPadPro        = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.minLength == 1024.0
    static let isPad            = UIDevice.current.userInterfaceIdiom == .pad
    static let isPhone          = UIDevice.current.userInterfaceIdiom == .phone
}

struct Version {
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7     = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8     = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9     = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10    = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
    static let iOS11    = (Version.SYS_VERSION_FLOAT >= 11.0 && Version.SYS_VERSION_FLOAT < 12.0)
}


//MARK: - Devices
//To identify devices and its Family
extension UIDevice {
    
    class func configureFor(i6p b1:()->(), i6 b2:()->(), i5 b3:()->(), i4 b4:()->()) {
        if DeviceType.isIPhone8Plus {
            b1()
        } else if DeviceType.isIPhone8 {
            b2()
        } else if DeviceType.isIPhone5 {
            b3()
        } else if DeviceType.isIPhone4OrLess {
            b4()
        }
    }
}
