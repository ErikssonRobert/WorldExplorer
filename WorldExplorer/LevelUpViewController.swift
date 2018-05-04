//
//  LevelUpViewController.swift
//  WorldExplorer
//
//  Created by Robert on 2018-04-30.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class LevelUpViewController: UIViewController {
    @IBOutlet weak var labelSkillpoints: UILabel!
    @IBOutlet weak var labelStrength: UILabel!
    @IBOutlet weak var labelVitality: UILabel!
    @IBOutlet weak var labelToughness: UILabel!
    @IBOutlet weak var labelAgility: UILabel!
    
    @IBOutlet weak var buttonStrength: UIButton!
    @IBOutlet weak var buttonVitality: UIButton!
    @IBOutlet weak var buttonToughness: UIButton!
    @IBOutlet weak var buttonAgility: UIButton!
    
    var character : CharacterHandler!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupLevelUpPopUpView()
    }
    
    func setupLevelUpPopUpView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        updateStatsLabels()
    }
    
    func updateStatsLabels() {
        self.labelSkillpoints.text = "Skillpoints: \(self.character.skillPoints)"
        self.labelStrength.text = "Strength: \(self.character.strength)"
        self.labelVitality.text = "Vitality: \(self.character.vitality)"
        self.labelToughness.text = "Toughness: \(self.character.toughness)"
        self.labelAgility.text = "Agility: \(self.character.agility)"
    }
    
    @IBAction func buttonStrengthPressed(_ sender: Any) {
        if self.buttonStrength.titleLabel?.text == "+" {
            self.character.skillPoints -= 1
            self.character.strength += 1
            updateStatsLabels()
            disableAndEnableButtons(text: "str")
            self.buttonStrength.setTitle("-", for: .normal)
        } else {
            self.character.skillPoints += 1
            self.character.strength -= 1
            updateStatsLabels()
            disableAndEnableButtons(text: "enable")
            self.buttonStrength.setTitle("+", for: .normal)
        }
    }
    
    @IBAction func buttonVitalityPressed(_ sender: Any) {
    }
    
    @IBAction func buttonToughnessPressed(_ sender: Any) {
    }
    
    @IBAction func buttonAgilityPressed(_ sender: Any) {
    }
    
    func disableAndEnableButtons(text: String) {
        if text == "enable" {
            self.buttonStrength.isHidden = false
            self.buttonVitality.isHidden = false
            self.buttonToughness.isHidden = false
            self.buttonAgility.isHidden = false
        } else {
            self.buttonStrength.isHidden = true
            self.buttonVitality.isHidden = true
            self.buttonToughness.isHidden = true
            self.buttonAgility.isHidden = true
        }
        switch text {
        case "str": self.buttonStrength.isHidden = false
        case "vit": self.buttonVitality.isHidden = false
        case "tough": self.buttonToughness.isHidden = false
        case "agi": self.buttonAgility.isHidden = false
        default: return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closePopUpButtonPressed(_ sender: Any) {
        let save = SavedCharacterModel()
        save.saveCharacter(char: self.character)
        self.view.removeFromSuperview()
    }
    
}
