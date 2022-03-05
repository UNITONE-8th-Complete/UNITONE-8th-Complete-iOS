//
//  HomeAlbumDetailVC.swift
//  DEARPHOTO
//
//  Created by InJe Choi on 2022/03/06.
//

import UIKit

class HomeAlbumDetailVC: UIViewController {
    
    @IBOutlet weak var topCoverImageView: UIImageView!
    @IBOutlet weak var numberOfFeed: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var gridButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var photoCV: UICollectionView!
    private var collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    var albumId: Int?
    var albumTitle: String?
    var addButton = UIBarButtonItem()
    var shareButton = UIBarButtonItem()
    var lineSpacing = CGFloat(16)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviBarItems()
        defaultConfiguration()
        setInitialUIValue()
    }
}

// MARK: - Default Settings
extension HomeAlbumDetailVC {
    private func defaultConfiguration() {
        photoCV.collectionViewLayout = collectionViewFlowLayout
        photoCV.delegate = self
        photoCV.dataSource = self
        photoCV.register(UINib(nibName: Identifiers.homeAlbumDetailCVC,
                               bundle: nil),
                         forCellWithReuseIdentifier: "HomeAlbumDetailCVC")
    }
    
    private func setInitialUIValue() {
        topCoverImageView.layer.cornerRadius = 32
        topCoverImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        orderLabel.font = UIFont.systemFont(ofSize: 13)
        orderLabel.text = "최신순"
    }
}

// MARK: - Navigation Bar Settings
extension HomeAlbumDetailVC {
    private func setNaviBarItems() {
        addButton.image = UIImage(named: "NavigationAdd")
        shareButton.image = UIImage(named: "NavigationShare")
        navigationItem.rightBarButtonItems = [addButton, shareButton]
    }
}

// MARK: - CV Delegate
extension HomeAlbumDetailVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView,
//                        didSelectItemAt indexPath: IndexPath) {
//        guard let homeAlbumDetailVC = ViewControllerFactory.viewController(for: .homeAlbumDetail) as? HomeAlbumDetailVC else {
//            print("HomeAlbumDetailVC Casting Error!!!")
//            return
//        }
//
//        // datasource의 indexPath.item번째 원소의 albumId 전달
//        // 그 id 토대로 detail data get
//        navigationController?.pushViewController(homeAlbumDetailVC, animated: true)
//    }
}

// MARK: - CV Datasource
extension HomeAlbumDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = photoCV.dequeueReusableCell(withReuseIdentifier: "HomeAlbumDetailCVC", for: indexPath) as? HomeAlbumDetailCVC else {
            return UICollectionViewCell()
        }
        
        cell.cellComponentConfigure()
        cell.imageView.image = UIImage(systemName: "heart.fill")
        cell.profileImageView.image = UIImage(named: "ProfileTemp")
        
        return cell
    }
}

// MARK: - CV Delegate Flow Layout
extension HomeAlbumDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (photoCV.frame.width - lineSpacing) / 2,
               height: ((photoCV.frame.width - lineSpacing) / 2) * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        lineSpacing
    }
}

