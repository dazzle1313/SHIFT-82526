import UIKit

final class PopupViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Icons.greeting
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let justGreetingLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.mainFontSemiBold(size: 20)
        label.textColor = Constants.Colors.mainBlack
        label.numberOfLines = 4
        label.textAlignment = .center
        return label
    }()
    
    private let okButton = CustomButton(text: "Понятно", textSize: 20)
    
    private var userData: UserData?
    
    var onClose: (() -> Void)?
    
    init(userData: UserData) {
        super.init(nibName: nil, bundle: nil)
        self.userData = userData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupUsername(userData: userData)
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.Colors.customWhite
        
        preferredContentSize = CGSize(width: 300, height: 300)
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(justGreetingLabel)
        stack.addArrangedSubview(okButton)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            okButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        okButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
    }
    
    private func setupUsername(userData: UserData?) {
        if let userData = userData {
            justGreetingLabel.text = "Это просто приветствие,\n\(String(userData.name)) :)\nСпасибо за выбор\nнашего приложения!"
        }
    }
    
    @objc private func closePopup() {
        onClose?()
        dismiss(animated: true)
    }
    
}
