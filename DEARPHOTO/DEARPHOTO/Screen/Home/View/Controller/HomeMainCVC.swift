//
//  HomeAlbumCVC.swift
//  DEARPHOTO
//
//  Created by InJe Choi on 2022/03/05.
//

import UIKit

class HomeMainCVC: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumCreatedDate: UILabel!
    @IBOutlet weak var numberOfImages: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Change UI
extension HomeMainCVC {
    func cellComponentConfigure() {
        albumImageView.layer.cornerRadius = 8
        albumImageView.backgroundColor = .orange
    }
}
