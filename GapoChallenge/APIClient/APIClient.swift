import RxSwift

protocol APIClient {
    func fetchNotificationList() -> Single<[Notification]>
}

final class DefaultAPIClient: APIClient {
    func fetchNotificationList() -> Single<[Notification]> {
        return Single.create { single in
            if let notificationData = readLocalJson(forName: "noti") {
                let decoder = JSONDecoder()
                do {
                    let responseNotification = try decoder.decode(ResponseNotification.self, from: notificationData)
                    single(.success(responseNotification.data))
                } catch {
                    single(.failure(error))
                }
            } else {
                single(.failure(NSError(domain: "Unable to read json data", code: -1, userInfo: nil)))
            }
            return Disposables.create()
        }
    }
}
