import UIKit

extension UITextField {
    
    func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func enablePasswordToggle() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        // Contenedor con padding
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24)) // 40 da espacio extra
        button.center = container.center
        container.addSubview(button)
        
        self.rightView = container
        self.rightViewMode = .always
        self.isSecureTextEntry = true
    }

        @objc private func togglePasswordVisibility(_ sender: UIButton) {
            self.isSecureTextEntry.toggle()
            let imageName = self.isSecureTextEntry ? "eye.slash" : "eye"
            (sender as? UIButton)?.setImage(UIImage(systemName: imageName), for: .normal)
        }

}
