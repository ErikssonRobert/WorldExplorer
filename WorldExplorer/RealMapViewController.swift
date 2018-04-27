//
//  RealMapViewController.swift
//  WorldExplorer
//
//  Created by Robert on 2018-04-13.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RealMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager : CLLocationManager!
    var character : CharacterHandler!
    
    var monsters : [MonsterHandler] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setup location manager
        setupLocationManager()
        
        // Setup mapview to show user location
        setupMapView()
        loadCharacter()
        //createHiddenMap()
    }
    
    func loadCharacter() {
        let load = SavedCharacterModel()
        character = load.loadCharacter()
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 5
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(locations[0].coordinate)\(mapView.userLocation.coordinate)")
        
        let spanX = 0.003
        let spanY = 0.003
        let newRegion = MKCoordinateRegionMake(mapView.userLocation.coordinate, MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
        checkPlayerMonsterDistance()
    }
    
    func checkPlayerMonsterDistance() {
        let userLocation = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        for annotation in mapView.annotations {
            if annotation.title! != "My Location" {
                let monsterLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                let distance = userLocation.distance(from: monsterLocation)
                print(distance)
                if distance < 100 {
                    self.mapView.view(for: annotation)?.isHidden = false
                }
            }
        }
        
    }
    
    // Byter till custom bild för location iconen och monster
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let playerIcon = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            playerIcon.image = UIImage(named: "charicon")
            return playerIcon
        } else {
            let icon = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            icon.image = UIImage(named: "monstericon")
            icon.isHidden = true
            return icon
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if (view.annotation?.title)! == "My Location" {
            return
        }
        var mName: String = ""
        if let monsterName = view.annotation?.title {
            mName = "\(String(describing: monsterName ?? "BABBADADDA"))"
        }
        presentMonsterAlert(monsterName: mName)
    }
    
    func presentMonsterAlert(monsterName: String) {
        let attackAlert = UIAlertController(title: "Do you want to attack the \(monsterName)?", message: "", preferredStyle: .alert)
        
        attackAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            print("Presenting battle screen.")
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "battlePopUpVC") as! BattleMonsterPopUpViewController
            self.addChildViewController(popOverVC)
            popOverVC.player = self.character
            for m in self.monsters {
                if m.name == monsterName {
                    popOverVC.monster = m
                }
            }
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        }))
        attackAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(attackAlert, animated: true)
    }
    
    // Placerar egna annotations av monster
    func createHiddenMap() {
        print("Creating and placing annotations")
        let monster1 = MonsterHandler(name: "Babba", level: 1)
        let monster2 = MonsterHandler(name: "Giant Spider", level: 2)
        let monster3 = MonsterHandler(name: "Goblin", level: 2)
        monsters.append(monster1)
        monsters.append(monster2)
        monsters.append(monster3)
        
        for m in monsters {
            let annotation = CustomAnnotation(monster: m,
                                              coordinate: CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude + calcRandomDistance(), longitude: self.mapView.userLocation.coordinate.longitude + calcRandomDistance()),
                                              title: m.name,
                                              locationName: m.name,
                                              dicipline: "Test3")
            
            mapView.addAnnotation(annotation)
        }
        print("Creating and placing annotations done!")
    }
    
    func calcRandomDistance() -> Double {
        var offSet : Double = Double(arc4random_uniform(8) + 6)
        if Int(arc4random_uniform(2)) == 0 {
            offSet *= -1
        }
        return offSet / 10000
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showCharacterPopUp(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpVC") as! PopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.character = self.character
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func enterWorldButtonPressed(_ sender: Any) {
        createHiddenMap()
    }
    
}
