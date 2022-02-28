import Moya

import Alamofire
import RxSwift

typealias ApiParameter = [String : Any]

protocol NetworkingService {
    //디코더
    var jsonDecoder : JSONDecoder { get }
    //네트워크 프로바이더
    var provider : MoyaProvider<NetworkAPI> { get }
    //데이터요청
    func request<T: Decodable>(type : T.Type , _ api: NetworkAPI) -> Single<T>
    //리프레시 토큰 (사용은 안함)
    func requestSimple(_ api: NetworkAPI) -> Single<Response> 

//    func renewalToken() -> Single<Response>
    
}

final class NetworkingAPI: NetworkingService {
    static let shared : NetworkingAPI = NetworkingAPI()
    
    
    let jsonDecoder: JSONDecoder = JSONDecoder()
    
    let provider: MoyaProvider<NetworkAPI>
    
    //provider 객체 삽입
    init(provider: MoyaProvider<NetworkAPI> = MoyaProvider<NetworkAPI>(plugins: [MoyaCacheablePlugin()])) {
        self.provider = provider
    }
   
  
    //데이터통신코드
    func request<T: Decodable>(type : T.Type , _ api: NetworkAPI) -> Single<T> {
        return provider.rx
            .request(api)
        
            .filterSuccessfulStatusCodes()
            .map( T.self )
           
    }
    
    //데이터통신코드
    func requestSimple(_ api: NetworkAPI) -> Single<Response> {
        return provider.rx
            .request(api)
            .filterSuccessfulStatusCodes()
            
    }
    

}


