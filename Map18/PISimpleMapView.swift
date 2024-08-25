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
    }
    
    func displayPinOnMap(location: CLLocation) {
        
        let annotation = PIAnnotation(location: location.coordinate,
                                      title: "Sample", subtitle: nil)
        addAnnotation(annotation)
        
        // Position the map so that all overlays and annotations are visible on screen.
        visibleMapRect = visibleArea(from: annotation)
        // setVisibleMapRect(visibleArea(from: annotation), animated: true)
    }
    
    private func visibleArea(from annotation: PIAnnotation) -> MKMapRect {
        
        let annotationPoint = MKMapPoint(annotation.coordinate)
        return MKMapRect(x: annotationPoint.x - HALF_MAP_SIDE_MULTIPLIER * METERS_PER_MILE,
                         y: annotationPoint.y - HALF_MAP_SIDE_MULTIPLIER * METERS_PER_MILE,
                         width: HALF_MAP_SIDE_MULTIPLIER * 2.0 * METERS_PER_MILE,
                         height: HALF_MAP_SIDE_MULTIPLIER * 2.0 * METERS_PER_MILE)
    }
}