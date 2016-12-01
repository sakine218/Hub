import UIKit

class PlayGameViewController: UIViewController {
    
    @IBOutlet var quizImageView: UIImageView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var pointLabel: UILabel!
    
    @IBOutlet var timerLabel: UILabel!
    
    var answerNumber = 0
    var point = 0
    var timecount = 30
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadQuiz()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayGameViewController.updateTimer(_:)), userInfo: nil, repeats: true)
        timecount = 30
        timerLabel.text = String(timecount)
        point = 0
        pointLabel.text = String(point)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTimer(_ timer: Timer){
        timecount -= 1
        timerLabel.text = String(timecount)
        
        if timecount <= 0 {
            timer.invalidate()
            performSegue(withIdentifier: "toScore", sender: nil)
        }
        
    }
    
    
    @IBAction func selectButton(_ sender: UIButton) {
        if sender.tag == answerNumber{
            reloadQuiz()
            point += 1
            pointLabel.text = String(point)
        } else {
            performSegue(withIdentifier: "toScore", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScore" {
            let SVController: ScoreViewController = segue.destination as! ScoreViewController
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
        buttons[answerNumber].setBackgroundImage(answerImage!, for: UIControlState())
        print(answer)
        print(answerNumber)
        
        var choices: [[Int]] = []
        for (index,button) in buttons.enumerated() {
            button.adjustsImageWhenDisabled = false
            if index != answerNumber{
            var choice = getArray()
                while choice == answer || indexOf(choices, element: choice) {
                    choice = getArray()
                }
                choices.append(choice)
                let choiceImage = UIImage(named: getImageName(choice))
                button.setBackgroundImage(choiceImage, for: UIControlState())
                print (choice)
            }
        }
        print(choices)
    }
    
    //配列の要素検索
    func indexOf(_ array: [[Int]], element: [Int]) -> Bool{
        for a in array {
            if a == element {
                return true
            }
        }
        return false
    }
    
    //[Int]をつなげてStringにして返す
    func getImageName(_ array: [Int]) -> String {
        return array.map { String($0) }.reduce("", + )
    }
    
    //[Int]を反対にして返す
    func getAnswer(_ quiz: [Int]) -> [Int] {
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

