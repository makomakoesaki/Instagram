//
//  HomeViewController.swift
//  Instagram
//
//  Created by ESAKI MAKOTO on 2021/10/22.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    // Firestoreのリスナー
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UITableViewDelegateプロトコルを自クラスで処理する
        tableView.delegate = self
        // UITableViewDataSourceプロトコルを自クラスで処理する
        tableView.dataSource = self
        // xibファイルを読み込みnibに格納する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        // 読み込んだxibファイルを使ってカスタムセルを登録する
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    // 画面が戻ってきた時に一度だけ処理する
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ユーザーがログイン状態なら
        if Auth.auth().currentUser != nil {
            // Firestoreに保存する投稿データの保存場所と投稿日時の新しい順に取得する順序を定義している
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            // 投稿データの更新を監視するlistenerを登録する
            // 投稿データが更新されている間にクロージャー内の処理を実行する
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                // エラーがnilでないなら
                if let error = error {
                    // 以下を出力する
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    // 何もしない
                    return
                }
                // 更新される投稿のデータをPostDataの要素に変換し、postArrayに格納する
                // 変換する時に更新される投稿のデータを引数にしてクロージャー内の処理を実行する
                self.postArray = querySnapshot!.documents.map { document in
                    // 以下を出力する
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    // 変換前のデータをPostDataのデータに置き換える
                    let postData = PostData(document: document)
                    // 変換されたデータを返す
                    return postData
                }
                // TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    
    //ホーム画面が閉じられる時に呼ばれるメソッド
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }
    
    // セルの数を決めるメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    // セルを構築するメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // withIdentifier: "Cell"に紐づく再利用可能なセルを取得し、PostViewControllerで定義したプロパティやメソッドを使用する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        // セルを取得してデータを設定する
        cell.setPostData(postArray[indexPath.row])
        // セル内にあるいいねのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        // セル何にあるコメントのアクションをソースコードで設定する
        cell.commentButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        // セルを返す
        return cell
    }
    
    // セル内のいいねがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        // タッチ情報を取り出してtouchに格納する
        let touch = event.allTouches?.first
        // タッチ情報から座標を割り出し、pointに格納する
        let point = touch!.location(in: self.tableView)
        if point == CGPoint(x: 30, y: 424) {
            print("DEBUG_PRINT: likeボタンがタップされました。")
        } else if point == CGPoint(x: 0, y: 0) {
            
        }
        // タッチした座標からtableView内のどのインデックス位置になるのか割り当て、indexPathに格納する
        let indexPath = tableView.indexPathForRow(at: point)
        // indexPathからタップされたインデックスのデータを取り出しpostDataに格納する
        let postData = postArray[indexPath!.row]
        // ユーザーがログインしているならIDをmyidに格納する
        if let myid = Auth.auth().currentUser?.uid {
            // FieldValue型のupdateValueを生成
            var updateValue: FieldValue
            // 自分がいいねを押しているなら
            if postData.isLiked {
                // いいね解除のためpostDataの中のlikesフィールドを更新するためのデータを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たにいいねを押した場合は、postDataの中のlikesフィールドにmyidを追加するためのデータを作成する
                updateValue = FieldValue.arrayUnion([myid])
            }
            // Firestoreに保存する投稿データの保存場所を定義している
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            // 保存場所に更新データを書き込む
            postRef.updateData(["likes": updateValue])
        }
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
