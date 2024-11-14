import Foundation
import FirebaseFirestore

class UserToken{
    static var token: String = ""
}

struct Contact: Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var lastMessage: String?
    var lastMessageTime: Date?
    var hasUnreadMessages: Bool?
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
        self.hasUnreadMessages = false
    }
}