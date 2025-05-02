
import UIKit

extension UIView {
    func applyNeumorphicEffect() {
        self.backgroundColor = UIColor.systemGray6
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4

        let innerShadow = CALayer()
        innerShadow.frame = bounds
        innerShadow.shadowColor = UIColor.white.cgColor
        innerShadow.shadowOffset = CGSize(width: -5, height: -5)
        innerShadow.shadowOpacity = 1
        innerShadow.shadowRadius = 5
        innerShadow.cornerRadius = 12
        layer.insertSublayer(innerShadow, at: 0)
    }
}
