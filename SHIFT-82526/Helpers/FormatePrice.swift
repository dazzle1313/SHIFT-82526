import Foundation

func formatePrice(price: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.groupingSeparator = " "
    numberFormatter.maximumFractionDigits = 2
    
    if let formatted = numberFormatter.string(from: NSNumber(value: price)) {
        return "$ \(formatted)"
    } else {
        return "$ \(Int(price))"
    }
}
