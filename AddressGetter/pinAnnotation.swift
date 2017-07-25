import MapKit
class pinAnnotation : MKPointAnnotation{
    var address: String?
    var street: String?
    var locality:  String?
    var city:  String?
    var country:  String?
    var pincode:  String?
    //var coordinate: CLLocationCoordinate2D
    init(address: String,street: String,locality:  String,city:  String,country:  String,pincode:  String) {
        self.address =  address
    self.street = street
    self.locality = locality
    self.city = city
    self.country = country
    self.pincode = pincode
      //  self.coordinate = coordinate
        super.init()
    }
    }
