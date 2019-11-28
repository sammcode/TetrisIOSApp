//
//  GameViewController.swift
//  OGTetris
//
//  Created by Sam McGarry on 10/16/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet var row0: [UIImageView]!
    
    @IBOutlet var row1: [UIImageView]!
    
    @IBOutlet var row2: [UIImageView]!
    
    @IBOutlet var row3: [UIImageView]!
    
    @IBOutlet var row4: [UIImageView]!
    
    @IBOutlet var row5: [UIImageView]!
    
    @IBOutlet var row6: [UIImageView]!
    
    @IBOutlet var row7: [UIImageView]!
    
    @IBOutlet var row8: [UIImageView]!
    
    @IBOutlet var row9: [UIImageView]!
    
    @IBOutlet var row10: [UIImageView]!
    
    @IBOutlet var row11: [UIImageView]!
    
    @IBOutlet var row12: [UIImageView]!
    
    @IBOutlet var row13: [UIImageView]!
    
    @IBOutlet var row14: [UIImageView]!
    
    @IBOutlet var row15: [UIImageView]!
    
    lazy var rows: [[UIImageView]] = [row0, row1, row2, row3, row4, row5, row6, row7, row8, row9, row10, row11, row12, row13, row14, row15]
    
    @IBOutlet weak var numRows: UILabel!
    @IBOutlet weak var numScore: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var tapToPlay: UILabel!
    
    var playing: Bool = false//is game being played currently
    var isBlockShifting: Bool = false
    lazy var currentB: tetrisBlock = emptyBlock //current tetris block
    lazy var nextB: tetrisBlock = emptyBlock//next tetris block
    var score: Int = 0 //current player score
    var rowsCompleted: Int = 0 //number of completed rows this game
    var chighScore: Int = 0
    var govo = UserDefaults.standard.bool(forKey: "govo")
    let level = UserDefaults.standard.integer(forKey: "level")
    let levelTimes: [Double] = [0.8, 0.75, 0.7, 0.65, 0.6, 0.55, 0.5, 0.45, 0.4, 0.35]
    let levelKeys : [String] = ["lv1HS", "lv2HS", "lv3HS", "lv4HS", "lv5HS", "lv6HS", "lv7HS", "lv9HS", "lv9HS", "lv10HS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            chighScore = UserDefaults.standard.integer(forKey: levelKeys[level])
            highScore.text = String(chighScore)
            
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            chighScore = 0
            highScore.text = String(chighScore)
        }
        
        UserDefaults.standard.set(false, forKey: "govo")
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if(!playing && !UserDefaults.standard.bool(forKey: "govo")){
            startGame()
            tapToPlay.text = ""
        }else{
            return
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        DispatchQueue.main.async {
            self.isBlockShifting = true
            if(!self.playing){
                return
            }
            switch gesture.direction {
            case .right:
                self.move(dir: "RIGHT")
            case .left:
                self.move(dir: "LEFT")
            case .up:
                self.move(dir: "ROTATE")
            case .down:
                self.move(dir: "DROPDOWN")
            default:
                break
            }
            self.isBlockShifting = false
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    func updateHS(x: Int){
        chighScore = x
        highScore.text = String(chighScore)
        UserDefaults.standard.set(chighScore, forKey: levelKeys[level])
    }
    func setScore(n: Int){
        score = n
        if score > chighScore {
            updateHS(x: score)
        }
    }
    func addScore(n: Int){
        score += n
        if score > chighScore {
            updateHS(x: score)
        }
    }
    func setRows(n: Int){rowsCompleted = n}
    func addRows(n: Int){rowsCompleted += n}
    func setCurrentB(b: tetrisBlock){currentB = b}
    func setNextB(b: tetrisBlock){nextB = b}
    func getBlockImage(x: Int, y: Int) -> UIImage{return rows[y][x].image!}
    func setBlockImage(x: Int, y:Int, n: UIImage){rows[y][x].image = n}

    struct pos{
        var grid: [[UIImage]]
        var xCord: Int //reference cords to 8x8 grid for rotation
        var yCord: Int
    }

    struct tetrisBlock{
        var pos1: pos
        var pos2: pos
        var pos3: pos
        var pos4: pos
        var currentPos: pos
        var xPoint: Int // referring to the x-value of the bottom left corner position
        var yPoint: Int // referring to the y-value of the top left corner position
        func getRandPos() -> pos{
            let allPos: [pos] = [pos1, pos2, pos3, pos4]
            return allPos[Int.random(in: 0..<4)]
        }
        func getNextPos() -> pos{
            let allPos: [pos] = [pos1, pos2, pos3, pos4]
            var index: Int = 0
            for i in 0..<allPos.count{
                if allPos[i].grid == currentPos.grid{
                    if(i + 1 == 4){
                        index = 0
                    }else{
                        index = i + 1
                    }
                }
            }
            return allPos[index]
        }
    }

    lazy var greenBlockPos1: pos = pos(grid: greenBlockGrid1, xCord: 0, yCord: 1)
    lazy var greenBlockPos2: pos = pos(grid: greenBlockGrid2, xCord: 1, yCord: 0)
    lazy var greenBlockPos3: pos = pos(grid: greenBlockGrid3, xCord: 0, yCord: 0)
    lazy var greenBlockPos4: pos = pos(grid: greenBlockGrid4, xCord: 0, yCord: 0)
    
    var greenBlockGrid1: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisGreenBlock ()"), #imageLiteral(resourceName: "TetrisGreenBlock ()"), #imageLiteral(resourceName: "TetrisGreenBlock ()")], [#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisGreenBlock ()")]]
    var greenBlockGrid2: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisGreenBlock ()"), #imageLiteral(resourceName: "TetrisGreenBlock ()")], [#imageLiteral(resourceName: "TetrisGreenBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")], [#imageLiteral(resourceName: "TetrisGreenBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")]]
    var greenBlockGrid3: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisGreenBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")], [#imageLiteral(resourceName: "TetrisGreenBlock ()"), #imageLiteral(resourceName: "TetrisGreenBlock ()"), #imageLiteral(resourceName: "TetrisGreenBlock ()")]]
    var greenBlockGrid4: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisGreenBlock ()")], [#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisGreenBlock ()")], [#imageLiteral(resourceName: "TetrisGreenBlock ()"), #imageLiteral(resourceName: "TetrisGreenBlock ()")]]
    
    lazy var redBlockPos1: pos = pos(grid: redBlockGrid1, xCord: 1, yCord: 0)
    lazy var redBlockPos2: pos = pos(grid: redBlockGrid2, xCord: 0, yCord: 1)
    lazy var redBlockPos3: pos = pos(grid: redBlockGrid1, xCord: 2, yCord: 0)
    lazy var redBlockPos4: pos = pos(grid: redBlockGrid2, xCord: 0, yCord: 2)
    
    var redBlockGrid1: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisRedBlock ()")], [#imageLiteral(resourceName: "TetrisRedBlock ()")], [#imageLiteral(resourceName: "TetrisRedBlock ()")], [#imageLiteral(resourceName: "TetrisRedBlock ()")]]
    var redBlockGrid2: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisRedBlock ()"), #imageLiteral(resourceName: "TetrisRedBlock ()"), #imageLiteral(resourceName: "TetrisRedBlock ()"), #imageLiteral(resourceName: "TetrisRedBlock ()")]]
    
    lazy var pinkBlockPos1: pos = pos(grid: pinkBlockGrid1, xCord: 0, yCord: 0)
    
    var pinkBlockGrid1: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisPinkBlock ()"), #imageLiteral(resourceName: "TetrisPinkBlock ()")], [#imageLiteral(resourceName: "TetrisPinkBlock ()"), #imageLiteral(resourceName: "TetrisPinkBlock ()")]]
    
    lazy var blueBlockPos1: pos = pos(grid: blueBlockGrid1, xCord: 0, yCord: 0)
    lazy var blueBlockPos2: pos = pos(grid: blueBlockGrid2, xCord: 0, yCord: 0)
    lazy var blueBlockPos3: pos = pos(grid: blueBlockGrid3, xCord: 0, yCord: 1)
    lazy var blueBlockPos4: pos = pos(grid: blueBlockGrid4, xCord: 1, yCord: 0)
    
    var blueBlockGrid1: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")], [#imageLiteral(resourceName: "TetrisBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlueBlock ()")]]
    var blueBlockGrid2: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisBlueBlock ()")], [#imageLiteral(resourceName: "TetrisBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlueBlock ()")], [#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisBlueBlock ()")]]
    var blueBlockGrid3: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlueBlock ()")], [#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")]]
    var blueBlockGrid4: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")], [#imageLiteral(resourceName: "TetrisBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlueBlock ()")], [#imageLiteral(resourceName: "TetrisBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")]]
    
    lazy var lightBlueBlockPos1: pos = pos(grid: lightBlueBlockGrid1, xCord: 0, yCord: 1)
    lazy var lightBlueBlockPos2: pos = pos(grid: lightBlueBlockGrid2, xCord: 1, yCord: 0)
    lazy var lightBlueBlockPos3: pos = pos(grid: lightBlueBlockGrid3, xCord: 0, yCord: 0)
    lazy var lightBlueBlockPos4: pos = pos(grid: lightBlueBlockGrid4, xCord: 0, yCord: 0)
    
    var lightBlueBlockGrid1: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisLightBlueBlock ()"), #imageLiteral(resourceName: "TetrisLightBlueBlock ()"), #imageLiteral(resourceName: "TetrisLightBlueBlock ()")], [#imageLiteral(resourceName: "TetrisLightBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")]]
    var lightBlueBlockGrid2: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisLightBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")], [#imageLiteral(resourceName: "TetrisLightBlueBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")], [#imageLiteral(resourceName: "TetrisLightBlueBlock ()"), #imageLiteral(resourceName: "TetrisLightBlueBlock ()")]]
    var lightBlueBlockGrid3: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisLightBlueBlock ()")], [#imageLiteral(resourceName: "TetrisLightBlueBlock ()"), #imageLiteral(resourceName: "TetrisLightBlueBlock ()"), #imageLiteral(resourceName: "TetrisLightBlueBlock ()")]]
    var lightBlueBlockGrid4: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisLightBlueBlock ()"), #imageLiteral(resourceName: "TetrisLightBlueBlock ()")], [#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisLightBlueBlock ()")], [#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisLightBlueBlock ()")]]
    
    lazy var purpleBlockPos1: pos = pos(grid: purpleBlockGrid1, xCord: 0, yCord: 1)
    lazy var purpleBlockPos2: pos = pos(grid: purpleBlockGrid2, xCord: 0, yCord: 0)
    lazy var purpleBlockPos3: pos = pos(grid: purpleBlockGrid1, xCord: 0, yCord: 0)
    lazy var purpleBlockPos4: pos = pos(grid: purpleBlockGrid2, xCord: 1, yCord: 0)
    
    var purpleBlockGrid1: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisPurpleBlock ()"), #imageLiteral(resourceName: "TetrisPurpleBlock ()")], [#imageLiteral(resourceName: "TetrisPurpleBlock ()"), #imageLiteral(resourceName: "TetrisPurpleBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")]]
    var purpleBlockGrid2: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisPurpleBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")], [#imageLiteral(resourceName: "TetrisPurpleBlock ()"), #imageLiteral(resourceName: "TetrisPurpleBlock ()")], [#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisPurpleBlock ()")]]
    
    lazy var orangeBlockPos1: pos = pos(grid: orangeBlockGrid1, xCord: 0, yCord: 1)
    lazy var orangeBlockPos2: pos = pos(grid: orangeBlockGrid2, xCord: 0, yCord: 0)
    lazy var orangeBlockPos3: pos = pos(grid: orangeBlockGrid1, xCord: 0, yCord: 0)
    lazy var orangeBlockPos4: pos = pos(grid: orangeBlockGrid2, xCord: 1, yCord: 0)
    
    var orangeBlockGrid1: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisOrangeBlock ()"), #imageLiteral(resourceName: "TetrisOrangeBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")], [#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisOrangeBlock ()"), #imageLiteral(resourceName: "TetrisOrangeBlock ()")]]
    var orangeBlockGrid2: [[UIImage]] = [[#imageLiteral(resourceName: "TetrisBlankBlock ()"), #imageLiteral(resourceName: "TetrisOrangeBlock ()")], [#imageLiteral(resourceName: "TetrisOrangeBlock ()"), #imageLiteral(resourceName: "TetrisOrangeBlock ()")], [#imageLiteral(resourceName: "TetrisOrangeBlock ()"), #imageLiteral(resourceName: "TetrisBlankBlock ()")]]
    
    lazy var emptyPos: pos = pos(grid: emptyGrid, xCord: 0, yCord: 0)
    
    var emptyGrid: [[UIImage]] = []
    
    lazy var emptyBlock = tetrisBlock(pos1: emptyPos, pos2: emptyPos, pos3: emptyPos, pos4: emptyPos, currentPos: emptyPos, xPoint: 0, yPoint: 0)
    
    lazy var greenBlock = tetrisBlock(pos1: greenBlockPos1, pos2: greenBlockPos2, pos3: greenBlockPos3, pos4: greenBlockPos4, currentPos: emptyPos, xPoint: 4, yPoint: 0)
    lazy var redBlock = tetrisBlock(pos1: redBlockPos1, pos2: redBlockPos2, pos3: redBlockPos3, pos4: redBlockPos4, currentPos: emptyPos, xPoint: 4, yPoint: 0)
    lazy var pinkBlock = tetrisBlock(pos1: pinkBlockPos1, pos2: pinkBlockPos1, pos3: pinkBlockPos1, pos4: pinkBlockPos1, currentPos: emptyPos, xPoint: 4, yPoint: 0)
    lazy var blueBlock = tetrisBlock(pos1: blueBlockPos1, pos2: blueBlockPos2, pos3: blueBlockPos3, pos4: blueBlockPos4, currentPos: emptyPos, xPoint: 4, yPoint: 0)
    lazy var lightBlueBlock = tetrisBlock(pos1: lightBlueBlockPos1, pos2: lightBlueBlockPos2, pos3: lightBlueBlockPos3, pos4: lightBlueBlockPos4, currentPos: emptyPos, xPoint: 4, yPoint: 0)
    lazy var purpleBlock = tetrisBlock(pos1: purpleBlockPos1, pos2: purpleBlockPos2, pos3: purpleBlockPos1, pos4: purpleBlockPos2, currentPos: emptyPos, xPoint: 4, yPoint: 0)
    lazy var orangeBlock = tetrisBlock(pos1: orangeBlockPos1, pos2: orangeBlockPos2, pos3: orangeBlockPos1, pos4: orangeBlockPos2, currentPos: emptyPos, xPoint: 4, yPoint: 0)
    
    lazy var tetrisBlocks: [tetrisBlock] = [greenBlock, redBlock, pinkBlock, blueBlock, lightBlueBlock, purpleBlock, orangeBlock]
    
    func getRandomBlock() -> tetrisBlock { //Returns random tetris block
        let x: tetrisBlock = tetrisBlocks[Int.random(in: 0..<7)]
        return x
    }
    
    func getCordDiff(x1: Int, x2: Int) -> Int{ //Returns respective coordinate difference between two rotation positions
        return x2 - x1
    }
    
    func doesBlockOverlap(x: Int, y: Int, pos1: pos, pos2: pos) -> Bool{ //Checks if next rotation position has individual blocks that overlap with current position
        let refXCord = x + pos1.xCord
        let refYCord = y + pos2.yCord
        var result: Bool = false
        if (refXCord >= pos2.xCord) && (refXCord <= pos2.xCord + pos2.grid.count - 1)
            && (refYCord >= pos2.yCord) && (refYCord <= pos2.yCord + pos2.grid[0].count - 1) && !(image(image1: pos1.grid[x][y], isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()"))){
            result = true
        }
        return result
    }
    
    func occupied(pos: pos, x: Int, y: Int, dir: String) -> Bool{ //Checks if a position is occupied
        var x1 = x
        var y1 = y
        var result: Bool = false
        switch dir{
        case "DOWN":
            if (y1 + pos.grid.count == 16) || isBlockShifting {
                result = true
                break
            }else{
                y1 += 1
            }
            //rewrite, fails for redblock
            for i in 0..<pos.grid[0].count{
                var minIndex = 0
                for j in 0..<pos.grid.count {
                    if !image(image1: pos.grid[j][i], isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()")){
                        minIndex = j
                    }
                }
                if (image(image1: rows[y1 + minIndex][x1 + i].image!, isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()"))){
                    continue
                }else{
                    result = true
                }
            }
        case "RIGHT":
            print(pos.grid[0].count)
            if (x1 + pos.grid[0].count > rows[0].count - 1) {
                result = true
            }else{
                x1 += 1
                for i in 0..<pos.grid.count{
                    var minIndex = 0
                    for j in 0..<pos.grid[0].count{
                        if !image(image1: pos.grid[i][j], isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()")){
                            minIndex = j
                        }
                    }
                    if !(image(image1: rows[y1 + i][x1 + minIndex].image!, isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()"))){
                        result = true
                        continue
                    }
                }
            }
        case "LEFT":
            if (x1 - 1 < 0) {
                result = true
            }else{
                x1 = x1 - 1
            }
            //rewrite
            for i in 0..<pos.grid.count{
                var minIndex = 0
                for j in 0..<pos.grid[0].count{
                    if !image(image1: pos.grid[i][j], isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()")){
                        minIndex = j
                        break
                    }
                }
                if !(image(image1: rows[y1 + i][x1 + minIndex].image!, isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()"))){
                    result = true
                    continue
                }
            }
        case "ROTATE":
            let nxtPos: pos = self.currentB.getNextPos()
            let xChange = (nxtPos.xCord - pos.xCord)
            let yChange = (nxtPos.yCord - pos.yCord)
            print(xChange)
            print(yChange)
            if(x1 + xChange + nxtPos.grid[0].count > 9) || (x1 + xChange < 0) || (y1 + yChange + nxtPos.grid.count > 15) || (y1 + yChange < 0){
                result = true
                break
            }else{
                x1 += xChange
                y1 += yChange
                eraseBlock(x: currentB.xPoint, y: currentB.yPoint, pos1: currentB.currentPos)
                for i in 0..<nxtPos.grid[0].count{
                    for j in 0..<nxtPos.grid.count{
                        if !image(image1: rows[y1 + j][x1 + i].image!, isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()")){
                            result = true
                            break
                        }
                    }
                }
                printBlock(x: currentB.xPoint, y: currentB.yPoint, pos1: currentB.currentPos)
            }
        case "DROP":
            for i in 0..<pos.grid[0].count{
                for j in 0..<pos.grid.count{
                    if(!image(image1: pos.grid[j][i], isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()"))&&(!image(image1: rows[j + y1][i + x1].image!, isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()")))){
                        result = true
                        print("drop area occupied")
                        break
                    }
                }
            }
        case "DROPDOWN":
        y1 = getLowestYPoint(pos1: currentB.currentPos)
        for i in 0..<pos.grid[0].count{
            for j in 0..<pos.grid.count{
                if(!image(image1: pos.grid[j][i], isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()"))&&(!image(image1: rows[j + y1][i + x].image!, isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()")))){
                    result = true
                    print("drop area occupied")
                    break
                }
            }
        }
        default:
            break
        }
        return result
    }
    
    func unoccupied(pos: pos, x: Int, y: Int, dir: String) -> Bool{ //Checks if a position is unoccupied
        return !occupied(pos: pos, x: x, y: y, dir: dir)
    }
    
    func move(dir: String) -> Bool{ //Function that is called when moving a tetris block
        var x: Int = currentB.xPoint
        var y: Int = currentB.yPoint
        var cPos = currentB.currentPos
        switch dir {
        case "DOWN":
            y += 1
        case "RIGHT":
            isBlockShifting = true
            x += 1
        case "LEFT":
            isBlockShifting = true
            x = x - 1
        case "ROTATE":
            isBlockShifting = true
            let nxtPos: pos = self.currentB.getNextPos()
            let xChange = getCordDiff(x1: currentB.currentPos.xCord, x2: nxtPos.xCord)
            let yChange = getCordDiff(x1: currentB.currentPos.yCord, x2: nxtPos.yCord)
            x += xChange
            y += yChange
            cPos = nxtPos
        case "DROPDOWN":
            y = getLowestYPoint(pos1: currentB.currentPos)
        default:
            break
        }
        if unoccupied(pos: currentB.currentPos, x: currentB.xPoint, y: currentB.yPoint, dir: dir){
            eraseBlock(x: currentB.xPoint, y: currentB.yPoint, pos1: currentB.currentPos)
            currentB.xPoint = x
            currentB.yPoint = y
            currentB.currentPos = cPos
            printBlock(x: x, y: y, pos1: cPos)
            return true
        }else{
            return false
        }
    }
    
    func reset(){ //Resets scores and updates game board
        setScore(n: 0)
        setRows(n: 0)
        numRows.text = String(rowsCompleted)
        numScore.text = String(score)
        clearBoard()
    }
    
    func clearBoard(){ //Erases entire board
        for i in 0..<rows.count{
            eraseRow(index: i)
        }
    }
    
    func eraseBlock(x: Int, y: Int, pos1: pos){ //Erases tetris block at specific coordinates
        for i in 0..<pos1.grid[0].count{
            for j in 0..<pos1.grid.count{
                if !(image(image1: pos1.grid[j][i], isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()"))){
                    rows[j + y][i + x].image = #imageLiteral(resourceName: "TetrisBlankBlock ()")
                }
            }
        }
    }
    
    func printBlock(x: Int, y: Int, pos1: pos){ //Prints tetris block at specific coordinates
        for m in 0..<pos1.grid[0].count{
            for n in 0..<pos1.grid.count{
                if !(image(image1: pos1.grid[n][m], isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()"))){
                    rows[n + y][m + x].image = pos1.grid[n][m]
                }
            }
        }
    }
    
    func update(){
        Timer.scheduledTimer(withTimeInterval: levelTimes[level], repeats: true){timer in
            if(!self.isBlockShifting){
                self.drop()
            }
            if !self.playing{
                timer.invalidate()
                print(self.playing)
            }else{
                return
            }
        }
    }
    
    func startGame(){
        reset()
        playing = true
        print("game just started, playing should be true: ")
        print(self.playing)
        currentB = getRandomBlock()
        nextB = getRandomBlock()
        currentB.currentPos = currentB.getRandPos()
        currentB.xPoint = 4
        currentB.yPoint = 0
        dropNewBlock()
        update()
    }
    
    func gameOver(){ //Ends game, loads game over screen
        playing = false
        var scoreText = ""
        var rowsText = ""
        let gameOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameOver") as! GameOverViewController
        self.addChild(gameOverVC)
        gameOverVC.view.frame = self.view.frame
        self.view.addSubview(gameOverVC.view)
        scoreText = String(score)
        rowsText = String(rowsCompleted)
        gameOverVC.score.text = scoreText
        gameOverVC.rows.text = rowsText
        UserDefaults.standard.set(true, forKey: "govo")
        gameOverVC.didMove(toParent: self)
    }
    
    @objc func drop(){ //Function moves block down, if returns false it drops a new block
        if (!move(dir: "DOWN")){
            addScore(n: 10)
            removeLines()
            numRows.text = String(rowsCompleted)
            numScore.text = String(score)
            setCurrentB(b: nextB)
            setNextB(b: getRandomBlock())
            currentB.currentPos = currentB.getRandPos()
            currentB.xPoint = 4
            currentB.yPoint = 0
            if unoccupied(pos: currentB.currentPos, x: currentB.xPoint, y: currentB.yPoint, dir: "DROP"){
                dropNewBlock()
            }
            else{
                gameOver()
            }
        }
    }
    
    func dropNewBlock() { //Moves tetris block one unit down
        printBlock(x: currentB.xPoint, y: currentB.yPoint, pos1: currentB.currentPos)
    }
    
    func removeLines() { //Sorts through rows recursively and removes any full rows
        for i in 0..<rows.count{
            if isRowFull(x: rows[i]){
                rowsCompleted += 1
                setScore(n: score + 100)
                eraseRow(index: i)
                for j in stride(from: i, to: 0, by: -1){
                    switch j {
                    case 0:
                        break
                    default:
                        printRow(row: rows[j - 1], index: j)
                    }
                }
            }
        }
    }

    func eraseRow(index: Int){ //Function that erases an entire row
        for i in 0...rows[0].count - 1{
            rows[index][i].image = #imageLiteral(resourceName: "TetrisBlankBlock ()")
        }
    }
    
    func printRow(row: [UIImageView], index: Int){ //Function that prints an entire row
        for i in 0...rows[0].count - 1{
            rows[index][i].image = row[i].image
        }
    }
    
    func isRowFull (x: [UIImageView]) -> Bool{ //Function checks if a row is full
        for i in x{
            if image(image1: i.image!, isEqualTo: #imageLiteral(resourceName: "TetrisBlankBlock ()")){
                return false
            }
        }
        return true
    }
    
    func image(image1: UIImage, isEqualTo image2: UIImage) -> Bool { //Compares two image
        let data1: NSData = image1.pngData()! as NSData
        let data2: NSData = image2.pngData()! as NSData
        return data1.isEqual(data2)
    }

    func getLowestYPoint(pos1: pos) -> Int { //Returns lowest y-coordinate tetris block can move
        var y: Int = currentB.yPoint
        for i in currentB.yPoint..<(rows.count - currentB.currentPos.grid.count + 1){
            if unoccupied(pos: currentB.currentPos, x: currentB.xPoint, y: i, dir: "DROP"){
                y = i
            }
        }
        return y
    }
}
