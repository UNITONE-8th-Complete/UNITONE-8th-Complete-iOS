//
//  HomeAlbumDetailCVC.swift
//  DEARPHOTO
//
//  Created by InJe Choi on 2022/03/06.
//

import UIKit

class HomeAlbumDetailCVC: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension HomeAlbumDetailCVC {
    func cellComponentConfigure() {
        imageView.layer.cornerRadius = 8
//        imageView.backgroundColor = .orange
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        nameLabel.font = UIFont.boldSystemFont(ofSize: 10)
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        photoCount.font = UIFont.systemFont(ofSize: 12)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        descriptionLabel.font = UIFont.systemFont(ofSize: 10)
    }
}
