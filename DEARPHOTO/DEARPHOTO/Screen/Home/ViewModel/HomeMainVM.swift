//
//  HomeMainVM.swift
//  DEARPHOTO
//
//  Created by InJe Choi on 2022/03/05.
//

import RxCocoa
import RxSwift

class HomeMainVM {
    
    var disposeBag = DisposeBag()
    let apiSession = APISession()
    var albumData = [HomeMainModel]()
    var getDataSuccess = PublishSubject<Void>()
    
}

// MARK: - Networking
extension HomeMainVM {
    func showSearchedAlbums() {
        
    }
    
    func getAlbumDate() {
        let baseURL = "http://13.124.131.113:8000/albums"
        let url = URL(string: baseURL)!
        let resource = urlResource<[HomeMainModel]>(url: url)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    print("ERROR!!!! \(error.localizedDescription)")
                    
                case .success(let response):
                    owner.albumData = response
                    owner.getDataSuccess.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
}
