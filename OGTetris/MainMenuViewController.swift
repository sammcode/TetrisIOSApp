//
//  MainMenuViewController.swift
//  OGTetris
//
//  Created by Sam McGarry on 11/12/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = UserDefaults.standard.integer(forKey: "level")
        _ = UserDefaults.standard.integer(forKey: "lv1HS")
        _ = UserDefaults.standard.integer(forKey: "lv2HS")
        _ = UserDefaults.standard.integer(forKey: "lv3HS")
        _ = UserDefaults.standard.integer(forKey: "lv4HS")
        _ = UserDefaults.standard.integer(forKey: "lv5HS")
        _ = UserDefaults.standard.integer(forKey: "lv6HS")
        _ = UserDefaults.standard.integer(forKey: "lv7HS")
        _ = UserDefaults.standard.integer(forKey: "lv8HS")
        _ = UserDefaults.standard.integer(forKey: "lv9HS")
        _ = UserDefaults.standard.integer(forKey: "lv10HS")
        
    }
    
    @IBAction func newG(_ sender: Any) { //Loads game view controller
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let gameViewController = storyBoard.instantiateViewController(withIdentifier: "gameView") as! GameViewController

            self.present(gameViewController, animated:true, completion:nil)
    }

    @IBAction func setLev(_ sender: Any) { //Loads set level view controller
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let setLevelViewController = storyBoard.instantiateViewController(withIdentifier: "setLevel") as! SetLevelViewController

        self.present(setLevelViewController, animated:true, completion:nil)
    }
    
    @IBAction func highSco(_ sender: Any) { //Loads highscore view controller
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let highScoresViewController = storyBoard.instantiateViewController(withIdentifier: "highScores") as! HighScoresViewController

        self.present(highScoresViewController, animated:true, completion:nil)
    }
}
