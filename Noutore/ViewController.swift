//
//  ViewController.swift
//  Noutore
//
//  Created by 西林咲音 on 2016/08/04.
//  Copyright © 2016年 西林咲音. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        UIView.animateWithDuration(1.3, delay: 0.0,
        options: UIViewAnimationOptions.Repeat, animations: {
            () -> Void in
            self.startButton.alpha = 0.0
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

