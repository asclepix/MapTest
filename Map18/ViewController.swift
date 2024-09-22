//
//  ViewController.swift
//  Map18
//
//  Created by Enrico Bonaldo on 25/08/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var map: PISimpleMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func zoomIn(_ sender: UIButton) {
        let location = CLLocation(latitude: 46.30, longitude: 8.77)
        map.displayPinOnMap(location: location)
    }
    
    @IBAction func zoomOut(_ sender: UIButton) {
        let location = CLLocation(latitude: 46.30, longitude: 8.77)
        map.zoomOut(location: location)
    }
    
    @IBAction func zoomWorld(_ sender: UIButton) {
        map.zoomWorld()
    }
}

