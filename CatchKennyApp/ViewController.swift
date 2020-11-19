//
//  ViewController.swift
//  CatchKennyApp
//
//  Created by aytug on 19.11.2020.
//  Copyright © 2020 aytug. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let timeLabel = UILabel()
    let scoreLabel = UILabel()
    let highscoreLabel = UILabel()
    let imageView = UIImageView()
    var score = 0
    var highscore = 0
    var time = 10
    var timer = Timer()
    var kennyTimer = Timer()
    var lastNumber1 = -1
    var lastNumber2 = -1
    override func viewDidLoad() {
        super.viewDidLoad()

        highscore = UserDefaults.standard.integer(forKey: "highscore")
        initAppUI()
        startGame()
    }
    
    func initAppUI(){
        let width = view.frame.size.width
        let height = view.frame.size.height

        timeLabel.text = "\(time)"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        timeLabel.textAlignment = .center
        timeLabel.frame  =  CGRect(x: 0, y: height * 0.08, width: width , height: height * 0.1 )
        view.addSubview(timeLabel)
        
        scoreLabel.text = "Score: \(score)"
        scoreLabel.textAlignment = .center
        scoreLabel.frame = CGRect(x: 0, y: height * 0.2, width: width, height: height * 0.05)
        view.addSubview(scoreLabel)
        
        highscoreLabel.text = "Highscore: \(highscore)"
        highscoreLabel.textAlignment = .center
        highscoreLabel.frame = CGRect(x: 0, y: height * 0.85, width: width, height: height * 0.05)
        view.addSubview(highscoreLabel)
        
        createRandomLocationForKenny()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(kennyClicked))
        imageView.addGestureRecognizer(gestureRecognizer)
        imageView.image = UIImage(named: "kenny")
        view.addSubview(imageView)
    }

    @objc func kennyClicked(){
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    func createRandomLocationForKenny(){
        var number1 = CGFloat(Int.random(in: 0...2))
        var number2 = CGFloat(Int.random(in: 0...2))
        if Int(number1) == lastNumber1 {
            if number1 == 0 {
                number1 = 2
            }
            else {
                number1 -= 1
            }
        }
        if Int(number2) == lastNumber1 {
            if number2 == 0 {
                number2 = 2
            }
            else {
                number2 -= 1
            }
        }
        lastNumber1 = Int(number1)
        lastNumber2 = Int(number2)
        let width = view.frame.size.width
        let height = view.frame.size.height
        imageView.frame = CGRect(x: Double(width * CGFloat(0.33) * number1), y: Double( (height * 0.26) + (height * 0.19 * number2) ) , width: Double(width * 0.33), height: Double(height * 0.19))
   }
    func startGame(){
        time = 10
        score = 0
        scoreLabel.text = "Score: \(score)"
        timeLabel.text = "\(time)"
        createRandomLocationForKenny()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decreaseTime), userInfo: nil, repeats: true)
        kennyTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(randomLocation), userInfo: nil, repeats: true)
    }
    @objc func decreaseTime(){
        print(time)
        time -= 1
        if time == 0 {
            onGameOver()
        } else{
            timeLabel.text = "\(time)"
        }
        
    }
    @objc func randomLocation(){
        createRandomLocationForKenny()
    }
    
    func onGameOver(){
        kennyTimer.invalidate()
        timer.invalidate()
        if score > highscore {
            highscore = score
            UserDefaults.standard.set(highscore, forKey: "highscore")
            timeLabel.text = "New Highscore!"
            highscoreLabel.text = "Highscore: \(highscore)"
        } else {
            timeLabel.text = "Game Over"
        }
        let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.startGame()
        }
        alert.addAction(okButton)
        alert.addAction(replayButton)
        self.present(alert, animated: true, completion: nil)
    }


}

