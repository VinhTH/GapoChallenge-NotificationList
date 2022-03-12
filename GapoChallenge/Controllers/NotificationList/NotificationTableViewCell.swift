import UIKit
import Nuke

final class NotificationTableViewCell: UITableViewCell {
    static let identifier = String(describing: NotificationTableViewCell.self)
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var reactionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 28
        reactionImageView.layer.cornerRadius = 12
        reactionImageView.layer.borderWidth = 2
        reactionImageView.layer.borderColor = (UIColor(named: "white") ?? .white).cgColor
    }
    
    func fill(withViewModel viewModel: NotificationViewModel) {
        timeLabel.text = viewModel.time
        backgroundColor = viewModel.read ? UIColor(named: "white") : UIColor(named: "lighter2")
        messageLabel.setText(
            text: viewModel.message,
            textFont: .systemFont(ofSize: 14),
            textColor: UIColor(named: "gray10") ?? .black,
            highlights: viewModel.highlights,
            highlightsFont: .systemFont(ofSize: 14, weight: .semibold),
            highlightsColor: UIColor(named: "gray10") ?? .black
        )
        Nuke.loadImage(with: viewModel.image, into: avatarImageView)
        Nuke.loadImage(with: viewModel.icon, into: reactionImageView)
    }
}
