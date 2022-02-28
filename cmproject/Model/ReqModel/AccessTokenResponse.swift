
import Foundation

struct AccessTokenResponse : Codable {
    var access_token : String
    var scope : String
    var token_type : String
}
