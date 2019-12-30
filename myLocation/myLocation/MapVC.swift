//
//  MapVC.swift
//  myLocation
//
//  Created by mohamed on 12/25/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//donot foret to add 
class MapVC: UIViewController {
    //my map view
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var press: UIButton!
    //the region
    let regionInMeter:Double = 10000
    //instance of CllocationManager Class
    let locationmanager = CLLocationManager()
   
    //for delegation protocol
    var delegate : MyDelegate?
    //for adress name
    var previousLocation : CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        Map.delegate = self
        
        
    }

    //go back
    @IBAction func Press(_ sender: UIButton) {
      //  self.delegate!.SendMapData(Data: <#T##String#>)
        dismiss(animated: true, completion: nil)
        
    }
    
    func setuplocationmanager(){
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    func centerViewOnuserLocation()
    {
        if let location = locationmanager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            Map.setRegion(region, animated: true)
            print("my location is \(location.latitude)")
            print("my location is \(location.longitude)")
    
        }
        
    }
    
   
    
    
    
    func checkLocationAuherization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse :
            //do map stuff
            starTrackuserLocation()
        case .denied :
            //make Alert
            break
        case .notDetermined :
            locationmanager.requestWhenInUseAuthorization()
        case .restricted :
            //make Alert
            break
        case .authorizedAlways :
            
            break
       
        
        }
    }
    func starTrackuserLocation()
       {
           Map.showsUserLocation = true
           centerViewOnuserLocation()
           locationmanager.startUpdatingLocation()
           previousLocation = getCenterLocation(for: Map)
        
        
       }
    
    func checkLocationServices()
    {
    //check if services of mobile for location is on or off
        if CLLocationManager.locationServicesEnabled()
        {
           //setup our location manager
            setuplocationmanager()
            checkLocationAuherization()
        }
        else{
            //setup alert
        }
    }
   
    
    func getCenterLocation(for mapView : MKMapView)-> CLLocation
    {
        let latitud = Map.centerCoordinate.latitude
        let longitud = Map.centerCoordinate.longitude
        return CLLocation(latitude: latitud, longitude: longitud)
      
    }
    
}


extension MapVC :CLLocationManagerDelegate{
    //when the location is changed that func tell the delegate ther is anew location
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {return}
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let regoin = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
//        Map.setRegion(regoin, animated: true)
//    }
    
    //when the user changed the autherization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuherization()
    }
    
}

extension MapVC : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: Map)
        let geocoder = CLGeocoder()
        guard let previouslocation = self.previousLocation else {return}
        guard center.distance(from: previousLocation!) > 50 else {  return  }
        geocoder.reverseGeocodeLocation(center){ [weak self] (placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error {
              print("Fail")
              return
            }
            guard let placemarks = placemarks?.first else
            {
                return
            }
            
            let streetAdress = placemarks.subThoroughfare ?? ""
           let streetName = placemarks.name ?? ""
            DispatchQueue.main.async {
            //     self.press.setTitle(streetName, for: .normal)
                self.delegate?.SendMapData(Data: streetName)
                self.press.setTitle(streetName, for: .normal)
                
            }
           
            
            
        }
        
    }
}

