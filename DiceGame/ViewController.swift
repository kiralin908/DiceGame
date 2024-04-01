//
//  ViewController.swift
//  DiceGame
//
//  Created by 林郁琦 on 2024/3/3.
//

import UIKit

class ViewController: UIViewController {
    
    //把需要用到的UI元件拉進Outlet
    @IBOutlet weak var player1TotalLabel: UILabel!
    @IBOutlet weak var player2TotalLabel
    : UILabel!
    @IBOutlet weak var player1DicePointLabel
    : UILabel!
    @IBOutlet weak var player2DicePointLabel
    : UILabel!
    
    @IBOutlet weak var player1View: UIView!
    @IBOutlet weak var player2View: UIView!
    
    @IBOutlet weak var diceImage1: UIImageView!
    @IBOutlet weak var diceImage2: UIImageView!
    
    @IBOutlet weak var rollButton: UIButton!
    @IBOutlet weak var holdButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    //宣告玩家的分數、總分
    var player1DicePoint = 0
    var player2DicePoint = 0
    var player1Total = 0
    var player2Total = 0
    let gameScore = 100
    let diceImageView = ["dice1","dice2","dice3","dice4","dice5","dice6"]
    var currentPlayerDicePoint = 0
    
    //宣告目前是哪一個玩家的回合，之後進行判斷會比較清楚
    var isPlayer1Turn = true
    
    //設定兩個隨機的骰子顯示圖片
    func diceRandom() -> (Int,Int) {
        let dice1 = Int.random(in: 1...6)
        let dice2 = Int.random(in: 1...6)
        diceImage1.image = UIImage(named: diceImageView[dice1 - 1])
        diceImage2.image = UIImage(named: diceImageView[dice2 - 1])
        return (dice1, dice2)
    }
    
    //切換玩家
    func togglePlayer() {
        isPlayer1Turn.toggle()
    }
    
    //設定遊戲結束時顯示對話框
    func gameEnd(winner: String) {
        let alertController = UIAlertController(title: "Game Over!", message: "\(winner)獲勝!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        present(alertController, animated: true,completion: nil)
        diceImage1.image = UIImage(named: diceImageView[0])
        diceImage2.image = UIImage(named: diceImageView[0])
        player1TotalLabel.text = "0"
        player1DicePointLabel.text = "0"
        player2TotalLabel.text = "0"
        player2DicePointLabel.text = "0"
    }
    
    //重置遊戲
    func resetGame() {
        diceImage1.image = UIImage(named: diceImageView[0])
        diceImage2.image = UIImage(named: diceImageView[0])
        player1Total = 0
        player2Total = 0
        player1TotalLabel.text = "0"
        player2TotalLabel.text = "0"
        player1DicePointLabel.text = "0"
        player2DicePointLabel.text = "0"
        rollButton.isEnabled = true
        holdButton.isEnabled = true
    }
    
    //設定不同的背景顏色來區分玩家的每一個回合
    func updatePlayerViewBackground() {
        if isPlayer1Turn {
            player1View.backgroundColor = UIColor.systemGreen
            player2View.backgroundColor = UIColor.white
        } else {
            player1View.backgroundColor = UIColor.white
            player2View.backgroundColor = UIColor.systemGreen
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player1View.layer.cornerRadius = 10
        player2View.layer.cornerRadius = 10
        rollButton.layer.cornerRadius = 20
        holdButton.layer.cornerRadius = 20
        resetButton.layer.cornerRadius = 20
    }
    
    @IBAction func roll(_ sender: UIButton) {
        let (dice1,dice2) = diceRandom()
        //判斷兩個骰子都是1，總分歸0，切換玩家
        if dice1 == 1 && dice2 == 1 {
            currentPlayerDicePoint = 0
            if isPlayer1Turn {
                player1Total = 0
                player1TotalLabel.text = "0"
                player1DicePoint = 0
                player1DicePointLabel.text = "0"
            } else {
                player2Total = 0
                player2TotalLabel.text = "0"
                player2DicePoint = 0
                player2DicePointLabel.text = "0"
            }
            togglePlayer()
            updatePlayerViewBackground()
            return
        }
        //判斷如果其中一個骰子擲到1，點數歸0，切換玩家
        if dice1 == 1 || dice2 == 1 {
            currentPlayerDicePoint = 0
            if isPlayer1Turn {
                player1DicePoint = 0
                player1DicePointLabel.text = "0"
            } else {
                player2DicePoint = 0
                player2DicePointLabel.text = "0"
            }
        
            togglePlayer()
            updatePlayerViewBackground()
            return
        }
        //判斷每一回合玩家的分數及總分
        currentPlayerDicePoint += dice1 + dice2
        if isPlayer1Turn {
            updatePlayerViewBackground()
            player1DicePoint = currentPlayerDicePoint
            if player1Total >= gameScore {
                player1DicePointLabel.text = "\(player1DicePoint)"
                gameEnd(winner: "Player 1")
                return
            }
            player1DicePointLabel.text = "\(player1DicePoint)"
        } else {
            updatePlayerViewBackground()
            player2DicePoint = currentPlayerDicePoint
            if player2Total >= gameScore {
                player2DicePointLabel.text = "\(player2DicePoint)"
                gameEnd(winner: "Player 2")
                return
            }
            player2DicePointLabel.text = "\(player2DicePoint)"
        }
    }
    
    @IBAction func hold(_ sender: UIButton) {
        //設定當前玩家的分數及總分，結束當前回合
        if isPlayer1Turn {
            updatePlayerViewBackground()
            player1Total += currentPlayerDicePoint
            if player1Total >= gameScore {
                player1DicePointLabel.text = "\(player1DicePoint)"
                gameEnd(winner: "Player 1")
                return
            }
            player1TotalLabel.text = "\(player1Total)"
        } else {
            updatePlayerViewBackground()
            player2Total += currentPlayerDicePoint
            if player2Total >= gameScore {
                player2DicePointLabel.text = "\(player2DicePoint)"
                gameEnd(winner: "Player 2")
                return
            }
            player2TotalLabel.text = "\(player2Total)"
        }
        togglePlayer()
        updatePlayerViewBackground()
        currentPlayerDicePoint = 0
        player1DicePointLabel.text = "0"
        player2DicePointLabel.text = "0"
    }
    
    @IBAction func reset(_ sender: UIButton) {
        resetGame()
        updatePlayerViewBackground()
    }
}
