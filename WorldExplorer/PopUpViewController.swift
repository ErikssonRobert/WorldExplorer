//
//  PopUpViewController.swift
//  WorldExplorer
//
//  Created by Robert on 2018-04-16.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
   
    @IBOutlet weak var textCharacterStats: UITextView!
    
    var character : CharacterHandler!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupPopUpView()
    }
    
    func setupPopUpView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.textCharacterStats.text =
        """
        \(character.name)     level: \(character.level)
        Health: \(character.currentHp)/\(character.maxHp)
        Exp: \(character.currentExp)/\(character.expToLevel)
        Damage: \(character.strength + character.dmg) Armor: \(character.armor)
        Strength: \(character.strength) Vitality: \(character.vitality)
        Toughness: \(character.toughness)
        Agility: \(character.agility) Luck: \(character.luck)
        """
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeCharacterPopUp(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
