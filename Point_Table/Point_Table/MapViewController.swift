//
//  MapViewController.swift
//  Point_Table
//
//  Created by Jatin Rathod on 18/12/19.
//  Copyright © 2019 Jatin Rathod. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var mapview: MKMapView!
    var arrBanner = [ShopeModel]()
    let annotation = MKPointAnnotation()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        objApplication.setLocation()

        self.SetupUI()
        
        getShopedetail()

        // Do any additional setup after loading the view.
    }
    //MARK:- Setup UI
    func SetupUI() -> Void {
        

        lblHeader.font = UIFont(name: Font_Semibold, size: 18)
        
        
    }
    //MARK: - Ws Call
    
    func getShopedetail() -> Void {
        
        self.arrBanner.removeAll()
        if Reachability.isConnectedToNetwork() {
            
            APIManager.requestPostJsonEncoding(.getallshops, isLoading: true,params: [:], headers: [:],success: { (JSONResponse)  -> Void in
                
                let Dict = JSONResponse as! [String:Any]
                print(Dict)
                
                
                if let data = Dict["data"] as? [[String:Any]] {
                    
                        for objAd in data {
                            let obj = ShopeModel(json: objAd)
                            
                            self.annotation.coordinate = CLLocationCoordinate2D(latitude: obj.Latitude ?? 0.0, longitude: obj.Longitude ?? 0.0)
                            self.annotation.title = obj.BusinessName ?? ""
                            
                            self.mapview.addAnnotation(self.annotation)
                            self.arrBanner.append(obj)
                        }
                        
                }

                
                
            }) { (error) -> Void in
                    // CommonFunctions.showMessage(message: "\(error.localizedDescription)")
            }
        } else {
            CommonFunctions.showMessage(message: Message.internetnotconnected)
        }
    }
    //MARK:- IBAction Event

    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
