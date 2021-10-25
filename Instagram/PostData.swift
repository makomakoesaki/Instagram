import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false

    init(document: QueryDocumentSnapshot) {
        // 投稿ID（保存する際に作られたユニークなID）をidに格納する
        self.id = document.documentID
        // Firestoreから取得したデータをpostDicに格納する
        let postDic = document.data()
        // 投稿者名をnameに格納する
        self.name = postDic["name"] as? String
        // 投稿の説明文をcaptionに格納する
        self.caption = postDic["caption"] as? String
        // 投稿日時をtimestampに格納する
        let timestamp = postDic["date"] as? Timestamp
        // Timestamp型の投稿日時をDate型に変換(取得)
        self.date = timestamp?.dateValue()
        // いいねされていたらいいねした人のIDをlikesに格納する
        if let likes = postDic["likes"] as? [String] {
            // 自クラスのlikesにいいねした人のIDを格納する
            self.likes = likes
        }
        // ログイン中のユーザのidがnilでないなら
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば、いいねを押していると認識する。
                self.isLiked = true
            }
        }
    }
}
