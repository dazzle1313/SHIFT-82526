import UIKit

final class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        configure(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(placeholder: String) {
        self.backgroundColor = Constants.Colors.customWhite
        self.layer.cornerRadius = 8
        self.layer.borderColor = Constants.Colors.mainBlack?.cgColor
        self.layer.borderWidth = 1
        self.placeholder = placeholder
        self.font = Constants.Fonts.mainFont(size: 16)
        self.textColor = Constants.Colors.mainBlack
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        self.leftView = leftView
        self.rightView = rightView
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
    
}
