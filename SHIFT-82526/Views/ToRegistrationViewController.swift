import UIKit

final class ToRegistrationViewController: UIViewController {
    
    lazy private var logoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 40
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy private var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Images.logoCircle
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var toRegistrationButton = CustomButton(text: "Зарегистрироваться", textSize: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addSubviews()
        setupConstraints()
    }
    
    private func configure() {
        view.backgroundColor = Constants.Colors.customWhite
        toRegistrationButton.addTarget(self, action: #selector(toRegistrationButtonTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(logoStackView)
        logoStackView.addArrangedSubview(logoView)
        logoStackView.addArrangedSubview(toRegistrationButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor),
            
            toRegistrationButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc private func toRegistrationButtonTapped() {
        self.navigationController?.isNavigationBarHidden = true
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
}
