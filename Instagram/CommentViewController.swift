//
//  CommentViewController.swift
//  Instagram
//
//  Created by ESAKI MAKOTO on 2021/10/26.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {

    var postData: PostData!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBAction func handleCommentButton(_ sender: Any) {
        if let comment = commentTextView.text {
            if comment.isEmpty {
                SVProgressHUD.showError(withStatus: "コメントを入力して下さい。")
                return
            }
            if let commenter = Auth.auth().currentUser?.displayName {
                let string = commenter + " : " + comment
                let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
                let updateValue: FieldValue
                updateValue = FieldValue.arrayUnion([string])
                postRef.updateData(["comment": updateValue])
            } else {
                SVProgressHUD.showError(withStatus: "表示名を登録して下さい。")
            }
            SVProgressHUD.showSuccess(withStatus: "コメントしました。")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.layer.borderWidth = 1.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
