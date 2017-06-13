//
//  CustomAnnotation.swift
//  Geotify
//
//  Created by Jordan Stephenson on 6/12/17.
//  Copyright © 2017 Ken Toh. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
 let coordinate: CLLocationCoordinate2D
  let title: String?
  let subtitle: String?
    
  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle


  }

}
