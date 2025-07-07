import UIKit

final class RegisterViewController: UIViewController {
    
    lazy private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Images.logoCircle
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var errorLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.mainFontMedium(size: 16)
        label.textColor = Constants.Colors.error
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.mainFontMedium(size: 28)
        label.textColor = Constants.Colors.mainBlack
        label.text = "Добро пожаловать!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var textFieldsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy private var nameTextField = CustomTextField(placeholder: "Введите имя")
    lazy private var surnameTextField = CustomTextField(placeholder: "Введите фамилию")
    lazy private var birthdateTextField = CustomTextField(placeholder: "Выберите дату рождения")
    lazy private var passwordTextField = CustomTextField(placeholder: "Введите пароль")
    lazy private var passwordRepeatTextField = CustomTextField(placeholder: "Введите пароль")
    
    lazy private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var allTextFields = [nameTextField, surnameTextField, birthdateTextField, passwordTextField, passwordRepeatTextField]
    
    lazy private var registerButton = CustomButton(text: "Зарегистрироваться", textSize: 24)
    
    private var activeTextField: UITextField?
    private var keyboardIsShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addSubviews()
        setupConstraints()
    }
    
    private func configure() {
        view.backgroundColor = Constants.Colors.customWhite
        setupKeyboardObserver()
        
        allTextFields.forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            $0.returnKeyType = .done
        }
        passwordTextField.isSecureTextEntry = true
        passwordRepeatTextField.isSecureTextEntry = true
        
        birthdateTextField.inputView = datePicker
        
        let currentDate = Date()
        let calendar = Calendar.current
        if let minDate = calendar.date(byAdding: .year, value: -100, to: currentDate) {
            datePicker.minimumDate = minDate
        }
        if let maxDate = calendar.date(byAdding: .year, value: -10, to: currentDate) {
            datePicker.maximumDate = maxDate
        }
        datePicker.date = datePicker.maximumDate ?? currentDate
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(dismissDatePicker))
        toolbar.setItems([doneButton], animated: true)
        birthdateTextField.inputAccessoryView = toolbar
        
        registerButton.isEnabled = false
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoView)
        contentView.addSubview(textFieldsStack)
        textFieldsStack.addArrangedSubview(welcomeLabel)
        textFieldsStack.addArrangedSubview(nameTextField)
        textFieldsStack.addArrangedSubview(surnameTextField)
        textFieldsStack.addArrangedSubview(birthdateTextField)
        textFieldsStack.addArrangedSubview(passwordTextField)
        textFieldsStack.addArrangedSubview(passwordRepeatTextField)
        contentView.addSubview(registerButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            textFieldsStack.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 24),
            textFieldsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            textFieldsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            registerButton.topAnchor.constraint(equalTo: textFieldsStack.bottomAnchor, constant: 40),
            registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            registerButton.heightAnchor.constraint(equalToConstant: 56),
            registerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        allTextFields.forEach {
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 48)
            ])
        }
    }
    
    // MARK: - Validation Logic
    @objc private func registerButtonTapped() {
        let result = isDataValid()
        switch result {
        case (false, let field):
            showError(in: field)
        case (true, nil):
            hideError()
            
            let user = UserData(name: nameTextField.text ?? "",
                                surname: surnameTextField.text ?? "")
            if let codedUser = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(codedUser, forKey: Constants.UserDefaults.userData)
            }
            
            UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isLoggedIn)
            
            let mainVC = MainViewController()
            self.navigationController?.pushViewController(mainVC, animated: true)
        default:
            print("")
        }
    }
    
    // MARK: - Error View
    private func showError(in textField: CustomTextField?) {
        guard let textField = textField else { return }
        textFieldsStack.insertArrangedSubview(errorLabel, at: 0)
        textField.layer.borderColor = Constants.Colors.error?.cgColor
        
        switch textField {
        case nameTextField:
            errorLabel.text = "Имя указано неверно!\nМинимальное количество символов - 2"
        case surnameTextField:
            errorLabel.text = "Фамилия указана неверно!\nМинимальное количество символов - 2"
        case passwordTextField:
            errorLabel.text = "Пароль указан неверно!\nОзнакомьтесь с правилами"
        case passwordRepeatTextField:
            errorLabel.text = "Пароли не совпадают!\nПроверьте ввод пароля"
        default:
            print("")
        }
    }
    
    private func hideError() {
        allTextFields.forEach {
            $0.layer.borderColor = Constants.Colors.mainBlack?.cgColor
        }
        textFieldsStack.removeArrangedSubview(errorLabel)
        errorLabel.removeFromSuperview()
    }
    
    // MARK: - Keyboard Settings
    private func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard !keyboardIsShown,
              let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        keyboardIsShown = true

        let keyboardHeight = keyboardFrame.height
        let bottomInset = keyboardHeight - view.safeAreaInsets.bottom

        scrollView.contentInset.bottom = bottomInset + 56
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset + 16

        if let activeField = activeTextField {
            let fieldFrame = activeField.convert(activeField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(fieldFrame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        keyboardIsShown = false
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - RegisterButton States
    private func allDataInputted() -> Bool {
        return allTextFields.allSatisfy { !($0.text?.isEmpty ?? true) }
    }
    
    private func updateRegisterButton() {
        registerButton.isEnabled = allDataInputted()
    }
    
    @objc private func textFieldDidChange() {
        updateRegisterButton()
    }
    
    // MARK: - Data Validation
    private func isDataValid() -> (Bool, CustomTextField?) {
        guard let name = nameTextField.text else { return (false, nameTextField) }
        guard let surname = surnameTextField.text else { return (false, surnameTextField) }
        guard let date = birthdateTextField.text else { return (false, birthdateTextField) }
        guard let password = passwordTextField.text else { return (false, passwordTextField) }
        guard let passwordRepeat = passwordRepeatTextField.text else { return (false, passwordRepeatTextField) }
        
        if name.count < 2 {
            return (false, nameTextField)
        }
        
        if surname.count < 2 {
            return (false, surnameTextField)
        }
        
        if !isPasswordValid(password: password) {
            return (false, passwordTextField)
        }
        
        if password != passwordRepeat {
            return (false, passwordRepeatTextField)
        }
        
        return (true, nil)
    }
    
    private func isPasswordValid(password: String) -> Bool {
        let cyrillicRange = password.range(of: "[а-яА-Я]", options: .regularExpression)
        if cyrillicRange != nil {
            return false
        }
        
        let hasNumber = password.range(of: "\\d", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        
        return hasNumber && hasLowercase && hasUppercase && password.count > 4
    }
    
    // MARK: - Work With Dates
    @objc private func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        birthdateTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc private func dismissDatePicker() {
        view.endEditing(true)
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if activeTextField == textField {
            activeTextField = nil
        }
    }
}

