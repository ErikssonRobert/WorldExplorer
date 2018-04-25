//
//  CustomAnnotation.swift
//  WorldExplorer
//
//  Created by Robert on 2018-04-21.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var locationName: String
    var dicipline: String
    
    var monster : MonsterHandler
    
    init(monster: MonsterHandler, coordinate: CLLocationCoordinate2D, title: String, locationName: String, dicipline: String) {
        self.coordinate = coordinate
        self.title = title
        self.locationName = locationName
        self.dicipline = dicipline
        self.monster = monster
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
