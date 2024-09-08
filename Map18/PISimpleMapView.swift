//
//  PISimpleMapView.swift
//  PhotInfo
//
//  Created by Enrico Bonaldo on 07/03/21.
//  Copyright © 2021 Enrico Bonaldo. All rights reserved.
//

import UIKit
import MapKit

let CORNER_RADIUS: CGFloat = 8.0
let METERS_PER_MILE: Double = 1609.344  // * 8

class PIAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    private(set) var title: String?
    private(set) var subtitle: String?
    
    init(location: CLLocationCoordinate2D,
         title: String? = nil, subtitle: String? = nil) {
        
        coordinate = location
        self.title = title
        self.subtitle = subtitle
    }
}

class PISimpleMapView: MKMapView {
    
    private let HALF_MAP_SIDE_MULTIPLIER: Double = 1.4
    
    private let pinIdentifier = "pinIdentifier"
    
    private var scaleView: MKScaleView?
    
    typealias PinAnnotationView = MKMarkerAnnotationView     // MKPinAnnotationView
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        inizialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inizialize()
    }
    
    func inizialize() {
        
        layer.cornerRadius = CORNER_RADIUS
        register(PinAnnotationView.self,
                 forAnnotationViewWithReuseIdentifier: pinIdentifier)
        
        addScale()
    }
    
    private func addScale() {
        
        let scale = MKScaleView(mapView: self)
        scale.translatesAutoresizingMaskIntoConstraints = false
        scale.scaleVisibility = .visible // always visible
        addSubview(scale)
        
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scale.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 16.0),
            scale.rightAnchor.constraint(equalTo: guide.centerXAnchor),
            scale.topAnchor.constraint(equalTo: guide.topAnchor),
            scale.heightAnchor.constraint(equalToConstant: 20.0)
        ])
        
        scaleView?.removeFromSuperview()
        scaleView = scale
    }
    
    func displayPinOnMap(location: CLLocation) {
        
        let annotation = PIAnnotation(location: location.coordinate,
                                      title: "Sample", subtitle: nil)
        addAnnotation(annotation)
        
        // Position the map so that all overlays and annotations are visible on screen.
        // visibleMapRect = visibleArea(from: annotation)
        // setVisibleMapRect(visibleArea(from: annotation), animated: true)
        // region = MKCoordinateRegion(visibleArea(from: annotation))
        
        // --
        
        // visibleRegion(from: annotation)
        
        // --
        
        visibleCamera(from: annotation)
    }
    
    private func visibleArea(from annotation: PIAnnotation) -> MKMapRect {
        
        let annotationPoint = MKMapPoint(annotation.coordinate)
        return MKMapRect(x: annotationPoint.x - HALF_MAP_SIDE_MULTIPLIER * METERS_PER_MILE,
                         y: annotationPoint.y - HALF_MAP_SIDE_MULTIPLIER * METERS_PER_MILE,
                         width: HALF_MAP_SIDE_MULTIPLIER * 2.0 * METERS_PER_MILE,
                         height: HALF_MAP_SIDE_MULTIPLIER * 2.0 * METERS_PER_MILE)
    }
    
    private func visibleCamera(from annotation: PIAnnotation) {
        
        let placemark = MKPlacemark(coordinate: annotation.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        let camera = MKMapCamera(lookingAt: mapItem,
                                 forViewSize: CGSize(width: HALF_MAP_SIDE_MULTIPLIER * 2.0 * METERS_PER_MILE,
                                                     height: HALF_MAP_SIDE_MULTIPLIER * 2.0 * METERS_PER_MILE),
                                 allowPitch: false)
        setCamera(camera, animated: true)
    }
    
    private func visibleRegion(from annotation: PIAnnotation) {
        
        let mapRegion = MKCoordinateRegion(center: annotation.coordinate,
                                           span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                                  longitudeDelta: 0.05))
        setRegion(mapRegion, animated: true)
    }
}
