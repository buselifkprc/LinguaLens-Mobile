import Foundation

struct UserProfile: Codable {
    let id: Int
    let email: String
    let name: String
    let surname: String
    let profile_image: String
}
