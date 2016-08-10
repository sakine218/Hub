import UIKit

class PlayGameViewController: UIViewController {
    
    @IBOutlet var quizImageView: UIImageView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var pointLabel: UILabel!
    
    @IBOutlet var timerLabel: UILabel!
    
    var answerNumber = 0
    var point = 0
    var timecount = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reloadQuiz()
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(PlayGameViewController.updateTimer(_:)), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTimer(timer: NSTimer){
        timecount -= 1
        timerLabel.text = String(timecount)
        
        if timecount <= 0 {
            timer.invalidate()
            performSegueWithIdentifier("toScore", sender: nil)
        }
        
    }
    
    
    @IBAction func selectButton(sender: UIButton) {
        if sender.tag == answerNumber{
            reloadQuiz()
            point += 1
            pointLabel.text = String(point)
        } else {
            performSegueWithIdentifier("toScore", sender: sender)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toScore" {
            let SVController: ScoreViewController = segue.destinationViewController as! ScoreViewController
            SVController.score = point
        }
    }
    
    func getArray() -> [Int] {
        var array: [Int] = []
        for _ in 0...3{
            let num = Int(arc4random_uniform(2))
            array.append(num)
        }
        return array
    }
    
    func reloadQuiz() {
        var quiz: [Int] = []
        for _ in 0...3{
            let num = Int(arc4random_uniform(2))
            quiz.append(num)
        }
        
        let imageName = getImageName(quiz)
        quizImageView.image = UIImage(named: imageName)
        
        let answer = getAnswer(quiz)
        let answerImage = UIImage(named: getImageName(answer))
        answerNumber = Int(arc4random_uniform(9))
        buttons[answerNumber].setBackgroundImage(answerImage!, forState: .Normal)
        print(answer)
        print(answerNumber)
        
        var choices: [[Int]] = []
        for (index,button) in buttons.enumerate() {
            button.adjustsImageWhenDisabled = false
            if index != answerNumber{
            var choice = getArray()
                while choice == answer || indexOf(choices, element: choice) {
                    choice = getArray()
                }
                choices.append(choice)
                let choiceImage = UIImage(named: getImageName(choice))
                button.setBackgroundImage(choiceImage, forState: .Normal)
                print (choice)
            }
        }
        print(choices)
    }
    
    //配列の要素検索
    func indexOf(array: [[Int]], element: [Int]) -> Bool{
        for a in array {
            if a == element {
                return true
            }
        }
        return false
    }
    
    //[Int]をつなげてStringにして返す
    func getImageName(array: [Int]) -> String {
        return array.map { String($0) }.reduce("", combine: + )
    }
    
    //[Int]を反対にして返す
    func getAnswer(quiz: [Int]) -> [Int] {
        var answer: [Int] = []
        quiz.forEach {
            if $0 == 0 {
                answer.append(1)
            } else {
                answer.append(0)
            }
        }
        return answer
    }
    
}

