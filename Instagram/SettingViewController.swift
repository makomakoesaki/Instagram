//
//  SettingViewController.swift
//  Instagram
//
//  Created by ESAKI MAKOTO on 2021/10/22.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    
    // 表示名変更ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text {
            // 表示名が空なら
            if displayName.isEmpty {
                // エラーの旨を表すHUDを表示する
                SVProgressHUD.showError(withStatus: "表示名を入力して下さい。")
                // 処理を返す
                return
            }
            // 表示名を設定する
            let user = Auth.auth().currentUser
            // userがnilでないなら
            if let user = user {
                // ユーザーのプロフィールを更新するためのリクエスト情報をchangeRequestに格納する
                let changeRequest = user.createProfileChangeRequest()
                // そのリクエスト情報に表示名を格納する
                changeRequest.displayName = displayName
                // リクエスト情報に格納されている表示名を更新する
                changeRequest.commitChanges { error in
                    // errorがnilでないなら、「DEBUG_PRINT: " + その時に見合ったエラー文言」を出力し、処理を返す
                    if let error = error {
                        // エラーの旨を表すHUDを表示する
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    // 「DEBUG_PRINT: [displayName = 表示名]の設定に成功しました。」を出力
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                    // HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました。")
                }
            }
        }
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    // ログアウトボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLogoutButton(_ sender: Any) {
        // ログアウトする
        try! Auth.auth().signOut()
        // withIdentifier: "Login"に紐づくUIViewControllerを取得する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        // 取得したUIViewControllerにモーダル画面遷移する
        self.present(loginViewController!, animated: true, completion: nil)
        // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
        tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 現在のユーザー情報をuserに格納する
        let user = Auth.auth().currentUser
        // userがnilでないなら
        if let user = user {
            // 表示名を取得してTextFieldに設定する
            displayNameTextField.text = user.displayName
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
