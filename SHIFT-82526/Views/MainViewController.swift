import UIKit

final class MainViewController: UIViewController {
    
    lazy private var upperBackground: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.customWhite
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var greetingButton = CustomButton(text: "Добро пожаловать!", textSize: 18)
    
    lazy private var logoutButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Icons.logout
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var lowerBackground: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.customWhite
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let loadSpinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = Constants.Colors.mainColor
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let productsViewModel = ProductsViewModel()
    private var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addSubviews()
        setupConstraints()
        initializeViewModel()
    }
    
    private func configure() {
        view.backgroundColor = Constants.Colors.grayDark
        
        setupCollectionView()
        
        greetingButton.addTarget(self, action: #selector(popupShow), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutButtonTapped))
        logoutButton.addGestureRecognizer(tapGesture)
    }
    
    private func addSubviews() {
        view.addSubview(upperBackground)
        upperBackground.addSubview(greetingButton)
        upperBackground.addSubview(logoutButton)
        view.addSubview(lowerBackground)
        lowerBackground.addSubview(collectionView)
        lowerBackground.addSubview(loadSpinner)
        view.addSubview(dimmingView)
    }
    
    private func setupConstraints() {
        // General Constraints
        NSLayoutConstraint.activate([
            upperBackground.topAnchor.constraint(equalTo: view.topAnchor),
            upperBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upperBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upperBackground.heightAnchor.constraint(equalToConstant: 160),
            
            lowerBackground.topAnchor.constraint(equalTo: upperBackground.bottomAnchor, constant: 24),
            lowerBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lowerBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lowerBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Upper Background Constraints
        NSLayoutConstraint.activate([
            greetingButton.bottomAnchor.constraint(equalTo: upperBackground.bottomAnchor, constant: -16),
            greetingButton.heightAnchor.constraint(equalToConstant: 40),
            greetingButton.leadingAnchor.constraint(equalTo: upperBackground.leadingAnchor, constant: 64),
            greetingButton.trailingAnchor.constraint(equalTo: upperBackground.trailingAnchor, constant: -64),
            
            logoutButton.centerYAnchor.constraint(equalTo: greetingButton.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: upperBackground.trailingAnchor, constant: -16),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        //Lower Background Constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: lowerBackground.topAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: lowerBackground.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: lowerBackground.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: lowerBackground.bottomAnchor),
            
            loadSpinner.centerXAnchor.constraint(equalTo: lowerBackground.centerXAnchor),
            loadSpinner.centerYAnchor.constraint(equalTo: lowerBackground.centerYAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
    }
    
    private func initializeViewModel() {
        let errorView = ErrorView()
        errorView.setup(in: self.lowerBackground)
        productsViewModel.onStateScreenUpdated = { stateScreen in
            switch stateScreen {
            case .Default:
                self.loadSpinner.stopAnimating()
                errorView.isHidden = true
            case .Loading:
                self.loadSpinner.startAnimating()
                errorView.isHidden = true
            case .Error:
                errorView.isHidden = false
            }
        }
        
        productsViewModel.onProductsUpdated = { [weak self] products in
            self?.products = products
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func popupShow() {
        if let userData = UserDefaults.standard.data(forKey: Constants.UserDefaults.userData), let decodedUserData = try? JSONDecoder().decode(UserData.self, from: userData) {
            let popupVC = PopupViewController(userData: decodedUserData)
            popupVC.onClose = {
                self.dimmingView.isHidden = true
            }
            popupVC.modalPresentationStyle = .popover

            if let popover = popupVC.popoverPresentationController {
                popover.sourceView = self.view
                popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
                popover.delegate = self
            }
            
            dimmingView.isHidden = false
            present(popupVC, animated: true)
        }
    }
    
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(
            title: "Выход из аккаунта",
            message: "Вы уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        let logoutAction = UIAlertAction(title: "Выйти", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.userData)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.isLoggedIn)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }

            let newVC = ToRegistrationViewController()
            let newNavigationVC = UINavigationController(rootViewController: newVC)

            UIView.transition(with: window,
                             duration: 0.3,
                             options: .transitionCrossDissolve,
                             animations: {
                window.rootViewController = newNavigationVC
            }, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        cell.setup(with: products[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 170.0
        let height = 250.0
        return CGSize(width: width, height: height)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
