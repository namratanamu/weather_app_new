//
//  ViewController.swift
//  Weather_Map
//
//  Created by Mac on 15/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//


import UIKit
import  MapKit
class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate   {
    
    
    
    var lati = Double()
    var longi = Double()
    
    let locationmanager = CLLocationManager()
    
   
    enum JsonErrors:Error
    {
        case dataError
        case conversionError
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.view.backgroundColor = UIColor(patternImage:UIImage(named: "images-2.jpeg")!)
        
        parseJson()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    //@IBOutlet weak var tableview1: UITableView!
    
    func parseJson()
    {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lati)&lon=\(longi)&appid=d1f8d629f7379fee7a22af945d4eadff" 
        
        
        //"https://api.openweathermap.org/data/2.5/weather?lat=19.0176147 &lon=72.8561644&appid=d1f8d629f7379fee7a22af945d4eadff"
        let url:URL = URL(string: urlString)!
        let sessionconfiguration =  URLSessionConfiguration.default
        let session = URLSession(configuration: sessionconfiguration)
        
        let dataTask = session.dataTask(with:url){(data,response,error) in
            do{
                guard let data = data
                    else{
                        throw JsonErrors.dataError
                        
                }
                guard let Coord = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                    
                    else{
                        throw JsonErrors.conversionError
                }
                
                let WArray = Coord["weather"] as! [[String:Any]]
                let WDisc = WArray.last!
                let Disc = WDisc["description"] as! String
                print(Disc)
                DispatchQueue.main.async {
                    self.descrip.text = "Description:- \(Disc)"
                }
                
                
                let main = Coord["main"] as! [String:Any]
                let tempn = main["temp"] as!  NSNumber
                let tem = Double(trunc(Double(tempn)))
                print(tempn)
                DispatchQueue.main.async {
                    self.temper.text = "Temperature:- \(String(tem))"
                }
                
                let humid = main["humidity"] as! NSNumber
                let hm = Double(trunc(Double(humid)))
                print(hm)
                DispatchQueue.main.async {
                    self.humid.text = "Humidity:- \(String(hm))"
                }
                
                let name1 = Coord["name"] as! String
                print(name1)
                DispatchQueue.main.async {
                    self.nameweather.text = "Name:- \(name1)"
                }
                
                
                
                
                
            }
                
            catch JsonErrors.dataError
            {
                print("dataerror \(error?.localizedDescription)")
            }
            catch JsonErrors.conversionError{
                print("conversionerror \(error?.localizedDescription)")
            }
            catch let error
            {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
        
        
    }
    
    
    @IBOutlet weak var mapviewNew: MKMapView!
    
    
    @IBOutlet weak var mapview: MKMapView!
    
    
    @IBAction func show(_ sender: UIButton) {
        
        detectlocation()
 
    }
        
        func detectlocation()
        {
            locationmanager.desiredAccuracy = kCLLocationAccuracyBest
            locationmanager.delegate = self
            locationmanager.requestWhenInUseAuthorization()
            locationmanager.startUpdatingLocation()
        }
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                let currentlocation = locations.last!
                var latitude = currentlocation.coordinate.latitude
                let longitude = currentlocation.coordinate.longitude
                print("latitude = \(latitude) and longitude = \(longitude)")
                
                
                //print("latitude = \(latitude)")
                
                lati = latitude
                longi = longitude
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: currentlocation.coordinate, span: span)
            mapviewNew.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = currentlocation.coordinate
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(currentlocation){(placemarks,error)in
                    let placemark:CLPlacemark = (placemarks?.first)!
                    let country = placemark.country
                    annotation.title = country
                    self.mapviewNew.addAnnotation(annotation)
                }  }
            
            
        
        
        
        
        
        

    
    
    
    
    @IBOutlet weak var descrip: UITextField!
    
    
    @IBOutlet weak var temper: UITextField!
    @IBOutlet weak var humid: UITextField!
    
    
    @IBOutlet weak var nameweather: UITextField!
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
