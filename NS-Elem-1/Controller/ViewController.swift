//
//  ViewController.swift
//  NS-Elem-1
//
//  Created by Eric Hernandez on 12/2/18.
//  Copyright © 2018 Eric Hernandez. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerTxt: UITextField!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var questionNumberLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    var randomPick: Int = 0
    var correctAnswers: Int = 0
    var numberAttempts: Int = 0
    var timer = Timer()
    var counter = 0.0
    
    var randomNumA : Int = 0
    var randomNumB : Int = 0
    var randomNumC : Int = 0
    var randomNumD : Int = 0
    
    var firstNum : Int = 0
    var secondNum : Int = 0
    var thirdNum : Int = 0
    var questionTxt : String = ""
    var answerCorrect : Int = 0
    var answerUser : Int = 0
    
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome","Give me a high five"]
    let retryArray = ["Try again","Oooops"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        askQuestion()
        
        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        self.answerTxt.becomeFirstResponder()
    }

    @IBAction func checkAnswerByUser(_ sender: Any) {
        checkAnswer()
    }
    
    func askQuestion(){
        //3 digit questions starting at 100
        randomNumA = Int.random(in: 10 ..< 100)
        randomNumB = Int.random(in: 10 ..< 100)
        randomNumC = Int.random(in: 10 ..< 100)
        randomNumD = Int.random(in: 10 ..< 100)
        
        questionLabel.text = "\(randomNumA) + \(randomNumB) + \(randomNumC) + \(randomNumD)"
        readMe(myText: "What is \(randomNumA) plus \(randomNumB) plus \(randomNumC) plus \(randomNumD)?")
        checkBtn.isEnabled = true
    }
    
    func checkAnswer(){
        answerUser = (answerTxt.text! as NSString).integerValue
        answerCorrect = randomNumA + randomNumB + randomNumC + randomNumD
        
        if answerCorrect == answerUser {
            checkBtn.isEnabled = false
            correctAnswers += 1
            numberAttempts += 1
            updateProgress()
            randomPositiveFeedback()
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                //next problem
                self.askQuestion()
                self.answerTxt.text = ""
            }
        }
        else{
            randomTryAgain()
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
        }
    }
    
    @objc func updateTimer(){
        counter += 0.1
        timerLbl.text = String(format:"%.1f",counter)
    }
    
    func readMe( myText: String) {
        let utterance = AVSpeechUtterance(string: myText )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func randomPositiveFeedback(){
        randomPick = Int(arc4random_uniform(9))
        readMe(myText: congratulateArray[randomPick])
    }
    
    func updateProgress(){
        progressLbl.text = "\(correctAnswers) / \(numberAttempts)"
    }
    
    func randomTryAgain(){
        randomPick = Int(arc4random_uniform(2))
        readMe(myText: retryArray[randomPick])
    }
}

