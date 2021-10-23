/*
LoginViewControllerを生成
HomeViewControllerを生成
ImageSelectViewControllerを生成
PostViewControllerを生成
SettingViewControllerを生成
Gitの準備
Pods/*
Instagram.xcworkspace
GoogleService-Info.plist
TabBarControllerを作成
TabBarControllerからHomeViewContrller、ImageSelectViewController、SettingViewControllerに接続する
ViewControllerを削除
 SettingViewControllerファイルを作成
*/*/

/*
 UITabBarControllerDelegateを宣言
 タブアイコンの色
 タブバーの背景色
 UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
 */

/*
 タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
 ImageSelectViewControllerは、タブ切り替えではなくモーダル画面遷移する
 その他のViewControllerは通常のタブ切り替えを実施
 */

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ImageSelectViewController {
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            present(imageSelectViewController, animated: true)
            return false
        } else {
            return true
        }
    }
}
