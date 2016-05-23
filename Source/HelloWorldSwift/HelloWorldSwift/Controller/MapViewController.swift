//
//  MapViewController.swift
//  Feed Me
//
/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import GoogleMaps
class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var mapCenterPinImage: UIImageView!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
  let locationManager = CLLocationManager()
  let searchRadius: Double = 1000
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    
    mapView.delegate = self
    let settings:GMSUISettings =  mapView.settings
    settings.consumesGesturesInView=false
  }
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear")
        setPlaces()
        let del:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
        let place = del.results!.places![0]
        let placeMarker = PlaceMarker(place: place)
        moveToPlace(placeMarker)
    }
  
  func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
    let geocoder = GMSGeocoder()
    
    geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
      self.addressLabel.unlock()
      if let address = response?.firstResult() {
        let lines = address.lines as! [String]
        self.addressLabel.text = lines.joinWithSeparator("\n")
        
        let labelHeight = self.addressLabel.intrinsicContentSize().height
        self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
        
        UIView.animateWithDuration(0.25) {
          self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
          self.view.layoutIfNeeded()
        }
      }
    }
  }
  
  func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
    
    if let location = mapView.myLocation
    {
        mapView.animateToLocation(location.coordinate)
    }
    mapView.myLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
    func moveToPlace(placeMarker: PlaceMarker) {
        let coordinate = placeMarker.position
        placeMarker.map = self.mapView
        mapView.animateToLocation(coordinate)
        self.mapView.animateToZoom(12)
    }
    func setPlaces()
    {
        let del:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
        let places:Array<Place> = del.results.places!
        for place in places
        {
            let placeMarker = PlaceMarker(place: place)
            placeMarker.map = self.mapView
        }
    }
    
    @IBAction func btnInfoClicked(sender: AnyObject) {
        let refreshAlert = UIAlertController(title: "App Info", message: "Bicycle Rent version 0.1\nDev: Tran Binh Nguyen", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnLogoutClicked(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("accessToken")
        self.navigationController?.popViewControllerAnimated(true)
    }
    func moveToPaymentView()
    {
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("paymentController") as! PaymentController
        
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    func buttonClicked(sender:UIButton)
    {
        if(sender.tag == 5){
            
            moveToPaymentView()
        }
        
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse {
      locationManager.startUpdatingLocation()
      mapView.myLocationEnabled = true
      mapView.settings.myLocationButton = true
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      locationManager.stopUpdatingLocation()
      fetchNearbyPlaces(location.coordinate)
    }
  }
    
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
  func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
    reverseGeocodeCoordinate(position.target)
  }
  
  func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
    addressLabel.lock()
    
    if (gesture) {
      mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
    }
  }
  
  func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
    let placeMarker = marker as! PlaceMarker
    if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
        infoView.superview?.bringSubviewToFront(infoView)
      infoView.nameLabel.text = placeMarker.place.name
        infoView.rentBtn.tag = 5
        infoView.rentBtn.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)
//        moveToPaymentView()
      if let photo = placeMarker.icon {
        infoView.placePhoto.image = photo
      } else {
        infoView.placePhoto.image = UIImage(named: "generic")
      }
      return infoView
    } else {
      return nil
    }
  }
  func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
    mapCenterPinImage.fadeOut(0.25)
    return false
  }
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        self.moveToPaymentView()
    }
    
  func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
    mapCenterPinImage.fadeIn(0.25)
    mapView.selectedMarker = nil
    return false
  }
}