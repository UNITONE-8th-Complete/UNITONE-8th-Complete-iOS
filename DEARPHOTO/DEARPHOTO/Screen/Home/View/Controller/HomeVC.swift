//
//  HomeVC.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/05.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SwiftUI

class HomeVC: UIViewController {
   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var addAlbumButton: UIBarButtonItem!
    @IBOutlet weak var albumCV: UICollectionView!
    @IBOutlet weak var albumCount: UILabel!
    private var collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    var disposeBag = DisposeBag()
    let homeMainVM = HomeMainVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callGetAlbumDataAPI()
        configureNaviBarTitle()
        defaultConfiguration()
        setInitialUIValue()
        bindUI()
        bindVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .black)
    }
    
}

// MARK: - Navigation Bar Settings
extension HomeVC {
    private func configureNaviBarTitle() {
        navigationItem.title = "DEAR PHOTO"
        navigationController?.setNaviItemTintColor(navigationController: self.navigationController, color: .black)
    }
}

// MARK: - Default Settings
extension HomeVC {
    private func defaultConfiguration() {
        albumCV.collectionViewLayout = collectionViewFlowLayout
        albumCV.delegate = self
        albumCV.dataSource = self
        albumCV.register(UINib(nibName: Identifiers.homeMainCVC,
                               bundle: nil),
                         forCellWithReuseIdentifier: "HomeMainCVC")
    }
    
    private func setInitialUIValue() {
        albumCV.showsVerticalScrollIndicator = false
        albumCV.showsHorizontalScrollIndicator = false
        searchTextField.addRightPadding()
    }
    
    func callGetAlbumDataAPI() {
        homeMainVM.getAlbumDate()
    }
}

// MARK: - Bindings
extension HomeVC {
    private func bindUI() {
        searchButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.searchTextField.resignFirstResponder()
                self.homeMainVM.showSearchedAlbums()
            })
            .disposed(by: disposeBag)
        
        searchTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.resignFirstResponder()
                owner.homeMainVM.showSearchedAlbums()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindVM() {
        homeMainVM.getDataSuccess
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.albumCV.reloadData()
                self.albumCount.text = "총 \(self.homeMainVM.albumData.count)개의 앨범"
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CV Delegate
extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let homeAlbumDetailVC = ViewControllerFactory.viewController(for: .homeAlbumDetail) as? HomeAlbumDetailVC else {
            print("HomeAlbumDetailVC Casting Error!!!")
            return
        }
        
        let id = homeMainVM.albumData[indexPath.item].id
        homeAlbumDetailVC.albumId = id
        
        navigationController?.pushViewController(homeAlbumDetailVC, animated: true)
    }
}

// MARK: - CV Datasource
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return homeMainVM.albumData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = albumCV.dequeueReusableCell(withReuseIdentifier: "HomeMainCVC", for: indexPath) as? HomeMainCVC else {
            return UICollectionViewCell()
        }
        
        cell.cellComponentConfigure()
        let decodedData = homeMainVM.albumData[indexPath.item]
        
        cell.albumTitle.text = decodedData.title
        cell.albumCreatedDate.text = decodedData.createdAt?.replacingOccurrences(of: "-", with: ".")
        cell.albumImageView.image = decodedData.albumImage
        cell.albumImageView.kf.setImage(with: URL(string: decodedData.image ?? ""),
                                        placeholder: UIImage(named: "plus"),
                                        options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .cacheOriginalImage
                                        ])
        cell.numberOfImages.text = "총 \(decodedData.postCount ?? 0)개의 사진"
        
        return cell
    }
}

// MARK: - CV Delegate Flow Layout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: albumCV.frame.width, height: albumCV.frame.width / 1.82)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
}
