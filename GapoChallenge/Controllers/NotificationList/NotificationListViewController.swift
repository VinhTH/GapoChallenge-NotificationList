import UIKit
import RxSwift

final class NotificationListViewController: UIViewController, StoryboardInstantiable {
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - Variable
    private var viewModel: NotificationListViewModel!
    private lazy var disposeBag = DisposeBag()
    private var isSearching = false {
        didSet {
            headerView.isHidden = isSearching
            searchView.isHidden = !isSearching
            if isSearching {
                searchTextField.becomeFirstResponder()
            } else {
                searchTextField.text = nil
                searchTextField.resignFirstResponder()
            }
        }
    }
    
    // MARK: - Static
    static func create(viewModel: NotificationListViewModel) -> UIViewController {
        let viewController = instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindToViewModel()
        viewModel.fetchNotificationList()
    }
    
    // MARK: - IBAction
    @IBAction func onSearchPressed(_ sender: UIButton) {
        isSearching = true
    }
    
    @IBAction func onCloseSearchPressed(_ sender: UIButton) {
        isSearching = false
        viewModel.closeSearch()
    }
    
    @IBAction func onSearchEditingChanged(_ sender: UITextField) {
        viewModel.search(withKey: sender.text ?? "")
    }
}

// MARK: - Private Func
extension NotificationListViewController {
    private func setupView() {
        /// Setup search placeholder
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Tìm kiếm",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "gray10") ?? .black]
        )
        
        /// Setup search clear button
        if let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton {
           let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
           clearButton.setImage(templateImage, for: .normal)
           clearButton.tintColor = UIColor(named: "gray50")
       }
    }
    
    private func bindToViewModel() {
        viewModel
            .items
            .subscribe { [weak self] _ in
                self?.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel
            .error
            .subscribe { event in
                guard let error = event.element else { return }
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UITextFieldDelegate
extension NotificationListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDataSource
extension NotificationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as! NotificationTableViewCell
        cell.fill(withViewModel: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items.value[indexPath.row]
        if !item.read {
            item.read = true
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}
