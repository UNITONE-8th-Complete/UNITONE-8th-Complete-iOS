//
//  APIService.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/06.
//

import Alamofire
import RxSwift

protocol APIService {
    func postRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters) -> Observable<Result<T, APIError>>
    
    func getRequest<T: Decodable>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>>
}

