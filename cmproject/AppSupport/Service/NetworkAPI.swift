import Alamofire
import Moya


enum NetworkAPI{
    case search(keyword : String  , itemCount : Int , pagingCount : Int)
  
    case loginAccesstoken(code: String)

    case getUserInfo
    
    case getUserStarredRepos(itemCount : Int , pagingCount : Int)
    
    case starredChecked(repoLogin : String , repoName : String)
    
    case starredDelete(repoLogin : String , repoName : String)
  
    case starredAdd(repoLogin : String , repoName : String)
}


extension NetworkAPI : TargetType {
    //BaseURL
    var baseURL: URL {
        switch self {
        case .loginAccesstoken :
            return URL(string: "https://github.com/")!
        default :
            return URL(string: "https://api.github.com/")!
        }
    }
    
    
    var headers: [String: String]? {
        let token = UserDefaultsManager.shared.accessToken
       
        if token == ""{
            return [
                "accept": "application/json"
            ]
        } else {
            return [
                "accept": "application/json",
                "Authorization" : "token " + token
            ]
        }
    }
    
    //경로
    var path: String {
        switch self {
        case .search :
            return "search/repositories"
        case .loginAccesstoken :
            return "login/oauth/access_token"
        case .getUserInfo :
            return "user"
        case .getUserStarredRepos  :
            return "user/starred"
        case .starredChecked(let repoLogin , let repoName) :
            return "user/starred/\(repoLogin)/\(repoName)"
        case .starredDelete(let repoLogin , let repoName) :
            return "user/starred/\(repoLogin)/\(repoName)"
        case .starredAdd(let repoLogin , let repoName) :
            return "user/starred/\(repoLogin)/\(repoName)"
        }
    }
    //통신을 get , post , put 등 무엇으로 할지 이곳에서 결정한다 값이 없다면 디폴트로 Get을 요청
    var method : Moya.Method {
        switch self {
        case .loginAccesstoken :
            return .post
        case .starredDelete :
            return .delete
        case .starredAdd :
            return .put
        default :
            return .get
        }
    }
   
    var task: Task {
        switch self {
        case .search(let keyword , let itemCount , let pagingCount) :
            var parameter = PageRequest(perPage: itemCount, page: pagingCount).toDictionary
            parameter.updateValue(keyword, forKey: "q")
            return .requestParameters(parameters: parameter , encoding: URLEncoding.queryString)
        case .loginAccesstoken(let code) :
            return .requestJSONEncodable(AccessTokenRequest(code: code))
        case .getUserStarredRepos(let itemCount , let pagingCount) :
            return .requestParameters(parameters: PageRequest(perPage: itemCount, page: pagingCount).toDictionary , encoding: URLEncoding.queryString)
        default :
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getUserInfo :
            return stubbedResponse("UserInfo")
        default :
            return stubbedResponse("")
        }
    }
    
    func stubbedResponse(_ filename: String) -> Data! {
        let bundlePath = Bundle.main.path(forResource: "Json", ofType: "bundle")
        let bundle = Bundle(path: bundlePath!)
        let path = bundle?.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
    
   
    
}



extension NetworkAPI : MoyaCacheable {
  var cachePolicy: MoyaCacheablePolicy {
    switch self {
    case .getUserStarredRepos :
      return .reloadIgnoringLocalCacheData
    default:
      return .useProtocolCachePolicy
    }
  }
}
