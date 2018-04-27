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
    let level : Int
    
    var currentHp : Int
    let maxHp : Int
    var strength : Int
    var defence : Int

    init(name: String, level: Int) {
        self.name = name
        self.level = level
        self.currentHp = Int(level * 15)
        self.maxHp = self.currentHp
        self.strength = Int(level * 4)
        self.defence = Int(level * 3)
    }
    
    func dealDamage() -> Int {
        return self.strength
    }
    
    func takeDamage(dmg: Int) {
        self.currentHp -= (dmg - self.defence)
        if self.currentHp <= 0 {
            self.currentHp = 0
        }
    }
    
    func isAlive() -> Bool {
        if self.currentHp == 0 {
            return false
        } else {
            return true
        }
    }
}
