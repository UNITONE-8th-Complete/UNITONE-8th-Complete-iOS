//
//  OverlayImageCVCCollectionViewCell.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/06.
//

import UIKit

class OverlayImageCVC: UICollectionViewCell {
    @IBOutlet weak var overlayImage: UIImageView!
    var isReSelect = false
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                layer.borderColor = UIColor.retro_yellow.cgColor
            }
            else {
                layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
}
