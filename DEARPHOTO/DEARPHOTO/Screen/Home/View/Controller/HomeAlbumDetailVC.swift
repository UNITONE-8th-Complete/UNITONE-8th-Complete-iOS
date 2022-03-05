//
//  HomeAlbumDetailVC.swift
//  DEARPHOTO
//
//  Created by InJe Choi on 2022/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

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
    var backButton = UIBarButtonItem()
    var lineSpacing = CGFloat(16)
    var homeAlbumDetailVM = HomeAlbumDetailVM()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBarTitle()
        getAlbumDetailData()
        setNaviBarItems()
        defaultConfiguration()
        setInitialUIValue()
        bindVM()
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
        
        backButton.image = UIImage(named: "BackButton")
        navigationItem.leftBarButtonItem = backButton
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureNaviBarTitle() {
        navigationItem.title = "DEAR PHOTO"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .white)
    }
}

extension HomeAlbumDetailVC {
    func getAlbumDetailData() {
        homeAlbumDetailVM.getAlbumDetail(albumId ?? 1)
    }
}

// MARK: - Bindings
extension HomeAlbumDetailVC {
    private func bindVM() {
        homeAlbumDetailVM.getDetailAlbumSuccess
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.photoCV.reloadData()
                self.numberOfFeed.text = "\(self.homeAlbumDetailVM.detailAlbumData.count)개의 피드"
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CV Delegate
extension HomeAlbumDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let homeAlbumDetailVC = ViewControllerFactory.viewController(for: .homeAlbumDetail) as? HomeAlbumDetailVC else {
            print("HomeAlbumDetailVC Casting Error!!!")
            return
        }

        // datasource의 indexPath.item번째 원소의 albumId 전달
        // 그 id 토대로 detail data get
        navigationController?.pushViewController(homeAlbumDetailVC, animated: true)
    }
}

// MARK: - CV Datasource
extension HomeAlbumDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        homeAlbumDetailVM.detailAlbumData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = photoCV.dequeueReusableCell(withReuseIdentifier: "HomeAlbumDetailCVC", for: indexPath) as? HomeAlbumDetailCVC else {
            return UICollectionViewCell()
        }
        
        cell.cellComponentConfigure()
        
        let decodedData = homeAlbumDetailVM.detailAlbumData[indexPath.item]
        cell.imageView.kf.setImage(with: URL(string: decodedData.images?[0] ?? ""),
                                   placeholder: UIImage(named: "plus"),
                                   options: [
                                    .scaleFactor(UIScreen.main.scale),
                                    .cacheOriginalImage
                                   ])
        cell.profileImageView.image = decodedData.profileImage
        cell.nameLabel.text = decodedData.authorName
        cell.dateLabel.text = decodedData.createdAt
        cell.photoCount.text = String(decodedData.images?.count ?? 0)
        cell.titleLabel.text = decodedData.title
        cell.descriptionLabel.text = decodedData.title
        cell.likeCount.text = String(decodedData.likeCount ?? 0)
        cell.commentCount.text = String(decodedData.commentCount ?? 0)
        
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

