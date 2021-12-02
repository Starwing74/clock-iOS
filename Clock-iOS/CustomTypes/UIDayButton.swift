import UIKit

/*
 Custom button type for days
 It's a toggle button with a number corresponding to its day (0 to 6)
 */
@IBDesignable class UIDayButton: UIButton {
    @IBInspectable public var day: Int = 0
    public var isToggled = false
}
