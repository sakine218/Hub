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
    
    //STEP.1 変数を定義
    var memoryDate: Date!
    
    var idString: String!
    
    let defaults = UserDefaults.standard

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = FIRDatabase.database().reference()
        //TODO: ここでスコア順にソート
        //https://firebase.google.com/docs/database/ios/retrieve-data ここ参照
        
        ref.queryOrdered(byChild: "point").queryLimited(toLast: 50).observe(.childAdded, with: { snapshot in
            if let point = (snapshot.value! as AnyObject).object(forKey: "point") as? Int,
                let username = (snapshot.value! as AnyObject).object(forKey: "username") as? String,
                let time = (snapshot.value! as AnyObject).object(forKey: "time") as? String,
                let uuid = (snapshot.value! as AnyObject).object(forKey: "uuid") as? String {
                //Scoreのインスタンス生成
                let score = Score(point: point, username: username, time: time, uuid: uuid)
                self.scores.insert(score, at: 0)
                self.tableView.reloadData()
            }
        })
        
        idString = defaults.string(forKey: "id")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell",for: indexPath) as! RankingTableViewCell
        // セルに値を設定
        var indexNumber = indexPath.row
        if indexNumber == 0{
            cell.rankLabel.text = String(indexPath.row+1)
        }else if scores[indexPath.row].point == scores[indexPath.row-1].point{
            while indexNumber > 0 && scores[indexNumber].point == scores[indexPath.row].point{
                indexNumber -= 1
            }
            cell.rankLabel.text = String(indexNumber+2)
        }else{
            cell.rankLabel.text = String(indexNumber+1)
        }
        cell.userLabel.text = scores[indexPath.row].username
        cell.pointLabel.text = String(scores[indexPath.row].point)
        
        print("\(indexPath.row)列")
        
        if idString == scores[indexPath.row].uuid {
            cell.rankLabel.textColor = UIColor.red
            cell.userLabel.textColor = UIColor.red
            cell.pointLabel.textColor = UIColor.red
        }
        return cell
    }
    
}

