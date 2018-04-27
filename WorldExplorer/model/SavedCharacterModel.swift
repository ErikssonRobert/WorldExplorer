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
        let encodedData = try! JSONEncoder().encode(char)
        save.set(encodedData, forKey: "char")
        //save.synchronize()
        print("Save success!")
    }
    
    func loadCharacter() -> CharacterHandler {
        print("Loading...")
        let load = UserDefaults()
        if let charData = load.data(forKey: "char") {
            print("Loading success!")
            let char = try! JSONDecoder().decode(CharacterHandler.self, from: charData)
            return char
        } else {
            preconditionFailure("Loading failed!")
        }
    }
}
