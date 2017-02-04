import UIKit

public protocol OCPopupViewStyle {
    var backgroundColor: UIColor { get }
}

public struct OCPopupViewStyleDefault: OCPopupViewStyle {
    public let backgroundColor = UIColor(white: 0.3, alpha: 0.6)
}
