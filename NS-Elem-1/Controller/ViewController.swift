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

    var answerCorrect : Int = 0
    var answerUser : Int = 0
    
    var number1 = 0
    var number2 = 0
    var smallNum = 0
    var bigNum = 0
    
    var isShow: Bool = false
    
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome","Give me a high five","You are so smart!"]
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
    
    @IBAction func showAnswerBtn(_ sender: Any) {
        findGCF()
        isShow = true
        answerTxt.text = String(answerCorrect)
    }
    
    func askQuestion(){
        number1 = Int.random(in: 12...80)
        number2 = Int.random(in: 12...80)
        
        if number1 % 2 != 0 {
            number1 = number1 + 1
        }
        if number1 % 2 == 0 && number2 % 2 != 0{
            number2 = number2 + 5
        }
        
        if number1 > number2 {
            bigNum = number1
            smallNum = number2
        }
        else {
            smallNum = number1
            bigNum = number2
        }
        
        questionLabel.text = "The GCF of \(smallNum) and \(bigNum) is"
        checkBtn.isEnabled = true
    }
    
    func checkAnswer(){
        answerUser = (answerTxt.text! as NSString).integerValue
        findGCF()
        
        if answerCorrect == answerUser {
            if isShow == false{
                correctAnswers += 1
                numberAttempts += 1
                updateProgress()
                randomPositiveFeedback()
            }
            else{
                numberAttempts += 1
                updateProgress()
                readMe(myText: "Next Question!")
                isShow = false
            }
            
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
    

    
    func findGCF(){
        for i in (1...smallNum).reversed(){
            if(number1 % i==0 && number2 % i==0){
                answerCorrect=i;
                break;
            }
        }
    }
}

