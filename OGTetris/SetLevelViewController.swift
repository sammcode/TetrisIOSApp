//
//  SetLevelViewController.swift
//  OGTetris
//
//  Created by Sam McGarry on 11/27/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import UIKit

class SetLevelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let temp: Int = UserDefaults.standard.integer(forKey: "level")
        levels[temp].setTitleColor(.systemRed, for: .normal)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func returnToMenu(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let mainMenuViewController = storyBoard.instantiateViewController(withIdentifier: "mainMenu") as! MainMenuViewController

        self.present(mainMenuViewController, animated:true, completion:nil)
        
    }
    @IBOutlet weak var level1: UIButton!
    @IBOutlet weak var level2: UIButton!
    @IBOutlet weak var level3: UIButton!
    @IBOutlet weak var level4: UIButton!
    @IBOutlet weak var level5: UIButton!
    @IBOutlet weak var level6: UIButton!
    @IBOutlet weak var level7: UIButton!
    @IBOutlet weak var level8: UIButton!
    @IBOutlet weak var level9: UIButton!
    @IBOutlet weak var level10: UIButton!
    
    lazy var levels: [UIButton] = [level1, level2, level3, level4, level5, level6, level7, level8, level9, level10]

    @IBAction func lv1(_ sender: Any) {
        updateTextColor()
        UserDefaults.standard.set(0, forKey: "level")
        level1.setTitleColor(.red, for: .normal)
    }
    @IBAction func lv2(_ sender: Any) {
        updateTextColor()
        UserDefaults.standard.set(1, forKey: "level")
        level2.setTitleColor(.red, for: .normal)
    }
    @IBAction func lv3(_ sender: Any) {
        updateTextColor()
        UserDefaults.standard.set(2, forKey: "level")
        level3.setTitleColor(.red, for: .normal)
    }
    @IBAction func lv4(_ sender: Any) {
        updateTextColor()
        UserDefaults.standard.set(3, forKey: "level")
        level4.setTitleColor(.red, for: .normal)
    }
    @IBAction func lv5(_ sender: Any) {
        updateTextColor()
        UserDefaults.standard.set(4, forKey: "level")
        level5.setTitleColor(.red, for: .normal)
    }
    @IBAction func lv6(_ sender: Any) {
        updateTextColor()
        UserDefaults.standard.set(5, forKey: "level")
        level6.setTitleColor(.red, for: .normal)
    }
    @IBAction func lv7(_ sender: Any) {
        updateTextColor()
        UserDefaults.standard.set(6, forKey: "level")
        level7.setTitleColor(.red, for: .normal)
    }
    @IBAction func lv8(_ sender: Any) {
        updateTextColor()
        UserDefaults.standard.set(7, forKey: "level")
        level8.setTitleColor(.red, for: .normal)
    }
    @IBAction func lv9(_ sender: Any) {
        updateTextColor()
        UserDefaults.standard.set(8, forKey: "level")
        level9.setTitleColor(.red, for: .normal)
    }
    @IBAction func lv10(_ sender: Any) {
        updateTextColor()
        UserDefaults.standard.set(9, forKey: "level")
        level10.setTitleColor(.red, for: .normal)
    }
    
    func updateTextColor(){
        let temp: Int = UserDefaults.standard.integer(forKey: "level")
        levels[temp].setTitleColor(.systemBlue, for: .normal)
    }
    
}
