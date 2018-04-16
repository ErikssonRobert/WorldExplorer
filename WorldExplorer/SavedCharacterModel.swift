//
//  SavedCharacterModel.swift
//  WorldExplorer
//
//  Created by Robert on 2018-04-13.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class SavedCharacterModel: NSObject {

    func saveCharacter(char: CharacterHandler) {
        print("Saving...")
        let save = UserDefaults()
        save.set(char, forKey: "char")
        //save.synchronize()
        print("Save success!")
    }
    
    func loadCharacter() -> CharacterHandler {
        print("Loading...")
        let load = UserDefaults()
        if let char : CharacterHandler = load.object(forKey: "char") as? CharacterHandler {
            print("Load success!")
            return char
        } else {
            preconditionFailure("Load failed!")
        }
    }
}
