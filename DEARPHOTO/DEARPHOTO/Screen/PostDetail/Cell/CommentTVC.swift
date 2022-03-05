//
//  CommentTVC.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/06.
//

import UIKit
import Kingfisher

class CommentTVC: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentContent: UITextView!
    @IBOutlet weak var createAt: UILabel!
    @IBOutlet weak var createCommentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCommentContent()
        configureText()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCommentContent() {
        commentContent.setAllMarginToZero()
        commentContent.setTextViewToViewer()
    }
    
    private func configureText() {
        userName.textColor = .primary
        userName.font = UIFont.PretendardMedium(size: 13)

        commentContent.textColor = .gray2
        commentContent.font = UIFont.PretendardRegular(size: 12)
        
        createAt.textColor = .gray2
        createAt.font = UIFont.PretendardRegular(size: 10)
        
        createCommentButton.setTitle("답글 달기", for: .normal)
        createCommentButton.titleLabel?.font = UIFont.PretendardRegular(size: 10)
        createCommentButton.tintColor = .gray2
    }
    
    func configureCell(_ comments: CommentModel, _ index: Int) {
        profileImg.kf.setImage(with: URL(string: comments.profile_image!),
                               placeholder: UIImage(named: "Null_Comment"),
                               options: [
                                .scaleFactor(UIScreen.main.scale),
                                .cacheOriginalImage
                               ])
        userName.text = comments.name
        commentContent.text = comments.comment_text
        createAt.text = comments.created_at
    }
}
