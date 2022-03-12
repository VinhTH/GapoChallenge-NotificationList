import XCTest
import RxSwift
@testable import GapoChallenge

class NotificationListViewModelTests: XCTestCase {
    func test_whenFetchNotificationListFailed_shouldReturnProperError() {
        let disposeBag = DisposeBag()
        let expectedError = NSError(domain: "Testing fetch notification failed", code: -1, userInfo: nil)
        let expectation = self.expectation(description: #function)
        let mockApiClient = MockAPIClient()
        mockApiClient.error = expectedError
        
        let sut = DefaultNotificationListViewModel(apiClient: mockApiClient)
        sut
            .error
            .subscribe { event in
                guard let error = event.element,
                      (error as NSError) == expectedError else {
                    return
                }
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        
        sut.fetchNotificationList()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenFetchNotificationListSuccessed_shouldReturnProperItems() {
        let disposeBag = DisposeBag()
        let expectation = self.expectation(description: #function)
        let mockApiClient = MockAPIClient()
        mockApiClient.notifications = [mockNotfi]
        
        let sut = DefaultNotificationListViewModel(apiClient: mockApiClient)
        sut
            .items
            .subscribe { event in
                guard let notifications = event.element,
                      notifications.count == 1,
                      notifications[0].id == mockNotfi.id else {
                    return
                }
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        
        sut.fetchNotificationList()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenSearchWithKey_shoudlReturnItemsHaveMessageContainTheKey() {
        let disposeBag = DisposeBag()
        let expectation = self.expectation(description: #function)
        let mockApiClient = MockAPIClient()
        mockApiClient.notifications = [mockNotfi, searchNotfi]
        
        var isSearched = false
        let sut = DefaultNotificationListViewModel(apiClient: mockApiClient)
        sut
            .items
            .subscribe { event in
                guard let notifications = event.element, !notifications.isEmpty else { return }
                if isSearched {
                    guard notifications.count == 1,
                          notifications[0].message == searchNotfi.message.text else {
                        return
                    }
                    expectation.fulfill()
                } else {
                    isSearched = true
                    sut.search(withKey: "search")
                }
            }
            .disposed(by: disposeBag)
        
        sut.fetchNotificationList()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenSearchWithEmptyKey_shoudlReturnWholeItems() {
        let disposeBag = DisposeBag()
        let expectation = self.expectation(description: #function)
        let mockNotifications = [mockNotfi, searchNotfi]
        let mockApiClient = MockAPIClient()
        mockApiClient.notifications = mockNotifications
        
        var isSearched = false
        var isSearchedEmptyKey = false
        let sut = DefaultNotificationListViewModel(apiClient: mockApiClient)
        sut
            .items
            .subscribe { event in
                guard let notifications = event.element, !notifications.isEmpty else { return }
                if isSearched {
                    if isSearchedEmptyKey {
                        guard notifications.count == mockNotifications.count else {
                            return
                        }
                        expectation.fulfill()
                    } else {
                        isSearchedEmptyKey = true
                        sut.search(withKey: "")
                    }
                } else {
                    isSearched = true
                    sut.search(withKey: "search")
                }
            }
            .disposed(by: disposeBag)
        
        sut.fetchNotificationList()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenCloseSearch_shoudlReturnWholeItems() {
        let disposeBag = DisposeBag()
        let expectation = self.expectation(description: #function)
        let mockNotifications = [mockNotfi, searchNotfi]
        let mockApiClient = MockAPIClient()
        mockApiClient.notifications = mockNotifications
        
        var isSearched = false
        var isClosedSearch = false
        let sut = DefaultNotificationListViewModel(apiClient: mockApiClient)
        sut
            .items
            .subscribe { event in
                guard let notifications = event.element, !notifications.isEmpty else { return }
                if isSearched {
                    if isClosedSearch {
                        guard notifications.count == mockNotifications.count else {
                            return
                        }
                        expectation.fulfill()
                    } else {
                        isClosedSearch = true
                        sut.closeSearch()
                    }
                } else {
                    isSearched = true
                    sut.search(withKey: "search")
                }
            }
            .disposed(by: disposeBag)
        
        sut.fetchNotificationList()
        
        wait(for: [expectation], timeout: 1.0)
    }
}

fileprivate let mockNotfi = GapoChallenge.Notification (
    id: "mock_noti",
    message: .init(text: "mock_message", highlights: []),
    image: "",
    icon: "",
    createdAt: 0,
    status: ""
)

fileprivate let searchNotfi = GapoChallenge.Notification(
    id: "search_noti",
    message: .init(text: "search_message", highlights: []),
    image: "",
    icon: "",
    createdAt: 0,
    status: ""
)

final class MockAPIClient: APIClient {
    var notifications = [GapoChallenge.Notification]()
    var error: Error?
    
    func fetchNotificationList() -> Single<[GapoChallenge.Notification]> {
        Single.create { single in
            if let error = self.error {
                single(.failure(error))
            } else {
                single(.success(self.notifications))
            }
            return Disposables.create()
        }
    }
}
