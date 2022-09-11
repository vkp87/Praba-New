//
//  CommonFunctions.swift
//  PDRemote
//
//  Created by Jatin Rathod on 10/19/16.
//  Copyright © 2016 Rathod. All rights reserved.
//

import UIKit
import EMAlertController

class CommonFunctions: NSObject {
    
    var plistDict: [String: AnyObject]!
    static let sharedInstance = CommonFunctions()
    
    
    override init() {

        
    }
    
    public class func toString(dateFormat : String , Dateobj : Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: Dateobj)
    }
    public class func toDate(dateFormat : String , Dateobj : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        if let date1 = dateFormatter.date(from: Dateobj)
        {
            return date1
        }
        return Date()
        
    }

    func GetPlistForSurvay()->(source:[String:AnyObject],options:[String:AnyObject]) {

        var source = [String:AnyObject]()
        var options = [String : AnyObject]()
        
        if let path = Bundle.main.path(forResource: "SF36Scores", ofType: "plist") {
            
            if let dic = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                source = dic as [String : AnyObject]
            }
        }
        
        if let path = Bundle.main.path(forResource: "SF36Options", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                options = dic as [String : AnyObject]
            }
        }
        return(source,options)
    }
    
    
    
    public class func appendString(data: Double) -> String { // changed input type of data
        let value = data
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2 // for float
        formatter.maximumFractionDigits = 2 // for float
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 5
        formatter.paddingPosition = .afterPrefix
        formatter.paddingCharacter = "0"
        return formatter.string(from: NSNumber(floatLiteral: value))! // here double() is not required as data is already double
    }
    
    // MARK: -  Alert
    public class func showMessage(message : String) {
        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
        //let icon = UIImage(named: "login_ic")
        let alertError = EMAlertController(icon: nil, title: nil, message: message)
        alertError.addAction(EMAlertAction(title: "OK", style: .normal, action: {
            rootViewController.dismiss(animated: true, completion: nil)
        }))
        rootViewController.present(alertError, animated: true, completion: nil)
    }
    
   
    
    //MARK: Image resize
    public class func compressImage(img:UIImage) -> UIImage? {
        // Reducing file size to a 10th
        var actualHeight: CGFloat = img.size.height
        var actualWidth: CGFloat = img.size.width
        let maxHeight: CGFloat = 1136.0
        let maxWidth: CGFloat = 640.0
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        var compressionQuality: CGFloat = 0.5
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        img.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        
        
        guard let imageData = img.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    //MARK: User Default Finctions wihtout Encription/Decription
    public class func setUserDefault(object: AnyObject, key: String) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public class func getUserDefault(key: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    
    //MARK :- IS Login
    public class func userLoginData() -> Bool
    {
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
        
            let user = UserModel(json: userdict)

            if user.isOtpVerify == true {
                return true

            } else {
                return false

            }
            print(userdict)
            return true
        } else {
            return false
        }
    }
    //MARK: - User Default Functions
    public class func setUserDefaultObject(object : AnyObject, key : String) {

        let data:Data = NSKeyedArchiver.archivedData(withRootObject: object)
        
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    //get encoded data from userDefault
    public class func getUserDefaultObjectForKey(key : String) -> AnyObject? {
        var retval : AnyObject! = nil
        
        if let data: AnyObject = UserDefaults.standard.object(forKey: key) as AnyObject? {
            retval = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as AnyObject?
        }
        
        return retval
    }
    
    //remove key value from user default
    public class func removeUserDefaultForKey(key : String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    //MARK :- GET NUMBER
    public class func stringwithnum(str:String) -> String
    {
        return str.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
    }

    
    
    //email validation
    public class func isValid(Email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        //@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: Email)
    }
    //Base 64 string validation
    public class func fromBase64(stringPass : String) -> String? {
        guard let data = Data(base64Encoded: stringPass) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    public class func toBase64(stringPass : String) -> String {
        return Data(stringPass.utf8).base64EncodedString()
    }
    
    
    public class func setGradient(view : UIView,Color1:UIColor,Color2 : UIColor,radius:CGFloat) {
        DispatchQueue.main.async {
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [Color1.cgColor,Color2.cgColor]
            view.layer.cornerRadius = radius
            view.layer.insertSublayer(gradient, at: 0)
            gradient.cornerRadius = radius
            view.layer.masksToBounds = true;
            view.clipsToBounds = true;
        }
    }
    
    public class  func setBorder(view : UIView,color : UIColor,width : CGFloat) {
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = width
    }
    
    public class  func setShadow(view: UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 5.0
        view.layer.masksToBounds = false

        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    public class func roundCornerView(view: UIView){
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 15
    }
    public class func setShadowInImageView(imgView: UIImageView) {
        imgView.layer.shadowColor = UIColor.black.cgColor
        imgView.layer.shadowOpacity = 0.8
        imgView.layer.shadowRadius = 3.0
        imgView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        imgView.clipsToBounds = false
    }
    
    public class func setCornerRadius(view: UIView,radius: CGFloat) {
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
    }
    
    public class func getDirectoryPath() -> NSURL {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Supervisorvisit")
        let url = NSURL(string: path)
        return url!
    }
    public class func getImageFromDocumentDirectory(strImagepath : String) -> UIImage? {
        let fileManager = FileManager.default
            let imagePath = (self.getDirectoryPath() as NSURL).appendingPathComponent("\(strImagepath)")
            let urlString: String = imagePath!.absoluteString
            if fileManager.fileExists(atPath: urlString) {
                if let image = UIImage(contentsOfFile: urlString) {
                    return image } else {
                    return nil
                }
            } else {
                return nil
        }
    }
    public class func setPadding(textField: UITextField, width: Int) {
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: Int(textField.frame.height)))
        textField.leftViewMode = .always

    }
    public class func saveImageDocumentDirectory(image: UIImage, imageName: String) {
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Supervisorvisit")
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        
        let url = NSURL(string: path)
        let imagePath = url!.appendingPathComponent(imageName)
        let urlString: String = imagePath!.absoluteString
        let imageData = image.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
    }
    public class func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    
}

extension Date {
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }
    
}
extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    public func getDateWithFormate(_ formate:String)->String!{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        let date = dateFormatter.string(from: self)
        return date
    }
}
extension UIView {
    func animRightShow() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.x -= self.bounds.width
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animRightHide(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.x += self.bounds.width
                        self.layoutIfNeeded()
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
//MARK: Shadow View
extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, radius: CGFloat = 1) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    func dropShadow1(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
    var fileName: String {
       URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    var fileExtension: String{
       URL(fileURLWithPath: self).pathExtension
    }
}

extension URL {
    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
