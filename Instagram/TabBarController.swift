//
//  TabBarController.swift
//  Instagram
//
//  Created by ESAKI MAKOTO on 2021/10/22.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // タブバーのアイコンの色を設定
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色を設定
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスに処理する
        self.delegate = self
    }
    
    // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // タップしたアイコンがImageSelectViewControllerなら
        if viewController is ImageSelectViewController {
            // withIdentifier: "ImageSelect"に紐づくUIViewControllerを取得する
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            // 取得したUIViewControllerにモーダル画面遷移する
            self.present(imageSelectViewController, animated: true, completion: nil)
            // 通常のタブ切り替えを実施しない
            return false
        } else {
            // その他のViewControllerは通常のタブ切り替えを実施
            return true
        }
    }
    
    // 画面が呼ばれたタイミングで一度だけ処理するメソッド
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 現在のユーザーがnilなら
        if Auth.auth().currentUser == nil {
            // withIdentifier: "Login"に紐づくUIViewControllerを取得する
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            // 取得したUIViewControllerにモーダル画面遷移する
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
}
