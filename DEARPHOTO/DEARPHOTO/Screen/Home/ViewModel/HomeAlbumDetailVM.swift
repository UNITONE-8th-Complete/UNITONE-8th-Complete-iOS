//
//  HomeAlbumDetailVM.swift
//  DEARPHOTO
//
//  Created by InJe Choi on 2022/03/06.
//

import RxCocoa
import RxSwift

class HomeAlbumDetailVM {
    
    var disposeBag = DisposeBag()
    let apiSession = APISession()
    var detailAlbumData = [HomeAlbumDetailModel]()
    var getDetailAlbumSuccess = PublishSubject<Void>()
    
}

extension HomeAlbumDetailVM {
    func getAlbumDetail(_ id: Int) {
        print("HERE!!!!!!!!!! \(id)")
        let baseURL = "http://13.124.131.113:8000/albums/\(id)/post"
        let url = URL(string: baseURL)!
        let resource = urlResource<[HomeAlbumDetailModel]>(url: url)
        
        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    
                case .success(let response):
                    owner.detailAlbumData = response
                    owner.getDetailAlbumSuccess.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
}
