import UIKit
import CoreLocation
import MapKit
class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var myMap: MKMapView!
    var locationManager = CLLocationManager()
    let ceo: CLGeocoder = CLGeocoder()
    var annotationGroup = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            self.myMap.showsUserLocation = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("reached EEOR")
        print("Error 3") }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        findloc(localr: location)
    }
    
    func removeAllAnnotations() {
        DispatchQueue.main.async {
            let annotations = self.myMap.annotations.filter {
                $0 !== self.myMap.userLocation
            }
            self.myMap.removeAnnotations(annotations)
        }
      
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch oldState {
        case .starting:
            view.dragState = .dragging
            print("print ----- dragg")
            case .ending:
                let currentAnnotationLattitude = view.annotation?.coordinate.latitude
                let currentAnnotationLongitude = view.annotation?.coordinate.longitude
                let locationm = CLLocationCoordinate2D(latitude: currentAnnotationLattitude!, longitude: currentAnnotationLongitude!)
                print(locationm)
                findloc(localr: locationm)
                
            view.dragState = .none
            print("print ----- nil")
            default: break
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinTintColor = .green
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            return pinAnnotationView
        }
        
        return nil
    }
    

    func findloc(localr: CLLocationCoordinate2D){
        
        DispatchQueue.main.async {
            let annotations = self.myMap.annotations
                self.myMap.removeAnnotations(annotations)
                self.annotationGroup.removeAll()
            
        }
     
        
        let span = MKCoordinateSpanMake(0.025,0.025)
        
        let region = MKCoordinateRegionMake(localr, span)
        myMap.setRegion(region, animated: true )
        print("function complete")
       let loc: CLLocation = CLLocation(latitude: localr.latitude, longitude: localr.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    let country = pm.country
                    let locality = pm.locality
                    let subLocality = pm.subLocality
                    let thoroughfare = pm.thoroughfare
                    let postalCode = pm.postalCode
                    let subThoroughfare = pm.subThoroughfare
                    var addressString : String = ""
                    var addresscountry : String = ""
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.subThoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ". "
                    }
                    if pm.locality != nil {
                        addresscountry = addresscountry + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addresscountry = addresscountry + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addresscountry = addresscountry + pm.postalCode! + " "
                    }
                    
                    
                    print("\(String(describing: subThoroughfare))  \(String(describing: thoroughfare))  \(String(describing: subLocality))  \(String(describing: locality))  \(String(describing: postalCode))  \(String(describing: country)) ")
                    DispatchQueue.main.async {
                        let pinr = MKPointAnnotation()
                        pinr.coordinate.longitude = localr.longitude
                        pinr.coordinate.latitude = localr.latitude
                        pinr.title = addressString
                        pinr.subtitle = addresscountry
                        self.annotationGroup.append(pinr)
                        self.myMap.addAnnotations(self.annotationGroup)
                        self.myMap.showAnnotations(self.annotationGroup, animated: true)
                        print("Completed getting address \(pinr.coordinate.latitude)    \(pinr.coordinate.longitude)")
                        print(" ======address: \(addressString),\(addresscountry)=========")
                        self.locationManager.stopUpdatingLocation()
                    }
                }
        })
    }
}





