//
//  LoginViewController.swift
//  Instagram
//
//  Created by ESAKI MAKOTO on 2021/10/22.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    // ログインボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLoginButton(_ sender: Any) {
        // アドレスとパスワードがnilでないなら
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                return
            }
            // HUDで処理中を表示
            SVProgressHUD.show()
            // 入力されたアドレスとパスワードを使ってFirebase(サーバー)にアカウント照合を依頼
            // アカウント照合処理の結果を受け取ったタイミングでクロージャーを呼び出す
            Auth.auth().signIn(withEmail: address, password: password) { _, error in
                // errorがnilでないなら、「DEBUG_PRINT: " + その時に見合ったエラー文言」を出力し、処理を返す
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    // エラーの旨を表すHUDを表示する
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                }
                // 照合に成功した時、「DEBUG_PRINT: ログインに成功しました。」を出力
                print("DEBUG_PRINT: ログインに成功しました。")
                // HUDを消す
                SVProgressHUD.dismiss()
                // 画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // アカウント作成ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        // アドレス、パスワード、表示名がnilでないなら
        if let adress = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            // アドレス、パスワード、表示名のうち一つでも空文字が含まれていたら「DEBUG_PRINT: 何かが空文字です」を出力し、処理を返す
            if adress.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です")
                // エラーの旨を表すHUDを表示する
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい。")
                return
            }
            // HUDで処理中を表示
            SVProgressHUD.show()
            // 入力されたアドレスとパスワードを使ってFirebase(サーバー)にアカウント作成処理を依頼
            // アカウント作成処理の結果を受け取ったタイミングでクロージャーを呼び出す
            Auth.auth().createUser(withEmail: adress, password: password) { _ , error in
                // errorがnilでないなら「DEBUG_PRINT: " + その時に見合ったエラー文言」を出力し、処理を返す
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    // エラーの旨を表すHUDを表示する
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ユーザ作成に成功しました。")
                // 現在のユーザー情報をuserに格納する
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
                            print("EDEBUG_PRINT: " + error.localizedDescription)
                            return
                        }
                        // 更新に成功した時、以下を出力
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        // HUDを消す
                        SVProgressHUD.dismiss()
                        // 画面を閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
