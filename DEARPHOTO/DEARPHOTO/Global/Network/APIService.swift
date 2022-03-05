import Alamofire
import RxSwift

protocol APIService {
    func postRequest<T: Decodable>(with urlResource: urlResource<T>, param: Parameters) -> Observable<Result<T, APIError>>
    
    func getRequest<T: Decodable>(with urlResource: urlResource<T>) -> Observable<Result<T, APIError>>
}
