import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var names: [String] = []
    var caption: String?
    var date: Date?
    var comments: [String] = []
    var isCommented: Bool = false
    var likes: [String] = []
    var isLiked: Bool = false

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let postDic = document.data()
        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        if let comments = postDic["comments"] as? [String] {
            self.comments = comments
        }
        if let names = postDic["names"] as? [String] {
            self.names = names
        }
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            if self.likes.firstIndex(of: myid) != nil {
                self.isLiked = true
            }
            if self.comments.firstIndex(of: myid) != nil {
                self.isCommented = true
            }
        }
    }
}
