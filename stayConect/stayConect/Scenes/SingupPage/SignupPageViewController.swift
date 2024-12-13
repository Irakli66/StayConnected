//
//  SignupPageViewController.swift
//  stayConect
//
//  Created by irakli kharshiladze on 28.11.24.
//

import UIKit

final class SignupPageViewController: UIViewController {
    private var textFields: [UITextField] = []
    private let viewModel = SignupPageViewModel()
    
    private let navigationButtonAndPageTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.alignment = .leading
        return stackView
    }()
    
    private let navigationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign up"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let pageWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let signupFormStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    private let signupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = UIColor(named: AppColors.primaryColor.rawValue)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        setNavigationButtonAndPageTitleStackView()
        setupPageWrapper()
        setupSignupFormStackView()
        setupSignupButton()
    }
    
    private func setNavigationButtonAndPageTitleStackView() {
        view.addSubview(navigationButtonAndPageTitleStackView)
        [navigationButton, pageTitle].forEach{ navigationButtonAndPageTitleStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            navigationButtonAndPageTitleStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            navigationButtonAndPageTitleStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            navigationButtonAndPageTitleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        ])
        
        navigationButton.addAction(UIAction(handler: { [weak self] action in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
    }
    
    private func setupPageWrapper() {
        view.addSubview(pageWrapperView)
        
        NSLayoutConstraint.activate([
            pageWrapperView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 33),
            pageWrapperView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -33),
            pageWrapperView.topAnchor.constraint(equalTo: navigationButtonAndPageTitleStackView.bottomAnchor, constant: 40),
            pageWrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSignupFormStackView() {
        pageWrapperView.addSubview(signupFormStackView)
        
        let usernameStackView = createLabelAndTextField(labelText: "Username", placeholderText: "Enter your username")
        let emailStackView = createLabelAndTextField(labelText: "Email", placeholderText: "Enter your email")
        let passwordStackView = createLabelAndTextField(labelText: "Password", placeholderText: "Enter your password", isSecure: true)
        let confirmPasswordStackView = createLabelAndTextField(labelText: "Confirm Password", placeholderText: "Confirm your password", isSecure: true)
        
        [usernameStackView, emailStackView, passwordStackView, confirmPasswordStackView].forEach{ signupFormStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            signupFormStackView.leftAnchor.constraint(equalTo: pageWrapperView.leftAnchor),
            signupFormStackView.rightAnchor.constraint(equalTo: pageWrapperView.rightAnchor),
            signupFormStackView.topAnchor.constraint(equalTo: pageWrapperView.topAnchor),
            signupFormStackView.heightAnchor.constraint(equalToConstant: 350),
        ])
        
        textFields.forEach{
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    private func setupSignupButton() {
        pageWrapperView.addSubview(signupButton)
        
        NSLayoutConstraint.activate([
            signupButton.leftAnchor.constraint(equalTo: pageWrapperView.leftAnchor),
            signupButton.rightAnchor.constraint(equalTo: pageWrapperView.rightAnchor),
            signupButton.bottomAnchor.constraint(equalTo: pageWrapperView.bottomAnchor, constant: -50),
            signupButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        signupButton.addAction(UIAction(handler: { [weak self] action in
            self?.registerUser()
        }), for: .touchUpInside)
    }
    
    private func createLabelAndTextField(labelText: String, placeholderText: String, isSecure: Bool = false) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        stackView.addArrangedSubview(label)
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholderText
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 8
        stackView.addArrangedSubview(textField)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        if isSecure {
            let lockContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
            let lockImageView = UIImageView(image: UIImage(named: AppIcons.lockIcon.rawValue))
            lockImageView.tintColor = .gray
            lockImageView.contentMode = .scaleAspectFit
            lockImageView.frame = CGRect(x: 10, y: 0, width: 24, height: 24)
            lockContainer.addSubview(lockImageView)
            textField.leftView = lockContainer
            textField.leftViewMode = .always
            
            let eyeContainer = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
            let eyeButton = UIButton(type: .system)
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            eyeButton.tintColor = .gray
            eyeButton.frame = CGRect(x: -10, y: 0, width: 24, height: 24)
            eyeContainer.addSubview(eyeButton)
            textField.rightView = eyeContainer
            textField.rightViewMode = .always
            textField.isSecureTextEntry = true
            
            eyeButton.addAction(UIAction(handler: { [weak self] action in
                self?.togglePasswordVisibility(sender: eyeButton, textField: textField)
            }), for: .touchUpInside)
        }
        
        textFields.append(textField)
        
        return stackView
    }
    
    private func togglePasswordVisibility(sender: UIButton, textField: UITextField) {
        textField.isSecureTextEntry.toggle()
        
        let imageName = textField.isSecureTextEntry ? "eye" : "eye.slash"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func registerUser() {
        ButtonAnimationUtility.animateButtonPress(signupButton)
        
        guard let username = textFields[0].text?.lowercased(),
              let email = textFields[1].text,
              let password = textFields[2].text,
              let confirmPassword = textFields[3].text else {
            return
        }
        
        Task {
            do {
                let _ = try await viewModel.registerUser(username: username, email: email, password: password, confirmPassword: confirmPassword)
                
                navigateToLoginPage()
            } catch {
                showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func navigateToLoginPage() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
