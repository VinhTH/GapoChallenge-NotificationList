import Foundation

protocol NotificationViewModelOutput: AnyObject {
    var id: String { get }
    var message: String { get }
    var highlights: [NSRange] { get }
    var image: String { get }
    var icon: String { get }
    var time: String { get }
    var read: Bool { get set }
}

protocol NotificationViewModel: NotificationViewModelOutput { }

final class DefaultNotificationViewModel: NotificationViewModel {
    // MARK: - Output
    let id: String
    let message: String
    var highlights: [NSRange]
    let image: String
    let icon: String
    let time: String
    var read: Bool
    
    init(fromNotification notification: Notification) {
        self.id = notification.id
        self.message = notification.message.text
        self.highlights = notification.message.highlights.map { $0.asRange() }
        self.image = notification.image
        self.icon = notification.icon
        self.time = notification.createdAt.formatTimestampToDDMMYYHHMM()
        self.read = notification.status == "read"
    }
}
