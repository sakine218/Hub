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

class ScoreViewController: UIViewController {
    
    var score: Int!
    @IBOutlet var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scoreLabel.text = String(score)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func runkingButton(sender: AnyObject) {
        let alert = UIAlertController(title: "User name", message: "Input text", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Done", style: .Default) { (action:UIAlertAction!) -> Void in
            
            // 入力したテキストをコンソールに表示
            let textField = alert.textFields![0] as UITextField
            print(textField.text)
            //Firebaseのインスタンスを生成
            let ref = FIRDatabase.database().reference()
            //Dictionary型で"point","username","time"を入れてデータベースにポスト
            ref.childByAutoId().setValue(["point": self.score, "username": textField.text!, "time": String(NSDate())])
            
            self.performSegueWithIdentifier("toVC", sender: sender)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action:UIAlertAction!) -> Void in
        }
        
        // UIAlertControllerにtextFieldを追加
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func homeButton() {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareButton(sender: UIButton) {
        let twitterPostView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        
        self.presentViewController(twitterPostView, animated: true, completion: nil)
        
        twitterPostView.setInitialText("My score is \(score)point！")
    }
    
}
