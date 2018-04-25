//
//  EquipmentModel.swift
//  WorldExplorer
//
//  Created by Robert on 2018-04-25.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class EquipmentModel: NSObject {

    let name : String
    let damage : Int
    let armor : Int
    
    init(name: String, damage: Int, armor: Int) {
        self.name = name
        self.damage = damage
        self.armor = armor
    }
}
