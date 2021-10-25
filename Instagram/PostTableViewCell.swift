//
//  PostTableVireCellTableViewCell.swift
//  Instagram
//
//  Created by ESAKI MAKOTO on 2021/10/24.
//

import UIKit
import FirebaseStorageUI

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    // xibファイルに貼り付けたUI部品が読み込まれた時に呼び出されるメソッド
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // このセルが選択された時に呼び出されるメソッド
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // PostDataの内容をセルに表示するメソッド
    func setPostData(_ postData: PostData) {
        // Cloud Storageから画像をダウンロードしている間、ダウンロード中であることを示すインジケーターをグレーのくるくる回るアイコンに指定する
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        // Storageに保存する画像の保存場所を定義している
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        //　指定場所から自動的に画像をダウンロードしてUIImageViewに表示する
        postImageView.sd_setImage(with: imageRef)
        // 投稿者名と投稿説明文をcaptionLabelのテキストに格納する
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        // dateLabelのテキストに空文字を格納する
        self.dateLabel.text = ""
        // 投稿日時がnilでないならdateに格納する
        if let date = postData.date {
            // DateFormatterインスタンスを生成する
            let formatter = DateFormatter()
            // 投稿日時のフォーマットを指定する
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            // dataに入っているData型の値を投稿日時のフォーマットに従ってString型に変換する
            let dateString = formatter.string(from: date)
            // String型に変換した、投稿日時をdateLabelのテキストに格納する
            self.dateLabel.text = dateString
        }
        // カウントしたいいねの数をlikeNumberに格納する
        let likeNumber = postData.likes.count
        // カウントしたいいねの数をlikeLabelのテキストに格納する
        likeLabel.text = "\(likeNumber)"
        // 自分がいいねを押しているなら
        if postData.isLiked {
            // 画像名"like_exist"をbuttonImageに格納する
            let buttonImage = UIImage(named: "like_exist")
            // likeButtonに画像名"like_exist"をセットする
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            // 自分がいいねを押していないなら
            // 画像名"like_none"をbuttonImageに格納する
            let buttonImage = UIImage(named: "like_none")
            // likeButtonに画像名"like_none"をセットする
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
}
