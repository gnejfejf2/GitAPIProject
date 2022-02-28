import Foundation

struct Repo: Codable , Equatable {
    static func == (lhs: Repo, rhs: Repo) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let owner: Owner
    let htmlURL: String
    let welcomeDescription: String?
    let fork: Bool
    let updatedAt: String
    var stargazersCount : Int
    let watchersCount: Int
    let language: String?
    let license: License?
    let topics: [String]
    let visibility: String
    let forks, openIssues, watchers: Int

    enum CodingKeys: String, CodingKey {
        case id, name, owner
        case htmlURL = "html_url"
        case welcomeDescription = "description"
        case fork
        case updatedAt = "updated_at"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language, license, topics, visibility, forks
        case openIssues = "open_issues"
        case watchers
    }

    
}

// MARK: - License
struct License: Codable {
    let key, name, spdxID: String
    let url: String?

    enum CodingKeys: String, CodingKey {
        case key, name
        case spdxID = "spdx_id"
        case url
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}

