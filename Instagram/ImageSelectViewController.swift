//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by ESAKI MAKOTO on 2021/10/22.
//

import UIKit
import CLImageEditor

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate {
    
    @IBAction func handleLibraryButton(_ sender: Any) {
        // 利用可能か確認する
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // UIImagePickerControllerインスタンスを生成する
            let pickerController = UIImagePickerController()
            // UIImagePickerControllerプロトコルを自クラスで処理する
            pickerController.delegate = self
            // 画像取得方法をライブラリ（カメラロール）に指定する
            pickerController.sourceType = .photoLibrary
            // イメージピッカーを表示する
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCameraButton(_ sender: Any) {
        // 利用可能か確認する
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // UIImagePickerControllerインスタンスを生成する
            let pickerController = UIImagePickerController()
            // UIImagePickerControllerプロトコルを自クラスで処理する
            pickerController.delegate = self
            // 画像取得方法をカメラに指定する
            pickerController.sourceType = .camera
            // イメージピッカーを表示する
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCancekButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    // 写真を撮影/選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 撮影/選択できる画像が１枚でもあるなら
        if info[.originalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[.originalImage] as! UIImage
            // 画像名を出力する
            print("DEBUG_PRINT: image = \(image)")
            // CLImageEditor（画像加工画面）と加工したい画像をeditorに格納する
            let editor = CLImageEditor(image: image)!
            // CLImageEditorDelegateプロトコルを自クラスで処理する
            editor.delegate = self
            // CLImageEditor（画像加工画面）をフルスクリーンで生成する
            editor.modalPresentationStyle = .fullScreen
            // 画像加工画面に画面遷移する
            picker.present(editor, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // UIImagePickerControllerの画面内でキャンセルボタンをタップした時に呼ばれるメソッド
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // ImageSelectViewController画面を閉じてタブ画面に戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // CLImageEditorで加工が終わったときに呼ばれるメソッド
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        // withIdentifier: "Post"に紐づくUIViewControllerを取得し、PostViewControllerで定義したプロパティやメソッドを使用する
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        // PostViewControllerのimageに加工画像を渡す
        postViewController.image = image!
        // postViewController（投稿画面）に画面遷移する
        editor.present(postViewController, animated: true, completion: nil)
    }

    // CLImageEditorの編集がキャンセルされた時に呼ばれるメソッド
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        // ImageSelectViewController画面を閉じてタブ画面に戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
