import UIKit

final class ErrorView: UIView {
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Произошла ошибка!\nНе удалось загрузить товары..."
        label.font = Constants.Fonts.mainFontSemiBold(size: 18)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        isHidden = true
        
        addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setup(in view: UIView) {
        self.layer.maskedCorners = view.layer.maskedCorners
        self.layer.cornerRadius = view.layer.cornerRadius
        
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
