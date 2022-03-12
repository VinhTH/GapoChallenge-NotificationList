import RxSwift
import RxCocoa

protocol NotificationListViewModelInput {
    func fetchNotificationList()
    func search(withKey key: String)
    func closeSearch()
}

protocol NotificationListViewModelOutput {
    var error: PublishRelay<Error> { get }
    var items: BehaviorRelay<[NotificationViewModel]> { get }
}

protocol NotificationListViewModel: NotificationListViewModelInput, NotificationListViewModelOutput { }

final class DefaultNotificationListViewModel: NotificationListViewModel {
    // MARK: - Output
    let error = PublishRelay<Error>()
    let items = BehaviorRelay<[NotificationViewModel]>(value: [])
    var fullItems = [NotificationViewModel]()
    
    // MARK: - Variables
    var fetchNotificationListDisposable: Disposable? {
        willSet {
            fetchNotificationListDisposable?.dispose()
        }
    }
    
    private let apiClient: APIClient
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    deinit {
        fetchNotificationListDisposable = nil
    }

}

// MARK: - Input
extension DefaultNotificationListViewModel {
    func fetchNotificationList() {
        fetchNotificationListDisposable = apiClient
            .fetchNotificationList()
            .subscribe { [weak self] event in
                switch event {
                case .success(let notifications):
                    let items = notifications.map { DefaultNotificationViewModel(fromNotification: $0) }
                    self?.fullItems = items
                    self?.items.accept(items)
                case .failure(let error):
                    self?.error.accept(error)
                }
            }
    }
    
    func search(withKey key: String) {
        if key.isEmpty {
            items.accept(fullItems)
        } else {
            let seachedItems = fullItems.filter {
                $0.message.lowercased().contains(key.lowercased())
            }
            items.accept(seachedItems)
        }
    }
    
    func closeSearch() {
        items.accept(fullItems)
    }
}
