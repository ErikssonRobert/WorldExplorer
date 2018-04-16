//
//  CharacterHandler.swift
//  WorldExplorer
//
//  Created by Robert on 2018-04-13.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class CharacterHandler {
    
    // Stats
    let name : String
    var maxHp : Int
    var currentHp : Int
    
    init(name: String) {
        self.name = name
        self.maxHp = 100
        self.currentHp = 100
    }
    
}
