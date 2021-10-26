//
//  PostViewController.swift
//  Instagram
//
//  Created by ESAKI MAKOTO on 2021/10/22.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {

    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    // 投稿ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
        // 画像をJPEG形式に変換する
        let imageData = image.jpegData(compressionQuality: 0.75)
        // Firestoreに保存する投稿データの保存場所を定義している
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        // Storageに保存する画像の保存場所を定義している
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        // StorageMetadataクラスのインスタンスを作成
        let metadata = StorageMetadata()
        // 画像を保存する際のファイル形式は、JPEG形式を使う
        metadata.contentType = "image/jpeg"
        // 画像をStorageにアップロードする // その間にクロージャー内の処理を行い、アップロード処理が完了したらクロージャ内の処理結果を返す
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            // errorがnilでないなら
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                // エラーの旨を表すHUDを表示する
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                // 投稿処理をキャンセルし、先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                // 処理を返す
                return
            }
            // 投稿者名をnameに格納する
            let name = Auth.auth().currentUser?.displayName
            // 投稿者名、投稿の説明文、投稿日時を定義する
            let postDic = ["name": name!,"caption": self.textField.text!,"date": FieldValue.serverTimestamp()] as [String : Any]
            // 指定した場所に投稿者名、投稿の説明文、投稿日時を保存する
            postRef.setData(postDic)
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました。")
            // 投稿処理が完了したので先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 受け取った画像をImageViewに設定する
        imageView.image = image
        // Do any additional setup after loading the view.
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
