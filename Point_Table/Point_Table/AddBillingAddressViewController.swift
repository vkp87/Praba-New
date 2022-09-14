//
//  MyAddressListViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 29/12/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GooglePlaces

class AddBillingAddressViewController: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var txtfname: SkyFloatingLabelTextField!
    @IBOutlet weak var txtlname: SkyFloatingLabelTextField!
    @IBOutlet weak var txtmobile: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtAddress1: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress2: SkyFloatingLabelTextField!
    @IBOutlet weak var txtTown: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPostal: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    
    
    var UserAddressId = 0
    
    var addressCount = 0
    
    
    var arrAddress = [BillingAddressModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
        getuseradresslist()
        
        // Do any additional setup after loading the view.
    }
    func getuseradresslist() -> Void {
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            let user = UserModel(json: userdict)
            if Reachability.isConnectedToNetwork() {
                var param  = [String : Any]()
                param["UserId"] = user.UserId
                APIManager.requestPostJsonEncoding(.getuserbillingadress, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    
                    if let data1 = Dict["data"] as? [String:Any] {
                        
                        
                        let obj = BillingAddressModel(json: data1)
                        self.arrAddress.append(obj)
                    }
                    if(self.arrAddress.count > 0) {
                        
                        
                        self.UserAddressId = self.arrAddress[0].UserBillingAddressId ?? 0
                        
                        
                        
                        self.txtfname.text = self.arrAddress[0].FirstName!
                        self.txtlname.text = self.arrAddress[0].LastName!
                        self.txtmobile.text = self.arrAddress[0].MobileNo!
                        self.txtAddress1.text = self.arrAddress[0].StreetAddress1!
                        self.txtAddress2.text =  self.arrAddress[0].StreetAddress2!
                        self.txtTown.text =  self.arrAddress[0].Town!
                        self.txtPostal.text =  self.arrAddress[0].PostCode!
                        
                        
                        
                    }
                    
                    
                }) { (error) -> Void in
                    CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
    
    //MARK:- Setup UI
    
    func textSet(text : SkyFloatingLabelTextField) {
        text.font = UIFont(name: Font_Regular, size: 17)
        text.titleFormatter = { $0 }
    }
    
    func SetupUI() -> Void {
        
        
        CommonFunctions.setCornerRadius(view: btnSubmit, radius: 21)
        
        btnSubmit.titleLabel?.font = UIFont(name: Font_Semibold, size: 17)
        btnSearch.titleLabel?.font = UIFont(name: Font_Regular, size: 17)
        CommonFunctions.setCornerRadius(view: btnSearch, radius: btnSearch.frame.height/2)

        
        CommonFunctions.setCornerRadius(view: btnSubmit, radius: btnSubmit.frame.height/2)
        
        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        self.textSet(text: txtfname)
        self.textSet(text: txtlname)
        self.textSet(text: txtmobile)
        self.textSet(text: txtAddress1)
        self.textSet(text: txtAddress2)
        self.textSet(text: txtTown)
        self.textSet(text: txtPostal)
        
        
        txtfname.delegate = self
        txtlname.delegate = self
        txtmobile.delegate = self
        txtAddress1.delegate = self
        txtAddress2.delegate = self
        txtTown.delegate = self
        txtPostal.delegate = self
        
        
        
        
        
        
        
    }
    
    
    // MARK: - IBAction Event
    
    @IBAction func btnSearchClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.country = "UK"
        filter.type = .geocode
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        self.view.endEditing(true)
        if txtfname.text == ""
        {
            CommonFunctions.showMessage(message: Message.fname)
            return
        }
        
        if txtlname.text == ""
        {
            CommonFunctions.showMessage(message: Message.lname)
            return
        }
        
        if txtmobile.text == ""
        {
            CommonFunctions.showMessage(message: Message.mobile)
            return
        }
        
        if txtAddress1.text == ""
        {
            CommonFunctions.showMessage(message: Message.add1)
            return
        }
        
        /* if txtAddress2.text == ""
         {
         CommonFunctions.showMessage(message: Message.add2)
         return
         }*/
        
        if txtTown.text == ""
        {
            CommonFunctions.showMessage(message: Message.town)
            return
        }
        
        if txtPostal.text == ""
        {
            CommonFunctions.showMessage(message: Message.postalcode)
            return
        }
        
        if let userdict = CommonFunctions.getUserDefaultObjectForKey(key: UserDefaultsKey.USER) as? [String:Any] {
            
            let user = UserModel(json: userdict)
            
            if Reachability.isConnectedToNetwork() {
                
                var param  = [String : Any]()
                param["FirstName"] = txtfname.text!
                param["LastName"] = txtlname.text!
                param["MobileNo"] = txtmobile.text!
                
                param["StreetAddress1"] = txtAddress1.text!
                param["StreetAddress2"] = txtAddress2.text!
                param["Town"] = txtTown.text!
                param["PostCode"] = txtPostal.text!
                
                param["UserAddressId"] = UserAddressId
                
                param["UserId"] = user.UserId!
                
                APIManager.requestPostJsonEncoding(.addedituserbillingadress, isLoading: true, params: param, headers: [:],success: { (JSONResponse)  -> Void in
                    
                    let Dict = JSONResponse as! [String:Any]
                    print(Dict)
                    self.navigationController?.popViewController(animated: true)
                    CommonFunctions.showMessage(message: Message.successaddyouradress)
                }) { (error) -> Void in
                    CommonFunctions.showMessage(message: "\(error.localizedDescription)")
                }
            } else {
                CommonFunctions.showMessage(message: Message.internetnotconnected)
            }
        }
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
//MARK: - Textfield Delegate
extension AddBillingAddressViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        
        
        if textField == txtmobile
        {
            let maxLength = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        let maxLength = 50
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
    }
}
extension AddBillingAddressViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name!)")
        print("Place ID: \(place.placeID!)")
        
        // objApplication.applatitude = place.coordinate.latitude
        //objApplication.applongitude = place.coordinate.longitude
        
        
        self.dismiss(animated: true, completion: nil)
        
        // A hotel in Saigon with an attribution.
        let placeID = place.placeID ?? ""
        
        
        if Reachability.isConnectedToNetwork() {
            
            self.txtAddress1.text = ""
            self.txtAddress2.text = ""
            
            //let params = ["username":"john", "password":"123456"] as Dictionary<String, String>
            
            var request = URLRequest(url: URL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=\(Google_Key)")!)
            request.httpMethod = "GET"
            //request.httpBody = try? JSONSerialization.data(withJSONObject: [], options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                print(response!)
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    
                    if let result = json["result"] as? [String : Any] {
                        
                        if let geometry = result["address_components"] as? [[String : Any]] {
                            
                            for obj in geometry {
                                
                                if let type = obj["types"] as? [String] {
                                    
                                    for obj1 in type {
                                        
                                        if obj1 == "route" {
                                            DispatchQueue.main.async {
                                                
                                                self.txtAddress1.text =  obj["long_name"] as? String
                                            }
                                            
                                        }
                                        if obj1 == "sublocality_level_2" {
                                            DispatchQueue.main.async {
                                                
                                                self.txtAddress1.text =  "\(self.txtAddress1.text!), \(obj["long_name"] as! String)"
                                            }
                                            
                                        }
                                        if obj1 == "sublocality_level_1" {
                                            DispatchQueue.main.async {
                                                
                                                self.txtAddress2.text =  obj["long_name"] as? String
                                            }
                                            
                                        }
                                        
                                        if obj1 == "locality" {
                                            DispatchQueue.main.async {
                                                
                                                self.txtAddress2.text =  "\(self.txtAddress2.text!) \(obj["long_name"] as! String)"
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        if obj1 == "administrative_area_level_1" {
                                            DispatchQueue.main.async {
                                                
                                                self.txtAddress2.text =  "\(self.txtAddress2.text!) \(obj["long_name"] as! String)"
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        
                                        if obj1 == "postal_code" {
                                            DispatchQueue.main.async {
                                                
                                                self.txtPostal.text =  obj["long_name"] as? String
                                            }
                                            
                                        }
                                        
                                        if obj1 == "postal_town" {
                                            DispatchQueue.main.async {
                                                
                                                self.txtTown.text =  obj["long_name"] as? String
                                            }
                                            
                                        }
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                        
                        if let geometry = result["geometry"] as? [String : Any] {
                            if let location = geometry["location"] as? [String : Any] {
                                
                                if let lat = location["lat"] as? Double {
                                    print(lat)
                                    //  dictSendRequest["Latitude"] = lat
                                    //objApplication.applatitude = lat
                                    
                                }
                                
                                if let lng = location["lng"] as? Double {
                                    print(lng)
                                    
                                    //dictSendRequest["Longitude"] = lng
                                    //objApplication.applongitude = lng
                                    
                                }
                                
                                
                            }
                        }
                        
                    }
                } catch {
                    print("error")
                }
            })
            
            task.resume()
            
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
        
        
        //  tblView.reloadData()
        
        // dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
