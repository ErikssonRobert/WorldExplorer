//
//  MonsterHandler.swift
//  WorldExplorer
//
//  Created by Robert on 2018-04-17.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class MonsterHandler {
    
    var name : String

    var currentHp : Int
    var maxHp : Int
    var attack : Int
    var defence : Int

    init(name: String, level: Int) {
        self.name = name
        self.maxHp = Int(level * 13)
        self.currentHp = self.maxHp
        self.attack = Int(level * 4)
        self.defence = Int(level * 3)
    }
}
