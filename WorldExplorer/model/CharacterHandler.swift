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
    var luck : Int
    
    // Equipment stats
    var dmg : Int
    var armor : Int
    
    init(name: String, weapon: EquipmentModel, armor: EquipmentModel) {
        self.name = name
        self.level = 1
        self.currentExp = 0
        self.expToLevel = 50
        self.skillPoints = 0
        self.maxHp = 100
        self.currentHp = 100
        self.strength = 5
        self.vitality = 5
        self.toughness = 5
        self.agility = 5
        self.luck = 1
        self.dmg = weapon.damage
        self.armor = armor.armor
    }
    
    func dealDamage() -> Int {
        let rawDmg = (self.strength + self.dmg)
        if isCriticalHit() {
            return Int(rawDmg * 2)
        } else {
            return rawDmg
        }
    }
    
    func takeDamage(dmg: Int) {
        self.currentHp -= (dmg - self.armor)
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
