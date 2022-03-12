import Foundation

extension TimeInterval {
    func formatTimestampToDDMMYYHHMM() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY, HH:mm"
        return dateFormatter.string(from: date)
    }
}
