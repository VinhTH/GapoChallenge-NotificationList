import Foundation

struct ResponseNotification: Decodable {
    let data: [Notification]
}

struct Notification: Decodable {
    let id: String
    let message: Message
    let image: String
    let icon: String
    let createdAt: TimeInterval
    let status: String
}

extension Notification {
    struct Message: Decodable {
        let text: String
        let highlights: [Highlight]
    }
    
    struct Highlight: Decodable {
        let offset: Int
        let length: Int
        
        func asRange() -> NSRange {
            NSRange(location: offset, length: length)
        }
    }
}
