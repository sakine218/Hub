import UIKit

class Score {
    let point: Int
    let username: String
    let time: String
    let uuid: String
    
    init(point: Int, username: String, time: String, uuid: String) {
        self.point = point
        self.username = username
        self.time = time
        self.uuid =  uuid
    }
}