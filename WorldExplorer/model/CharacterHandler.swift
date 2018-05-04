//
//  CharacterHandler.swift
//  WorldExplorer
//
//  Created by Robert on 2018-04-13.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class CharacterHandler: Codable {
    
    let name : String
    
    // Level variables
    var level : Int
    var currentExp : Int
    var expToLevel : Int
    var skillPoints : Int
    
    // Stats
    var maxHp : Int
    var currentHp : Int
    var strength : Int
    var vitality : Int
    var toughness : Int
    var agility : Int
    
    init(name: String) {
        self.name = name
        self.level = 1
        self.currentExp = 0
        self.expToLevel = 50
        self.skillPoints = 0
        self.maxHp = 100
        self.currentHp = 100
        self.strength = 5
        self.vitality = 3
        self.toughness = 3
        self.agility = 3
    }
    
    func dealDamage() -> Int {
        let rawDmg = (self.strength * 2)
        if isCriticalHit() {
            return Int(rawDmg * 2)
        } else {
            return rawDmg
        }
    }
    
    func takeDamage(dmg: Int) {
        let rawDmg = (dmg - self.toughness)
        if rawDmg <= 0 {
            self.currentHp -= 1
        } else {
            self.currentHp -= rawDmg
        }
        if self.currentHp <= 0 {
            self.currentHp = 0
        }
    }
    
    func isCriticalHit() -> Bool {
        let critValue = arc4random_uniform(1000) + 1
        if critValue > (1000 - (self.agility)) {
            return true
        } else {
            return false
        }
    }
    
    func gainExperience(exp: Int) {
        self.currentExp += exp
        if self.currentExp >= self.expToLevel {
            // Level up!
            levelUp()
        }
    }
    
    func levelUp() {
        self.level += 1
        self.skillPoints += 1
        self.currentExp -= self.expToLevel
        let tempExpToLevel = Double(self.expToLevel) * 2.1
        self.expToLevel = Int(tempExpToLevel)
    }
    
    func isAlive() -> Bool{
        if self.currentHp == 0 {
            return false
        } else {
            return true
        }
    }
}
