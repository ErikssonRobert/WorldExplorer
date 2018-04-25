//
//  CreateCharacterViewController.swift
//  WorldExplorer
//
//  Created by Robert on 2018-04-13.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class CreateCharacterViewController: UIViewController {
    
    @IBOutlet weak var textFieldName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textFieldName.placeholder = "Enter name"
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let name = self.textFieldName.text,
                name != "" else {
            print("Invalid name!")
            return
        }
        // Noob EQ hårdkodat under Beta-stadiet
        let weapon = EquipmentModel(name: "Stick", damage: 5, armor: 0)
        let armor = EquipmentModel(name: "Paper bag", damage: 0, armor: 2)
        let char = CharacterHandler(name: name, weapon: weapon, armor: armor)
        let save = SavedCharacterModel()
        save.saveCharacter(char: char)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
