import UIKit

final class CustomButton: UIButton {
    
    init(text: String, textSize: CGFloat) {
        super.init(frame: .zero)
        configure(text: text, textSize: textSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(text: String, textSize: CGFloat) {
        self.backgroundColor = Constants.Colors.mainColor
        self.setTitle(text, for: .normal)
        self.setTitleColor(Constants.Colors.customWhite, for: .normal)
        self.titleLabel?.font = Constants.Fonts.mainFontSemiBold(size: textSize)
        self.setBackgroundImage(UIImage(color: Constants.Colors.mainColorDark ?? UIColor.red), for: .highlighted)
        self.setBackgroundImage(UIImage(color: Constants.Colors.mainColorLight ?? UIColor.gray), for: .disabled)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
