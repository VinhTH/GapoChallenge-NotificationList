import UIKit

extension UILabel {
    func setText(
        text: String,
        textFont: UIFont,
        textColor: UIColor,
        highlights: [NSRange],
        highlightsFont: UIFont,
        highlightsColor: UIColor
    ) {
        let attributedText = NSMutableAttributedString(string: text)
        let textRange = NSRange(location: 0, length: text.utf16.count)
        attributedText.addAttribute(NSAttributedString.Key.font, value: textFont, range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: textRange)
        for range in highlights {
            attributedText.addAttribute(NSAttributedString.Key.font, value: highlightsFont, range: range)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: highlightsColor, range: range)
        }
        self.attributedText = attributedText
    }
}
