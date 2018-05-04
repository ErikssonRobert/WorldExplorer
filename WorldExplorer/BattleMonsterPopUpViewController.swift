//
//  BattleMonsterPopUpViewController.swift
//  WorldExplorer
//
//  Created by Robert on 2018-04-23.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class BattleMonsterPopUpViewController: UIViewController {
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var textFieldBattleText: UITextView!
    @IBOutlet weak var labelPlayerName: UILabel!
    @IBOutlet weak var labelMonsterName: UILabel!
    @IBOutlet weak var labelPlayerHp: UILabel!
    @IBOutlet weak var labelMonsterHp: UILabel!
    @IBOutlet weak var buttonAttack: UIButton!
    @IBOutlet weak var buttonFlee: UIButton!
    
    var character : CharacterHandler!
    var monster : MonsterHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBattlePopUpView()
    }
    
    func setupBattlePopUpView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        buttonDone.isHidden = true
        labelPlayerName.text = character.name
        labelMonsterName.text = monster.name
        updatePlayerAndMonsterHp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePlayerAndMonsterHp() {
        labelPlayerHp.text = "Hp: \(character.currentHp)/\(character.maxHp)"
        labelMonsterHp.text = "Hp: \(monster.currentHp)/\(monster.maxHp)"
    }
    
    @IBAction func buttonAttackPressed(_ sender: Any) {
        playerAttacks()
        if self.monster.isAlive() {
            monsterAttacks()
            if !self.character.isAlive() {
                self.textFieldBattleText.text = "You died!\nTry again next time."
                self.buttonDone.isHidden = false
            }
        } else {
            self.textFieldBattleText.text = "You killed the \(self.monster.name)!\n"
            self.character.gainExperience(exp: giveExperience(monsterLevel: self.monster.level))
            self.textFieldBattleText.text.append("You gained \(giveExperience(monsterLevel: self.monster.level)) experiencepoints!\n")
            self.buttonDone.isHidden = false
            turnOffBattleButtons()
        }
        updatePlayerAndMonsterHp()
    }
    
    func giveExperience(monsterLevel: Int) -> Int {
        return monsterLevel * 13
    }
    
    @IBAction func buttonFleePressed(_ sender: Any) {
        self.textFieldBattleText.text = "Trying to flee...\n"
        if Int(arc4random_uniform(4)) == 0 {
            self.textFieldBattleText.text.append("You managed to flee!")
            turnOffBattleButtons()
            self.buttonDone.isHidden = false
        } else {
            self.textFieldBattleText.text.append("You failed to flee.\n")
            monsterAttacks()
            updatePlayerAndMonsterHp()
        }
    }
    
    func playerAttacks() {
        let playerDmg = character.dealDamage()
        if playerDmg - self.monster.defence <= 0 {
            self.textFieldBattleText.text = "You attack the \(self.monster.name) dealing 1 damage!\n"
        } else {
            self.textFieldBattleText.text = "You attack the \(self.monster.name) dealing \(playerDmg - self.monster.defence) damage!\n"
        }
        self.monster.takeDamage(dmg: playerDmg)
    }
    
    func monsterAttacks() {
        let monsterDmg = monster.dealDamage()
        self.textFieldBattleText.text.append("The \(self.monster.name) attacked you dealing \(monsterDmg - self.character.toughness) damage!")
        self.character.takeDamage(dmg: monsterDmg)
    }
    
    func turnOffBattleButtons() {
        self.buttonAttack.isEnabled = false
        self.buttonFlee.isEnabled = false
        self.buttonAttack.alpha = 0.8
        self.buttonFlee.alpha = 0.8
    }
    
    @IBAction func buttonDonePressed(_ sender: Any) {
        let save = SavedCharacterModel()
        save.saveCharacter(char: self.character)
        self.view.removeFromSuperview()
    }

}

