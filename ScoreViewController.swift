//
//  ScoreViewController.swift
//  Noutore
//
//  Created by 西林咲音 on 2016/08/05.
//  Copyright © 2016年 西林咲音. All rights reserved.
//

import UIKit
import Social
import Firebase
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class ScoreViewController: UIViewController {
    
    var memoryDate: Date!
    
    var score: Int!
    @IBOutlet var scoreLabel: UILabel!
    var textField : UITextField!
    
    let uuid: NSString = UUID().uuidString as NSString

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scoreLabel.text = String(score)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func runkingButton(_ sender: AnyObject) {
        let alert = UIAlertController(title: "User name", message: "Input text", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Done", style: .default) { (action:UIAlertAction!) -> Void in
            
            // 入力したテキストをコンソールに表示
            self.textField = alert.textFields![0] as UITextField
            print(self.textField.text)
            if self.textField.text! == "" {
                let noNameAlert = UIAlertController(
                    title: "No name",
                    message: "Please write your name!",
                    preferredStyle: UIAlertControllerStyle.alert)
                
                let closeAction = UIAlertAction(title: "close", style: .default) { (action:UIAlertAction!) -> Void in
                }
                noNameAlert.addAction(closeAction)
                
                self.present(noNameAlert, animated: true, completion: nil)
                
                print("なにもない")
                
            }else{
            //Firebaseのインスタンスを生成
                self.memoryDate = Date()
            let ref = FIRDatabase.database().reference()
            //Dictionary型で"point","username","time"を入れてデータベースにポスト
//            ref.childByAutoId().setValue(["point": self.score, "username": self.textField.text!, "time": String(NSDate())])
                ref.childByAutoId().setValue(["point": self.score, "username": self.textField.text!, "time": String(describing: self.memoryDate), "uuid": self.uuid], withCompletionBlock: { (error, ref) -> Void in
                    
                    let ud = UserDefaults.standard
                    ud.set(self.uuid, forKey: "id")
                    
                    self.performSegue(withIdentifier: "toVC", sender: sender)
            })
                
        }
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) -> Void in
        }
        
        // UIAlertControllerにtextFieldを追加
        alert.addTextField { (textField:UITextField!) -> Void in
            let myNotificationCenter = NotificationCenter.default
            myNotificationCenter.addObserver(self,
                selector: #selector(ScoreViewController.changeTextField(_:)),
                name: NSNotification.Name.UITextFieldTextDidChange,
                object: textField)
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //STEP.2 遷移元で、遷移先の変数に代入する
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVC" {
            let rankingView = segue.destination as! RankingViewController
            rankingView.memoryDate = self.memoryDate
        }
    }
    
    func changeTextField (_ sender: Notification) {
        textField = sender.object as! UITextField
        var InputStr = textField.text
        
        if InputStr?.characters.count >= 10 {
            textField.text = InputStr!.substring(to: InputStr!.characters.index(InputStr!.startIndex, offsetBy: 10))
        }
    }
    
    @IBAction func homeButton() {
        //self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func retryButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        let twitterPostView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        
        self.present(twitterPostView, animated: true, completion: nil)
        
        twitterPostView.setInitialText("My score is \(score)point！")
    }
    
    
    
}
