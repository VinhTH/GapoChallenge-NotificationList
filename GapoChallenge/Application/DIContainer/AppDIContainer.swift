import UIKit

final class AppDIContainer {
    private lazy var apiClient: APIClient = DefaultAPIClient()
}

// MARK: - Notification List
extension AppDIContainer {
    func makeNotificationListViewController() -> UIViewController {
        NotificationListViewController.create(viewModel: makeNotificationListViewModel())
    }
    
    private func makeNotificationListViewModel() -> NotificationListViewModel {
        DefaultNotificationListViewModel(apiClient: apiClient)
    }
}
