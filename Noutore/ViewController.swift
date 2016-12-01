//
//  ViewController.swift
//  Noutore
//
//  Created by 西林咲音 on 2016/08/04.
//  Copyright © 2016年 西林咲音. All rights reserved.
//

import UIKit
import EAIntroView

class ViewController: UIViewController {
    
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let ud = UserDefaults.init()
        print(ud.bool(forKey: "firstLaunch"))
        if ud.bool(forKey: "firstLaunch") {
            // 初回起動時の処理
            showTutorial()
            // 2回目以降の起動では「firstLaunch」のkeyをfalseに
            ud.set(false, forKey: "firstLaunch")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startButton.alpha = 1
        UIView.animate(withDuration: 1.3, delay: 0.0,
                                   options: UIViewAnimationOptions.repeat, animations: {
                                    () -> Void in
                                    self.startButton.alpha = 0.0
                                    print(self.startButton)
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showTutorial (){
    // basic
        let page1: EAIntroPage = EAIntroPage()
        let page2: EAIntroPage = EAIntroPage()
        let page3: EAIntroPage = EAIntroPage()
        let page4: EAIntroPage = EAIntroPage()
        
        page1.bgImage = UIImage(named: "walkthrow0.png")
        page2.bgImage = UIImage(named: "walkthrow1.png")
        page3.bgImage = UIImage(named: "walkthrow2.png")
        page4.bgImage = UIImage(named: "walkthrow3.png")
        
        
        let intro :EAIntroView = EAIntroView(frame: self.view.bounds, andPages: [page1,page2,page3,page4])
        
        intro.skipButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        //intro.setDelegate:self
        
        intro.show(in: self.view, animateDuration: 0.6)
        
    // チュートリアルを見たことを記録する
        UserDefaults.standard.set(1, forKey: "active")
        
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        showTutorial()
    }

    
}

