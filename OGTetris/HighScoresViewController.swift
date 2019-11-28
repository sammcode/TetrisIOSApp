//
//  HighScoresViewController.swift
//  OGTetris
//
//  Created by Sam McGarry on 11/28/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import UIKit

class HighScoresViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateScores()
    }
    
    @IBAction func returnToMenu(_ sender: Any) { //Returns to main menu
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let mainMenuViewController = storyBoard.instantiateViewController(withIdentifier: "mainMenu") as! MainMenuViewController

        self.present(mainMenuViewController, animated:true, completion:nil)
    }
    
    @IBOutlet weak var lev1HS: UILabel!
    @IBOutlet weak var lev2HS: UILabel!
    @IBOutlet weak var lev3HS: UILabel!
    @IBOutlet weak var lev4HS: UILabel!
    @IBOutlet weak var lev5HS: UILabel!
    @IBOutlet weak var lev6HS: UILabel!
    @IBOutlet weak var lev7HS: UILabel!
    @IBOutlet weak var lev8HS: UILabel!
    @IBOutlet weak var lev9HS: UILabel!
    @IBOutlet weak var lev10HS: UILabel!
    
    lazy var labels: [UILabel] = [lev1HS, lev2HS, lev3HS, lev4HS, lev5HS, lev6HS, lev7HS, lev8HS, lev9HS, lev10HS]
    
    func updateScores(){ //Updates all high scores based on respective level
        lev1HS.text = String(UserDefaults.standard.integer(forKey: "lv1HS"))
        lev2HS.text = String(UserDefaults.standard.integer(forKey: "lv2HS"))
        lev3HS.text = String(UserDefaults.standard.integer(forKey: "lv3HS"))
        lev4HS.text = String(UserDefaults.standard.integer(forKey: "lv4HS"))
        lev5HS.text = String(UserDefaults.standard.integer(forKey: "lv5HS"))
        lev6HS.text = String(UserDefaults.standard.integer(forKey: "lv6HS"))
        lev7HS.text = String(UserDefaults.standard.integer(forKey: "lv7HS"))
        lev8HS.text = String(UserDefaults.standard.integer(forKey: "lv8HS"))
        lev9HS.text = String(UserDefaults.standard.integer(forKey: "lv9HS"))
        lev10HS.text = String(UserDefaults.standard.integer(forKey: "lv10HS"))
    }
}
