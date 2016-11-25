//
//  ViewController.swift
//  MyLocation
//
//  Created by TimberTang on 16/11/24.
//  Copyright © 2016年 TimberTang. All rights reserved.
//  获取当前位置信息首先要在 info.plist 中添加 "Privacy - Location Always Usage Description" 和 "Privacy - Location When In Use Usage Description" 这两个获取位置权限的描述

import UIKit
import CoreLocation

final class ViewController: UIViewController {

    @IBOutlet weak var labMyCurrentLocation: UILabel!
    fileprivate var locationManager: CLLocationManager? = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func findMyLocation(_ sender: UIButton) {
        if let manager = locationManager {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation()
        }
    }
}

// CLLocationManagerDelegate
extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         labMyCurrentLocation.text = "Error while updating location " + error.localizedDescription
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {[weak self] (placemarks, error)->Void in
            if let `self` = self {
                guard  error == nil else {
                    self.labMyCurrentLocation.text = "Reverse geocoder failed with error" + error!.localizedDescription
                    return
                }
                if let palces = placemarks {
                    if palces.count > 0 {
                        let pm = palces[0]
                        self.displayLocationInfo(pm)
                    }else {
                        self.labMyCurrentLocation.text = "Problem with the data received from geocoder"
                    }
                }
            }
        })
    }
    
    private func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            locationManager?.stopUpdatingLocation()//stop updating location to save battery life
            let locality = containsPlacemark.locality ?? ""
            let postalCode = containsPlacemark.postalCode ?? ""
            let administrativeArea = containsPlacemark.administrativeArea ?? ""
            let country = containsPlacemark.country ?? ""
            labMyCurrentLocation.text = locality +  postalCode +  administrativeArea +  country
        }
    }
    
}


