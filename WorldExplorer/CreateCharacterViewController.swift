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
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let name = self.textFieldName.text,
                name != "" else {
            print("Invalid name!")
            return
        }
        
        let char = CharacterHandler(name: name)
        let save = SavedCharacterModel()
        save.saveCharacter(char: char)
        
        self.view.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
