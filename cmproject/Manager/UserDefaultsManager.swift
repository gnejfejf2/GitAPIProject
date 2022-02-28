

final class UserDefaultsManager {
    
    static let shared: UserDefaultsManager =  UserDefaultsManager()


  
    
    @Storage(key: USER_KEY.AccessToken.rawValue, defaultValue : "")
    var accessToken: String

    @Storage(key: USER_KEY.StarredRemoveList.rawValue, defaultValue : [])
    var starredRemoveList : Repos
    
    @Storage(key: USER_KEY.StarredAddList.rawValue, defaultValue : [])
    var starredAddList : Repos
    
    //스타를 추가해줄경우 스타추가리스트에 값을 더해줘야하고
    //삭제리스트 값이 있다면 삭제를 해줘야함
    func starredAdd(repo : Repo){
        if let index = starredRemoveList.firstIndex(of: repo) {
            starredRemoveList.remove(at: index)
        }
        starredAddList.append(repo)
    }
    
    func starredDelete(repo : Repo){
        if let index = starredAddList.firstIndex(of: repo) {
            starredAddList.remove(at: index)
        }
        starredRemoveList.append(repo)
    }
    func clearRemoveList(){
        starredAddList.removeAll()
        starredRemoveList.removeAll()
    }
}
