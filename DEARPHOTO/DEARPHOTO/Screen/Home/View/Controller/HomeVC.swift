//
//  HomeVC.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/05.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var addAlbumButton: UIBarButtonItem!
    @IBOutlet weak var albumCV: UICollectionView!
    private var collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    var disposeBag = DisposeBag()
    let homeMainVM = HomeMainVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBarTitle()
        defaultConfiguration()
        setInitialUIValue()
        bindUI()
    }
    
}

// MARK: - Navigation Bar Settings
extension HomeVC {
    private func configureNaviBarTitle() {
        let titleViewImage = UIImage(systemName: "heart.fill")
        navigationItem.titleView = UIImageView(image: titleViewImage)
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
}

// MARK: - CV Delegate
extension HomeVC: UICollectionViewDelegate {
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
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = albumCV.dequeueReusableCell(withReuseIdentifier: "HomeMainCVC", for: indexPath) as? HomeMainCVC else {
            return UICollectionViewCell()
        }
        
        cell.cellComponentConfigure()
        cell.albumImageView.image = UIImage(systemName: "heart.fill")
        
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
