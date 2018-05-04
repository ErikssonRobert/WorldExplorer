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
    @IBOutlet weak var levelUpButton: UIButton!
    @IBOutlet weak var enterWorldButton: UIButton!
    @IBOutlet weak var characterButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var locationManager : CLLocationManager!
    var character : CharacterHandler!
    
    var monsters : [MonsterHandler] = []
    var entered : Bool = false
    var deadMonsters : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setup location manager
        setupLocationManager()
        
        // Setup mapview to show user location
        setupMapView()
        loadCharacter()
        //createHiddenMap()
        setupButtons()
    }
        
    func saveCharacter() {
        let save = SavedCharacterModel()
        save.saveCharacter(char: self.character)
    }
    
    func loadCharacter() {
        let load = SavedCharacterModel()
        character = load.loadCharacter()
    }
    
    func setupButtons() {
        // setup shadow for characterButton
        self.characterButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        self.characterButton.layer.shadowOffset = CGSize(width: 2.0, height: 5.0)
        self.characterButton.layer.shadowOpacity = 1.0
        self.characterButton.layer.shadowRadius = 0.0
        self.characterButton.layer.masksToBounds = false
        
        // setup shadow for backButton
        self.backButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        self.backButton.layer.shadowOffset = CGSize(width: 2.0, height: 5.0)
        self.backButton.layer.shadowOpacity = 1.0
        self.backButton.layer.shadowRadius = 0.0
        self.backButton.layer.masksToBounds = false
        
        // setup shadow for levelUpButton
        self.levelUpButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        self.levelUpButton.layer.shadowOffset = CGSize(width: 2.0, height: 5.0)
        self.levelUpButton.layer.shadowOpacity = 1.0
        self.levelUpButton.layer.shadowRadius = 0.0
        self.levelUpButton.layer.masksToBounds = false
        
        // setup shadow for enterWorldButton
        self.enterWorldButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        self.enterWorldButton.layer.shadowOffset = CGSize(width: 2.0, height: 5.0)
        self.enterWorldButton.layer.shadowOpacity = 1.0
        self.enterWorldButton.layer.shadowRadius = 0.0
        self.enterWorldButton.layer.masksToBounds = false
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
    
    // Updating position
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(locations[0].coordinate)\(mapView.userLocation.coordinate)")
        
        let spanX = 0.004
        let spanY = 0.004
        let newRegion = MKCoordinateRegionMake(mapView.userLocation.coordinate, MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
        checkPlayerMonsterDistance()
        //enableEnterButton()
        if self.entered {
            checkIfMonstersAreAlive()
        }
        
        if self.character.skillPoints > 0 {
            self.levelUpButton.isHidden = false
        } else {
            self.levelUpButton.isHidden = true
        }
    }
    
//    func enableEnterButton() {
//        if self.deadMonsters == 3 {
//            self.enterWorldButton.isHidden = false
//        }
//    }
    
    // Checking if player is close enough.
    func checkPlayerMonsterDistance() {
        let userLocation = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        for annotation in mapView.annotations {
            if annotation.title! != "My Location" {
                let monsterLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                let distance = userLocation.distance(from: monsterLocation)
                print(distance)
                if distance < 200 {
                    self.mapView.view(for: annotation)?.isHidden = false
                    self.mapView.view(for: annotation)?.isEnabled = true
                }
            }
        }
    }
    
    // Check if all monsters are defeated
    func checkIfMonstersAreAlive() {
        //var index = 0
        var i = 0
        if self.monsters.count == 0 {
            self.entered = false
            self.enterWorldButton.isHidden = false
        }
        for m in self.monsters {
            if !m.isAlive() {
                //index = i
                for a in self.mapView.annotations {
                    if a.title! == m.name {
                        self.mapView.view(for: a)?.isHidden = true
                        self.deadMonsters += 1
                    }
                }
            }
            //self.monsters.remove(at: index)
            i += 1
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
            icon.isEnabled = false
            return icon
        }
    }
    
    // Om användaren trycker på ett synligt monster ska en alert visas
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
    
    // Skapar alert meddelandet som användaren ser när den klickar på ett synligt monster
    func presentMonsterAlert(monsterName: String) {
        let attackAlert = UIAlertController(title: "Do you want to attack the \(monsterName)?", message: "", preferredStyle: .alert)
        
        attackAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            print("Presenting battle screen.")
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "battlePopUpVC") as! BattleMonsterPopUpViewController
            self.addChildViewController(popOverVC)
            popOverVC.character = self.character
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
        monsters = []
        let monster1 = MonsterHandler(name: "Slime", level: self.character.level)
        let monster2 = MonsterHandler(name: "Giant Spider", level: self.character.level)
        let monster3 = MonsterHandler(name: "Orc warrior", level: self.character.level)
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
    
    // Presenterar popup fönstret med karaktärens information
    @IBAction func showCharacterPopUp(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpVC") as! PopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.character = self.character
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func levelUpButtonPressed(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LevelUpVC") as! LevelUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.character = self.character
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    // Kallar på metoden som skapar monster och annotationer när användaren väljer
    @IBAction func enterWorldButtonPressed(_ sender: Any) {
        createHiddenMap()
        self.entered = true
        //self.enterWorldButton.isHidden = true
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        saveCharacter()
        self.navigationController?.popViewController(animated: true)
    }
    
}
