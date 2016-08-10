//
//  RankingViewController.swift
//  Noutore
//
//  Created by 西林咲音 on 2016/08/06.
//  Copyright © 2016年 西林咲音. All rights reserved.
//

import UIKit
import Firebase

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var scores: [Score] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = FIRDatabase.database().reference()
        //TODO: ここでスコア順にソート
        //https://firebase.google.com/docs/database/ios/retrieve-data ここ参照
        
        ref.queryOrderedByChild("point").queryLimitedToLast(50).observeEventType(.ChildAdded, withBlock: { snapshot in
            if let point = snapshot.value!.objectForKey("point") as? Int,
                username = snapshot.value!.objectForKey("username") as? String,
                time = snapshot.value!.objectForKey("time") as? String {
                //Scoreのインスタンス生成
                let score = Score(point: point, username: username, time: time)
                self.scores.insert(score, atIndex: 0)
                self.tableView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルを取得
        let cell = tableView.dequeueReusableCellWithIdentifier("RankingCell",forIndexPath: indexPath) as! RankingTableViewCell
        // セルに値を設定
        cell.rankLabel.text = String(indexPath.row+1)
        cell.userLabel.text = scores[indexPath.row].username
        cell.pointLabel.text = String(scores[indexPath.row].point)
        return cell
    }
    
}

